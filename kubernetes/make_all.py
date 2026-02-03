#!/usr/bin/env python3
"""
Helm Chart Builder

This script replaces the functionality of the Makefile for building Helm charts.
It discovers, validates, packages, and optionally pushes Helm charts to a chart museum.

Features:
- Discovers Helm charts in the current directory and subdirectories
- Validates chart dependencies and sorts charts by dependency order
- Packages charts with Helm
- Optionally pushes charts to a chart museum
- Supports concurrent processing with configurable limits
- Provides detailed logging and error handling

Usage:
    make_all.py                    # Build all charts
    make_all.py --skip-lint        # Build all charts without linting
    make_all.py --clean            # Clean build artifacts
    make_all.py --list-charts      # List all charts without building
    make_all.py --max-concurrent 2 # Build charts with max 2 concurrent processes
"""

import argparse
import glob
import logging
import os
import shutil
import subprocess
import sys
from pathlib import Path
import yaml
import re
import asyncio
import concurrent.futures
from typing import Dict, List, Optional, Tuple, Union, Any


# Constants
IGNORED_DIRECTORIES = ["helm", "authentication", "onap"]
DEFAULT_OUTPUT_DIR = Path(__file__).parent.resolve() / 'dist'


class BuildError(Exception):
    """Exception raised when a build error occurs that should stop execution."""
    pass


class FailFastLogger:
    """Custom logger that raises BuildError on ERROR level logs."""

    def __init__(self, name: str):
        self._logger = logging.getLogger(name)
        self.level = self._logger.level

    def debug(self, msg: str, *args, **kwargs) -> None:
        self._logger.debug(msg, *args, **kwargs)

    def info(self, msg: str, *args, **kwargs) -> None:
        self._logger.info(msg, *args, **kwargs)

    def warning(self, msg: str, *args, **kwargs) -> None:
        self._logger.warning(msg, *args, **kwargs)

    def error(self, msg: str, *args, **kwargs) -> None:
        self._logger.error(msg, *args, **kwargs)
        raise BuildError(f"Build error occurred: {msg}")

    def critical(self, msg: str, *args, **kwargs) -> None:
        self._logger.critical(msg, *args, **kwargs)
        raise BuildError(f"Critical build error occurred: {msg}")


# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = FailFastLogger(__name__)

# Global set to track package names already pushed to chartmuseum
pushed_packages = set()


def check_helm_version(helm_bin: str) -> bool:
    """
    Check if the Helm version starts with 3.7

    Args:
        helm_bin: Path to the Helm binary

    Returns:
        True if Helm version is compatible, False otherwise
    """
    try:
        # Get Helm version
        version_result = subprocess.run([helm_bin, "version", "--template", "{{.Version}}"],
                                       check=False, capture_output=True, text=True)

        if version_result.returncode != 0:
            logger.error(f"Failed to get Helm version: {version_result.stderr}")
            return False

        version_output = version_result.stdout.strip()

        # Extract just the version number (remove leading 'v' if present)
        version_clean = version_output.lstrip('v')

        # Check if the version starts with "3.7"
        if version_clean.startswith("3.7"):
            logger.info(f"Helm version {version_output} is compatible (starts with 3.7)")
            return True
        else:
            logger.error(f"Helm version {version_output} does not start with 3.7 as required")
            return False

    except Exception as e:
        logger.debug(f"Error checking Helm version: {e}")
        return False

def update_dependencies(chart_path: Union[str, Path], helm_bin: str) -> bool:
    """
    Update chart dependencies using Helm dependency update command.

    This function executes the equivalent of the 'dep-%' step from the Makefile,
    which updates the dependencies for a Helm chart if a Chart.yaml file exists.

    Args:
        chart_path: Path to the chart directory containing Chart.yaml
        helm_bin: Path to the Helm binary to use for dependency update

    Returns:
        True if dependencies were updated successfully or no Chart.yaml exists, False otherwise
    """
    chart_path_obj = Path(chart_path)
    if (chart_path_obj / "Chart.yaml").is_file():
        logger.info(f"Updating dependencies for chart in {chart_path_obj}")
        dep_cmd = [helm_bin, "dependency", "update", str(chart_path_obj)]
        dep_result = subprocess.run(dep_cmd, check=False, capture_output=True, text=True)
        if dep_result.returncode != 0:
            logger.error(f"Helm dependency update failed for {chart_path_obj}: {dep_result.stderr}")
            return False
        else:
            logger.info(f"Dependencies updated for {chart_path_obj}")
            return True
    return True


def lint_chart(chart_path: Union[str, Path], helm_bin: str, skip_lint: bool) -> bool:
    """
    Lint the chart using Helm lint command if not skipped.

    This function executes the equivalent of the 'lint-%' step from the Makefile,
    which runs Helm lint on a chart if a Chart.yaml file exists and skip_lint is False.

    Args:
        chart_path: Path to the chart directory containing Chart.yaml
        helm_bin: Path to the Helm binary to use for linting
        skip_lint: Whether to skip the linting step

    Returns:
        True if linting passed or was skipped, False otherwise
    """
    chart_path_obj = Path(chart_path)
    if not skip_lint and (chart_path_obj / "Chart.yaml").is_file():
        logger.info(f"Linting chart in {chart_path_obj}")
        lint_cmd = [helm_bin, "lint", str(chart_path_obj)]
        lint_result = subprocess.run(lint_cmd, check=False, capture_output=True, text=True)
        if lint_result.returncode != 0:
            logger.error(f"Helm lint failed for {chart_path_obj}: {lint_result.stderr}")
            return False
        else:
            logger.info(f"Linting passed for {chart_path_obj}")
    return True


def package_chart(chart_path: Union[str, Path], helm_bin: str, output_dir: Union[str, Path]) -> Optional[str]:
    """
    Package the chart to the output directory using Helm package command.

    This function executes the equivalent of the 'package-%' step from the Makefile,
    which packages a Helm chart to the specified output directory if a Chart.yaml file exists.

    Args:
        chart_path: Path to the chart directory containing Chart.yaml
        helm_bin: Path to the Helm binary to use for packaging
        output_dir: Output directory where the packaged chart should be stored

    Returns:
        Path to the packaged chart file if successful, or None if packaging failed
    """
    chart_path_obj = Path(chart_path)
    output_dir_obj = Path(output_dir)

    if (chart_path_obj / "Chart.yaml").is_file():
        # Create the output directory if it doesn't exist
        package_dir = output_dir_obj / "packages"
        package_dir.mkdir(parents=True, exist_ok=True)

        # Prepare the helm package command
        package_cmd = [helm_bin, "package", str(chart_path_obj), "--destination", str(package_dir)]

        logger.info(f"Running command: {' '.join(package_cmd)}")

        # Execute the package command
        package_result = subprocess.run(package_cmd, check=False, capture_output=True, text=True)
        if package_result.returncode != 0:
            logger.error(f"Helm package failed for {chart_path_obj}: {package_result.stderr}")
            return None

        # Extract the package name from the output
        package_output = package_result.stdout.strip()
        if ":" in package_output:
            # Extract package name from output like "Successfully packaged chart and saved it to: /path/to/chart-1.0.0.tgz"
            package_parts = package_output.split(":")
            if len(package_parts) >= 2:
                package_name = package_parts[1].strip()
            else:
                # Alternative parsing if format is different
                package_lines = package_output.split("\n")
                for line in package_lines:
                    if line.strip().endswith(".tgz") or line.strip().endswith(".tar.gz"):
                        package_name = line.strip()
                        break
                else:
                    package_name = None
        else:
            # Get the chart directory name to help find the packaged file
            chart_dir_name = chart_path_obj.name
            # Try to find the .tgz file in the package directory
            tgz_files = list(package_dir.glob(f"{chart_dir_name}*.tgz"))
            if tgz_files:
                package_name = str(tgz_files[-1])  # Take the most recently created one
            else:
                tar_gz_files = list(package_dir.glob(f"{chart_dir_name}*.tar.gz"))
                if tar_gz_files:
                    package_name = str(tar_gz_files[-1])
                else:
                    package_name = None

        if package_name:
            logger.info(f"Package created: {package_name}")
            return package_name
        else:
            logger.error(f"Could not determine package name from output: {package_output}")
            return None
    return None

def push_to_chartmuseum(chart_path: Union[str, Path], package_name: str, helm_bin: str) -> bool:
    """
    Push the packaged chart to chart museum using Helm cm-push command.

    This function executes the push portion of the 'package-%' step from the Makefile,
    which pushes a packaged Helm chart to a chart museum repository.

    Args:
        chart_path: Path to the original chart directory (used for logging)
        package_name: Full path to the packaged chart file (.tgz)
        helm_bin: Path to the Helm binary to use for pushing

    Returns:
        True if push was successful, False otherwise
    """
    chart_path_obj = Path(chart_path)
    package_path_obj = Path(package_name)

    # Check and log the size of the package before pushing
    if package_path_obj.exists():
        package_size = package_path_obj.stat().st_size
        logger.info(f"Package {package_path_obj} size: {package_size} bytes ({package_size / (1024*1024):.2f} MB)")
    else:
        logger.error(f"Package file does not exist: {package_path_obj}")
        return False

    # Push to chart museum using cm-push
    # Note: This assumes chartmuseum plugin is installed
    push_cmd = [helm_bin, "cm-push", '-f', str(package_path_obj), "local"]
    logger.info(f"Pushing to chart museum: {' '.join(push_cmd)}")

    push_result = subprocess.run(push_cmd, check=False, capture_output=True, text=True)
    if push_result.returncode != 0:
        logger.error(f"Chart museum push failed for {package_path_obj}: {push_result.stderr}")
        logger.info("Note: This may fail if the chartmuseum plugin is not installed.")
        return False
    else:
        logger.info(f"Successfully pushed {package_path_obj} to chart museum")
        return True


def process_chart(chart_path: Union[str, Path], helm_bin: str, skip_lint: bool, output_dir: Union[str, Path]) -> bool:
    """
    Process a single chart following the complete Makefile workflow.

    This function performs the complete workflow for a single Helm chart:
    1. Checks if the chart has already been processed
    2. Updates dependencies
    3. Lints the chart (unless skipped)
    4. Packages the chart
    5. Pushes the packaged chart to chart museum

    Args:
        chart_path: Path to the chart directory containing Chart.yaml
        helm_bin: Path to the Helm binary to use for operations
        skip_lint: Whether to skip the linting step
        output_dir: Output directory where packaged charts should be stored

    Returns:
        True if the chart was processed successfully, False otherwise
    """
    chart_path_obj = Path(chart_path)
    # Get the chart name from Chart.yaml to use as package identifier
    chart_yaml_path = chart_path_obj / "Chart.yaml"
    chart_name = None

    if chart_yaml_path.exists():
        try:
            with open(chart_yaml_path, 'r') as f:
                chart_data = yaml.safe_load(f)
                chart_name = chart_data.get('name')
        except yaml.YAMLError as e:
            logger.debug(f"Could not parse Chart.yaml in {chart_path_obj}: {e}")
        except Exception as e:
            logger.debug(f"Error reading Chart.yaml in {chart_path_obj}: {e}")

    # Check if this chart has already been pushed (using chart name as identifier)
    if chart_name and chart_name in pushed_packages:
        logger.info(f"Chart {chart_name} already pushed to chart museum, skipping...")
        return True

    # dep-%: Update dependencies
    deps_success = update_dependencies(chart_path_obj, helm_bin)
    if not deps_success:
        return False

    # lint-%: Run helm lint if not skipped
    lint_success = lint_chart(chart_path_obj, helm_bin, skip_lint)
    if not lint_success:
        return False

    # package-%: Package the chart and push to chart museum
    package_name = package_chart(chart_path_obj, helm_bin, output_dir)
    if package_name is None:
        return False

    push_success = push_to_chartmuseum(chart_path_obj, package_name, helm_bin)
    if not push_success:
        return False

    # Add chart name to the set of pushed packages after successful processing
    if chart_name:
        pushed_packages.add(chart_name)

    logger.info(f"Successfully processed chart in {chart_path_obj}")
    return True


async def run_process_chart_async(chart_path: Union[str, Path], helm_bin: str, skip_lint: bool, output_dir: Union[str, Path], chart_name: str) -> bool:
    """
    Wrapper to run process_chart in a thread-safe way.

    This function wraps the synchronous process_chart function to run it in a thread pool
    executor, allowing it to be called from an async context without blocking the event loop.

    Args:
        chart_path: Path to the chart directory containing Chart.yaml
        helm_bin: Path to the Helm binary to use for operations
        skip_lint: Whether to skip the linting step
        output_dir: Output directory where packaged charts should be stored
        chart_name: Name of the chart (for logging purposes)

    Returns:
        True if the chart was processed successfully, False otherwise
    """
    def run_in_thread():
        return process_chart(
            chart_path=chart_path,
            helm_bin=helm_bin,
            skip_lint=skip_lint,
            output_dir=output_dir
        )

    # Run the synchronous function in a thread pool to avoid blocking the event loop
    loop = asyncio.get_event_loop()
    return await loop.run_in_executor(None, run_in_thread)

def discover_helm_charts(charts_dir: Union[str, Path]) -> List[Dict[str, Any]]:
    """
    Discover all Helm charts in the current directory and subdirectories based on the Makefile logic.

    This function walks through the directory tree starting from charts_dir, looking for directories
    that contain a Chart.yaml file. For each chart found, it extracts the chart name and dependencies
    from the Chart.yaml file.

    Args:
        charts_dir: Root directory to search for Helm charts

    Returns:
        List of dictionaries containing chart information with keys:
        - 'name': Name of the chart
        - 'dependencies': List of dependency names
        - 'path': Relative path to the chart directory from charts_dir
    """

    # Discover chart directories that contain Chart.yaml
    charts_info = []

    # Walk through all subdirectories recursively
    for root, dirs, files in os.walk(charts_dir):
        # Skip ignored directories
        original_dirs = dirs[:]
        dirs[:] = [d for d in dirs if d not in IGNORED_DIRECTORIES]

        # Log skipped directories
        skipped_dirs = set(original_dirs) - set(dirs)
        for skipped_dir in skipped_dirs:
            logger.debug(f"Skipping ignored directory: {Path(root) / skipped_dir}")

        # Check if Chart.yaml exists in the current directory
        if "Chart.yaml" in files:
            chart_path = Path(root)
            chart_yaml_path = chart_path / "Chart.yaml"

            # Parse the Chart.yaml to get the chart name and dependencies
            try:
                with open(chart_yaml_path, 'r') as f:
                    chart_data = yaml.safe_load(f)
                    chart_name = chart_data.get('name', chart_path.name)  # Use directory name as fallback

                    # Extract dependencies if they exist
                    dependencies = []
                    if 'dependencies' in chart_data:
                        for dep in chart_data.get('dependencies', []):
                            if 'name' in dep:
                                dependencies.append(dep['name'])

            except yaml.YAMLError as e:
                logger.error(f"Could not parse Chart.yaml in {chart_path}: {e}")
                raise
            except Exception as e:
                logger.error(f"Error reading Chart.yaml in {chart_path}: {e}")
                raise

            # Use relative path from current directory
            relative_path = chart_path.relative_to(charts_dir)

            # Add chart info as a dictionary to the list
            chart_info = {
                'name': chart_name,
                'dependencies': dependencies,
                'path': str(relative_path)
            }
            charts_info.append(chart_info)

    logger.debug(f"Discovered charts: {charts_info}")
    return charts_info


def sort_helm_charts(charts_info: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    """
    Sort Helm charts based on their dependencies using topological sorting.

    This function implements Kahn's algorithm for topological sorting to arrange charts
    in an order where dependencies are built before the charts that depend on them.
    Charts with no dependencies come first, followed by charts that depend on those,
    and so on.

    Args:
        charts_info: List of dictionaries containing chart information as returned by discover_helm_charts

    Returns:
        List of chart dictionaries sorted by dependency order (independent first)

    Raises:
        ValueError: If there are circular dependencies among charts
    """
    # Create a mapping from chart name to its info for quick lookup
    chart_map = {chart['name']: chart for chart in charts_info}

    # Build dependency graph - for each chart, store which other charts depend on it
    dependents_graph = {chart['name']: [] for chart in charts_info}
    dependencies_count = {chart['name']: 0 for chart in charts_info}

    # Calculate direct dependencies for each chart
    for chart in charts_info:
        chart_name = chart['name']
        for dep_name in chart['dependencies']:
            if dep_name in chart_map:  # Only consider dependencies that exist in our chart list
                dependents_graph[dep_name].append(chart_name)
                dependencies_count[chart_name] += 1

    # Topological sort using Kahn's algorithm
    # Start with charts that have no dependencies
    queue = []
    for chart_name, count in dependencies_count.items():
        if count == 0:
            queue.append(chart_name)

    sorted_charts = []

    while queue:
        # Pop a chart with no remaining dependencies
        current_chart_name = queue.pop(0)
        sorted_charts.append(chart_map[current_chart_name])

        # Reduce the dependency count for all charts that depended on this one
        for dependent_chart in dependents_graph[current_chart_name]:
            dependencies_count[dependent_chart] -= 1
            if dependencies_count[dependent_chart] == 0:
                queue.append(dependent_chart)

    return sorted_charts


def get_ready_charts(remaining_charts: List[str], chart_info_by_name: Dict[str, Any],
                     pushed_packages_set: set) -> List[Tuple[Dict[str, Any], str, Path]]:
    """
    Get list of charts that have all dependencies met and are ready to be processed.

    Args:
        remaining_charts: List of chart names that still need to be processed
        chart_info_by_name: Dictionary mapping chart names to their info
        pushed_packages_set: Set of packages already pushed to chartmuseum

    Returns:
        List of tuples containing (chart_info, chart_name, chart_path) for ready charts
    """
    ready_charts = []

    for chart_name in remaining_charts:
        # Find the chart in the list by name
        chart_info = chart_info_by_name.get(chart_name)

        if chart_info:
            # Check if all dependencies for this chart have been pushed
            dependencies = chart_info.get('dependencies', [])
            missing_deps = [dep for dep in dependencies if dep not in pushed_packages_set]

            # Only process if all dependencies have been pushed or there are no dependencies
            if not missing_deps:
                chart_path = Path(chart_info['path']).resolve()
                logger.info(f"Building chart: {chart_name} at {chart_path}")
                ready_charts.append((chart_info, chart_name, chart_path))
            else:
                logger.debug(f"Chart '{chart_name}' has unmet dependencies {missing_deps}, skipping for now...")
        else:
            logger.warning(f"Chart '{chart_name}' not found, skipping...")

    return ready_charts


async def process_ready_charts(ready_charts: List[Tuple[Dict[str, Any], str, Path]],
                               semaphore: asyncio.Semaphore, args) -> List[Tuple[bool, str]]:
    """
    Process the ready charts concurrently with semaphore control.

    Args:
        ready_charts: List of tuples containing (chart_info, chart_name, chart_path) for ready charts
        semaphore: Semaphore to limit concurrent processing
        args: Parsed command-line arguments object

    Returns:
        List of tuples containing (success, chart_name) for each processed chart
    """
    async def process_chart_with_semaphore(chart_path, helm_bin, skip_lint, output_dir, chart_name):
        async with semaphore:
            return await run_process_chart_async(
                chart_path=chart_path,
                helm_bin=helm_bin,
                skip_lint=skip_lint,
                output_dir=output_dir,
                chart_name=chart_name
            )

    tasks = []
    for chart_info, chart_name, chart_path in ready_charts:
        # Schedule the chart processing asynchronously with semaphore
        task = asyncio.create_task(
            process_chart_with_semaphore(
                chart_path=str(chart_path),
                helm_bin=args.helm_bin,
                skip_lint=args.skip_lint,
                output_dir=str(args.output_dir),
                chart_name=chart_name
            )
        )
        tasks.append((task, chart_name))

    # Wait for all scheduled tasks to complete and collect results
    results = []
    for task, chart_name in tasks:
        try:
            success = await task
            results.append((success, chart_name))
        except Exception as e:
            logger.error(f"Exception while building chart {chart_name}: {e}")
            results.append((False, chart_name))  # Mark as failed

    return results


async def build_charts_with_dependencies(all_charts: List[Dict[str, Any]], args) -> bool:
    """
    Build charts with proper dependency handling and concurrency control.

    This function manages the building of charts while respecting their dependencies
    and limiting concurrent processing based on the max_concurrent setting.

    Args:
        all_charts: List of chart dictionaries to build
        args: Parsed command-line arguments object

    Returns:
        True if all charts were built successfully, False otherwise
    """
    # Create a semaphore to limit concurrent processing
    semaphore = asyncio.Semaphore(args.max_concurrent)

    # Create a copy of the charts to build to manage the iteration
    remaining_charts = [c['name'] for c in all_charts]
    processed_any = True  # Flag to track if we processed any chart in the current iteration

    chart_info_by_name = {chi['name']: chi for chi in all_charts}

    while remaining_charts and processed_any:
        processed_any = False
        charts_to_remove = []  # Track charts that were successfully processed

        # Get charts that are ready to be processed (all dependencies met)
        ready_charts = get_ready_charts(remaining_charts, chart_info_by_name, pushed_packages)

        # Process ready charts concurrently
        if ready_charts:
            results = await process_ready_charts(ready_charts, semaphore, args)

            for success, chart_name in results:
                if success:
                    charts_to_remove.append(chart_name)
                    processed_any = True
                else:
                    logger.error(f"Failed to build chart: {chart_name}")
                    return False  # Indicate failure

        # Remove successfully processed charts from remaining list
        for chart_name in charts_to_remove:
            if chart_name in remaining_charts:
                remaining_charts.remove(chart_name)

    # Check if there are still unprocessed charts (possible circular dependencies)
    if remaining_charts:
        logger.error(f"Could not process the following charts due to unmet dependencies or circular dependencies: {remaining_charts}")
        return False

    return True


def main():
    parser = argparse.ArgumentParser(
        description='Build Helm charts from the kubernetes directory',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s                           # Build all charts
  %(prog)s --skip-lint               # Build all charts without linting
  %(prog)s --clean                   # Clean build artifacts
  %(prog)s --list-charts             # List all charts without building
  %(prog)s --max-concurrent 2        # Build charts with max 2 concurrent processes
        """
    )

    parser.add_argument(
        '--skip-lint',
        action='store_true',
        help='Skip linting of charts (equivalent to SKIP_LINT=TRUE in Makefile)'
    )

    parser.add_argument(
        '--helm-bin',
        default='helm',
        help='Helm binary to use (default: helm)'
    )

    parser.add_argument(
        '--clean',
        action='store_true',
        help='Clean build artifacts before building'
    )

    parser.add_argument(
        '--list-charts',
        action='store_true',
        help='List discovered charts without building them'
    )

    parser.add_argument(
        '--output-dir',
        default=DEFAULT_OUTPUT_DIR,
        help='Output directory for built charts (default: dist)'
    )

    parser.add_argument(
        '--max-concurrent',
        type=int,
        default=4,
        help='Maximum number of charts to process concurrently (default: 4)'
    )

    # Parse arguments first to get the helm-bin option
    temp_args = parser.parse_known_args()[0]
    helm_bin = temp_args.helm_bin

    # Check Helm version compatibility at startup
    if not check_helm_version(helm_bin):
        print("ERROR: Helm version 3.7.x or compatible is required to build charts.")
        print("Using an incompatible version will result in hardcoded size limits preventing successful builds.")
        print(f"You can specify an alternative Helm binary using the --helm-bin parameter. Current binary: {helm_bin}")
        return sys.exit(1)

    args = parser.parse_args()

    try:
        # Discover Helm charts
        all_charts = sort_helm_charts(discover_helm_charts(Path.cwd()))

        if args.list_charts:
            logger.info("Discovered Helm charts:")
            for chart_info in all_charts:
                logger.info(f"{chart_info['name']}")

            return sys.exit()

        # Determine which charts to build
        charts_to_build = all_charts

        logger.debug(f"Charts to build: {charts_to_build}")
        logger.info(f"Arguments: {args}")

        # If cleaning, remove output directory
        if args.clean:
            output_dir_path = Path(args.output_dir)
            if output_dir_path.exists():
                logger.info(f"Cleaning output directory: {output_dir_path}")
                shutil.rmtree(output_dir_path)

        # Build the selected charts, considering dependencies
        # Run the async chart building function
        success = asyncio.run(build_charts_with_dependencies(charts_to_build, args))

        if not success:
            return sys.exit(1)

        logger.info("All charts built successfully!")
        return sys.exit(0)

    except BuildError as e:
        logger.error(f"Build stopped due to error: {e}")
        return sys.exit(1)
    except KeyboardInterrupt:
        logger.error("Build interrupted by user")
        return sys.exit(1)
    except Exception as e:
        logger.error(f"Unexpected error during build: {e}")
        return sys.exit(1)


if __name__ == "__main__":
    sys.exit(main())
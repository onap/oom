#!/bin/sh

# Set the working directory
working_directory="/tmp"

# Extract the cl_release version
version="1.14.0"  # Example version string; replace with actual value
cl_release=$(echo $version | cut -d. -f1-3 | cut -d- -f1)
printf "\033[33mcl_release=[$cl_release]\033[0m\n"

# Execute the import-Conformance command
conf_dir="/tmp/writable-config/sdctool/config"
tosca_dir="/tmp/writable-config/sdctool/tosca"
cl_version=$(grep 'toscaConformanceLevel:' $conf_dir/configuration.yaml | awk '{print $2}')

cd /tmp/writable-config/sdctool/scripts
chmod +x sdcSchemaFileImport.sh

echo "execute /tmp/writable-config/sdctool/scripts/sdcSchemaFileImport.sh ${tosca_dir} ${cl_release} ${cl_version} ${conf_dir} onap"
./sdcSchemaFileImport.sh ${tosca_dir} ${cl_release} ${cl_version} ${conf_dir} onap

#!/bin/bash

usage() {
cat << EOF
Install (or upgrade) an umbrella Helm Chart, and its subcharts, as separate Helm Releases 

The umbrella Helm Chart is broken apart into a parent release and subchart releases.
Subcharts the are disabled (<chart>.enabled=false) will not be installed or upgraded.
All releases are grouped and deployed within the same namespace.


The deploy arguments must be a release and chart. The chart
argument can be either: a chart reference('stable/onap'), a path to a chart directory,
a packaged chart, or a fully qualified URL. For chart references, the latest
version will be specified unless the '--version' flag is set.

To override values in a chart, use either the '--values' flag and pass in a file
or use the '--set' flag and pass configuration from the command line, to force string
values, use '--set-string'.

You can specify the '--values'/'-f' flag multiple times. The priority will be given to the
last (right-most) file specified. For example, if both myvalues.yaml and override.yaml
contained a key called 'Test', the value set in override.yaml would take precedence:

	$ helm deploy demo ./onap --namespace onap -f openstack.yaml -f overrides.yaml

You can specify the '--set' flag multiple times. The priority will be given to the
last (right-most) set specified. For example, if both 'bar' and 'newbar' values are
set for a key called 'foo', the 'newbar' value would take precedence:

	$ helm deploy demo local/onap --namespace onap -f overrides.yaml --set log.enabled=false --set vid.enabled=false

Usage:
  helm deploy [RELEASE] [CHART] [flags]

Flags:
      --namespace string         namespace to install the release into. Defaults to the current kube config namespace.
      --set stringArray          set values on the command line (can specify multiple or separate values with commas: key1=val1,key2=val2)
      --set-string stringArray   set STRING values on the command line (can specify multiple or separate values with commas: key1=val1,key2=val2)
  -f, --values valueFiles        specify values in a YAML file or a URL(can specify multiple) (default [])
      --verbose                  enables full helm install/upgrade output during deploy
      --set-last-applied         set the last-applied-configuration annotation on all objects.This annotation is required to restore services using Ark/Veloro backup restore.
EOF
}

generate_overrides() {
  SUBCHART_NAMES=($(cat $COMPUTED_OVERRIDES | grep -v '^\s\s'))

  for index in "${!SUBCHART_NAMES[@]}"; do
    START=${SUBCHART_NAMES[index]}
    END=${SUBCHART_NAMES[index+1]}
    if [[ $START == "global:" ]]; then
      echo "global:" > $GLOBAL_OVERRIDES
      cat $COMPUTED_OVERRIDES | sed '/common:/,/consul:/d' \
        | sed -n '/^'"$START"'/,/'log:'/p' | sed '1d;$d' >> $GLOBAL_OVERRIDES
    else
      SUBCHART_DIR="$CACHE_SUBCHART_DIR/$(cut -d':' -f1 <<<"$START")"
      if [[ -d "$SUBCHART_DIR" ]]; then
        if [[ -z "$END" ]]; then
          cat $COMPUTED_OVERRIDES | sed -n '/^'"$START"'/,/'"$END"'/p' \
            | sed '1d;$d' | cut -c3- > $SUBCHART_DIR/subchart-overrides.yaml
        else
          cat $COMPUTED_OVERRIDES | sed -n '/^'"$START"'/,/^'"$END"'/p' \
            | sed '1d;$d' | cut -c3- > $SUBCHART_DIR/subchart-overrides.yaml
        fi
      fi
    fi
  done
}
resolve_deploy_flags() {
  flags=($1)
  n=${#flags[*]}
  for (( i = 0; i < n; i++ )); do
    PARAM=${flags[i]}
    if [[ $PARAM == "-f" || \
          $PARAM == "--values" || \
          $PARAM == "--set" || \
          $PARAM == "--set-string" || \
          $PARAM == "--version" ]]; then
       # skip param and its value
       i=$((i + 1))
    else
      DEPLOY_FLAGS="$DEPLOY_FLAGS $PARAM"
    fi
  done
  echo "$DEPLOY_FLAGS"
}

deploy() {
  # validate params
  if [[ -z "$1" || -z "$2" ]]; then
    usage
    exit 0
  fi

  RELEASE=$1
  CHART_URL=$2
  FLAGS=${@:3}
  CHART_REPO="$(cut -d'/' -f1 <<<"$CHART_URL")"
  CHART_NAME="$(cut -d'/' -f2 <<<"$CHART_URL")"
  if [[ $HELM_VER == "v3."* ]]; then
    CACHE_DIR=~/.local/share/helm/plugins/deploy/cache
  else
    CACHE_DIR=~/.helm/plugins/deploy/cache
  fi
  echo "Use cache dir: $CACHE_DIR"
  CHART_DIR=$CACHE_DIR/$CHART_NAME
  CACHE_SUBCHART_DIR=$CHART_DIR-subcharts
  LOG_DIR=$CHART_DIR/logs

  # determine if verbose output is enabled
  VERBOSE="false"
  if [[ $FLAGS = *"--verbose"* ]]; then
    FLAGS="$(echo $FLAGS| sed -n 's/--verbose//p')"
    VERBOSE="true"
  fi
  # determine if delay for deployment is enabled
  DELAY="false"
  if [[ $FLAGS = *"--delay"* ]]; then
    FLAGS="$(echo $FLAGS| sed -n 's/--delay//p')"
    DELAY="true"
  fi
  # determine if set-last-applied flag is enabled
  SET_LAST_APPLIED="false"
  if [[ $FLAGS = *"--set-last-applied"* ]]; then
    FLAGS="$(echo $FLAGS| sed -n 's/--set-last-applied//p')"
    SET_LAST_APPLIED="true"
  fi
  if [[ $FLAGS = *"--dry-run"* ]]; then
    VERBOSE="true"
    FLAGS="$FLAGS --debug"
  fi

  # should pass all flags instead
  NAMESPACE="$(echo $FLAGS | sed -n 's/.*\(namespace\).\s*/\1/p' | cut -c10- | cut -d' ' -f1)"

  VERSION="$(echo $FLAGS | sed -n 's/.*\(version\).\s*/\1/p' | cut -c8- | cut -d' ' -f1)"

  if [ ! -z $VERSION ]; then
     VERSION="--version $VERSION"
  fi

  # Remove all override values passed in as arguments. These will be used during dry run
  # to resolve computed override values. Remaining flags will be passed on during
  # actual upgrade/install of parent and subcharts.
  DEPLOY_FLAGS=$(resolve_deploy_flags "$FLAGS")

  # determine if upgrading individual subchart or entire parent + subcharts
  SUBCHART_RELEASE="$(cut -d'-' -f2 <<<"$RELEASE")"
  # update specified subchart without parent
  RELEASE="$(cut -d'-' -f1 <<<"$RELEASE")"
  if [[ $SUBCHART_RELEASE == $RELEASE ]]; then
    SUBCHART_RELEASE=
  fi

  # clear previously cached charts
  rm -rf $CACHE_DIR

  # fetch umbrella chart (parent chart containing subcharts)
  if [[ -d "$CHART_URL" ]]; then
    mkdir -p $CHART_DIR
    cp -R $CHART_URL/* $CHART_DIR/

    charts=$CHART_DIR/charts/*
    for subchart in $charts ; do
      tar xzf ${subchart} -C $CHART_DIR/charts/
    done
    rm -rf $CHART_DIR/charts/*.tgz
  else
    echo "fetching $CHART_URL"
    helm fetch $CHART_URL --untar --untardir $CACHE_DIR $VERSION
  fi

  # create log driectory
  mkdir -p $LOG_DIR

  # move out subcharts to process separately
  mkdir -p $CACHE_SUBCHART_DIR
  mv $CHART_DIR/charts/* $CACHE_SUBCHART_DIR/
  # temp hack - parent chart needs common subchart
  mv $CACHE_SUBCHART_DIR/common $CHART_DIR/charts/

  # disable dependencies
  rm $CHART_DIR/requirements.lock
  mv $CHART_DIR/requirements.yaml $CHART_DIR/requirements.deploy

  # compute overrides for parent and all subcharts
  COMPUTED_OVERRIDES=$CACHE_DIR/$CHART_NAME/computed-overrides.yaml
  helm upgrade -i $RELEASE $CHART_DIR $FLAGS --dry-run --debug \
   | sed -n '/COMPUTED VALUES:/,/HOOKS:/p' | sed '1d;$d' > $COMPUTED_OVERRIDES

  # extract global overrides to apply to parent and all subcharts
  GLOBAL_OVERRIDES=$CHART_DIR/global-overrides.yaml
  generate_overrides $COMPUTED_OVERRIDES $GLOBAL_OVERRIDES

  # upgrade/install parent chart first
  if [[ -z "$SUBCHART_RELEASE" ]]; then
    LOG_FILE=$LOG_DIR/${RELEASE}.log
    :> $LOG_FILE

    helm upgrade -i $RELEASE $CHART_DIR $DEPLOY_FLAGS -f $COMPUTED_OVERRIDES \
     > $LOG_FILE.log 2>&1

    if [[ $VERBOSE == "true" ]]; then
      cat $LOG_FILE
    else
      echo "release \"$RELEASE\" deployed"
    fi
    # Add annotation last-applied-configuration if set-last-applied flag is set
    if [[ $SET_LAST_APPLIED == "true" ]]; then
      helm get manifest ${RELEASE} \
      | kubectl apply set-last-applied --create-annotation -n onap -f - \
      > $LOG_FILE.log 2>&1
    fi
  fi

  # upgrade/install each "enabled" subchart
  cd $CACHE_SUBCHART_DIR/
  #“helm ls” is an expensive command in that it can take a long time to execute.
  #So cache the results to prevent repeated execution.
  ALL_HELM_RELEASES=$(helm ls -q)
  for subchart in * ; do
    SUBCHART_OVERRIDES=$CACHE_SUBCHART_DIR/$subchart/subchart-overrides.yaml

    SUBCHART_ENABLED=0
    if [[ -f $SUBCHART_OVERRIDES ]]; then
      SUBCHART_ENABLED=$(cat $SUBCHART_OVERRIDES | grep -c "^enabled: true")
    fi

    if [[ $SUBCHART_ENABLED -eq 1 ]]; then
      if [[ -z "$SUBCHART_RELEASE" || $SUBCHART_RELEASE == "$subchart" ]]; then
        LOG_FILE=$LOG_DIR/"${RELEASE}-${subchart}".log
        :> $LOG_FILE

        helm upgrade -i "${RELEASE}-${subchart}" $CACHE_SUBCHART_DIR/$subchart \
         $DEPLOY_FLAGS -f $GLOBAL_OVERRIDES -f $SUBCHART_OVERRIDES \
         > $LOG_FILE 2>&1

        if [[ $VERBOSE == "true" ]]; then
          cat $LOG_FILE
        else
          echo "release \"${RELEASE}-${subchart}\" deployed"
        fi
	# Add annotation last-applied-configuration if set-last-applied flag is set
        if [[ $SET_LAST_APPLIED == "true" ]]; then
          helm get manifest "${RELEASE}-${subchart}" \
          | kubectl apply set-last-applied --create-annotation -n onap -f - \
	      > $LOG_FILE.log 2>&1
        fi
      fi
	  if [[ $DELAY == "true" ]]; then
		echo sleep 3m
		sleep 3m
	  fi
    else
      array=($(echo "$ALL_HELM_RELEASES" | grep "${RELEASE}-${subchart}"))
      n=${#array[*]}
      for (( i = n-1; i >= 0; i-- )); do
        if [[ $HELM_VER == "v3."* ]]; then
          helm del "${array[i]}" 
        else
          helm del "${array[i]}" --purge
        fi
      done
    fi
  done

  # report on success/failures of installs/upgrades
  helm ls | grep FAILED | grep $RELEASE
}
HELM_VER=$(helm version --template "{{.Version}}")
echo $HELM_VER

case "${1:-"help"}" in
  "help")
    usage
    ;;
  "--help")
    usage
    ;;
  "-h")
    usage
    ;;
  *)
    deploy $1 $2 ${@:3}
    ;;
esac

exit 0

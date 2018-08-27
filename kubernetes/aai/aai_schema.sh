#!/bin/bash

# Instead of duplicating the changes from aai-common
# Clone the repo and extract the oxm and dbedgerules
function retrieve_schema_edgerules(){

    local current_branch=$(git rev-parse --abbrev-ref HEAD);
    local current_dir=$(pwd);
    echo "Current directory: $current_dir";

    local microservice_name=aai-common;
    temp_dir=/tmp/${microservice_name}-$(uuidgen);

    if [ -d "${current_dir}/aai/resources/config/schema" ]; then
        return;
    fi;

    (
        mkdir -p ${temp_dir} && cd ${temp_dir};
        rm -r ${current_dir}/aai/resources/config/schema

        git init
        git remote add origin https://gerrit.onap.org/r/aai/aai-common
        git config core.sparsecheckout true

        # Specifies which folders to checkout from the repo
        # Limited to only the aai-resources as we don't need other folders from
        # microservice deployment for this repository

        echo "aai-schema/src/main/resources/**" >> .git/info/sparse-checkout

        git fetch --depth=1 origin ${current_branch} && {
            git checkout ${current_branch}
        } || {
            echo "Unable to find the branch ${current_branch} in aai-common, so using default branch ${default_branch}";
            git fetch --depth=1 origin ${default_branch}
            git checkout ${default_branch}
        }

        mkdir -p ${current_dir}/aai/resources/config/schema;
        cp -R ${temp_dir}/aai-schema/src/main/resources/onap/ ${current_dir}/aai/resources/config/schema;

        rm -rf ${temp_dir};
    );
}

retrieve_schema_edgerules;


    apiVersion: v1
    data:
      installSdncDb.sh: |
        #!/bin/bash

        ###
        # Test with sh
        # ============LICENSE_START=======================================================
        # ONAP : SDN-C
        # ================================================================================
        # Copyright (C) 2017 AT&T Intellectual Property. All rights
        # 							reserved.
        # ================================================================================
        # Licensed under the Apache License, Version 2.0 (the "License");
        # you may not use this file except in compliance with the License.
        # You may obtain a copy of the License at
        #
        #      http://www.apache.org/licenses/LICENSE-2.0
        #
        # Unless required by applicable law or agreed to in writing, software
        # distributed under the License is distributed on an "AS IS" BASIS,
        # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        # See the License for the specific language governing permissions and
        # limitations under the License.
        # ============LICENSE_END=========================================================
        ###

        SDNC_HOME=${SDNC_HOME:-/opt/onap/sdnc}
        ETC_DIR=${ETC_DIR:-${SDNC_HOME}/data}
        BIN_DIR=${BIN_DIR-${SDNC_HOME}/bin}
        MYSQL_HOST=${MYSQL_HOST:-dbhost}
        MYSQL_PASSWORD=${MYSQL_PASSWORD:-openECOMP1.0}

        SDNC_DB_USER=${SDNC_DB_USER:-sdnctl}
        SDNC_DB_PASSWORD=${SDNC_DB_PASSWORD:-gamma}
        SDNC_DB_DATABASE=${SDN_DB_DATABASE:-sdnctl}


        # Create tablespace and user account
        mysql -h ${MYSQL_HOST} -u root -p${MYSQL_PASSWORD} mysql <<-END
        CREATE DATABASE IF NOT EXISTS ${SDNC_DB_DATABASE};
        CREATE USER '${SDNC_DB_USER}'@'localhost' IDENTIFIED BY '${SDNC_DB_PASSWORD}';
        CREATE USER '${SDNC_DB_USER}'@'%' IDENTIFIED BY '${SDNC_DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${SDNC_DB_DATABASE}.* TO '${SDNC_DB_USER}'@'localhost' WITH GRANT OPTION;
        GRANT ALL PRIVILEGES ON ${SDNC_DB_DATABASE}.* TO '${SDNC_DB_USER}'@'%' WITH GRANT OPTION;
        flush privileges;
        commit;
        END

        # load schema
        if [ -f ${ETC_DIR}/sdnctl.dump ]
        then
          mysql -h ${MYSQL_HOST} -u root -p${MYSQL_PASSWORD} sdnctl < ${ETC_DIR}/sdnctl.dump
        fi

        for datafile in ${ETC_DIR}/*.data.dump
        do
          mysql -h ${MYSQL_HOST} -u root -p${MYSQL_PASSWORD} sdnctl < $datafile
        done

        # Create VNIs 100-199
        ${BIN_DIR}/addVnis.sh 100 199

        # Drop FK_NETWORK_MODEL foreign key as workaround for SDNC-291.
        ${BIN_DIR}/rmForeignKey.sh NETWORK_MODEL FK_NETWORK_MODEL

        if [ -x ${SDNC_HOME}/svclogic/bin/install.sh ]
        then
            echo "Installing directed graphs"
            ${SDNC_HOME}/svclogic/bin/install.sh
        fi


        exit 0

      startODL.sh: |
        #!/bin/bash
        #
        ###
        # ============LICENSE_START=======================================================
        # SDNC
        # ================================================================================
        # Copyright (C) 2017 AT&T Intellectual Property. All rights reserved.
        # ================================================================================
        # Licensed under the Apache License, Version 2.0 (the "License");
        # you may not use this file except in compliance with the License.
        # You may obtain a copy of the License at
        #
        #      http://www.apache.org/licenses/LICENSE-2.0
        #
        # Unless required by applicable law or agreed to in writing, software
        # distributed under the License is distributed on an "AS IS" BASIS,
        # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        # See the License for the specific language governing permissions and
        # limitations under the License.
        # ============LICENSE_END=========================================================
        ###
        #
        # Append features to karaf boot feature configuration
        # $1 additional feature to be added
        # $2 repositories to be added (optional)
        function addToFeatureBoot() {
          CFG=$ODL_HOME/etc/org.apache.karaf.features.cfg
          ORIG=$CFG.orig
          if [ -n "$2" ] ; then
            echo "Add repository: $2"
            mv $CFG $ORIG
            cat $ORIG | sed -e "\|featuresRepositories|s|$|,$2|" > $CFG
          fi
          echo "Add boot feature: $1"
          mv $CFG $ORIG
          cat $ORIG | sed -e "\|featuresBoot *=|s|$|,$1|" > $CFG
        }
        #
        # Append features to karaf boot feature configuration
        # $1 search pattern
        # $2 replacement
        function replaceFeatureBoot() {
          CFG=$ODL_HOME/etc/org.apache.karaf.features.cfg
          ORIG=$CFG.orig
          echo "Replace boot feature $1 with: $2"
          sed -i "/featuresBoot/ s/$1/$2/g" $CFG
        }
        #
        function install_sdnrwt_features() {
          addToFeatureBoot "$SDNRWT_BOOTFEATURES" $SDNRWT_REPOSITORY
        }
        #
        function enable_odl_cluster(){
          if [ -z $SDNC_REPLICAS ]; then
            echo "SDNC_REPLICAS is not configured in Env field"
            exit
          fi
        #
          #Be sure to remove feature odl-netconf-connector-all from list
          replaceFeatureBoot "odl-netconf-connector-all,"
        #
          echo "Installing Opendaylight cluster features"
          replaceFeatureBoot odl-netconf-topology odl-netconf-clustered-topology
          replaceFeatureBoot odl-mdsal-all odl-mdsal-all,odl-mdsal-clustering
          addToFeatureBoot odl-jolokia
          #${ODL_HOME}/bin/client feature:install odl-mdsal-clustering
          #${ODL_HOME}/bin/client feature:install odl-jolokia
        #  
        #
          echo "Update cluster information statically"
          hm=$(hostname)
          echo "Get current Hostname ${hm}"
        #
          node=($(echo ${hm} | sed 's/-[0-9]*$//g'))
          node_index=($(echo ${hm} | awk -F"-" '{print $NF}'))
          member_offset=1
        #
          if $GEO_ENABLED; then
            echo "This is a Geo cluster"
        #
            if [ -z $IS_PRIMARY_CLUSTER ] || [ -z $MY_ODL_CLUSTER ] || [ -z $PEER_ODL_CLUSTER ]; then
              echo "IS_PRIMARY_CLUSTER, MY_ODL_CLUSTER and PEER_ODL_CLUSTER must all be configured in Env field"
              return
            fi
        #
            if $IS_PRIMARY_CLUSTER; then
              PRIMARY_NODE=${MY_ODL_CLUSTER}
              SECONDARY_NODE=${PEER_ODL_CLUSTER}
            else
              PRIMARY_NODE=${PEER_ODL_CLUSTER}
              SECONDARY_NODE=${MY_ODL_CLUSTER}
              member_offset=4
            fi
        #
            node_list="${PRIMARY_NODE} ${SECONDARY_NODE}"
        #
            /opt/onap/sdnc/bin/configure_geo_cluster.sh $((node_index+member_offset)) ${node_list}
          else
            echo "This is a local cluster"
            node_list="{{.Release.Name}}-sdnc-0.{{.Values.service.name}}-cluster.{{.Release.Namespace}}";
            for ((i=1;i<${SDNC_REPLICAS};i++));
            do
              node_list="${node_list} {{.Release.Name}}-sdnc-$i.{{.Values.service.name}}-cluster.{{.Release.Namespace}}";
            done
            node_list1="{{.Release.Name}}-sdnc-backup-0.{{.Values.service.name}}-cluster.{{.Release.Namespace}}";
            for ((i=1;i<${SDNC_REPLICAS};i++));
            do
              node_list1="${node_list1} {{.Release.Name}}-sdnc-backup-$i.{{.Values.service.name}}-cluster.{{.Release.Namespace}}";
            done
            for ((i=1;i<${SDNC_REPLICAS};i++));
            do
              if [ ${hm} == "{{.Release.Name}}-sdnc-$((i-1))" ]; then
                /opt/opendaylight/current/bin/configure_cluster.sh $i ${node_list} ${node_list1};
              fi
              if [ ${hm} == "{{.Release.Name}}-sdnc-backup-$((i-1))" ]; then
                /opt/opendaylight/current/bin/configure_cluster.sh $((i+SDNC_REPLICAS)) ${node_list} ${node_list1};
              fi
            done
          fi
        }
        #
        #
        # Install SDN-C platform components if not already installed and start container
        #
        ODL_HOME=${ODL_HOME:-/opt/opendaylight/current}
        ODL_ADMIN_USERNAME=${ODL_ADMIN_USERNAME:-admin}
        ODL_ADMIN_PASSWORD=${ODL_ADMIN_PASSWORD:-Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U}
        SDNC_HOME=${SDNC_HOME:-/opt/onap/sdnc}
        SDNC_BIN=${SDNC_BIN:-/opt/onap/sdnc/bin}
        CCSDK_HOME=${CCSDK_HOME:-/opt/onap/ccsdk}
        ENABLE_ODL_CLUSTER=${ENABLE_ODL_CLUSTER:-false}
        GEO_ENABLED=${GEO_ENABLED:-false}
        SDNRWT=${SDNRWT:-false}
        SDNRWT_BOOTFEATURES=${SDNRWT_BOOTFEATURES:-sdnr-wt-feature-aggregator}
        export ODL_ADMIN_PASSWORD ODL_ADMIN_USERNAME
        #
        echo "Settings:"
        echo "  ENABLE_ODL_CLUSTER=$ENABLE_ODL_CLUSTER"
        echo "  SDNC_REPLICAS=$SDNC_REPLICAS"
        echo "  SDNRWT=$SDNRWT"

        if [ ! -f ${SDNC_HOME}/.installed ]
        then 
        echo "Installing SDN-C keyStore"
        ${SDNC_HOME}/bin/addSdncKeyStore.sh
        if $ENABLE_ODL_CLUSTER ; then enable_odl_cluster ; fi
        if $SDNRWT ; then install_sdnrwt_features ; fi
        echo "Installed at `date`" > ${SDNC_HOME}/.installed
        fi
        
        cp /opt/opendaylight/current/certs/* /tmp
        nohup python ${SDNC_BIN}/installCerts.py &

        exec ${ODL_HOME}/bin/karaf server
        echo "Tri Nguyen"

    kind: ConfigMap
    metadata:
      labels:
        app: sdnc
        chart: sdnc-5.0.0
        heritage: Tiller
        release: devsdnc
      name: devsdnc-sdnc-bin
      namespace: onap
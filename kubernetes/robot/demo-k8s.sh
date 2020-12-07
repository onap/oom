#!/bin/bash
# Copyright (C) 2018 Amdocs, Bell Canada
# Modifications Copyright (C) 2019 Samsung
# Modifications Copyright (C) 2020 Nokia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Execute tags built to support the hands-on demo
#
function usage
{
	echo "Usage: demo-k8s.sh <namespace> <command> [<parameters>] [execscript]"
	echo " "
	echo "       demo-k8s.sh <namespace> init"
	echo "               - Execute both init_customer + distribute"
	echo " "
	echo "       demo-k8s.sh <namespace> init_customer"
	echo "               - Create demo customer (Demonstration) and services, etc."
	echo " "
	echo "       demo-k8s.sh <namespace> distribute  [<prefix>]"
	echo "               - Distribute demo models (demoVFW and demoVLB)"
	echo " "
	echo "       demo-k8s.sh <namespace> preload <vnf_name> <module_name>"
	echo "               - Preload data for VNF for the <module_name>"
	echo " "
	echo "       demo-k8s.sh <namespace> appc <module_name>"
	echo "               - provide APPC with vFW module mount point for closed loop"
	echo " "
	echo "       demo-k8s.sh <namespace> init_robot [ <etc_hosts_prefix> ]"
	echo "               - Initialize robot after all ONAP VMs have started"
	echo " "
	echo "       demo-k8s.sh <namespace> instantiateVFW"
	echo "               - Instantiate vFW module for the demo customer (DemoCust<uuid>)"
	echo " "
	echo "       demo-k8s.sh <namespace> instantiateVFWdirectso  csar_filename"
	echo "               - Instantiate vFW module using direct SO interface using previously distributed model "
        echo "                 that is in /tmp/csar in robot container"
	echo " "
        echo "       demo-k8s.sh <namespace> instantiateVLB_CDS"
        echo "               - Instantiate vLB module using CDS with a preloaded CBA "
        echo " "
	echo "       demo-k8s.sh <namespace> deleteVNF <module_name from instantiateVFW>"
	echo "               - Delete the module created by instantiateVFW"
	echo " "
	echo "       demo-k8s.sh <namespace> vfwclosedloop <pgn-ip-address>"
        echo "               - vFWCL: Sets the packet generator to high and low rates, and checks whether the policy "
        echo "                 kicks in to modulate the rates back to medium"
	echo " "
	echo "       demo-k8s.sh <namespace> <command> [<parameters>] execscript"
	echo "               - Optional parameter to execute user custom scripts located in scripts/demoscript directory"
	echo " "
}

# Check if execscript flag is used and drop it from input arguments

if [[ "${!#}" == "execscript" ]]; then
        set -- "${@:1:$#-1}"
        execscript=true
fi

# Set the defaults

echo "Number of parameters:"
echo $#

if [ $# -lt 2 ];then
	usage
	exit
fi

NAMESPACE=$1
shift

##
## if more than 1 tag is supplied, the must be provided with -i or -e
##
while [ $# -gt 0 ]
do
	key="$1"
        echo "KEY:"
        echo $key

	case $key in
    	init_robot)
			TAG="UpdateWebPage"
			read -s -p "WEB Site Password for user 'test': " WEB_PASSWORD
			if [ "$WEB_PASSWORD" = "" ]; then
				echo ""
				echo "WEB Password is required for user 'test'"
				exit
			fi
			VARIABLES="$VARIABLES -v WEB_PASSWORD:$WEB_PASSWORD"
			shift
			if [ $# -eq 2 ];then
				VARIABLES="$VARIABLES -v HOSTS_PREFIX:$1"
			fi
			shift
			;;
    	init)
			TAG="InitDemo"
			shift
			;;
	    vescollector)
			TAG="vescollector"
			shift
			;;
        distribute_vcpe)
			TAG="distributeVCPE"
			shift
			;;
    	init_customer)
			TAG="InitCustomer"
			shift
			;;
    	distribute)
			TAG="InitDistribution"
			shift
			if [ $# -eq 1 ];then
				VARIABLES="$VARIABLES -v DEMO_PREFIX:$1"
			fi
			shift
			;;
    	preload)
			TAG="PreloadDemo"
			shift
			if [ $# -ne 2 ];then
				echo "Usage: demo-k8s.sh <namespace> preload <vnf_name> <module_name>"
				exit
			fi
			VARIABLES="$VARIABLES -v VNF_NAME:$1"
			shift
			VARIABLES="$VARIABLES -v MODULE_NAME:$1"
			shift
			;;
    	appc)
			TAG="APPCMountPointDemo"
			shift
			if [ $# -ne 1 ];then
					echo "Usage: demo-k8s.sh <namespace> appc <module_name>"
					exit
				fi
			VARIABLES="$VARIABLES -v MODULE_NAME:$1"
			shift
			;;
    	instantiateVFW)
			TAG="instantiateVFW"
			VARIABLES="$VARIABLES -v GLOBAL_BUILD_NUMBER:$$"
			shift
			;;
        instantiateVFWdirectso)
                        TAG="instantiateVFWdirectso"
                        shift
                        if [ $# -ne 1 ];then
                                        echo "Usage: demo-k8s.sh <namespace> instantiateVFWdirectso <csar_filename>"
                                        exit
                                fi
                        VARIABLES="$VARIABLES -v CSAR_FILE:$1 -v GLOBAL_BUILD_NUMBER:$$"
                        shift
                        ;;
        instantiateVLB_CDS)
                        TAG="instantiateVLB_CDS"
                        VARIABLES="$VARIABLES -v GLOBAL_BUILD_NUMBER:$$"
                        shift
                        ;;
    	deleteVNF)
			TAG="deleteVNF"
			shift
			if [ $# -ne 1 ];then
				echo "Usage: demo-k8s.sh <namespace> deleteVNF <module_name from instantiateVFW>"
				exit
			fi
			VARFILE=$1.py
			VARIABLES="$VARIABLES -V /share/${VARFILE}"
			shift
			;;
    	cds)
			TAG="cds"
			shift
			;;
        distributeVFWNG)
                        TAG="distributeVFWNG"
                        shift
                        ;;
        distributeDemoVFWDT)
                        TAG="DistributeDemoVFWDT"
                        shift
                        ;;
        instantiateDemoVFWDT)
                        TAG="instantiateVFWDT"
                        shift
                        ;;
        vfwclosedloop)
                        TAG="vfwclosedloop"
                        shift
                        VARIABLES="$VARIABLES -v PACKET_GENERATOR_HOST:$1 -v pkg_host:$1"
                        shift
                        ;;
    	*)
			usage
			exit
	esac
done

set -x

POD=$(kubectl --namespace $NAMESPACE get pods | sed 's/ .*//'| grep robot)

DIR=$(dirname "$0")
SCRIPTDIR=scripts/demoscript

ETEHOME=/var/opt/ONAP

if [ $execscript ]; then
   for script in $(ls -1 "$DIR/$SCRIPTDIR"); do
      [ -f "$DIR/$SCRIPTDIR/$script" ] && [ -x "$DIR/$SCRIPTDIR/$script" ] && source "$DIR/$SCRIPTDIR/$script"
   done
fi

export GLOBAL_BUILD_NUMBER=$(kubectl --namespace $NAMESPACE exec  ${POD}  -- bash -c "ls -1q /share/logs/ | wc -l")
OUTPUT_FOLDER=$(printf %04d $GLOBAL_BUILD_NUMBER)_demo_$key
DISPLAY_NUM=$(($GLOBAL_BUILD_NUMBER + 90))

VARIABLEFILES="-V /share/config/robot_properties.py"

kubectl --namespace $NAMESPACE exec ${POD} -- ${ETEHOME}/runTags.sh ${VARIABLEFILES} ${VARIABLES} -d /share/logs/${OUTPUT_FOLDER} -i ${TAG} --display $DISPLAY_NUM 2> ${TAG}.out

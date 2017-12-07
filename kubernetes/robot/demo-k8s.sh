#!/bin/bash

#
# Execute tags built to support the hands on demo,
#
function usage
{
	echo "Usage: demo.sh <command> [<parameters>]"
	echo " "
	echo "       demo.sh init"
	echo "               - Execute both init_customer + distribute"
	echo " "
	echo "       demo.sh init_customer"
	echo "               - Create demo customer (Demonstration) and services, etc."
	echo " "
	echo "       demo.sh distribute  [<prefix>]"
	echo "               - Distribute demo models (demoVFW and demoVLB)"
	echo " "
	echo "       demo.sh preload <vnf_name> <module_name>"
	echo "               - Preload data for VNF for the <module_name>"
	echo " "
	echo "       demo.sh appc <module_name>"
    echo "               - provide APPC with vFW module mount point for closed loop"
	echo " "
	echo "       demo.sh init_robot"
    echo "               - Initialize robot after all ONAP VMs have started"
	echo " "
	echo "       demo.sh instantiateVFW"
    echo "               - Instantiate vFW module for the a demo customer (DemoCust<uuid>)"
	echo " "
	echo "       demo.sh deleteVNF <module_name from instantiateVFW>"
    echo "               - Delete the module created by instantiateVFW"
	echo " "
	echo "       demo.sh heatbridge <stack_name> <service_instance_id> <service>"
    echo "               - Run heatbridge against the stack for the given service instance and service"
}

# Set the defaults
if [ $# -eq 0 ];then
	usage
	exit
fi
##
## if more than 1 tag is supplied, the must be provided with -i or -e
##
while [ $# -gt 0 ]
do
	key="$1"

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
			;;
    	init)
			TAG="InitDemo"
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
				echo "Usage: demo.sh preload <vnf_name> <module_name>"
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
			echo "Usage: demo.sh appc <module_name>"
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
    	deleteVNF)
			TAG="deleteVNF"
			shift
			if [ $# -ne 1 ];then
				echo "Usage: demo.sh deleteVNF <module_name from instantiateVFW>"
				exit
			fi
			VARFILE=$1.py
			if [ -e /opt/eteshare/${VARFILE} ]; then
				VARIABLES="$VARIABLES -V /share/${VARFILE}"
			else
				echo "Cache file ${VARFILE} is not found"
				exit
			fi
      shift
			;;
    	heatbridge)
			TAG="heatbridge"
			shift
			if [ $# -ne 3 ];then
				echo "Usage: demo.sh heatbridge <stack_name> <service_instance_id> <service>"
				exit
			fi
			VARIABLES="$VARIABLES -v HB_STACK:$1"
			shift
			VARIABLES="$VARIABLES -v HB_SERVICE_INSTANCE_ID:$1"
			shift
			VARIABLES="$VARIABLES -v HB_SERVICE:$1"
			shift
			;;
    	*)
			usage
			exit
	esac
done

ETEHOME=/var/opt/OpenECOMP_ETE
VARIABLEFILES="-V /share/config/vm_properties.py -V /share/config/integration_robot_properties.py -V /share/config/integration_preload_parameters.py"
POD=$(kubectl --namespace onap-robot get pods | sed 's/ .*//'| grep robot)
kubectl --namespace onap-robot exec ${POD} -- ${ETEHOME}/runTags.sh ${VARIABLEFILES} ${VARIABLES} -d /share/logs/demo/${TAG} -i ${TAG} --display 89 2> ${TAG}.out

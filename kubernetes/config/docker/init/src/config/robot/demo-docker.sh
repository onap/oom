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
	echo "       demo.sh distribute"
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
    	*)
			usage
			exit
	esac
done

ETEHOME=/var/opt/OpenECOMP_ETE
VARIABLEFILES="-V /share/config/vm_properties.py -V /share/config/integration_robot_properties.py -V /share/config/integration_preload_parameters.py"
CONTAINER_ID=`docker ps |grep robot |grep onap-robot|grep -v gcr|awk '{print $1}'`
docker exec ${CONTAINER_ID} ${ETEHOME}/runTags.sh ${VARIABLEFILES} ${VARIABLES} -d ${ETEHOME}/html/logs/demo/${TAG} -i ${TAG} --display 89 2> ${TAG}.out

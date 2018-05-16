#!/bin/bash
export PATH=$PATH:.
appDir=$(pwd)
if [ "$#" != 3 -a "$#" != 4 ]
then
	echo "Usage $0 releaseDir  loginId emailAddress [gitLocalRepository]"
	echo "Note: Specify the gitLocalRepository path if you would want to be able to import flows from your local git repository"
	exit
fi
if [ ! -e "releases" ]
then
	mkdir releases
fi
releaseDir="$1"
name="Release $releaseDir"
loginId="$2"
emailid="$3"
dbHost="{{.Values.config.dbServiceName}}.{{.Release.Namespace}}"
dbPort="3306"
dbName="sdnctl"
dbUser="sdnctl"
dbPassword="{{.Values.config.dbSdnctlPassword}}"
gitLocalRepository="$4"

lastPort=$(find "releases/" -name "customSettings.js" |xargs grep uiPort|cut -d: -f2|sed -e s/,//|sort|tail -1)
echo $lastPort|grep uiPort >/dev/null 2>&1
if [ "$?" == "0" ]
then
lastPort=$(find "releases/" -name "customSettings.js" |xargs grep uiPort|cut -d: -f3|sed -e s/,//|sort|tail -1)
fi
#echo $lastPort
if [ "${lastPort}" == "" ]
then
	lastPort="3099"
fi
let nextPort=$(expr $lastPort+1)
#echo $nextPort
if [ ! -e "releases/$releaseDir" ]
then
mkdir releases/$releaseDir
cd releases/$releaseDir
mkdir flows
mkdir flows/shared
mkdir flows/shared/backups
mkdir html
mkdir xml
mkdir lib
mkdir lib/flows
mkdir logs
mkdir conf
mkdir codecloud
customSettingsFile="customSettings.js"
if [ ! -e "./$customSettingsFile" ]
then
	echo "module.exports = {" >$customSettingsFile
	echo "		'name' : '$name'," >>$customSettingsFile
	echo "		'emailAddress' :'$emailid'," >>$customSettingsFile
	echo "		'uiPort' :$nextPort," >>$customSettingsFile
	echo "		'mqttReconnectTime': 15000," >>$customSettingsFile
	echo "		'serialReconnectTime' : 15000,"  >>$customSettingsFile
	echo "		'debugMaxLength': 1000," >>$customSettingsFile
	echo "		'htmlPath': 'releases/$releaseDir/html/'," >>$customSettingsFile
	echo "		'xmlPath': 'releases/$releaseDir/xml/'," >>$customSettingsFile
	echo "		'flowFile' : 'releases/$releaseDir/flows/flows.json'," >>$customSettingsFile
	echo "		'sharedDir': 'releases/$releaseDir/flows/shared'," >>$customSettingsFile
	echo "		'userDir' : 'releases/$releaseDir'," >>$customSettingsFile
	echo "		'httpAuth': {user:'$loginId',pass:'cc03e747a6afbbcbf8be7668acfebee5'}," >>$customSettingsFile
	echo "		'dbHost': '$dbHost'," >>$customSettingsFile
	echo "		'dbPort': '$dbPort'," >>$customSettingsFile
	echo "		'dbName': '$dbName'," >>$customSettingsFile
	echo "		'dbUser': '$dbUser'," >>$customSettingsFile
	echo "		'dbPassword': '$dbPassword'," >>$customSettingsFile
	echo "		'gitLocalRepository': '$gitLocalRepository'" >>$customSettingsFile
	echo "		}" >>$customSettingsFile
fi
	#echo "Created custom settings  file $customSettingsFile"
	echo "Done ....."
else
	echo "ERROR:customSettings file $customSettingsFile already exists for $releaseDir"
	exit
fi
#echo "Content of custom settings file"
#echo "============================================================================"
#	cat $customSettingsFile
#echo "============================================================================"
svclogicPropFile="./conf/svclogic.properties"
if [ ! -d "${appDir}/yangFiles" ]
then
	mkdir -p "${appDir}/yangFiles"
fi
if [ ! -d "${appDir}/generatedJS" ]
then
	mkdir -p "${appDir}/generatedJS"
fi

if [ ! -e "./$svclogicPropFile" ]
then
	echo "org.onap.ccsdk.sli.dbtype=jdbc" >$svclogicPropFile
	echo "org.onap.ccsdk.sli.jdbc.url=jdbc:mysql://{{.Values.config.dbServiceName}}.{{.Release.Namespace}}:3306/sdnctl" >>$svclogicPropFile
	echo "org.onap.ccsdk.sli.jdbc.database=sdnctl" >>$svclogicPropFile
	echo "org.onap.ccsdk.sli.jdbc.user=sdnctl" >>$svclogicPropFile
	echo "org.onap.ccsdk.sli.jdbc.password={{.Values.config.dbSdnctlPassword}}" >>$svclogicPropFile
fi
if [ ! -e "${appDir}/flowShareUsers.js" ]
then
	echo "module.exports = {\"flowShareUsers\":" >${appDir}/flowShareUsers.js
        echo "	[" >>${appDir}/flowShareUsers.js
        echo "	]" >>${appDir}/flowShareUsers.js
        echo "}" >>${appDir}/flowShareUsers.js
fi
grep "$releaseDir" ${appDir}/flowShareUsers.js >/dev/null 2>&1
if [ "$?" != "0" ]
then
	num_of_lines=$(cat ${appDir}/flowShareUsers.js|wc -l)
	if [ $num_of_lines -gt 4 ]
	then
		content=$(head -n -2 ${appDir}/flowShareUsers.js)
		echo "${content}," > ${appDir}/flowShareUsers.js
	else
		content=$(head -n -2 ${appDir}/flowShareUsers.js)
		echo "$content" > ${appDir}/flowShareUsers.js
	fi
	echo "	{" >> ${appDir}/flowShareUsers.js
	echo "          \"name\" : \"$name\"," >> ${appDir}/flowShareUsers.js
	echo "          \"rootDir\" : \"$releaseDir\"" >> ${appDir}/flowShareUsers.js
	echo "	}" >> ${appDir}/flowShareUsers.js
	echo "	]" >> ${appDir}/flowShareUsers.js
	echo "}" >> ${appDir}/flowShareUsers.js
fi

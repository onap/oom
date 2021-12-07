#!/bin/sh

#function to provide help
#desc: this function provide help menu
#argument: -h for help, -p for path, -r for repository
#calling syntax: options

options() {
  cat <<EOF
Usage: $0 [PARAMs]
-h                  : help
-l (Location)           : path for searching values.yaml
                      [in case no path is provided then is will scan current directories for values.yml]
-r (Repository)     : name of image repository
                      [format [repository name/url]:(port)]
                      [in case no repository is provided then defualt image repository will be nexus3.onap.org:10001]
-u (User)           : user name for login
                      [in case no user name is provided then default user will be docker]
-p (Password)       : password for login
                      [in case no password is provided then default user will be docker]
EOF
}

#function to parse yaml file
#desc: this function convert yaml file to dotted notion
#argument: yaml file
#calling syntax: parse_yaml <yaml_file_name>

parse_yaml () {
   local prefix
   prefix=$2
   local s
   s='[[:space:]]*'
   local w
   w='[a-zA-Z0-9_]*'
   local fs
   fs=$(echo @|tr @ '\034')

   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])(".")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

#algorithmic steps
#start
#scan all values.yaml files
#parse yaml file into dotted format
#for each lines check there is image tag in line
#store image name and check next line for version information
#if in next line version is not present as a subtag then call docker pull with imageName
#if version is present in next line then call docker pull with imageName and imageVersion
#end


#start processing for finding images and version
IMAGE_TEXT="image"
IMAGE_VERSION_TEXT="Version"
LOCATION="."
VALUES_FILE_NAME="values.yaml"
IMAGE_REPOSITORY="nexus3.onap.org:10001"
USER_NAME="docker"
PASSWORD="docker"

#scan for options menu
while getopts ":h:l:r:u:p:" PARAM; do
  case $PARAM in
    h)
      options
      exit 1
      ;;
    l)
      LOCATION=${OPTARG}
      ;;
    r)
      IMAGE_REPOSITORY=${OPTARG}
      ;;
    u)
      USER_NAME=${OPTARG}
      ;;
    p)
      PASSWORD=${OPTARG}
      ;;
    ?)
      options
      exit
      ;;
  esac
done


#docker login to nexus repo
echo docker login -u $USER_NAME -p $PASSWORD $IMAGE_REPOSITORY
docker login -u $USER_NAME -p $PASSWORD $IMAGE_REPOSITORY

#scan all values.yaml files recursively
for filename in `find $LOCATION -name $VALUES_FILE_NAME`
do
        imageNameWithVersion=" ";
        #parse yaml files
        for line in  `parse_yaml $filename`
        do
                #skiping commented line
                if echo "$line" | grep -v '^#' >/dev/null; then
                        #find all image subtag inside converted values.yaml file's lines
                        if echo $line | grep -q $IMAGE_TEXT ; then
                                #find imageName inside line
                                imageName=`echo $line | awk -F "=" '{print $2}'`
                                #remove attional prefix and postfix
                                imageNameFinal=`echo "$imageName" | sed -e 's/^"//' -e 's/"$//' `

                                #check if line contain Version as a subtag in lines if yes then call docker pull with version
                                if echo $line | grep -q $IMAGE_VERSION_TEXT ; then
                                        echo docker pull "$imageNameWithVersion":"$imageNameFinal"
                                        docker pull $imageNameWithVersion:$imageNameFinal &
                                        imageNameWithVersion=" "
                                else
                                        #check Version is not in subtag and old scanned value is present then call docker pull without version
                                        if [ "$imageNameWithVersion" != " " ]; then
                                                echo docker pull "$imageNameWithVersion"
                                                docker pull $imageNameWithVersion &
                                                imageNameWithVersion=$imageNameFinal
                                        else
                                                imageNameWithVersion=$imageNameFinal
                                        fi
                                fi
                        fi
                fi
        done
done
# complete processing
echo "finished launching pulls"
#MAX_WAIT_INTERVALS=300
INTERVAL_COUNT=300
while [  $(ps -ef | grep docker | grep pull | grep -v $0 | wc -l) -gt 0 ]; do
  sleep 10
  INTERVAL_COUNT=$((INTERVAL_COUNT - 1))
  echo "waiting for last pull"
  if [ "$INTERVAL_COUNT" -eq 0 ]; then
    break
  fi
done


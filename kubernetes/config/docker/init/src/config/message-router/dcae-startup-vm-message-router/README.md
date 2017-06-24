This project hosts the configurations and start-up scripts for instantiating the Open eCOMP Message Router.

To deploy an Open eCOMP Message Router to a host:

0. prepare the docker host:
   a. install the following software:  git, docker, docker-compose
1. login to the docker host
2. git clone this project
3. edit the deploy.sh file with docker registry info and local configurations such as docker-compose 
4. run the deploy.sh as root

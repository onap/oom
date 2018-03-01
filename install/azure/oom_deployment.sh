az group delete --name a_ONAP_auto_201803181110z -y
az group create --name a_ONAP_auto_201803181110z --location eastus
az group deployment create --resource-group a_ONAP_auto_201803181110z --template-file arm_deploy_ons_sut.json --parameters @arm_deploy_ons_sut_parameters.json 


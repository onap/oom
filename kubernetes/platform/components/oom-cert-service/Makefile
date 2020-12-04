CERTS_DIR = resources
CURRENT_DIR := ${CURDIR}
DOCKER_CONTAINER = generate-certs
DOCKER_EXEC = docker exec ${DOCKER_CONTAINER}

all: start_docker \
     clear_all \
     root_generate_keys \
     root_create_certificate \
     root_self_sign_certificate \
     client_generate_keys \
     client_generate_csr \
     client_sign_certificate_by_root \
     client_import_root_certificate \
     client_convert_certificate_to_jks \
     server_generate_keys \
     server_generate_csr \
     server_sign_certificate_by_root \
     server_import_root_certificate \
     server_convert_certificate_to_jks \
     server_convert_certificate_to_p12 \
     convert_truststore_to_p12 \
     convert_truststore_to_pem \
     server_export_certificate_to_pem \
     server_export_key_to_pem \
     clear_unused_files \
     stop_docker

.PHONY: all

# Starts docker container for generating certificates - deletes first, if already running
start_docker:
	@make stop_docker
	$(eval REPOSITORY := $(shell cat ./values.yaml | grep -i "^[ \t]*repository" -m1 | xargs | cut -d ' ' -f2))
	$(eval JAVA_IMAGE := $(shell cat ./values.yaml | grep -i "^[ \t]*certificateGenerationImage" -m1 | xargs | cut -d ' ' -f2))
	$(eval FULL_JAVA_IMAGE := $(REPOSITORY)/$(JAVA_IMAGE))
	$(eval USERNAME :=$(shell id -u))
	$(eval GROUP :=$(shell id -g))
	docker run --rm --name ${DOCKER_CONTAINER} --user "$(USERNAME):$(GROUP)" --mount type=bind,source=${CURRENT_DIR}/${CERTS_DIR},target=/certs -w /certs --entrypoint "sh" -td $(FULL_JAVA_IMAGE)

# Stops docker container for generating  certificates. 'true' is used to return 0 status code, if container is already deleted
stop_docker:
	docker rm ${DOCKER_CONTAINER} -f 1>/dev/null || true

#Clear all files related to certificates
clear_all:
	@make clear_existing_certificates
	@make clear_unused_files

#Clear certificates
clear_existing_certificates:
	@echo "Clear certificates"
	${DOCKER_EXEC} rm -f certServiceClient-keystore.jks certServiceServer-keystore.jks root.crt truststore.jks certServiceServer-keystore.p12 truststore.pem certServiceServer-cert.pem certServiceServer-key.pem
	@echo "#####done#####"

#Generate root private and public keys
root_generate_keys:
	@echo "Generate root private and public keys"
	${DOCKER_EXEC} keytool -genkeypair -v -alias root -keyalg RSA -keysize 4096 -validity 3650 -keystore root-keystore.jks \
    -dname "CN=root.com, OU=Root Org, O=Root Company, L=Wroclaw, ST=Dolny Slask, C=PL" -keypass secret \
    -storepass secret -ext BasicConstraints:critical="ca:true"
	@echo "#####done#####"

#Export public key as certificate
root_create_certificate:
	@echo "(Export public key as certificate)"
	${DOCKER_EXEC} keytool -exportcert -alias root -keystore root-keystore.jks -storepass secret -file root.crt -rfc
	@echo "#####done#####"

#Self-signed root (import root certificate into truststore)
root_self_sign_certificate:
	@echo "(Self-signed root (import root certificate into truststore))"
	${DOCKER_EXEC} keytool -importcert -alias root -keystore truststore.jks -file root.crt -storepass secret -noprompt
	@echo "#####done#####"

#Generate certService's client private and public keys
client_generate_keys:
	@echo "Generate certService's client private and public keys"
	${DOCKER_EXEC} keytool -genkeypair -v -alias certServiceClient -keyalg RSA -keysize 2048 -validity 365 \
    -keystore certServiceClient-keystore.jks -storetype JKS \
    -dname "CN=certServiceClient.com,OU=certServiceClient company,O=certServiceClient org,L=Wroclaw,ST=Dolny Slask,C=PL" \
    -keypass secret -storepass secret
	@echo "####done####"

#Generate certificate signing request for certService's client
client_generate_csr:
	@echo "Generate certificate signing request for certService's client"
	${DOCKER_EXEC} keytool -certreq -keystore certServiceClient-keystore.jks -alias certServiceClient -storepass secret -file certServiceClient.csr
	@echo "####done####"

#Sign certService's client certificate by root CA
client_sign_certificate_by_root:
	@echo "Sign certService's client certificate by root CA"
	${DOCKER_EXEC} keytool -gencert -v -keystore root-keystore.jks -storepass secret -alias root -infile certServiceClient.csr \
    -outfile certServiceClientByRoot.crt -rfc -ext bc=0  -ext ExtendedkeyUsage="serverAuth,clientAuth"
	@echo "####done####"

#Import root certificate into client
client_import_root_certificate:
	@echo "Import root certificate into intermediate"
	${DOCKER_EXEC} sh -c "cat root.crt >> certServiceClientByRoot.crt"
	@echo "####done####"

#Import signed certificate into certService's client
client_convert_certificate_to_jks:
	@echo "Import signed certificate into certService's client"
	${DOCKER_EXEC} keytool -importcert -file certServiceClientByRoot.crt -destkeystore certServiceClient-keystore.jks -alias certServiceClient -storepass secret -noprompt
	@echo "####done####"

#Generate certService private and public keys
server_generate_keys:
	@echo "Generate certService private and public keys"
	${DOCKER_EXEC} keytool -genkeypair -v -alias oom-cert-service -keyalg RSA -keysize 2048 -validity 365 \
    -keystore certServiceServer-keystore.jks -storetype JKS \
    -dname "CN=oom-cert-service,OU=certServiceServer company,O=certServiceServer org,L=Wroclaw,ST=Dolny Slask,C=PL" \
    -keypass secret -storepass secret -ext BasicConstraints:critical="ca:false"
	@echo "####done####"

#Generate certificate signing request for certService
server_generate_csr:
	@echo "Generate certificate signing request for certService"
	${DOCKER_EXEC} keytool -certreq -keystore certServiceServer-keystore.jks -alias oom-cert-service -storepass secret -file certServiceServer.csr
	@echo "####done####"

#Sign certService certificate by root CA
server_sign_certificate_by_root:
	@echo "Sign certService certificate by root CA"
	${DOCKER_EXEC} keytool -gencert -v -keystore root-keystore.jks -storepass secret -alias root -infile certServiceServer.csr \
    -outfile certServiceServerByRoot.crt -rfc -ext bc=0  -ext ExtendedkeyUsage="serverAuth,clientAuth" \
    -ext SubjectAlternativeName:="DNS:oom-cert-service,DNS:localhost"
	@echo "####done####"

#Import root certificate into server
server_import_root_certificate:
	@echo "Import root certificate into intermediate(server)"
	${DOCKER_EXEC} sh -c "cat root.crt >> certServiceServerByRoot.crt"
	@echo "####done####"

#Import signed certificate into certService
server_convert_certificate_to_jks:
	@echo "Import signed certificate into certService"
	${DOCKER_EXEC} keytool -importcert -file certServiceServerByRoot.crt -destkeystore certServiceServer-keystore.jks -alias oom-cert-service \
    -storepass secret -noprompt
	@echo "####done####"

#Convert certServiceServer-keystore(.jks) to PCKS12 format(.p12)
server_convert_certificate_to_p12:
	@echo "Convert certServiceServer-keystore(.jks) to PCKS12 format(.p12)"
	${DOCKER_EXEC} keytool -importkeystore -srckeystore certServiceServer-keystore.jks -srcstorepass secret \
        -destkeystore certServiceServer-keystore.p12 -deststoretype PKCS12 -deststorepass secret
	@echo "#####done#####"

#Convert truststore(.jks) to PCKS12 format(.p12)
convert_truststore_to_p12:
	@echo "Convert certServiceServer-keystore(.jks) to PCKS12 format(.p12)"
	${DOCKER_EXEC} keytool -importkeystore -srckeystore truststore.jks -srcstorepass secret \
        -destkeystore truststore.p12 -deststoretype PKCS12 -deststorepass secret
	@echo "#####done#####"

#Convert truststore(.p12) to PEM format(.pem)
convert_truststore_to_pem:
	@echo "Convert certServiceServer-keystore(.p12) to PEM format(.pem)"
	${DOCKER_EXEC} openssl pkcs12 -nodes -in truststore.p12 -out truststore.pem -passin pass:secret
	@echo "#####done#####"

#Export certificates from certServiceServer-keystore(.p12) to PEM format(.pem)
server_export_certificate_to_pem:
	@echo "Export certificates from certServiceClient-keystore(.p12) to PEM format(.pem)"
	${DOCKER_EXEC} openssl pkcs12 -in certServiceServer-keystore.p12 -passin 'pass:secret' -nodes -nokeys -out certServiceServer-cert.pem
	@echo "#####done#####"

#Export keys from certServiceServer-keystore(.p12) to PEM format(.pem)
server_export_key_to_pem:
	@echo "Export keys from certServiceClient-keystore(.p12) to PEM format(.pem)"
	${DOCKER_EXEC} openssl pkcs12 -in certServiceServer-keystore.p12 -passin 'pass:secret' -nodes -nocerts -out certServiceServer-key.pem
	@echo "#####done#####"


#Clear unused certificates
clear_unused_files:
	@echo "Clear unused certificates"
	${DOCKER_EXEC} rm -f certServiceClientByRoot.crt certServiceClient.csr root-keystore.jks certServiceServerByRoot.crt  certServiceServer.csr truststore.p12
	@echo "#####done#####"

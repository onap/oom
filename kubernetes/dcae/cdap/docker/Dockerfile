FROM ubuntu:16.04

# Setup apt.conf proxy settings
#RUN echo 'Acquire::http::proxy "http://some.proxy:8084/";' >> /etc/apt/apt.conf

# Setup Corporate proxy
#ENV no_proxy "localhost,127.0.0.1,localaddress,.localdomain.com,192.168.141.0/24"
#ENV https_proxy http://some.proxy:8084/
#ENV http_proxy http://fsome.proxy:8084/
#ENV HTTP_PROXY http://some.proxy:8084/
#ENV HTTPS_PROXY http://some.proxy:8084/
#ENV FTP_PROXY http://some.proxy:8084/
#ENV NO_PROXY "localhost,127.0.0.1,localaddress,.localdomain.com,192.168.141.0/24"

# Additional packages
RUN apt-get update -y
RUN apt-get install -y git wget unzip curl dnsutils
RUN apt-get install -y maven unzip

# Install python and pip
RUN apt-get install -y python
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN rm get-pip.py
RUN pip install pyyaml

# Install Groovy
RUN mkdir -p /opt/app
RUN (cd /opt/app ; curl -Lo apache-groovy-binary-2.4.6.zip https://dl.bintray.com/groovy/maven/apache-groovy-binary-2.4.6.zip )
RUN (cd /opt/app ; unzip apache-groovy-binary-2.4.6.zip )
RUN mkdir -p /opt/app/java/jdk
RUN ln -s /usr /opt/app/java/jdk/jdk170
RUN mkdir -p /opt/app/groovy
RUN ln -s /opt/app/groovy-2.4.6 /opt/app/groovy/246

# Create user dcae
RUN if [ ! -e /home/dcae ]; then useradd -m -s /bin/bash dcae; fi

# Hadoop
EXPOSE 8020 8025 50070 50075 50010 50020

# Zookeeper
EXPOSE 3888 2888 2181

VOLUME /opt/tools
VOLUME /opt/data

# Provisioning
COPY 00-provisioning.sh /usr/local/bin/00-provisioning.sh
RUN chmod a+x /usr/local/bin/00-provisioning.sh
RUN /usr/local/bin/00-provisioning.sh

# define the entrypoint
COPY 01-entrypoint.sh /usr/local/bin/01-entrypoint.sh
RUN chmod a+x /usr/local/bin/01-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/01-entrypoint.sh"]

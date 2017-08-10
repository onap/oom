FROM ubuntu:16.04

# Install additional packages
RUN apt-get update && apt-get -y install maven openjdk-8-jdk unzip python-pip curl dnsutils vim gawk wget openssh-client-ssh1
RUN pip install pyyaml

RUN apt-get update && apt-get install -y postgresql libpq5 repmgr python-psycopg2 python3-psycopg2 libgetopt-java
RUN rm -f /usr/sbin/policy-rc.d

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

# Download required packages
RUN curl -s -k -f -o /tmp/org.openecomp.dcae.storage.pgaas-cdf_1.0.0.deb https://nexus.onap.org/content/sites/raw/org.openecomp.dcae.pgaas/deb-releases/org.openecomp.dcae.storage.pgaas-cdf_1.0.0.deb
RUN curl -s -k -f -o /tmp/org.openecomp.dcae.storage.pgaas-postgresql-prep_1.0.0.deb https://nexus.onap.org/content/sites/raw/org.openecomp.dcae.pgaas/deb-releases/org.openecomp.dcae.storage.pgaas-postgresql-prep_1.0.0.deb
RUN curl -s -k -f -o /tmp/org.openecomp.dcae.storage.pgaas-postgresql-config_1.0.0.deb https://nexus.onap.org/content/sites/raw/org.openecomp.dcae.pgaas/deb-releases/org.openecomp.dcae.storage.pgaas-postgresql-config_1.0.0.deb
RUN curl -s -k -f -o /tmp/org.openecomp.dcae.storage.pgaas-pgaas_1.0.0.deb https://nexus.onap.org/content/sites/raw/org.openecomp.dcae.pgaas/deb-releases/org.openecomp.dcae.storage.pgaas-pgaas_1.0.0.deb
RUN curl -s -k -f -o /tmp/org.openecomp.dcae.storage.pgaas-pgaas-post_1.0.0.deb https://nexus.onap.org/content/sites/raw/org.openecomp.dcae.pgaas/deb-releases/org.openecomp.dcae.storage.pgaas-pgaas-post_1.0.0.deb

RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/tools
RUN mkdir -p /dbroot/pgdata
RUN mkdir -p /dbroot/pglogs

EXPOSE 5432

VOLUME /opt/tools
VOLUME /dbroot/pgdata
VOLUME /dbroot/pglogs

# Setup the entrypoint
COPY setup.sh /usr/local/bin/entrypoint.sh
RUN chmod a+x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["usr/local/bin/entrypoint.sh"]

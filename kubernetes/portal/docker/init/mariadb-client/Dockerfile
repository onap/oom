# Copyright © 2018 Amdocs, Bell Canada, AT&T
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

FROM boxfuse/flyway:5.0.7-alpine

ARG branch=3.0.0-ONAP
ENV no_proxy "localhost,127.0.0.1,.cluster.local,$KUBERNETES_SERVICE_HOST"
# Setup Corporate proxy
ENV https_proxy ${HTTP_PROXY}
ENV http_proxy ${HTTPS_PROXY}

RUN apk add --update \
    mariadb-client=10.1.32-r0 \
    git \
  && rm -rf /var/cache/apk/*

ENV so_branch=$branch
#ENV policy_branch: $branch
ENV portal_branch=$branch
#ENV sdnc_branch: $branch
#ENV vid_branch: $branch
#ENV clamp_branch: $branch

#ENV appc_repo: http://gerrit.onap.org/r/appc/deployment.git
ENV so_repo=http://gerrit.onap.org/r/so/docker-config.git
#ENV policy_repo: http://gerrit.onap.org/r/policy/docker.git
ENV portal_repo=http://gerrit.onap.org/r/portal.git
#ENV sdnc_repo: http://gerrit.onap.org/r/sdnc/oam.git
#ENV vid_repo: http://gerrit.onap.org/r/vid.git
#ENV clamp_repo: http://gerrit.onap.org/r/clamp.git

RUN mkdir -p /onap-sources
WORKDIR /onap-sources

RUN git clone -b $branch $portal_repo && cd portal && git checkout HEAD
RUN git clone -b $branch $so_repo && cd docker-config && git checkout HEAD

VOLUME /onap-sources

COPY db_migrate.sh /root

RUN chmod a+x /root/db_migrate.sh
ENTRYPOINT /root/db_migrate.sh

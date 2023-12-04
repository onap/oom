<!---
Copyright © 2021 Orange

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

# Contributing to OOM

Thanks for taking the time to contribute to OOM!
Please see some information on how to do it.

## Local setup

### Install helm-push plugin

In order to push locally built charts to chartmuseum, the `helm-push` plugin must be installed. You can do that with:

```sh
$ helm plugin install https://github.com/chartmuseum/helm-push
Downloading and installing helm-push v0.10.4 ...
https://github.com/chartmuseum/helm-push/releases/download/v0.10.3/helm-push_0.10.4_linux_amd64.tar.gz
Installed plugin: cm-push
```

### Run chartmuseum

``` shell
mkdir -p charts && docker-compose up
```
or
``` shell
nohup chartmuseum --storage="local" --storage-local-rootdir="/tmp/chartstorage" \
  --port 6464 &
```

### Add a `local` chart repository

OOM contains `make` files that build the charts and push them to the local chartmuseum.
For that to work, helm needs to know about the `local` helm repository.
```shell
helm repo remove local; helm repo add local http://localhost:6464
```

### Linting and testing
OOM uses helm linting in order to check that the template rendering is correct with default values.

As full rendering may be extremely long (~9h), you may only want to lint the common part and the component you're working on.
Here's an example with AAI:
```shell
cd kubernetes
make common && make aai
```

If you work on a non default path, it's strongly advised to also render the
template of your component / subcomponent to be sure it's as expected.

Here's an example enabling service mesh on aai graphadmin:

```shell
cd aai/components/
helm template --release-name onap --debug \
  --set global.ingress.virtualhost.baseurl=toto \
  --set global.ingress.enabled=true \
  --set global.masterPassword="toto" \
  --set global.serviceMesh.enabled=true \
  --set global.serviceMesh.tls=true \
  aai-graphadmin
```
All the output will be rendered YAML if everything works as expected or an error if something goes wrong.
Usually the errors come from bad indentation or unknown values.

### Contributing a Patch
1. Fork the desired repo, develop and test your code changes.
2. Sign the LFN CLA (<https://www.onap.org/cla>)
3. Submit a pull request.
4. Work with the reviewers on their suggestions.
5. Ensure to rebase to the HEAD of your target branch and [squash un-necessary commits](https://blog.carbonfive.com/always-squash-and-rebase-your-git-commits/)
   before finally mergin your contribution.

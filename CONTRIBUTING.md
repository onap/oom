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
Please see a few informations on how to dot it.

## How to become a contributor and submit your own code

### Environment setup

In order to be able to check on your side before submitting, you'll need to
install some binaries:

* helm (satisfying the targeted version as seen in [setup guide](
docs/oom_cloud_setup_guide.rst#software-requirements).
* chartmuseum (in order to push dependency charts)
* helm push (version 0.9.0 as of today)
* make

### Linting and testing

OOM use helm linting in order to check that the templates rendering is correct
with default values.

first step is to start chartmuseum:

```shell
nohup chartmuseum --storage="local" --storage-local-rootdir="/tmp/chartstorage" \
  --port 6464 &
```

then you add `local` repository to helm:

```shell
helm repo remove local && helm repo add local http://localhost:6464
```

As full rendering may be extremely long (~9h), you can only lint the common
part and the component you're working on.
Here's an example with AAI:

```shell
cd kubernetes
make common && make aai
```

If you work on non default path, it's strongly advised to also render the
template of your component / subcomponent to be sure it's as expected.

Here's an example enabling service mesh on aai graphadmin:

```shell
cd aai/components/
helm template --release-name onap --debug \
  --set global.ingress.virtualhost.baseurl=toto \
  --set global.ingress.enabled=true --set global.masterPassword="toto" \
  --set global.serviceMesh.enabled=true --set global.serviceMesh.tls=true \
  aai-graphadmin
```

All the output will be the rendered YAML if it's OK or you may see an error.
Usually the errors comes from bad indentation or unknown value.

### Contributing A Patch

1. Fork the desired repo, develop and test your code changes.
2. Sign the LFN CLA (<https://www.onap.org/cla>)
3. Submit a pull request.
4. Work with the reviewers on their suggestions.
5. Ensure to rebase to the HEAD of your target branch and squash un-necessary
   commits (
   <https://blog.carbonfive.com/always-squash-and-rebase-your-git-commits/>)
   before final merger of your contribution.

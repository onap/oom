# Portal-bff helm chart
This repository contains the chart for the portal-bff.

# Redis chart
The app has a dependency to Redis. The chart for this was obtained from [artifacthub](https://artifacthub.io/packages/helm/bitnami/redis). For updates to that chart, go there click on `Install` and copy the direct link. Then do a
``` bash
wget -P charts/ https://charts.bitnami.com/bitnami/redis-16.8.7.tgz
```

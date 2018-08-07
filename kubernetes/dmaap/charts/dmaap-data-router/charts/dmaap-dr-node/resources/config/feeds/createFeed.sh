#!/bin/sh

sleep 20

if curl -k https://{{.Values.global.config.dmaapDrProv.name}}:{{.Values.global.config.dmaapDrProv.internalPort2}}/internal/prov | awk 'BEGIN{ORS=""} {print}' | egrep "\"feeds\":\s+\[\]"; then
   curl -X POST -H "Content-Type:application/vnd.att-dr.feed" -H "X-ATT-DR-ON-BEHALF-OF:dradmin" --data-ascii @/opt/app/datartr/etc/dedicatedFeed.json --post301 --location-trusted -k https://{{.Values.global.config.dmaapDrProv.name}}:{{.Values.global.config.dmaapDrProv.internalPort2}};
else
   echo "NO feed creation required";
fi

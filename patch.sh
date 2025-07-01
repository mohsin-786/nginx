#!/bin/bash

kubectl -n flux-system create configmap zscaler-ca \
  --from-file=ca.crt=/home/sin/zscaler.crt

kubectl -n flux-system patch deployment source-controller \
  --type='json' \
  -p='[
    {
      "op": "add",
      "path": "/spec/template/spec/volumes/-",
      "value": {
        "name": "zscaler-ca",
        "configMap": {
          "name": "zscaler-ca"
        }
      }
    },
    {
      "op": "add",
      "path": "/spec/template/spec/containers/0/volumeMounts/-",
      "value": {
        "mountPath": "/etc/ssl/certs/zscaler.crt",
        "name": "zscaler-ca",
        "subPath": "ca.crt"
      }
    },
    {
      "op": "add",
      "path": "/spec/template/spec/containers/0/env/-",
      "value": {
        "name": "SSL_CERT_FILE",
        "value": "/etc/ssl/certs/zscaler.crt"
      }
    }
  ]'

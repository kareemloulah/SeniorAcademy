## create name space
k create namespace web-app --dry-run=client -o yaml > namespace-web-app.yml
## create deployment

k create deployment deployment-nginx -n web-app --image=nginx:latest --replicas=3 --port=80 --dry-run=client -o yaml > deployment-nginx.yml 

set resources
```
resources:
    requests:
      memory: 0.5Gi
      cpu: 200m
    limits:
      memory: 1Gi
      cpu: 500m
``` 

## create service

k create svc clusterip service-nginx --tcp=80:80 --dry-run=client -o yaml
## manual scale

k scale deployment -n web-app deployment-nginx --replicas 4

## auto scaler HPA 
k autoscale deployment deployment-nginx -n web-app --cpu=70% --min=2 --max=8 --dry-run=client -o yaml > hpa-nginx.yml

## resource Quota 
```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: dev-team
spec:
  hard:
    pods: "10"
    requests.cpu: "4"
    requests.memory: "8Gi"
    limits.cpu: "8"
    limits.memory: "16Gi"
``` 
note that if deployment resources asking for 0.5G cpu with this setup max number of pods are 4 not 10 
## rollout history and status 
edit on deployment yaml and 
```
k rollout status deployment <deployment name>
k rollout history deployment <deployment name>
k rollout undo deployments <deployment name>

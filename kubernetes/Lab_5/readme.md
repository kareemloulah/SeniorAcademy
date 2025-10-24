## applying Taint 
- k get node to see the nodes we got 

to apply taint on a node 

- kubectl taint nodes <"node_name"> key=value:effect
```
kubectl taint nodes node1 db=only:NoSchedule
```
add toleration to deployment to permit being added to node 

```
tolerations:
- key: "db"
  operator: Equal
  value: only
  effect: "NoSchedule"
```

lets create a name space :

```
kubectl create namespace mysql-namespace
```
## config maps and secrets 


- k create configmap <"name"> --from-env-file=./<"path_to_config.txt"> <"args">
- k create secret <"name"> <"type"> --from-env-file=./<"path_to_secret.txt"> <"args">

```
kubectl create secret generic mysql-config -n mysql-namespace --from-env-file=./secret.txt -o yaml --dry-run=client > secret-mysql.yml
```
```
kubectl create configmap mysql-secret -n mysql-namespace --from-env-file=./config.txt -o yaml --dry-run=client > configmap-mysql.yml
```
## persistant volumes and claims 
has to be made either typed or adjusting a template
explain function could help 
``` 
- kubectl explain PersistentVolume 
```
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-sql-pv
spec:
  capacity:
    storage: 5Gi 
  accessModes:
    - ReadWriteOnce 
  storageClassName: "" # Empty string must be explicitly set 
  persistentVolumeReclaimPolicy: Retain 
  hostPath:
    path: "/mnt/data" 
```
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-sql-pv-claim
  namespace: foo
spec:
  storageClassName: "" # Empty string must be explicitly set otherwise default StorageClass will be set
  volumeName: my-sql-pv
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
```
## deploying an app uses the pvc and addig tollerations

```
k create deployment deployment-sql -n mysql-namespace --image=mysql:8.0 --replicas=2 --port=3306 --dry-run=client -o yaml > deployment-sql.yml 

```

can add resources if needed for deployment 

have to add spec.tolerations as described above
and add volume and volume mount for sql Data > /var/lib/mysql
- spec.volumes:
```
- name: pvc
  persistentVolumeClaim:
    claimName: pvc-mysql
```
- containers.volumeMounts:
```
- name: pvc
  mountPath: /var/lib/mysql
```
- add ref for config map and secret
containers.envFrom:
```
- configMapRef:
    name: configmap
- secretRef:
    name: my-secret-sql
```
- lastly create a service to expose it to the cluster
```
k create svc clusterip deployment-sql --tcp=3306:3306 -n mysql-namespace --dry-run=client -o yaml > service.yml

```


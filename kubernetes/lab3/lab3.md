# lab3 

create a cluster and taint one of the nodes 
kubectl taint nodes node1 <KEY>=<VALUE>:<EFFECT> 
note that the Operator is equal in this example
```
kubectl taint nodes node1 db=only:NoSchedule

```
## create a name space and configs 

kubectl create namespace <name> <args>

```
kubectl create namespace mysql-namespace
```
create 2 file 1 for config and 1 for secret 
make sure they have key=value syntax
in order to create configmap and the secret pass --from-env-file arg to the cli
k create configmap <name> --from-env-file=./<path_to_config.txt> <args>
k create secret <name> --from-env-file=./<path_to_secret.txt> <args>
can add ` -n <namespace_name> ` to add a name space 
append -o yaml --dry-run=client to get yaml file befor the actual run 
```
kubectl create configmap mysql-config -n mysql-namespace --from-env-file=./secret.txt -o yaml --dry-run=client > secret-mysql.yml
kubectl create secret mysql-secret -n mysql-namespace --from-env-file=./config.txt -o yaml --dry-run=client > configmap-mysql.yml
```
## create a persistant_volume and persistant_volume_claim
persistant_volume ex:
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-sql-pv
spec:
  capacity:
    storage: 5Gi # Define the storage capacity, e.g., 5 Gigabyte
  accessModes:
    - ReadWriteOnce # Define access modes, e.g., ReadWriteOnce
  storageClassName: ""    
  persistentVolumeReclaimPolicy: Retain # Define reclaim policy, e.g., Retain
  hostPath:
    path: "/mnt/data" # Specify the path on the host node (for hostPath volumes)
```
persistant_volume_claim ex:
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
## create a deployment
in the deployment we have to attach:
 - tollerations for the taint
    ```
    containers:
        tolerations:
        - key: "db"
          operator: Equal
          value: only
          effect: "NoSchedule"
    ```
 - configMapRef and secretRef 
    ```
    - image
      envFrom:
        - configMapRef:
            name: configmap
        - secretRef:
            name: my-secret-sql
    ```
 - volumes and volumeMounts for the pvc
    ```
    specs:
      volumes:
      - name: pvc
        persistentVolumeClaim:
          claimName: my-sql-pv-claim
    containers:
      - image
        volumeMounts:
        - name: pvc
          mountPath: /var/lib/mysql
    ```


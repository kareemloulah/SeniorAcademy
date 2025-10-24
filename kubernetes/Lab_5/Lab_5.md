
Deploy a MySQL database on a dedicated worker node using Kubernetes best practices.
You must use:
>>>> ConfigMap and Secret from .txt files
>>>> Persistent Volume (PV) and Persistent Volume Claim (PVC) for storage
>>>> Taint/Toleration to isolate the database node
>>>> Deployment and Service for database management and access
## Step 1 – Node Preparation
 Apply a Taint on node01 so that only pods with the correct toleration can run there.
o Key: db
o Value: only
o Effect: NoSchedule
## Step 2 – Configuration Files
Create two .txt files:
 config.txt → for MySQL configuration values
o Example: port, bind address, etc.
 secret.txt → for MySQL credentials
o Example: root password, user, password, database name
## Step 3 – Kubernetes Resources
Create the following resources using YAML files or kubectl commands:
 ConfigMap from config.txt
 Secret from secret.txt
 PersistentVolume (PV) of size 2Gi using hostPath /mnt/data/mysql
 PersistentVolumeClaim (PVC) requesting 1Gi storage
 Deployment named mysql-deployment:
o Image: mysql:8.0
o Environment variables loaded from ConfigMap and Secret
o Mount the PVC to /var/lib/mysql
o Add a Toleration matching the taint applied to node01
 Service named mysql-service:
o Type: ClusterIP
o Port: 3306
o TargetPort: 3306

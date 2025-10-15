#!/usr/bin/env bash

# Task 1 

# create a network with subnet and a gateway 

docker network create hr-app-net --gateway 192.168.20.1 --subnet 192.168.20.0/24 

# create a container from nginx image and attached to the created network 

docker run -d --name nginx-server --network hr-app-net nginx:1.28.0-alpine  

# create a container from alpine image and attached to the created network 

docker run -d -it --name alpine-tester --network hr-app-net alpine:3.22.2

# if ping from from either nginx-server to alpine-tester or vise versa will be succesfull 
# delete deleted containers / network/s
docker stop alpine-tester nginx-server 
docker network rm hr-app-net

# Task 2

# create 2 netwroks front-end and back-end 

docker network create frontend-net --subnet 10.1.1.0/24
docker network create backend-net --subnet 10.1.2.0/24

# create a nginx container attached to front-end network and back-end acting as a loadbalancer

docker run -d --name nginx-lb --network frontend-net --network backend-net nginx:1.28.0-alpine 

# create a client tester attached to front-end network only ftom the image alpine:latest
docker run -d -it --name client-tester --network frontend-net alpine:3.22.2

# create a Database tester attached to back-end network only ftom the image alpine:latest
docker run -d -it --name backend-tester --network backend-net alpine:3.22.2

# delete deleted containers / network/s
docker rm -f nginx-lb client-tester backend-tester
docker network rm frontend-net backend-net

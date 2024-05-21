#!/bin/bash

export AWS_PROFILE=devops

kubectl apply -f manifest_files/deployment-mariadb.yaml || exit
kubectl apply -f manifest_files/service-mariadb.yaml || exit
kubectl apply -f manifest_files/deployment.yaml || exit
kubectl apply -f manifest_files/service.yaml || exit
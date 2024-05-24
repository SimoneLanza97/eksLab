#!/bin/bash

manifest_path="/home/lanza/corsi/eks_course/kubernetes_foundamentals/manifest_files"

echo -e "What you want to do ?\n01 - create cluster\n02 - delete cluster" 

read operation

export AWS_PROFILE=devops   

if [[ "${operation}" -eq 01 ]]; then


    eksctl create cluster --name=BerryCluster01 --region=eu-west-1 --zones=eu-west-1a,eu-west-1b --without-nodegroup || exit
    
    eksctl utils associate-iam-oidc-provider --region eu-west-1 --cluster BerryCluster01 --approve || exit

    eksctl create nodegroup --cluster=BerryCluster01 --region=eu-west-1 --name=BerryCluster01-nodeGroup01 --node-type=t3.medium --nodes=2 --nodes-min=2 --nodes-max=4 --node-volume-size=20 --ssh-access --ssh-public-key=BerryKey --managed --asg-access --external-dns-access --full-ecr-access --appmesh-access --alb-ingress-access  || exit 

    # rolearn= $(kubectl -n kube-system get configmap aws-auth -o json | jq -r '.data.mapRoles | split("\n") | map(select(startswith("  rolearn: "))) | map(split(": ")[1]) | .[]')

    # aws iam attach-role-policy --role-name ${rolearn} --policy-arn arn:aws:iam::637364600367:policy/EBS-Storage-Policy-Complete

    kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

elif [[ "${operation}" -eq 02 ]]; then 

    eksctl delete cluster --name BerryCluster01 || echo "operation failed! remove the cluster by using the aws console" && exit 

else 

    echo "Not a valid number! Enter a number between 01 and 02"

fi 

echo -e "Would you like to deploy the worpress deployment for testing?\n yes/NO"

read operation2

if [[ "${operation2}" == "yes" ]]; then 

    kubectl apply -f ${manifest_path}/deployment.yaml || exit
    kubectl apply -f ${manifest_path}/service.yaml || exit
fi

echo "Bye!"

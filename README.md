# EKSLAB 

This is a repository created to learn about EKS, the Kubernetes service offered by AWS. The tutorial is designed to start with the basics of Kubernetes and then compare it with EKS, addressing the pros and cons of using EKS. Throughout the tutorial, various topics will be covered, including:

- Differences between On-Premise Kubernetes and EKS
- Creating an EKS cluster
- Configuring an EKS cluster and integrating other AWS services for the workflow with EKS.

## CONTENTS

Ogni cartella contiene un tutorial per uno step del corso :

- 01_installation_scripts         -> Scripts to install aws cli , kubectl and eksctl 
- 02_create_simple_cluster        -> Tutorial to create a cluster and a nodegroup using eksctl (there is a script to automate creation and deletion of the cluster)
- 03_kubernetes_foundamentals     -> System architecture and basics foundamentals of kubernetes, differences between k8s and EKS . Also a tutorial to deploy a wordpress and mariaDB pod on the cluster using services to allow comunication from and to the pods.
- 04_using_ebs_storage            -> Tutorial to create wordpress and mariaDB deployment using EBS storage for persistent volumes.
- 05_kubernetes_secrets           -> Tutorial to explain how to use k8s secrets for production deployment
- 06_kubernetes_init_container    -> Tutorial to explain how to use k8s init_containers
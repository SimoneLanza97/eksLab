# HOW TO DEPLOY USING MANIFEST FILES

## 2 WAYS TO USE K8S 

There are mainly two ways of performing operations in kubernetes , the imperative method and the declarative method.
The imperative method makes use of the command line to control actions on the cluster.
Instead, with the declarative method, yaml files are used to declare the desired state of the cluster so that the manager nodes work to maintain it.

## MANIFEST FILES

There are different types of yaml files dedicated to deploying different components or logics. In this guide we will address the main manifest files, i.e., deployments, services, ingresses and configmaps which form the basic architecture for supporting a containerized application.

We are going to create a simple deployment of a wordpress with mariaDB to show how you can handle the infrastracture using manifest files and declarative instructions. 
In this examples we use only deployment to create the pods and service to make the pods reachable.

## DEPLOYMENTS 

The deployment.yaml file serves as a blueprint for deploying one or more pods within a Kubernetes cluster. Pods represent the smallest unit of deployment and can contain one or more containers. This file typically consists of several sections. The ****metadata**** section provides descriptive information about the pod, such **as its name and labels,** which help identify and **manage it within** the cluster. The **selector** section specifies the criteria for selecting the pods to which the deployment's configuration will be applied. Within the **pod template** section, you define the configuration settings that will be applied to each pod, including container specifications and resource requirements. The **update and rollback policy** outlines rules for managing updates to the deployment, ensuring seamless transitions and enabling rollback to previous versions if necessary. Finally, the **volumes** section allows you to specify any volumes of data that should be mounted onto the pods, providing persistent storage or shared resources as needed. Together, these sections form a comprehensive deployment configuration that enables efficient and reliable management of containerized applications within a Kubernetes environment.

## SERVICES 

The service.yaml files in Kubernetes allow you to define a service, which is an abstraction that defines a set of pods that provide a common functionality. This service can then be accessed by other components within the cluster, such as other pods or external services. The basic structure of a service.yaml file includes **metadata** for the name of the service and associated labels, **specifications for the port exposed** by the service and the **type of service** (ClusterIP, NodePort, LoadBalancer, ExternalName), and a **selector** that specifies which pods should be reached through the service.
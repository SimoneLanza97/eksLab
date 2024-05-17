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
There are many manifest files for Kubernetes that can be used, but the deployment file can handle all those tasks by itself, such as managing pods and replica sets. You can use a pod definition file to describe the specifications of a pod, and a replica set is used to define how many replicas should be running at any given time. By using a deployment file, you can manage all these aspects with a higher-level controller.

## SERVICES 

The service.yaml files in Kubernetes allow you to define a service, which is an abstraction that defines a set of pods that provide a common functionality. This service can then be accessed by other components within the cluster, such as other pods or external services. The basic structure of a service.yaml file includes **metadata** for the name of the service and associated labels, **specifications for the port exposed** by the service and the **type of service** (ClusterIP, NodePort, LoadBalancer, ExternalName), and a **selector** that specifies which pods should be reached through the service.

## DEPLOY THE WORDPRESS APPLICATION AND ACCESS VIA BROWSER
    
We 've created the deployment file, that contains the information to create 2 wordpress pod and 1 mariaDB pod, and the service.yaml file , that contains the information to create a service that point to out wordpress pod and allows us to access them via web.
In the service.yaml file we've specified the node port service type, that means the service will be accessible pointing to node ip at the port specified.

    - protocol: TCP
      port: 80        -> the service port 
      targetPort: 80  -> the pod's exposed port
      nodePort: 30000 -> the node'port where the service will be forwarded
    type: NodePort    -> type of service

The service for mariaDB is different and has no type because we don't need to reach the mariadb service from outside the cluster , but we need to reach it from the wordpress pod and we do that by the following lines inside the manifest:

      ports:
      - port: 3306       -> the service's port 
        targetPort: 3306 -> the pod's exposed port 
        protocol: TCP    -> the protocol allowed 

This make the mariadb's pod reacheable from other pods in the cluster.
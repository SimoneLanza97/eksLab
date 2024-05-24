# KUBERNETES NAMESPACES

Kubernetes namespaces allow us to isolate groups of resources, separating them from other resources within the same cluster. In the namespace definition, we can also specify resource limits to allocate to the resources within that namespace. For example, we might want to create a namespace for each different application on the cluster, where each application would have various microservices that communicate with each other, keeping them separate from the microservices belonging to other namespaces.

## EXAMPLE

We will deploy two different namespaces, deploy a pod in each namespace, and test the isolation between the two by demonstrating that they cannot communicate with each other. To do this, we will use the declarative method, which involves using YAML manifests. This approach is preferred in a work context as it allows us to have artifacts that keep track of the configurations used, something that would not be possible when creating everything with kubectl using the imperative method.

So we've created a namespace.yaml file to create two namespaces and two different deployments: one for the namespace named mysql-ns, where we're going to deploy a MySQL pod and an Adminer pod (Adminer is an open-source tool for database administration), and in the other namespace(adminer-ns), we're going to deploy only one Adminer pod. After that, we'll try to use the second Adminer pod to connect to MySQL, and if everything is done correctly, the connection will fail. 

The namespace.yaml file look like this:

        apiVersion: v1
        kind: Namespace
        metadata:
          name: mysql-ns

This is a super simple namespace files, as I said before, you can specify other things , like resources request and limits for the namespace, but we 're only interested to learn how to create a namespace to isolate our resources.
Now apply the namespace.yaml file first , and others files after.

If you try to forward port 8080 of the Adminer pod in the namespace mysql-ns to your local port 8082, and forward port 8080 of the other Adminer pod (namespace: adminer-ns), and then try to connect from both of them to the MySQL container, you will see that only the Adminer pod in the same namespace as the MySQL pod can reach the database.
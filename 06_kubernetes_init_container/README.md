# K8S INIT CONTAINERS

Init containers are objects provided by Kubernetes that allow us to run a container before the creation of the container that actually holds the application. This enables the creation of volumes in advance or the performance of actions that need to be completed by the time our application is created.

Each init container is designed to perform a specific operation and shut down automatically; it is a temporary container with a short lifespan.

An example could be creating an image that contains an agent for monitoring containers, running this image as an init container to allow the creation of a volume containing the agent software, so that the main container can mount the volume upon creation and have the monitoring in place.

## EXAMPLE

In this example, we will deploy a simple init container that will run before the WordPress container. It will execute a command to check if the MariaDB pod is reachable, and then it will shut down, allowing the WordPress container to be created and connect to the MariaDB database.

The specific part for the init container is included directly in the pod deployment and looks like the following:


initContainers:
  - name: init-db
    image: busybox:1.31
    command: ['sh', '-c', 'echo -e "Checking for the availability of MySQL Server deployment"; while ! nc -z mariadb01-1 3306; do sleep 1; printf "-"; done; echo -e "  >> MariaDB Server has started";']

In the manifest_files directory, you can find the manifest files used to deploy WordPress and MariaDB using init containers. You need to apply these files in this order:

    deployment-mariadb.yaml
    service-mariadb.yaml
    deployment.yaml
    service.yaml

This way, you'll first have the MariaDB container running. After that, you run the init container for the check, and at the end, deploy the WordPress container, ensuring that it will work.

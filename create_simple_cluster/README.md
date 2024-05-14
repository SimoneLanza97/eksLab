# CREATE A SIMPLE CLUSTER USING EKSCTL

You can try to use eksctl creating a cluster without nodegroups by running the command below

    eksctl create cluster --name=BerryCluster01 --region=eu-west-1 --zones=eu-west-1a,eu-west-1b --without-nodegroup 

Now we need to associate an IAM OIDC provider to our EKS-Cluster , we can do it by running the following command:
    
     eksctl utils associate-iam-oidc-provider --region eu-west-1 --cluster BerryCluster01 --approve

after that you can now create a nodegroup by yourself, we do it separetly to give more attention to this part of the operation.
Run the following command :

     eksctl create nodegroup --cluster=BerryCluster01 \                    # name of your cluster
                       --region=eu-west-1 \                                # region name
                       --name=BerryCluster01-nodeGroup01 \                 # name of nodegroup 
                       --node-type=t3.medium \                             # type of EC2 instances for the nodegroup 
                       --nodes=2 \                                         # number of node deployed initially 
                       --nodes-min=2 \                                     # minimum number of nodes 
                       --nodes-max=4 \                                     # max number of nodes
                       --node-volume-size=20 \                             # size of the EBS volume (in GB) for each node. 
                       --ssh-access \                                      # allow direct access to each node via SSH.
                       --ssh-public-key=kube-demo \                        # Specifies the public SSH key to use for access. This key must already exist as an EC2 public key in AWS.
                       --managed \                                         # node group will be automatically managed by EKS for updates and maintenance.Not for production!
                       --asg-access \                                      # Grants the node group access to manage Auto Scaling Groups (ASG).
                       --external-dns-access \                             # permissions to integrate the external-dns service, which enables Kubernetes to manage DNS records.
                       --full-ecr-access \                                 # Provides full access to the ECR (Elastic Container Registry)
                       --appmesh-access \                                  # Gives the node group permissions to interact with App Mesh, AWS's microservices management service.
                       --alb-ingress-access                                # Grants access to manage an Application Load Balancer (ALB) Ingress Controller for inbound traffic to applications in the cluster.

you can now check your nodes using k9s,or running the command :   

     kubectl get nodes 


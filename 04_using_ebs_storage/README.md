# USE EBS STORAGE TO HANDLE THE STORAGE OF YOUR APPLICATION ON K8S

## WHAT IS EBS STORAGE
EBS (Elastic Block Storage) consists of independent volumes that can be mounted to instances while they are active. They allow data persistence even when the instance is terminated (the instance is deleted, but the EBS volumes are standalone resources). They can be mounted on only one instance at a time and are limited to the region they belong to. Typically, an EBS volume is anchored to the Availability Zone it resides in. You can take a snapshot of an EBS volume, and snapshots can be moved from one Availability Zone to another, allowing us to move or duplicate our EBS volumes. Additionally, snapshots can be stored in the snapshot archive, reducing retention costs by 75%. However, restoring a snapshot from the archive takes more time (1 to 3 days).

## CREATION OF THE POLICY FOR EBS VOLUMES

We need to install the EBS CSI Driver for Kubernetes inside the cluster. First, we need to create an IAM policy to allow the actions needed for the EBS CSI Driver. The policy we need looks like this:


    {
      "Version": "2024-05-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "ec2:AttachVolume",
            "ec2:CreateSnapshot",
            "ec2:CreateTags",
            "ec2:CreateVolume",
            "ec2:DeleteSnapshot",
            "ec2:DeleteTags",
            "ec2:DeleteVolume",
            "ec2:DescribeInstances",
            "ec2:DescribeSnapshots",
            "ec2:DescribeTags",
            "ec2:DescribeVolumes",
            "ec2:DetachVolume"
          ],
          "Resource": "*"
        }
      ]
    }

This policy allows the role associated to attach volumes to instances, create and delete snapshots, tags, volumes, and perform other related actions.

## ATTACH POLICY TO THE IAM ROLE USED

After that, search for the IAM role used by the cluser, you can find it with the command :

    kubectl -n kube-system describe configmap aws-auth

the command will return the information about the aws-auth configmap , used to handle authorization via IAM role.
The output will be like this:

    Name:         aws-auth
    Namespace:    kube-system
    Labels:       <none>
    Annotations:  <none>

    Data
    ====
    mapRoles:
    ----
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::637364600367:role/eksctl-BerryCluster01-nodegroup-Be-NodeInstanceRole-YCPVjOQ44efW      -> this is the role you're searching
      username: system:node:{{EC2PrivateDNSName}}


    BinaryData
    ====

    Events:  <none>

- Open AWS Console ans search IAM/Roles
- Select the role used by the cluster
- Click on attach policy , search the policy for the EBS CSI created before and select it

## DEPLOY THE CSI DRIVER FOR EBS VOLUMES

Now you can install the CSI driver for EBS by running the command :

    kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

after that you can check if the installation worked by searching the CSI pods deployed, you can do it by running:

    kubectl get pods -n kube-system

you will see those pods in the output:

    ebs-csi-controller-7d69ff4987-dgqv6   6/6     Running   0          9m52s
    ebs-csi-controller-7d69ff4987-wtnx2   6/6     Running   0          9m52s
    ebs-csi-node-k25jh                    3/3     Running   0          9m52s
    ebs-csi-node-t46hb                    3/3     Running   0          9m52s

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
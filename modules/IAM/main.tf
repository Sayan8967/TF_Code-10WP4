# aws_iam_role.cluster-ServiceRole will be created

resource "aws_iam_role" "eks_cluster_iam_role" {
    name = "${var.PROJECT_NAME}-EKS-role" # Name of the IAM role for EKS cluster

    assume_role_policy = <<POLICY
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "eks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
POLICY
}

# Resource: aws_iam_role_policy_attachment for EKS cluster and ELB
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {

    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" # Managed policy for EKS cluster

    role       = aws_iam_role.eks_cluster_iam_role.name # Attach to the EKS cluster IAM role
  
}



resource "aws_iam_role_policy_attachment" "ELB_FullAccess" {

    policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess" # Managed policy for ELB full access
    role      = aws_iam_role.eks_cluster_iam_role.name # Attach to the EKS cluster IAM role
  
}


# Create IAM role for EKS Node Group
resource "aws_iam_role" "node_group" {
    name = "${var.PROJECT_NAME}-node-group-role" # Name of the IAM role for EKS Node Group

    # The policy that grants an entity permission to assume the role
    assume_role_policy = <<POLICY
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
POLICY
}

resource "aws_iam_role_policy_attachment" "worker_node" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" # Managed policy for EKS worker nodes
    role       = aws_iam_role.node_group.name # Attach to the EKS Node Group IAM role
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" # Managed policy for EKS CNI
    role       = aws_iam_role.node_group.name # Attach to the EKS Node Group IAM role
  
}

resource "aws_iam_role_policy_attachment" "ECR_read_only" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" # Managed policy for ECR read-only access
    role       = aws_iam_role.node_group.name # Attach to the EKS Node Group IAM role
  
}
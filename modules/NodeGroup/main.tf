resource "aws_eks_node_group" "node_group" {
    # The name of the EKS cluster to which this node group belongs
    cluster_name = var.EKS_CLUSTER_NAME

    # The name of the EKS node group
    node_group_name = "${var.EKS_CLUSTER_NAME}-node-group"
    
    # The ARN of the IAM role that provides permissions for the nodes in this group to make calls to AWS services on your behalf
    node_role_arn = var.NODE_GROUP_ARN

    # Identifiers of EC2 Subnets to associate with the EKS Node Group. 
    # These subnets must have the following resource tag: kubernetes.io/cluster/EKS_CLUSTER_NAME 

    subnet_ids = [
        var.PRI_SUB3_ID,
        var.PRI_SUB4_ID
    ]

    # Configure block
    scaling_config {
        desired_size = 2 # Desired number of worker nodes in the node group
        max_size     = 2 # Maximum number of worker nodes in the node group
        min_size     = 2 # Minimum number of worker nodes in the node group
    }

    ami_type = "AL2_x86_64" # Specify the AMI type for the worker nodes

    capacity_type = "ON_DEMAND" # Specify the capacity associated with EKS Node Group

    disk_size = 20

    force_update_version = false # Set to true to force an update of the node group even if the version has not changed

    instance_types = ["t3.small"] # Specify the instance types for the worker nodes

    labels = {
      role = "${var.EKS_CLUSTER_NAME}-Node-group-role"
      name = "${var.EKS_CLUSTER_NAME}-node_group"
    }

    version = "1.27" # Kubernetes version for the worker nodes in the node group

  
}
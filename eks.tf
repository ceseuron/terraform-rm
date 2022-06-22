module "rm_eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_name    = "rm-eks-cluster"
  cluster_version = "1.22"

  # Define EKS networking for groups.
  vpc_id      = module.vpc.vpc_id
  subnets     = module.vpc.private_subnets
  enable_irsa = true

  # We want to use GP2 disks for all of our workers.
  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  # Deploy autoscaling groups.
  worker_groups = [
    {
      name                          = "rm-eks-cluster-wg-1"
      instance_type                 = "t2.small"
      additional_security_group_ids = [aws_security_group.rm_eks_wg_mgmt_one.id]
      asg_desired_capacity          = 3
    },
    {
      name                          = "rm-eks-cluster-wg-2"
      instance_type                 = "t2.medium"
      additional_security_group_ids = [aws_security_group.rm_eks_wg_mgmt_two.id]
      avg_desired_capacity          = 3
    }
  ]
}

# Output data sources for Kubernetes direct provider.
data "aws_eks_cluster" "cluster" {
  name = module.rm_eks_cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.rm_eks_cluster.cluster_id
}

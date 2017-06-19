Inspired by [Kubernetes from scratch to AWS with Terraform and Ansible](https://opencredo.com/kubernetes-aws-terraform-ansible-1/) series

Instead, I'm using S3 bucket to store artifacts (`etcd` and `Kubernetes` distribution)

1. Download `etcd` and `kubernetes` artifacts
+ Create S3 Bucket
+ Upload to S3 Bucket
+ Create VPC and Subnet
+ Create EC2 Instances for `etcd` cluster
+ Create EC2 Instances for `kubernetes` Control Plane cluster
+ Create EC2 Instances for `kubernetes` nodes


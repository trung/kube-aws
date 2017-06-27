**Update**: this attempt will not bring me any further. It's rather a learning excercise to understand how different pieces are fit together.

Inspired by [Kubernetes from scratch to AWS with Terraform and Ansible](https://opencredo.com/kubernetes-aws-terraform-ansible-1/) series

Instead, I'm using S3 bucket to store [software binaries](https://kubernetes.io/docs/getting-started-guides/scratch/#software-binaries)

## Deployment model
* `etcd`, `docker` and `kubernetes` distributions are stored in S3
* 3 EC2 instances of `etcd`
* 1 EC2 instance of Kubernetes Master
* 2 EC2 instance of Kubernetes Node

## Steps
1. Install `etcd` cluster
   * Option 1: from tar ball distribution
   * Option 2: from `docker`'s image, required to install `docker`
+  Install Kubernetes cluster
   * Option 1: from pre-built scripts
   * Option 2:
     1. Install services for Kubernetes Master instance
     +  Install services for Kubernetes Node instances
        * Install Docker
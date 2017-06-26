## Prerequisites

Dowload `kubectl` client then run the following

```bash
$ kubectl config set-cluster lab --server=https://<master instance public ip>:6443
$ kubectl config set-cluster lab --insecure-skip-tls-verify=true
```

## Prepare

Create a function to wrap the common params
```bash
$ function k() { kubectl --cluster=lab --token=demo/system $@; }
```

## Verify

```bash
$ k get nodes
```


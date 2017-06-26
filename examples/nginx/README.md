Reuse https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/

```bash
$ kubectl --cluster=lab --token=demo/system create -f deployment.yaml
$ kubectl describe deployment nginx-deployment
$ kubectl get pods -l app=nginx
```
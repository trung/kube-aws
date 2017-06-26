Run nginx container
```bash
$ k run my-nginx --image=nginx --replicas=2 --port=80
```

Create load balancer service
```bash
$ k expose deployment my-nginx --port=80 --target-port=80 --type=LoadBalancer
$ k get service my-nginx
NAME       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
my-nginx   10.10.222.71   <pending>     80:31073/TCP   1h
```

Check Load Balancer using Busybox
```bash
$ k run busybox -it --image=busybox --restart=Never --rm
/ # wget -O - http://<my-nginx cluster ip>
```
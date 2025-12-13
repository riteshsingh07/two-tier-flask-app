# How to setup two-tier application deployment on kubernetes cluster

## First setup kubernetes kubeadm cluster
```
1. Create 2 instance which we are going to use as Master and Worker Node.
2. Create a AWS RDS DB and EC2's in the same Security Group
3. Provide "FullAdministatorAccess" IAM role to EC2's.
```

Use this repository to setup kubeadm https://github.com/LondheShubham153/kubestarter/tree/main/Kubeadm_Installation_Scripts_and_Documentation


## SetUp
```
mkdir flask-app
```
- Move to k8s directory
```bash
cd flask-app/
```
- Now, execute below commands one by one
- Execute the below command for secret for Image Pull from ECR
```bash
  kubectl create secret docker-registry <secret-name> \
  --docker-server=<ecr-image-url> \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password --region <region-name>) \
  --namespace=<namespace-name>
```
```bash
kubectl apply -f namespace.yml
```
```bash
kubectl apply -f ConfigMap.yml
```
```bash
kubectl apply -f secrets.yml
```
```bash
kubectl apply -f two-tier-app-pod.yml
```
```bash
kubectl apply -f two-tier-app-deployment.yml
```
```bash
kubectl apply -f two-tier-app-svc.yml
```

## Commands 

```
kubectl get nodes
kubectl apply -f <file-name.yml>
kubectl delete -f <file-name.yml>
kubectl get pods -n <namespace-name>
kubectl decribe pods <pod-name> -n <namespace-name>
kubectl logs <pod-name> -n <namespace-name>
kubectl get svc -n <namespace-name>
```

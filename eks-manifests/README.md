## How to setup two-tier application deployment on AWS EKS

```
1. Create a instance which we are going to use to create cluster.
2. Create a AWS RDS DB and EC2 in the same Security Group
3. Provide "FullAdministatorAccess" IAM role to EC2.
4. Create a Access Key ID and Secret Key ID and save it future usage.
```

Install below : 
```
1. Install awscli
2. Install kubectl
3. Install eskctl
```

```
AWS Configuration : "aws configure"
Provide Access Key ID and Secret Key ID and default region.
```

# Creation of EKS Cluster 
```
eksctl create cluster --name <cluster-name> --region <region-name> --node-type <instance-type> --nodes-min 2 --nodes-max 3
```

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
kubectl apply -f mysql-configmap.yml
```
```bash
kubectl apply -f mysql-secrets.yml
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

```
kubectl get svc -n <namespace-name>
You will see the services list.
You will find the Load Balancer DNS URL, which is the URL for the App.
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
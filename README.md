 
# Two Tier Flask App with AWS RDS-Docker Setup

This is a Flask app that interacts with a AWS RDS database. The app allows users to submit messages, which are then stored in the database and displayed on the frontend.

## Objective 

1. Create a separate Jenkins EC2 to pull the code via Github-Webhook and create Image and upload to AWS ECR.
3. Create a RDS Database. Inbound port:3306 from RDS SG to EC2 Launch Template SG.
4. Create a Launch Template with user_data.sh script that will install all packages, pull and run the docker image.
5. Attach a IAM Role with Launch Template for EC2ContainerRegistry and RDS Full Access and also Cloud-Watch full access.
6. Create a Target group with HTTP port as 5000.
7. Create a Auto-Scaling Group, use Launch Template default version, attach a new load balancer. 
8. Create a Inbound Rule for port:5000 from EC2 to Load Balancer SG.
9. Create a Outbond Rule for port:5000 from Load Balancer SG to EC2.

   
## Jenkins EC2

1. Create a EC2 instance, and inbound port:8080 for Jenkins. Attach ElasticIP with EC2.

**Note** : ElasticIPs won't change on start/stop of instance.

2. Do SSH. Install Java, Jenkins, docker and awscli.

3. http://Elastic_Public_Ip:8080 : Jenkins URL

4. Install Plugins : AWS Credentials, AWS Steps, Pipeline: View Stage
   
5. Refer to "Jenkinsfile" named file for the Pipeline Code.

6. Set up Github-Webhook.

**Webhook** : Jenkins automatically runs the Build whenever some change in the github repo.

## Create DB in AWS RDS

Create a DB. Select MYSQL while creating DB.

Inbound Rule : Add port:3306 from RDS SG to EC2 Launch Template SG.

## Create Launch Template

Refer user_script.sh required during creation if launch template.

```
Inside user_data.sh :

a. Installation of docker,awscli, mysql and other packages.
b. EC2 to ECR login check
c. Docker Pull Image
d. EC2 to RDS Connectivity check
e. Creating DB in RDS
f. Running the container
```

**Note** : Create a IAM Role. EC2 to EC2ContainerRegistry and RDS Full Access and also Cloud-Watch full access.

Attach the IAM Role while creating instance.

## Create Target Group, Load Balancer and  Auto-Scaling Group

1. Create Target Group with port: 5000

2. While Creating Auto-Scaling Group, attach the Launch Template with Default version.

3. Create a Application Load Balancer while creating ASG.

 **Note** : (Desired/Min/Max) Capacity : (1/1/your_wish).

5. Once the ASG created, you will see a instance will come up.

6. Check all the Inbound and Outbond among service connecting.

7. You are good to access the Flask app through the Load Balancer DNS URL.


## Login in RDS

 ```
"mysql -u user_name -h db_endpoint_url -P 3306 -p" press Enter : Fill the Password in prompt. Logged in.
```
1. Check your database in created or not.
2. If yes,In that database, a MESSAGE table will be created.
3. You can insert value in table and can check in the flaskapp updated and vice versa.


# Deploying Flask App with Kubernetes (kubeadm)


```
Please refer to the README file in K8s folder. You will find detailed description. 
```

# Deploying Flask App on AWS EKS

```
Please refer to the README file in K8s folder. You will find detailed description. 
```


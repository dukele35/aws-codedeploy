# AWS CodeDeploy
![alt text](https://github.com/dukele35/aws-codedeploy/blob/master/illustrations/flow.png)
# 1. Creating Amazon Linux AWS
- AMI: Amazon Linux 2 Kernel 5.10 AMI 2.0.20220606.1 x86_64 HVM gp2
- Instance type: t3.2xlarge
- Security group:

| IP version     | Type         | Protocol       | Port Range     | Source        |
| :----:         | :----:       | :---:          | :---:          |:---:          |
| IPv6		     | HTTPS		| TCP		     | 443		      | ::/0	      |
| IPv4		     | HTTPS		| TCP		     | 443		      | 0.0.0.0/0     |
| IPv4		     | HTTP 		| TCP		     | 80		      | 0.0.0.0/0     |
| IPv6		     | HTTP 		| TCP		     | 80		      | ::/0	      |
| IPv4		     | SSH  		| TCP		     | 22		      | 0.0.0.0/0     |
| IPv4		     | Custom TCP   | TCP		     | 5050 (or others)| 0.0.0.0/0     |

- Storage (volume): 50GB (or others)

# 2. AWS Linux Setup 
### 2.1. Install Docker & Docker Compose ([option1](https://www.cyberciti.biz/faq/how-to-install-docker-on-amazon-linux-2/)):
- install docker
```
sudo yum update
sudo yum search docker
sudo yum info docker
sudo usermod -a -G docker ec2-user
id ec2-user
newgrp docker
```
- install docker-compose
```
sudo yum install python3-pip
sudo pip3 install docker-compose # with root access
```
- start services
```
sudo systemctl enable docker.service
sudo systemctl start docker.service
```
- verification
```
sudo systemctl status docker.service
```

### 2.2. Install Docker & Docker Compose ([option2](https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html))
```
sudo yum update -y
sudo amazon-linux-extras install docker
sudo service docker start
sudo usermod -a -G docker ec2-user
```

### 2.3. reboot ec2 
```
sudo reboot
```

### 2.4. Move Git folder to EC2

### 2.5. Install Git on Amazon Linux ([link](https://cloudaffaire.com/how-to-install-git-in-aws-ec2-instance/))
```
sudo yum update -y
sudo yum install git -y
git version
```

### 2.6. Add SSH Key ([link](https://www.youtube.com/watch?v=WgZIv5HI44o))
```
ssh-keygen -t rsa -b 4096 -C "name@emailaddress.com"
>>> Generating public/private rsa key pair.
>>> Enter file in which to save the key (/home/ec2-user/.ssh/id_rsa): 
>>> Enter passphrase (empty for no passphrase): 
>>> Enter same passphrase again: 
>>> Your identification has been saved in /home/ec2-user/.ssh/id_rsa.
>>> Your public key has been saved in /home/ec2-user/.ssh/id_rsa.pub.
>>> The key fingerprint is:
>>> SHA256:******************************** name@emailaddress.com
>>> The key's randomart image is:
+---[RSA 4096]----+
|        o==o.    |
|       .+oo.     |
|      .+ o+      |
|+ o   +o.= +     |
|EO . o  S + .    |
|* +   . .+       |
|.* . . oo..      |
|+.o .o+ ..       |
|ooo+o++...       |
+----[SHA256]-----+
eval $(ssh-agent -s)
>>> Agent pid 8367
ssh-add ~/.ssh/id_rsa
>>> Enter passphrase for /home/ec2-user/.ssh/id_rsa:
>>> Identity added: /home/ec2-user/.ssh/id_rsa (/home/ec2-user/.ssh/id_rsa)
vim ~/.ssh/id_rsa.pub
>>> <copy ssh key>
```

### 2.7. Using Personal Access Token Git ([link](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token))

### 2.8. Reboot EC2 Again
```
sudo reboot
```

### 2.9. Login AWS
```
aws configure
>>> access key
>>> secret key
>>> time zone
>>> format
```

### 2.10. Install Conda ([link](https://medium.com/@GalarnykMichael/aws-ec2-part-3-installing-anaconda-on-ec2-linux-ubuntu-dbef0835818a))
- Go to: https://repo.anaconda.com/archive/ --> to choose a version of conda
- Example: https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh
```
wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh
bash Anaconda3-2022.05-Linux-x86_64.sh
>> follow instructions
source .bashrc
```

### 2.11. Reboot EC2 Again
```
sudo reboot
```

### 2.12. Check EBS persistent volume on EC2
```
df -h 
```

# 3. Install CodeDeploy Agent on AWS Linux EC2
- install codedeploy-agent on ec2 ([link](https://dev.to/ankushbehera/a-complete-guide-to-deploy-github-project-on-amazon-ec2-using-github-actions-and-aws-codedeploy-3f0b))
```
sudo yum update
sudo yum install -y ruby
sudo yum install wget
```
- list of packages available ([link](https://docs.aws.amazon.com/codedeploy/latest/userguide/resource-kit.html#resource-kit-bucket-names))
```
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start
```
- check status of codedeploy-agent
```
sudo service codedeploy-agent status
```
or
```
systemctl status codedeploy-agent
```

# 4. AWS Setup CodeDeploy
### 4.1. Creating 02 IAM Roles
#### Role no.1 - InstanceRole
- use case: EC2
- permission: AmazonEC2RoleforAWSCodeDeploy
- name the role: InstanceRole
#### Role no.2 - CodeDeployRole
- use case: EC2
- permission: AWSCodeDeployRole, AmazonEC2FullAccess, AWSCodeDeployFullAccess, AdministratorAccess
- name the role: CodeDeployRole
- after creating the role, edit Trust Relationship as follows:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "codedeploy.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```
### 4.2. Update EC2 
Created in Step 1
- edit IAM role to be Role no.1 - InstanceRole (Step 4.1) 
- add tags --> EC2-CodeDeploy:latest

### 4.3. Setup AWS CodeDeploy
#### 4.3.1. Create Application
- Application name: CodeDeployApplication
- Compute Platform: EC2/On-premise
#### 4.3.2. Create Deployment Group
- Group name: CodeDeployGroup
- Service role: Role no.2 - CodeDeployRole (Step 4.1)
- Deployment type: in-place 
- Environment configuration: Amazon EC2 instane // tag group: EC2-CodeDeploy:latest (Step 4.2)
- Install AWS CodeDeploy Agent: Now & Schedule Updates 
- Deployment settings: CodeDeployDefault.OneAtATime
- Load balancer: no choice
#### 4.3.3. Create Deployment
- This step is to verify and link between github & codedeploy
- Deployment group: CodeDeployGroup (Step 4.3.2)
- Revision type: My application is stored in Github
- Github token name: --> follow this [link](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- Then connect to github 
- Important [doc](https://docs.aws.amazon.com/codedeploy/latest/userguide/integrations-partners-github.html) - Integrating CodeDeploy w/ Github.

# 5. Required scripts in target repo
#### `./scripts/run.sh`
```
#!/bin/bash
cp /home/ec2-user/opply-app/.env /home/ec2-user/app
cp /home/ec2-user/opply-app/opply-ui/.env /home/ec2-user/app/opply-ui
cp -R /home/ec2-user/opply-app/models /home/ec2-user/app/
cd /home/ec2-user/app
docker-compose build --no-cache
docker-compose up -d
docker system prune -a -f
```
#### `./scripts/setup.sh`
```
#!/bin/bash
sudo amazon-linux-extras install docker -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chmod 666 /var/run/docker.sock
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo service docker start
```
#### `./appspec.yml`
```
version: 0.0
os: linux
files:
 - source: .
   destination: /home/ec2-user/app
hooks:
  AfterInstall:
   - location: scripts/setup.sh
     timeout: 300
     runas: root
  ApplicationStart:
   - location: scripts/run.sh
     timeout: 1200
     runas: root
```

`After this, you could start pushing code commits with automated EC2 server`

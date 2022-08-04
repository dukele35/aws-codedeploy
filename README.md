# AWS CodeDeploy

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
## 2.1.a install docker & docker compose in aws linux ([link](https://www.cyberciti.biz/faq/how-to-install-docker-on-amazon-linux-2/)):
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

## 2.1.b. install docker aws ([link](https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html))
```
sudo yum update -y
sudo amazon-linux-extras install docker
sudo service docker start
sudo usermod -a -G docker ec2-user
```

## 2.2. reboot ec2 
```
sudo reboot
```

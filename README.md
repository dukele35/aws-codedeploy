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
```
```
eval $(ssh-agent -s)
>>> Agent pid 8367
ssh-add ~/.ssh/id_rsa
>>> Enter passphrase for /home/ec2-user/.ssh/id_rsa:
>>> Identity added: /home/ec2-user/.ssh/id_rsa (/home/ec2-user/.ssh/id_rsa)
vim ~/.ssh/id_rsa.pub
>>> <copy ssh key>
```
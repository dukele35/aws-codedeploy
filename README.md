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
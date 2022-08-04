#!/bin/bash
cd /home/ec2-user/app
docker-compose build --no-cache
docker-compose up -d
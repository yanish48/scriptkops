#!/bin/bash

echo "Enter AWS Access Key:"
read awsaccess

echo "Enter AWS Secret Key:"
read awssecret

echo "Enter Cluster Name:"
read clname

echo "Enter an AZ for the cluster:"
read az

sudo apt update

curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.12.6/bin/linux/amd64/kubectl

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

curl -LO https://github.com/kubernetes/kops/releases/download/1.12.1/kops-linux-amd64

chmod +x kops-linux-amd64

sudo mv kops-linux-amd64 /usr/local/bin/kops
sudo apt-get install python -y
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
sudo python get-pip.py

sudo pip install awscli

aws configure set aws_access_key_id $awsaccess
aws configure set aws_secret_access_key $awssecret

ssh-keygen -N "" -f $HOME/.ssh/id_rsa

aws s3 mb s3://$clname

export KOPS_STATE_STORE=s3://$clname
kops create cluster --node-count=2 --master-size="t2.medium" --node-size="t2.medium" --master-volume-size=30 --node-volume-size=30 --zones $az $clname

kops get cluster
kops update cluster $clname --yes

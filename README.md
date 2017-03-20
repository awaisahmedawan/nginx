# nginx
This repository builds the following AWS stack
  - 1 VPC
  - Public subnet
  - Internet Gateway
  - 2 Webservers running Nginx as web server
  - 1 ELB routing traffics to the web servers
  - Security groups with appropriate ingress/egress rules
  - Route table entries 
  
The goal of this project is to build 2 load balanced nginx web servers hosting a simple hello World page

In order to create the infrastructure from this code, you need to make sure that you have terraform and git installed on your system.

Clone the repository using 
    git clone https://github.com/awaisahmedawan/nginx.git

Before you can run the terraform, make sure that you add the aws credentials to the following location:
    $HOME/.aws/credentials
  
The aws provisioner for this code assumes that the credentials are created for profile name nginx-test. An example of the credentials file with this profile will look like:
  
    [nginx-test]
    aws_access_key_id=XXXXXXXXXXXXXXXX
    aws_secret_access_key=XXXXXXXXXXXXXXXXXXXXXXX
  
where access key and secret key are generated from the IAM module in AWS. If not done already, you will need to create a user and give it sufficient access to be able to create stuff (ususally Administrator) and then generate the access keys. Use these keys to set the .aws/credentials profile as stated above. Please note that if you have your profile set already, you can use the same profile name and update it in the file providers.tf

Once you have done the credentials profile, you can run this code using the following:

    terraform plan - to plan to execution and see what is being created.
    terraform apple - to actually create the infrastructure
  
We use Chef for provisioning nginx on the web servers. The default web page is disabled and a simple hello world message is displayed. 

In case you need to connect to the boxes, you can do so by using the command:

    ssh -i key-file-pem ubuntu@instance-name

Since this is a test project, the pem keys are provided in the keys folder. This is not a recomended pratice for actual projects. 
The Instance name can be obtained from the EC2 console from AWS.


Some explanation about the repo itself:

  - The file default.tf contains the terraform code for aws ec2 instances and elb and also related security groups
  - routing.tf contains the infomation about the aws routes and route tables
  - subnet.tf contains the code for subnet creation
  - variables.tf contains variables
  - vpc.tf contains vpc definition
  - providers.tf contain information about the aws provider and the profile name used. If yo have a profile already defined, you can change the name in this file, rather than to create a new profile in youe local credentials
  - keypair.tf contains the location for keys
  - scripts/bootstrap.sh contains initial boot script
  - folder chef contains the chef cookbooks. my-cookbook folder has the actual cookbook data for this project. Rest is supplimentary chef cookbooks for nginx.
  

In order to see the output, you can browse to the instance in your web browser to see the Hello World message. The instance name can be obtained from your ec2 console. In this particular example, it is:

  http://ec2-34-250-96-30.eu-west-1.compute.amazonaws.com/
  displays:
  Hello world



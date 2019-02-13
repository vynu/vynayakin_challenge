# what is this repo about :

1. terraform scripts creates aws resources 

     a. vpc, subnets , security groups

     b. resources like EC2 autoscaling groups with ELB, autoscaling policies and cloudwatch alarms

     c. iam server certificates for ELB ssl

     e. EC2 instances will be created with matching scaling policies (high/low CPU metrics)
 
     d. GO webserver will be installed in docker container with SSL and HTTP to HTTPS port forwarding.

     
2. GO program contains webserver code  with SSL.
3. credit_check program contains credit card number validation code in python.
4. Dockerfile has instructions to compile GO code and create new Image with only GO binary outputs (which reduces image size       drastically!) (in my case its 700 mb to 4.7 mb final image) ( secured and portable for production !)

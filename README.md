# installing jenkins





  - use the packer configuration ubuntu.json file to generate an new ami image  
  - launch a new ec2 instance using the new ami image - enable ports 443,80 and 22    
  - connect to the ec2 instance and check jenkins is installed with jenkins --version command  
  - add new inbound rule to the security group for port 8080  
  - sudo cat /var/lib/jenkins/secrets/initialAdminPassword 
  - from a browser enter the ip address followed :8080

```
sudo apt-get update
sudo apt-get -y upgrade

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install fontconfig openjdk-11-jre -y
sudo apt-get install jenkins -y

sudo systemctl start jenkins
sudo systemctl enable jenkins

sudo ufw enable
sudo ufw allow 8080
sudo ufw status

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

```
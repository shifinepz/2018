#!/usr/bin/bash

From="ExecStart=/usr/libexec/tomcat/server start"
Path="ExecStart=/usr/bin/authbind "/usr/libexec/tomcat/server" start"

sudo yum install tomcat -y
sudo sed -i 's/port="8080"/port="80"/' /etc/tomcat/server.xml
sudo yum install tomcat-webapps tomcat-admin-webapps -y
sudo yum install tomcat-docs-webapp tomcat-javadoc -y
sudo mkdir /opt/authbind
sudo cd /opt/authbind
sudo wget https://s3.amazonaws.com/aaronsilber/public/authbind-2.1.1-0.1.x86_64.rpm
sudo touch /etc/authbind/byport/80
sudo chmod 500 /etc/authbind/byport/80
sudo chown tomcat /etc/authbind/byport/80

sudo sed -i "s~$From~$Path~" /usr/lib/systemd/system/tomcat.service
sudo sed -i "s~$From~$Path~" /etc/systemd/system/multi-user.target.wants/tomcat.service
sudo systemctl daemon-reload
sudo systemctl restart tomcat.service
sudo systemctl status tomcat.service

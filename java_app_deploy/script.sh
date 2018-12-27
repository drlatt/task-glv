 apt-get update
 apt-get install default-jdk -y 
 groupadd tomcat
 useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
cd /tmp
curl -LO https://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.34/bin/apache-tomcat-8.5.34.tar.gz
 mkdir /opt/tomcat
 tar xzvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
cd /opt/tomcat
 chgrp -R tomcat /opt/tomcat
 chmod -R g+r conf
 chmod g+x conf
 chown -R tomcat webapps/ work/ temp/ logs/

vi /

 systemctl daemon-reload
 systemctl start tomcat
 ufw allow 8080
 systemctl enable tomcat
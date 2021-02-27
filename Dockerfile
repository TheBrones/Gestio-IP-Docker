#This is the first dockerfile I made so don't be too harsh
FROM ubuntu:20.04

# Disable Prompt During Packages Installation
ENV DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software and install some required packages
RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get install -y curl wget sudo make apt-utils 
#nano

#Install Perl and a lot of modules
RUN apt-get install -y libssl-dev perl libdbd-mysql-perl libdbi-perl libdbd-mysql-perl libparallel-forkmanager-perl libwww-perl libnet-ip-perl libspreadsheet-parseexcel-perl libsnmp-perl libdate-manip-perl libdate-calc-perl libmailtools-perl libnet-dns-perl libsnmp-info-perl libgd-graph-perl libtext-diff-perl libexpect-perl libxml-parser-perl libxml-simple-perl libtime-parsedate-perl libtext-csv-perl libcrypt-blowfish-perl libcrypt-cbc-perl 

# Download Gestioip itself
RUN curl -L -o gestioip.tar.gz 'https://downloads.sourceforge.net/project/gestioip/gestioip_3.5.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fgestioip%2Ffiles%2Fgestioip_3.5.tar.gz%2Fdownload&ts=1610650147'

# extract and install Gestioip
# this will als install apache automagicly
RUN tar xzvf gestioip.tar.gz 
#RUN cd gestioip_3.5
RUN sed -i 's/GESTIOIP_USER_PASSWORD=""/GESTIOIP_USER_PASSWORD="gipadminpassword"/g' /gestioip_3.5/conf/setup.conf

RUN chmod +x gestioip_3.5/setup_gestioip.sh
RUN bash gestioip_3.5/setup_gestioip.sh

#Cleanup install files
RUN rm gestioip.tar.gz
RUN rm -rf gestioip_3.5

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Expose Port for the Application 
EXPOSE 80

CMD /usr/sbin/apache2ctl -D FOREGROUND

#Just a note 
#docker rm $(docker ps --filter "status=exited" -q)

#https://www.gestioip.net/docu/GestioIP_3.5_Installation_Guide.pdf
#+-------------------------------------------------------+
#|                                                       |
#|    Installation of GestioIP successfully finished!    |
#|                                                       |
#|   Please, review /etc/apache2/sites-enabled/gestioip.conf
#|          to ensure that all is good and               |
#|                                                       |
#|            RESTART the Apache daemon!                 |
#|                                                       |
#|            Then, point your browser to                |
#|                                                       |
#|           http://server/gestioip/install              |
#|                                                       |
#|          to configure the database server.            |
#|                                                       |
#|         Access with user "gipadmin" and the           |
#|        the password is: "gipadminpassword"            |
#|                                                       |
#+-------------------------------------------------------+
#Run manual inside MariaDB container after setup:
#mysql -h db -u root -p
#GRANT ALL PRIVILEGES ON gestioip3.* TO gestioip@db IDENTIFIED BY 'gipadminpassword';
#GRANT ALL PRIVILEGES ON gestioip3.* TO 'gestioip'@'db' IDENTIFIED BY 'gipadminpassword';
#GRANT SELECT, INSERT, DELETE ON gestioip3.* TO 'gipadmin'@'localhost';
#flush privileges;

#remove install files: rm -r /var/www/html/gestioip/install 
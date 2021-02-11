FROM ubuntu:20.04

# Disable Prompt During Packages Installation
#ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software and install some programs to pervent errors 
RUN apt-get update && apt-get upgrade -y 
RUN  apt-get install -y curl wget sudo make apt-utils

#Install Perl and a lot of modules
RUN apt-get install -y libssl-dev perl libdbd-mysql-perl libdbi-perl  libdbd-mysql-perl libparallel-forkmanager-perl libwww-perl libnet-ip-perl libspreadsheet-parseexcel-perl libsnmp-perl libdate-manip-perl libdate-calc-perl libmailtools-perl libnet-dns-perl libsnmp-info-perl libgd-graph-perl libtext-diff-perl libexpect-perl libxml-parser-perl libxml-simple-perl libtime-parsedate-perl libtext-csv-perl libcrypt-blowfish-perl libcrypt-cbc-perl 

# Download gestioip itself
RUN curl -L -o gestioip.tar.gz 'https://downloads.sourceforge.net/project/gestioip/gestioip_3.5.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fgestioip%2Ffiles%2Fgestioip_3.5.tar.gz%2Fdownload&ts=1610650147'

# extract and install gestioip
# this will als install apache automagicly
RUN tar xzvf gestioip.tar.gz 
RUN cd gestioip_3.5
RUN chmod +x gestioip_3.5/setup_gestioip.sh
RUN bash gestioip_3.5/setup_gestioip.sh

# Expose Port for the Application 
EXPOSE 80


#ADD run-apache.sh /run-apache.sh
#RUN chmod -v +x /run-apache.sh

#some trial and error to keep it running (temp)
ENTRYPOINT ["/bin/bash"]
CMD ["while true; do :; done & kill -STOP $! && wait $!"]

#ENTRYPOINT ["echo"]
#CMD ["Hello from CMD"]

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
#|           http://server/gestioip/install
#|                                                       |
#|          to configure the database server.            |
#|                                                       |
#|         Access with user "gipadmin" and the
#|        the password which you created before          |
#|                                                       |
#+-------------------------------------------------------+
#!/bin/bash
# Create config directory 1 if needed
if [ "$(ls -A /usr/share/gestioip/etc)" ]; then
  echo "Etc-Directory already copied"
else
  echo "etc-Files does not exist" ;
  cp /usr/share/gestioip/etc-backup/etc/* /usr/share/gestioip/etc -r
fi
# Create databse config directory if needed
if [ "$(ls -A /var/www/html/gestioip/priv)" ]; then
  echo "priv-Directory already copied"
  # Remove install folder automaticly if exists after the first run
  if [ "$(ls -A /var/www/html/gestioip/install)" ]; then
    echo "Removing installation files"
    rm -r /var/www/html/gestioip/install
  else
    echo "No installation files found"
  fi
else
  echo "priv-Files does not exist" ;
  cp /var/www/html/gestioip/priv-backup/priv/* /var/www/html/gestioip/priv -r
fi
# Set permissions for the gestioip database config (777, yes I know but the Gestioip documentation says so)
chmod -R 777 /var/www/html/gestioip/priv
chmod -R 777 /usr/share/gestioip/etc
# My own fix to set permissions for the web user (otherwise it is root and won't work)
chown -R www-data:www-data /usr/share/gestioip/etc

# start Apache2
. /etc/apache2/envvars
/usr/sbin/apache2ctl -D FOREGROUND
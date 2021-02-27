#!/bin/bash
if [ "$(ls -A /usr/share/gestioip/etc)" ]; then
echo "Directory already copied"
else
echo "Files do not exist" ;
cp /usr/share/gestioip/etc-backup/etc/* /usr/share/gestioip/etc -r
fi
. /etc/apache2/envvars
/usr/sbin/apache2ctl -D FOREGROUND
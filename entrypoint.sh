#!/bin/bash

chmod 0777 /var/www/html/gallery3/var
#/etc/init.d/apache2 start
apache2ctl -D FOREGROUND

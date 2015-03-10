#!/bin/bash

chmod 0777 /var/www/html/images/var
#/etc/init.d/apache2 start
apache2ctl -D FOREGROUND

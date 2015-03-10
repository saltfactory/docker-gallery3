#!/bin/sh

docker run -d \
-p 8888:80 \
--name=gallery3 \
-v $PWD/var:/var/www/html/images/var \
-v $PWD/log:/var/log/apache2 \
-t saltfactory/gallery3

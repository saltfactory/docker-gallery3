#!/bin/sh

docker run -d \
-p 8080:80 \
--name=gallery3 \
-v $PWD/var:/var/www/html/gallery3/var \
-t saltfactory/gallery3

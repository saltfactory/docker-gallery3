FROM ubuntu:14.04
MAINTAINER SungKwang Song <saltfactory@gmail.com>

RUN apt-get update
RUN apt-get install -y \
          git \
          apache2 \
          php5 \
          php5-mysql \
          php5-gd \
          autoconf \
          automake \
          build-essential \
          checkinstall \
          wget \
          unzip \
          libass-dev \
          libfreetype6-dev \
          libgpac-dev \
          libtheora-dev \
          libtool \
          libvorbis-dev \
          pkg-config \
          texi2html \
          zlib1g-dev \
          yasm \
          libx264-dev \
          libmp3lame-dev \
          libopus-dev

RUN mkdir /sources
WORKDIR /sources

RUN wget -O fdk-aac.zip https://github.com/mstorsjo/fdk-aac/zipball/master
RUN unzip fdk-aac.zip
RUN mv mstorsjo-fdk-aac* fdk-aac
WORKDIR fdk-aac
RUN autoreconf -fiv
RUN ./configure --prefix="/ffmpeg_build" --disable-shared
RUN make
RUN make install
RUN make distclean

WORKDIR /sources
RUN wget http://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2
RUN tar xjvf libvpx-v1.3.0.tar.bz2
WORKDIR libvpx-v1.3.0
RUN ./configure --prefix="/ffmpeg_build" --disable-examples
RUN make
RUN make install
RUN make clean

WORKDIR /sources
RUN wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
RUN tar xjvf ffmpeg-snapshot.tar.bz2
WORKDIR ffmpeg
ENV  PKG_CONFIG_PATH /ffmpeg_build/lib/pkgconfig
RUN ./configure \
  --prefix="/ffmpeg_build" \
  --extra-cflags="-I/ffmpeg_build/include" \
  --extra-ldflags="-L/ffmpeg_build/lib" \
  --bindir="/ffmpeg_build/bin" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-nonfree
RUN make
RUN make install
RUN make distclean
RUN hash -r

RUN git clone git://github.com/gallery/gallery3.git
RUN mv gallery3 /var/www/html/images

VOLUME ["/var/www/html/images/var", "/var/log/apache2"]
ADD htaccess /var/www/html/images/.htaccess

RUN chown -R www-data:www-data /var/www/html*

ADD php.ini /etc/php5/apache2/php.ini
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh

EXPOSE 80
#EXPOSE 2222

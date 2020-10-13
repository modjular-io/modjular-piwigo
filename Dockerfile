FROM modjular/modjular-nginx:latest

LABEL maintainer="Jeffrey Phillips Freeman the@jeffreyfreeman.me"

# Install needed tools
RUN echo "**** install packages ****" && \
    apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get dist-upgrade -y --no-install-recommends && \
    apt-get install -y --no-install-recommends \
      php-mysqli \
      php-curl \
      php-fpm \
      php-common \
      php-mbstring \
      php-xmlrpc \
      php-gd \
      php-xml \
      php-intl \
      php-mysql \
      php-ldap \
      php-zip \
      curl \
      exiftool \
      ffmpeg \
      imagemagick \
      libjpeg-turbo-progs \
      lynx \
      mediainfo \
      php-apcu \
      php-cgi \
      php-ctype \
      php-dom \
      php-exif \
      php-imagick \
      php-mysqlnd \
      php-pear \
      php-xsl \
      poppler-utils \
      re2c \
      unzip \
      wget && \
    echo "**** download piwigo ****" && \
    PIWIGO_RELEASE=$(curl -sX GET "https://api.github.com/repos/Piwigo/Piwigo/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
    mkdir /piwigo && \
    curl -o /piwigo/piwigo.zip -L "http://piwigo.org/download/dlcounter.php?code=${PIWIGO_RELEASE}" && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

RUN sed -i 's/^[[:space:]]*[;]*[[:space:]]*memory_limit[[:space:]]*=[[:space:]]*.*/memory_limit = 256M/' /etc/php/7.3/fpm/php.ini && \
    sed -i 's/^[[:space:]]*[;]*[[:space:]]*cgi.fix_pathinfo[[:space:]]*=[[:space:]]*.*/cgi.fix_pathinfo = 0/' /etc/php/7.3/fpm/php.ini && \
    sed -i 's/^[[:space:]]*[;]*[[:space:]]*upload_max_filesize[[:space:]]*=[[:space:]]*.*/upload_max_filesize = 512M/' /etc/php/7.3/fpm/php.ini && \
    sed -i 's/^[[:space:]]*[;]*[[:space:]]*date.timezone[[:space:]]*=[[:space:]]*.*/date.timezone = America\/New_York/' /etc/php/7.3/fpm/php.ini

# copy local files
COPY piwigo.conf /etc/nginx/conf.d/
COPY 40-install-piwigo.sh /docker-entrypoint.d/
COPY 39-start-fpm.sh /docker-entrypoint.d/

# ports and volumes
EXPOSE 80 443
VOLUME ["/config", "/pictures"]

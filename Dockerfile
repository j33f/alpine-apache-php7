FROM alpine:edge
MAINTAINER Jean-François Vial <jeff@modulaweb.fr>

# Add repos
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Add basics first
RUN apk update && apk upgrade && apk add \
	bash apache2-proxy curl ca-certificates git php7 php7-fpm php7-json php7-iconv php7-openssl

# Setup apache and php
RUN apk add \
	php7-ftp \
	php7-xdebug \
	php7-mcrypt \
	php7-soap \
	php7-gmp \
	php7-pdo_odbc \
	php7-dom \
	php7-pdo \
	php7-zip \
	php7-zlib \
	php7-mysqli \
	php7-sqlite3 \
	php7-pdo_pgsql \
	php7-bcmath \
	php7-gd \
	php7-odbc \
	php7-pdo_mysql \
	php7-pdo_sqlite \
	php7-gettext \
	php7-xmlreader \
	php7-xmlrpc \
	php7-bz2 \
	php7-pdo_dblib \
	php7-curl \
	php7-ctype \
	php7-session \
	php7-redis \
	php7-opcache \
	php7-uuid \
	&& rm /usr/bin/php \
	&& ln -s /usr/bin/php7 /usr/bin/php \
    && rm -f /var/cache/apk/*

# Add apache to run and configure + start script
RUN mkdir /run/apache2 && mkdir /bootstrap
COPY start.sh /bootstrap/start.sh
COPY www.conf /etc/php7/php-fpm.d/www.conf
RUN mkdir /app && chown -R apache:apache /app && chmod -R 755 /app  && chmod +x /bootstrap/start.sh

EXPOSE 8080
ENTRYPOINT ["/bootstrap/start.sh"]

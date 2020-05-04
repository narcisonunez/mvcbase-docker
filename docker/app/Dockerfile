# base image
FROM ubuntu:18.04

LABEL maintainer="Narciso Nunez"

# avoid interactivity - accepts the default option
ENV DEBIAN_FRONTEND=noninteractive

# Set the timezone to UTC 
RUN apt-get update \
	&& apt-get install -y gnupg tzdata \
	&& echo  "UTC" > /etc/timezone \
	&& dpkg-reconfigure -f noninteractive tzdata

# install all the php most common dependencies
RUN apt-get update \
	&& apt-get install -y vim curl zip unzip git supervisor sqlite3 \
	nginx php7.2-fpm php7.2-cli \
	php7.2-pgsql php7.2-sqlite3 php7.2-gd \
	php7.2-curl php7.2-memcached php7.2-redis \
	php7.2-imap php7.2-mysql php7.2-mbstring \
	php7.2-xml php7.2-zip php7.2-bcmath php7.2-soap \
	php7.2-intl php7.2-readline php7.2-xdebug \
	php-msgpack php-igbinary \
	&& php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin --filename=composer \
	&& mkdir /run/php \
	&& apt-get -y autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& echo "daemon off;" >> /etc/nginx/nginx.conf

# create symbolics links to nginx logs to the stdout and stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

# override the default nginx configuration
ADD default /etc/nginx/sites-available/default
# override default supervisord configuration
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# override default php-fpm configuration for nodaemon = 0 and error logs
ADD php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf
# script to setup the container
ADD startup-container.sh /usr/bin/startup-container
# grant permissions to the script
RUN chmod +x /usr/bin/startup-container
# use the script as the entry point
ENTRYPOINT [ "startup-container" ]
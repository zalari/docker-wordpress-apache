# from https://wordpress.org/about/requirements/
FROM php:5.6-apache

MAINTAINER  David Enke <david.enke@zalari.de>
ENV REFRESHED_AT 2016-02-15
ENV CONTAINER_VERSION 0.1.0

RUN a2enmod rewrite

#no frontend, otherwise ssmtp install fails...
ENV DEBIAN_FRONTEND noninteractive

# install the PHP extensions we need + SSMTP
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev ssmtp \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql

#setup php.ini to allow for sending via ssmtp
RUN echo "[mail function]" >> /usr/local/etc/php/php.ini && \
	echo "sendmail_path = /usr/sbin/ssmtp -t" >> /usr/local/etc/php/php.ini && \
	apache2ctl restart

WORKDIR /var/www/html

# https://de.wordpress.org/releases/
ENV WP_VERSION 4.4.2
ENV WP_LOCALE de_DE
ENV WP_MD5 8ac443eb8769f7dc2df7aec87acb44ce

RUN curl -fSL "https://de.wordpress.org/wordpress-${WP_VERSION}-${WP_LOCALE}.tar.gz" -o wp.tar.gz \
	&& echo "${WP_MD5} *wp.tar.gz" | md5sum -c - \
	&& tar -xz --strip-components=1 -f wp.tar.gz \
	&& rm wp.tar.gz
	&& chown -R www-data:www-data .

#setup ssmtp ENVs defaults
ENV SMTP_MAILHOST localhost
ENV SMTP_PORT 25
ENV SMTP_USER user
ENV SMTP_PASS pass
ENV SMTP_USE_TLS No
ENV SMTP_USE_TLS_CERTS No
ENV SMTP_FROM_OVERRIDE Yes
ENV SMTP_USE_STARTTLS No
ENV SMTP_ROOT root@localhost
ENV SMTP_HOSTNAME wordpress.zz

#allow running apache as root, to circumvent docker-host-sharing-file-ownership-madness
ENV CHANGE_USER_ID No
ENV WWW_DATA_USER_ID 1000

#configure ssmtp by creating a new conf on run, generated from ENVs
COPY setup_ssmtp_run_apache.sh /usr/local/bin/
CMD ["setup_ssmtp_run_apache.sh"]
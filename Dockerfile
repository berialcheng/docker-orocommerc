FROM php:7.0-fpm

RUN apt-get update && apt-get install -y \
    git \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    software-properties-common \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
RUN add-apt-repository ppa:ondrej/php && apt-get update && apt-get install -y \
    php7.0-intl

RUN cd /tmp \
    && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash \
    && . ~/.bashrc \
    && nvm install v6.11.2

RUN mkdir /app && cd /app \
    && git clone --recursive https://github.com/orocommerce/orocommerce-application.git

WORKDIR /app/orocommerce-application
RUN php -r "echo ini_get('memory_limit').PHP_EOL;"
RUN curl -s https://getcomposer.org/installer | php
RUN php -d memory_limit=-1 composer.phar install --prefer-dist

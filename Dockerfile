FROM php:fpm-alpine

MAINTAINER xinghen249@gmail.com

RUN apk --no-cache add hiredis libmemcached zlib libpng git && \
    apk --no-cache add --virtual .build-deps libpng-dev g++ make autoconf hiredis-dev libmcrypt-dev gmp-dev icu-dev linux-headers musl libmemcached-dev cyrus-sasl-dev zlib-dev && \
    cd /tmp && curl -o memcached.tar.gz https://github.com/php-memcached-dev/php-memcached/archive/master.tar.gz -L && \
    tar zxvf /tmp/memcached.tar.gz && rm -f /tmp/memcached.tar.gz &&  cd *memcached* && phpize && \
    ./configure && make && make install && \
    docker-php-ext-enable memcached && \
    cd /tmp && curl -o igbinary.tgz http://pecl.php.net/get/igbinary -L && \
    tar zxvf /tmp/igbinary.tgz && rm -f /tmp/igbinary.tgz && \
    cd *igbinary* && phpize && ./configure && make && make install && \
    docker-php-ext-enable igbinary && \
    cd /tmp && git clone https://github.com/phpredis/phpredis.git && \
    cd phpredis/ && phpize && ./configure --enable-redis-igbinary && make && make install && \
    docker-php-ext-enable redis && \
    cd /tmp && git clone --depth=1 git://github.com/dreamsxin/cphalcon7.git && \
    cd cphalcon7/ext/ && phpize && ./configure && make && make install && \
    docker-php-ext-enable phalcon && \
    docker-php-ext-install mysqli pdo_mysql zip bcmath gd && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer self-update && \
    apk del .build-deps .persistent-deps && \
    cd / && rm -rf tmp/*
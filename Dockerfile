FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libpq-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    unzip \
    wget \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_pgsql pgsql xml zip intl \
    && rm -rf /var/lib/apt/lists/*

ENV DOLI_VERSION=19.0.2
RUN wget -q https://github.com/Dolibarr/dolibarr/archive/refs/tags/19.0.2.tar.gz -O /tmp/dolibarr.tar.gz \
    && tar -xzf /tmp/dolibarr.tar.gz -C /tmp \
    && rm -rf /var/www/html/* \
    && cp -r /tmp/dolibarr-19.0.2/htdocs/* /var/www/html/ \
    && rm -rf /tmp/dolibarr*

RUN mkdir -p /var/www/documents \
    && chown -R www-data:www-data /var/www/html /var/www/documents \
    && chmod -R 775 /var/www/documents

RUN echo "memory_limit = 128M" > /usr/local/etc/php/conf.d/memory.ini \
    && echo "max_execution_time = 120" >> /usr/local/etc/php/conf.d/memory.ini \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && a2enmod rewrite

EXPOSE 80
CMD ["apache2-foreground"]

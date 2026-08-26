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
    && docker-php-ext-install gd pdo pdo_pgsql pgsql pdo_mysql mysqli xml zip intl \
    && rm -rf /var/lib/apt/lists/*

ENV DOLI_VERSION=19.0.2
RUN wget -q https://github.com/Dolibarr/dolibarr/archive/refs/tags/19.0.2.tar.gz -O /tmp/dolibarr.tar.gz \
    && tar -xzf /tmp/dolibarr.tar.gz -C /tmp \
    && rm -rf /var/www/html/* \
    && cp -r /tmp/dolibarr-19.0.2/htdocs/* /var/www/html/ \
    && rm -rf /tmp/dolibarr*

# Configurar conf.php permanente y candado de seguridad
RUN mkdir -p /var/www/documents \
    && touch /var/www/documents/install.lock \
    && echo "<?php" > /var/www/html/conf/conf.php \
    && echo "\$dolibarr_main_url_root='https://dolibarr-constructora.onrender.com';" >> /var/www/html/conf/conf.php \
    && echo "\$dolibarr_main_document_root='/var/www/html';" >> /var/www/html/conf/conf.php \
    && echo "\$dolibarr_main_data_root='/var/www/documents';" >> /var/www/html/conf/conf.php \
    && echo "\$dolibarr_main_db_host='aws-0-us-west-2.pooler.supabase.com';" >> /var/www/html/conf/conf.php \
    && echo "\$dolibarr_main_db_port='5432';" >> /var/www/html/conf/conf.php \
    && echo "\$dolibarr_main_db_name='postgres';" >> /var/www/html/conf/conf.php \
    && echo "\$dolibarr_main_db_prefix='llx_';" >> /var/www/html/conf/conf.php \
    && echo "\$dolibarr_main_db_user='postgres.vayoscssobmzijnsqnem';" >> /var/www/html/conf/conf.php \
    && echo "\$dolibarr_main_db_pass='AdminDoli2026!';" >> /var/www/html/conf/conf.php \
    && echo "\$dolibarr_main_db_type='pgsql';" >> /var/www/html/conf/conf.php \
    && echo "\$dolibarr_main_prod='1';" >> /var/www/html/conf/conf.php \
    && chown -R www-data:www-data /var/www/html /var/www/documents \
    && chmod 444 /var/www/html/conf/conf.php \
    && chmod -R 777 /var/www/documents

# Silenciar deprecated warnings
RUN echo "memory_limit = 128M" > /usr/local/etc/php/conf.d/dolibarr.ini \
    && echo "max_execution_time = 120" >> /usr/local/etc/php/conf.d/dolibarr.ini \
    && echo "error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE" >> /usr/local/etc/php/conf.d/dolibarr.ini \
    && echo "display_errors = Off" >> /usr/local/etc/php/conf.d/dolibarr.ini \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && a2enmod rewrite

EXPOSE 80
CMD ["apache2-foreground"]

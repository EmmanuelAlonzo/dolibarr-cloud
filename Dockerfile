FROM tuxgasy/dolibarr:latest

# Ajustes de memoria PHP
RUN echo "memory_limit = 128M" > /usr/local/etc/php/conf.d/memory-limit.ini \
    && echo "max_execution_time = 120" >> /usr/local/etc/php/conf.d/memory-limit.ini

# Configurar Apache para escuchar en el puerto que Render asigna ( o 80)
RUN sed -i 's/Listen 80/Listen 80\nListen 10000/' /etc/apache2/ports.conf \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

EXPOSE 80 10000

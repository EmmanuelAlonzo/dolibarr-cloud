FROM tuxgasy/dolibarr:latest
RUN echo "memory_limit = 128M" > /usr/local/etc/php/conf.d/memory-limit.ini \
&& echo "max_execution_time = 120" >> /usr/local/etc/php/conf.d/memory-limit.ini
RUN echo "Mutex flock" >> /etc/apache2/apache2.conf \
&& echo "ServerName localhost" >> /etc/apache2/apache2.conf
ENV PORT=80
EXPOSE 80

FROM tuxgasy/dolibarr:latest
RUN echo "memory_limit = 128M" > /usr/local/etc/php/conf.d/memory-limit.ini \
&& echo "max_execution_time = 120" >> /usr/local/etc/php/conf.d/memory-limit.ini
ENV PORT=80
EXPOSE 80
CMD ["apache2-foreground"]

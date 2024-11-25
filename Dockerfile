# Base image
FROM jadypamella/passoire:base

# Copy the .htaccess file 
COPY /files/.htaccess /passoire/web/.htaccess

# Copy the error page
COPY /files/error.html /passoire/web/error.html

# Modify Apache configuration to allow .htaccess overrides and adjust LogLevel
RUN echo '<Directory /var/www/html>' >> /etc/apache2/apache2.conf \
    && echo '    Options Indexes FollowSymLinks' >> /etc/apache2/apache2.conf \
    && echo '    AllowOverride All' >> /etc/apache2/apache2.conf \
    && echo '    Require all granted' >> /etc/apache2/apache2.conf \
    && echo '</Directory>' >> /etc/apache2/apache2.conf \
    && echo 'LogLevel notice' >> /etc/apache2/apache2.conf
    
# Restart Apache
RUN apache2ctl restart

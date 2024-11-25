# Base image
FROM nharrand/passoire:latest

### Flag 3
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

# Enable rewrite
RUN a2enmod headers

# Restart Apache
RUN apache2ctl restart

### Flag 14
# Removing user 'a' if it exists
RUN if getent passwd a > /dev/null 2>&1; then userdel -r a; fi

# Removing user 'admin' if it exists
RUN if getent passwd admin > /dev/null 2>&1; then userdel -r admin; fi

### Flag 2
RUN chmod -R 400 /root

# Change the ownership of the documents from root to 'passoire'
RUN chown -R passoire:passoire /passoire/

# Switch to user 'passoire'
USER passoire

# Continue with your application's setup or commands
WORKDIR /passoire
COPY . /passoire
# Base image
FROM jadypamella/passoire:latest

# Stop crypto-helper
RUN /passoire/crypto-helper/crypto-helper.sh stop

# Copy the new signup page
COPY /files/signup.php /passoire/web/signup.php

### Flag 13
# Replace the php.ini file 
COPY /files/php.ini /etc/php/7.4/cli/php.ini 

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


### Flag 9
# Encrypt the flag file during the build process
#RUN openssl enc -aes-256-cbc -salt -pbkdf2 -in /passoire/crypto-helper/flag_9 -out /passoire/crypto-helper/flag_9.enc -k "Z9fE4y@M8Q3#nH" && \

# Replace the flag for the encrypted one 
#RUN mv /passoire/crypto-helper/flag_9.enc /passoire/crypto-helper/flag_9


### Flag 14
# Removing user 'a' if it exists
#RUN if getent passwd a > /dev/null 2>&1; then userdel -r a; fi

# Removing user 'admin' if it exists
#RUN if getent passwd admin > /dev/null 2>&1; then userdel -r admin; fi

### Flag 6
#RUN chmod 000 /passoire/web/uploads/flag_6

### Flag 2
#RUN chmod -R 400 /root

# Change the ownership of the documents from root to 'passoire'
#RUN chown -R passoire:passoire /passoire/


### Final Adjustments
# Adjust log level
#RUN echo 'LogLevel error' >> /etc/apache2/apache2.conf
#RUN apache2ctl restart

# Switch to user 'passoire'
#USER passoire

# Continue with your application's setup or commands
#WORKDIR /passoire


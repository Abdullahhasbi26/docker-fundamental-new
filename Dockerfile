FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt update && apt install -y software-properties-common \
    && add-apt-repository ppa:ondrej/php \
    && apt update \
    && apt install -y \
    nginx \
    php8.2-fpm \
    php8.2-mysql \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Add your static assets to the web directory
# Add your static assets to the web directory
COPY web /var/www/html

# Copy Nginx configuration file
COPY config/nginx.conf /etc/nginx/sites-available/default

# Remove the existing symlink if it exists, and create a new symlink
RUN rm -f /etc/nginx/sites-enabled/default \
    && ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Expose port 80 for the web server
EXPOSE 80

# Start PHP-FPM and Nginx
CMD ["sh", "-c", "service php8.2-fpm start && nginx -g 'daemon off;'"]
FROM serversideup/php:8.4-fpm-nginx

WORKDIR /var/www/html

USER root

# ========================
# SYSTEM PACKAGES
# ========================
RUN apt-get update && apt-get install -y \
    ffmpeg \
    unzip \
    zip \
    jpegoptim \
    optipng \
    pngquant \
    gifsicle \
    libvips42 \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# ========================
# PHP EXTENSIONS
# ========================
RUN install-php-extensions \
    bcmath \
    curl \
    exif \
    gd \
    imagick \
    intl \
    mbstring \
    xml \
    zip \
    pdo_mysql \
    redis \
    vips \
    ffi

# ========================
# COPY SOURCE
# ========================
COPY --chown=www-data:www-data . /var/www/html

# ========================
# COPY ENTRYPOINT (🔥 QUAN TRỌNG NHẤT)
# ========================
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ========================
# COMPOSER
# ========================
RUN composer install --no-ansi --no-interaction --optimize-autoloader

# ========================
# FIX PERMISSION
# ========================
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# ========================
# RAILWAY VOLUME FIX
# ========================
RUN mkdir -p /data/storage \
    && chown -R www-data:www-data /data

USER www-data

EXPOSE 8080

# ========================
# START COMMAND (🔥)
# ========================
CMD ["/entrypoint.sh"]

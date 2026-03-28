FROM serversideup/php:8.4-fpm-nginx

WORKDIR /var/www/html

USER root

# ========================
# 1. SYSTEM PACKAGES (Tối ưu cho ảnh & video)
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
# 2. PHP EXTENSIONS (Bao gồm Redis & Vips siêu tốc)
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
# 3. NGINX OPTIMIZATION (🔥 NÂNG CẤP SIÊU TỐC)
# ========================
# Ghi đè cấu hình Nginx mặc định bằng file nginx.conf bạn vừa tạo
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN chown www-data:www-data /etc/nginx/conf.d/default.conf

# ========================
# 4. COPY SOURCE & ENTRYPOINT
# ========================
COPY --chown=www-data:www-data . /var/www/html
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ========================
# 5. COMPOSER & PERMISSIONS
# ========================
RUN composer install --no-ansi --no-interaction --optimize-autoloader

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# ========================
# 6. RAILWAY VOLUME FIX
# ========================
RUN mkdir -p /data/storage \
    && chown -R www-data:www-data /data

# Chuyển quyền lại cho www-data để bảo mật và vận hành
USER www-data

EXPOSE 8080

# ========================
# START COMMAND (Kết hợp Horizon & Web Server)
# ========================
CMD ["/entrypoint.sh"]

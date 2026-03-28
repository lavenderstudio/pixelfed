#!/bin/sh

echo "🚀 Pixelfed starting..."

# Fix permission
chown -R www-data:www-data /var/www/html || true
chmod -R 775 storage bootstrap/cache || true

# Laravel clean
php artisan config:clear || true
php artisan cache:clear || true

# Migrate
php artisan migrate --force || true

# 🔥 LOOP GIẢ LẬP CRON
echo "⚙️ Starting background worker loop..."
(
  while true
  do
    php artisan schedule:run --no-interaction
    php artisan queue:work --stop-when-empty --tries=3
    sleep 300
  done
) &

# 🔥 START SERVER (QUAN TRỌNG)
exec /init

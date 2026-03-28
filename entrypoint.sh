#!/bin/sh

echo "🚀 Pixelfed booting..."

# ========================
# FIX PERMISSION
# ========================
chown -R www-data:www-data /var/www/html || true
chmod -R 775 storage bootstrap/cache || true

# ========================
# LARAVEL CLEAN
# ========================
php artisan config:clear || true
php artisan cache:clear || true
php artisan route:clear || true
php artisan view:clear || true

# ========================
# STORAGE LINK (FIX 404 AVATAR)
# ========================
php artisan storage:link || true

# ========================
# WAIT DB (QUAN TRỌNG)
# ========================
echo "⏳ Waiting for DB..."
sleep 5

# ========================
# MIGRATE (KHÔNG FAIL DEPLOY)
# ========================
php artisan migrate --force || true

# ========================
# QUEUE (FIX HOMEPAGE 500)
# ========================
echo "⚙️ Starting queue..."
php artisan queue:work redis --sleep=3 --tries=3 --timeout=90 > /dev/stdout 2>&1 &

# ========================
# SCHEDULER (OPTIONAL)
# ========================
echo "⏱ Starting scheduler..."
while true
do
  php artisan schedule:run --no-interaction &
  sleep 60
done &

# ========================
# START NGINX + PHP-FPM
# ========================
echo "🌐 Starting web server..."
exec /init

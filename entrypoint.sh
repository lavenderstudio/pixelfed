#!/bin/sh

echo "🚀 Pixelfed Super-Charged Booting for Lavender Prime..."

# ========================
# 1. KHỞI TẠO CẤU TRÚC VOLUME /DATA (Bắt buộc để không lỗi 500)
# ========================
mkdir -p /data/storage/app/public
mkdir -p /data/storage/framework/cache
mkdir -p /data/storage/framework/sessions
mkdir -p /data/storage/framework/views
mkdir -p /data/storage/logs

# Phân quyền chuẩn cho Volume ngoài
chown -R www-data:www-data /data/storage
chmod -R 775 /data/storage
chown -R www-data:www-data /var/www/html/storage bootstrap/cache
chmod -R 775 /var/www/html/storage bootstrap/cache

# ========================
# 2. STORAGE & DB
# ========================
# Xóa link cũ nếu có và tạo link mới sang Volume /data
rm -rf public/storage
php artisan storage:link --force || true

echo "⏳ Syncing Database Schema..."
php artisan migrate --force || true

# ========================
# 3. DỌN DẸP CACHE (An toàn hơn cho Railway)
# ========================
# Không dùng config:cache để tránh kẹt biến môi trường cũ
php artisan config:clear
php artisan route:clear
php artisan view:clear

# ========================
# 4. KHỞI CHẠY HORIZON & SCHEDULER
# ========================
echo "⚙️ Starting Redis Workers (Horizon)..."
php artisan horizon &

echo "⏱ Starting Task Scheduler..."
(while true; do php artisan schedule:run --no-interaction; sleep 60; done) &

# ========================
# 5. START SERVER
# ========================
echo "🌐 Lavender Prime Social is Online!"
exec /init

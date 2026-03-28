#!/bin/sh

echo "🚀 Pixelfed Super-Charged Booting..."

# ========================
# 1. FIX PERMISSIONS (Chạy ngầm để không delay boot)
# ========================
(chown -R www-data:www-data /var/www/html && chmod -R 775 storage bootstrap/cache) &

# ========================
# 2. STORAGE & DB (Bắt buộc)
# ========================
php artisan storage:link --force || true
echo "⏳ Waiting for DB..."
sleep 3 # Giảm xuống 3s vì Railway DB thường khởi động rất nhanh
php artisan migrate --force || true

# ========================
# 3. TỐI ƯU HÓA CACHE (Đưa toàn bộ vào RAM)
# ========================
# Thay vì clear, ta nạp thẳng vào bộ nhớ để PHP không phải đọc ổ cứng
echo "⚡ Optimizing Laravel for Production..."
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache

# ========================
# 4. KHỞI CHẠY HORIZON (Thay cho queue:work)
# ========================
# Horizon quản lý hàng chờ Redis thông minh hơn, xử lý ảnh song song cực nhanh
echo "⚙️ Starting Laravel Horizon (Redis Powered)..."
php artisan horizon &

# ========================
# 5. SCHEDULER (Chạy tinh gọn)
# ========================
echo "⏱ Starting Scheduler..."
(while true; do php artisan schedule:run --no-interaction; sleep 60; done) &

# ========================
# 6. DỌN DẸP OOM (Chống tràn RAM trên Railway)
# ========================
# Giải phóng bộ nhớ đệm của hệ thống trước khi chạy Web Server
sync && echo 3 > /proc/sys/vm/drop_caches || true

# ========================
# 7. START NGINX + PHP-FPM
# ========================
echo "🌐 Web Server is Ready!"
exec /init

<?php

use Illuminate\Database\DBAL\TimestampType;

return [

    'default' => env('DB_CONNECTION', 'mysql'),

    'connections' => [

        // ... (sqlite giữ nguyên)

        'mysql' => [
            'driver'      => 'mysql',
            'host'        => env('DB_HOST', '127.0.0.1'),
            'port'        => env('DB_PORT', '3306'),
            'database'    => env('DB_DATABASE', 'forge'),
            'username'    => env('DB_USERNAME', 'forge'),
            'password'    => env('DB_PASSWORD', ''),
            'unix_socket' => env('DB_SOCKET', ''),
            'sticky'      => true,
            'charset'     => 'utf8mb4',
            'collation'   => 'utf8mb4_unicode_ci',
            'prefix'      => '',
            'strict'      => false,
            'engine'      => 'InnoDB', // Ép sử dụng InnoDB để tối ưu khóa dòng (row-level locking)
            
            // 🔥 NÂNG CẤP SIÊU TỐC TẠI ĐÂY:
            'options' => extension_loaded('pdo_mysql') ? array_filter([
                PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8mb4',
                // Kết nối bền vững: Giảm thời gian "bắt tay" (handshake) với DB trên Railway
                PDO::ATTR_PERSISTENT => true, 
                // Tăng tốc độ nạp dữ liệu lớn
                PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true,
            ]) : [],
            
            'dump' => [
                'use_single_transaction',
                'skip_lock_tables',
            ]
        ],

        'pgsql' => [
            'driver'   => 'pgsql',
            'host'     => env('DB_HOST', '127.0.0.1'),
            'port'     => env('DB_PORT', '5432'),
            'database' => env('DB_DATABASE', 'forge'),
            'username' => env('DB_USERNAME', 'forge'),
            'password' => env('DB_PASSWORD', ''),
            'charset'  => 'utf8',
            'prefix'   => '',
            'schema'   => 'public',
            'sslmode'  => 'prefer',
            // 🔥 NÂNG CẤP POSTGRES (Nếu bạn dùng trên Railway)
            'persistent' => true, 
        ],

        // ... (mariadb và sqlsrv giữ nguyên)
    ],

    'migrations' => 'migrations',

    'redis' => [
        // 🔥 QUAN TRỌNG: Chuyển sang phpredis để tận dụng extension bạn đã cài trong Docker
        'client' => env('REDIS_CLIENT', 'phpredis'),

        'options' => [
            'cluster' => env('REDIS_CLUSTER', 'redis'),
            'prefix' => env('REDIS_PREFIX', 'pixelfed_database_'),
            // Duy trì kết nối Redis không ngắt quãng
            'persistent' => true, 
        ],

        'default' => [
            'scheme'   => env('REDIS_SCHEME', 'tcp'),
            'path'     => env('REDIS_PATH'),
            'host'     => env('REDIS_HOST', '127.0.0.1'),
            'password' => env('REDIS_PASSWORD', null),
            'port'     => env('REDIS_PORT', 6379),
            'database' => env('REDIS_DATABASE', 0),
            'read_write_timeout' => 60,
        ],

        'cache' => [ // Thêm cache riêng cho Redis
            'scheme'   => env('REDIS_SCHEME', 'tcp'),
            'host'     => env('REDIS_HOST', '127.0.0.1'),
            'password' => env('REDIS_PASSWORD', null),
            'port'     => env('REDIS_PORT', 6379),
            'database' => env('REDIS_DATABASE_CACHE', 1),
        ],

        'session' => [
            'scheme'   => env('REDIS_SCHEME', 'tcp'),
            'path'     => env('REDIS_PATH'),
            'host'     => env('REDIS_HOST', '127.0.0.1'),
            'password' => env('REDIS_PASSWORD', null),
            'port'     => env('REDIS_PORT', 6379),
            'database' => env('REDIS_DATABASE_SESSION', 2),
        ],

        // Giữ nguyên Pulse nếu bạn dùng
        'pulse' => [
            'scheme'   => env('REDIS_SCHEME', 'tcp'),
            'path'     => env('REDIS_PATH'),
            'host'     => env('REDIS_HOST', '127.0.0.1'),
            'password' => env('REDIS_PASSWORD', null),
            'port'     => env('REDIS_PORT', 6379),
            'database' => env('REDIS_DATABASE_PULSE', 3),
        ],
    ],
];

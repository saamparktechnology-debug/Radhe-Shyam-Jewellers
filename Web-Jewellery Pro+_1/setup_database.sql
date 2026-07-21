-- ============================================================
-- Radhe Shyam Jewellers — Full Database Setup Script
-- Run this in phpMyAdmin or MySQL CLI to create the full database schema.
-- ============================================================

CREATE DATABASE IF NOT EXISTS `radhe_shyam_jewellers`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `radhe_shyam_jewellers`;

-- Users Table
CREATE TABLE IF NOT EXISTS `users` (
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `name`       VARCHAR(100) NOT NULL,
    `mobile`     VARCHAR(15) UNIQUE NOT NULL,
    `email`      VARCHAR(100),
    `password`   VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Admin user: saamparktechnology@gmail.com / 123456
INSERT IGNORE INTO `users` (`name`, `mobile`, `email`, `password`)
VALUES (
    'Radhe Shyam Admin',
    '8617536679',
    'saamparktechnology@gmail.com',
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'
);

-- Admin user: subhapatra169@gmail.com / radhe#123
INSERT IGNORE INTO `users` (`name`, `mobile`, `email`, `password`)
VALUES (
    'Subha Patra',
    '7000000000',
    'subhapatra169@gmail.com',
    '$2y$10$Je7Scc5m3N6XKrOkWrnPweVTfVZncjMD0HG.3qX4xm66wJA7kcqfm'
);

-- Admin user: hiisupriya@gmail.com / 123456
INSERT IGNORE INTO `users` (`name`, `mobile`, `email`, `password`)
VALUES (
    'Supriya',
    '7000000001',
    'hiisupriya@gmail.com',
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'
);

-- Products Table
CREATE TABLE IF NOT EXISTS `products` (
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `serial_no`  VARCHAR(50) UNIQUE NULL,
    `name`       VARCHAR(200) NOT NULL,
    `item_name`  VARCHAR(255) DEFAULT '',
    `weight`     VARCHAR(20) NULL,
    `category`   VARCHAR(50),
    `price`      DECIMAL(10,2) NOT NULL,
    `quantity`   INT DEFAULT 0,
    `huid_code`  VARCHAR(100) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Customers Table
CREATE TABLE IF NOT EXISTS `customers` (
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `name`       VARCHAR(100) NOT NULL,
    `mobile`     VARCHAR(15) UNIQUE NOT NULL,
    `email`      VARCHAR(100),
    `address`    TEXT NULL,
    `gst_number` VARCHAR(20) DEFAULT '',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Invoices Table
CREATE TABLE IF NOT EXISTS `invoices` (
    `id`               INT AUTO_INCREMENT PRIMARY KEY,
    `invoice_no`       VARCHAR(50) UNIQUE NOT NULL,
    `customer_id`      INT NULL,
    `customer_name`    VARCHAR(100) NOT NULL,
    `customer_mobile`  VARCHAR(15) NOT NULL,
    `customer_address` TEXT NULL,
    `customer_gstin`   VARCHAR(50) NULL,
    `gst_type`         ENUM('gst', 'non_gst') DEFAULT 'non_gst',
    `subtotal`         DECIMAL(10,2) DEFAULT 0,
    `gst_amount`       DECIMAL(10,2) DEFAULT 0,
    `discount`         DECIMAL(10,2) DEFAULT 0,
    `total_amount`     DECIMAL(10,2) DEFAULT 0,
    `payment_status`   VARCHAR(20) DEFAULT 'pending',
    `payment_method`   VARCHAR(20) DEFAULT 'Cash',
    `paid_amount`      DECIMAL(10,2) DEFAULT 0,
    `balance_amount`   DECIMAL(10,2) DEFAULT 0,
    `huid_code`        VARCHAR(100) NULL,
    `cash_paid`        DECIMAL(10,2) DEFAULT 0,
    `upi_paid`         DECIMAL(10,2) DEFAULT 0,
    `account_paid`     DECIMAL(10,2) DEFAULT 0,
    `due_date`         DATE NULL,
    `reminder_sent`    TINYINT(1) DEFAULT 0,
    `pdf_file`         LONGBLOB NULL,
    `pdf_file_name`    VARCHAR(255) NULL,
    `created_by`       INT,
    `created_at`       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Invoice Items Table
CREATE TABLE IF NOT EXISTS `invoice_items` (
    `id`            INT AUTO_INCREMENT PRIMARY KEY,
    `invoice_id`     INT,
    `product_id`     INT,
    `product_name`   VARCHAR(200) NULL,
    `serial_no`      VARCHAR(100) NULL,
    `hsn_code`       VARCHAR(50) NULL,
    `quantity`       DECIMAL(10,3),
    `price`          DECIMAL(10,2),
    `making_charge`  DECIMAL(10,2) DEFAULT 0,
    `hallmark`       DECIMAL(10,2) DEFAULT 0,
    `discount`       DECIMAL(10,2) DEFAULT 0,
    `total`          DECIMAL(10,2),
    `huid_code`      VARCHAR(100) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Income Table
CREATE TABLE IF NOT EXISTS `income` (
    `id`             INT PRIMARY KEY AUTO_INCREMENT,
    `income_date`    DATE NOT NULL,
    `source`         VARCHAR(100) NOT NULL,
    `category`       VARCHAR(50) NOT NULL,
    `amount`         DECIMAL(10,2) NOT NULL,
    `description`    TEXT,
    `payment_method` ENUM('cash', 'card', 'upi', 'bank') DEFAULT 'cash',
    `invoice_no`     VARCHAR(50),
    `created_by`     INT,
    `created_at`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_date` (`income_date`),
    INDEX `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Expenses Table
CREATE TABLE IF NOT EXISTS `expenses` (
    `id`             INT PRIMARY KEY AUTO_INCREMENT,
    `expense_date`   DATE NOT NULL,
    `category`       VARCHAR(50) NOT NULL,
    `amount`         DECIMAL(10,2) NOT NULL,
    `description`    TEXT,
    `payment_method` ENUM('cash', 'card', 'upi', 'bank') DEFAULT 'cash',
    `bill_no`        VARCHAR(50),
    `vendor_name`    VARCHAR(100),
    `created_by`     INT,
    `created_at`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_date` (`expense_date`),
    INDEX `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Income Categories
CREATE TABLE IF NOT EXISTS `income_categories` (
    `id`            INT PRIMARY KEY AUTO_INCREMENT,
    `category_name` VARCHAR(50) UNIQUE NOT NULL,
    `status`        ENUM('active', 'inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Expense Categories
CREATE TABLE IF NOT EXISTS `expense_categories` (
    `id`            INT PRIMARY KEY AUTO_INCREMENT,
    `category_name` VARCHAR(50) UNIQUE NOT NULL,
    `status`        ENUM('active', 'inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO `income_categories` (`category_name`) VALUES 
('Sales Income'), ('Interest Income'), ('Rental Income'), ('Commission Income'), ('Other Income');

INSERT IGNORE INTO `expense_categories` (`category_name`) VALUES 
('Purchase'), ('Rent'), ('Electricity Bill'), ('Salary'), ('Marketing'), ('Maintenance'), ('Tax Payment'), ('Transportation'), ('Other Expenses');

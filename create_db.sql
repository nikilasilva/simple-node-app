CREATE DATABASE terraform_demo;

USE terraform_demo;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20)
);

-- Run this command
-- mysql -u root -p < create_db.sql

-- INSERT INTO users (name, email, phone) VALUES ('John Doe', 'john@example.com', '77-676-7676');
-- INSERT INTO users (name, email, phone) VALUES ('Jane Smith', 'jane@example.com', '77-878-7878');
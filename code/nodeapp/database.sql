CREATE DATABASE IF NOT EXISTS TODO;
USE TODO;
CREATE TABLE IF NOT EXISTS task(id INTEGER PRIMARY KEY AUTO_INCREMENT,name VARCHAR(50), description VARCHAR(500));
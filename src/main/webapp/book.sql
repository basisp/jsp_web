CREATE TABLE IF NOT EXISTS book (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    publisher VARCHAR(255) NOT NULL,
    available BOOLEAN DEFAULT TRUE
    image_path VARCHAR(255) DEFAULT NULL,        
    summary TEXT DEFAULT NULL,             
    rating FLOAT DEFAULT 0,                 
    review_count INT DEFAULT 0    
);

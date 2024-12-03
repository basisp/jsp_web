USE mydb;

CREATE TABLE IF NOT EXISTS member (
    sno INT,
    password VARCHAR(255),
    name VARCHAR(14),
    major VARCHAR(50),
    email VARCHAR(100),
    role VARCHAR(14),
    PRIMARY KEY (sno)
);

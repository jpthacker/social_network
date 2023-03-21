TRUNCATE TABLE users, posts RESTART IDENTITY;

INSERT INTO users (username, email_address) VALUES ('Ray', 'ray@makers.com');
INSERT INTO users (username, email_address) VALUES ('Jack', 'jack@makers.com');
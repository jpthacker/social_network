TRUNCATE TABLE users, posts RESTART IDENTITY;

INSERT INTO users (username, email_address) VALUES ('Ray', 'ray@makers.com');
INSERT INTO users (username, email_address) VALUES ('Jack', 'jack@makers.com');

INSERT INTO posts (title, content, no_of_views, user_id) VALUES ('baby photos', 'six months progress', 5, 1);
INSERT INTO posts (title, content, no_of_views, user_id) VALUES ('cat photos', 'two years old', 3, 2);
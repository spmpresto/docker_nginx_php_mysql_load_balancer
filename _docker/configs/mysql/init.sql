-- Setting up a root user with a password
-- ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'password';

ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
FLUSH PRIVILEGES;


-- Set SQL_MODE
SET GLOBAL sql_mode = 'NO_ENGINE_SUBSTITUTION';
SET SESSION sql_mode = 'NO_ENGINE_SUBSTITUTION';

CREATE DATABASE mattermost;
CREATE USER mmuser WITH PASSWORD 'really_secure_password';
GRANT ALL PRIVILEGES ON DATABASE mattermost to mmuser;
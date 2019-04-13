CREATE DATABASE wine_db;
use wine_db;
CREATE TABLE wine_collection (
id INT Primary Key,
wine text,
location text,
score text,
GWS_score text,
nbj text,
);



CREATE TABLE top_20_wine (
id INT PRIMARY KEY,
wine text,
vintage text,
location text,
score text,
bottles_in_stock INT
);

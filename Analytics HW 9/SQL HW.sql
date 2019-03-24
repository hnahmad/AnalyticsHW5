
--  1a. Display the first and last names of all actors from the table `actor`.

USE sakila;
-- Want to see table
SELECT * FROM actor;
-- To see only first and last names
SELECT first_name, last_name FROM actor;

-- * 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

SELECT
	A.first_name as First_Name,
	A.last_name as Last_Name,
	CONCAT_WS('',first_name," ",last_name) AS Actor_Name
FROM actor AS A;

--  2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT * FROM Actor;
SELECT A.actor_id, A.first_name, A.last_name
FROM actor AS A
WHERE A.first_name = 'Joe';


-- * 2b. Find all actors whose last name contain the letters `GEN`:

SELECT * FROM actor 
WHERE last_name LIKE '%GEN%';

-- * 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

SELECT * FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

--  2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT * FROM country;

SELECT country_id, country 
FROM country 
WHERE country IN ("Afghanistan", "Bangladesh", "China");


-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a 
-- description, so create a column in the table `actor` named `description` and use the data type `BLOB`
--  (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).

ALTER TABLE actor 
ADD description BLOB;

SELECT * FROM actor;

-- * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the `description` column.

ALTER TABLE actor
DROP description;

SELECT * FROM actor;

-- * 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(last_name) as "Number of People"
FROM actor 
GROUP BY last_name;

-- * 4b. List last names of actors and the number of actors who have that last name,
-- but only -- for names that are
 -- shared by at least two actors
 SELECT last_name, COUNT(last_name) as "Number of People"
 FROM actor
 GROUP BY last_name 
 HAVING COUNT(last_name) >= 2;
 
-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`.
-- Write a query to fix the record.
 
UPDATE actor
SET first_name = "HENRY" WHERE first_name = "GROUCHO";

-- Note to self:  the above didn't work because there could have been multiple rows where that was the case;
-- Perhaps cyn's worked without primary key ID because it was reduced to one line????

SELECT * FROM actor WHERE first_name = "GROUCHO";

UPDATE actor 
SET first_name = 'HARPO'
WHERE actor_id = 172;

SELECT * FROM actor
WHERE actor_id = 172;

/*  4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the 
correct name after all! In a single query, if the first name of the actor is currently `HARPO`,
 change it to `GROUCHO`.*/
 
 -- NOTE TO TA'S:  i took this instruction to mean change ALL Harpos to Groucho
 
 SELECT * FROM actor
 WHERE first_name = "HARPO";
 
-- NOTE TO TA's - I guess it didn't matter since there is only one HARPO; however, 
 
 SET SQL_SAFE_UPDATES =0;
 UPDATE actor 
 SET first_name = "GROUCHO" 
 WHERE first_name = "HARPO";
 
 SET SQL_SAFE_UPDATES =0;
 
 --  5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
 
 SHOW CREATE TABLE address;
 
 DESCRIBE address;
 
 --  6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
 -- Use the tables `staff` and `address`:
 
 SELECT * FROM staff;
 SELECT * FROM address;
 
 SELECT 
	S.first_name, S.last_name, A.address
 
 FROM staff AS S
	INNER JOIN address AS A ON S.address_id = A.address_id;
    
    -- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
    -- Use tables `staff` and `payment`.

SELECT * FROM payment;

SELECT 
	SUM(P.amount) as "Total Purchases", S.first_name
FROM
	Staff as S 
    INNER JOIN payment as P on S.staff_id = P.staff_id
    WHERE P.payment_date LIKE "2005-08%"
    GROUP BY S.first_name;

-- 6c. List each film and the number of actors who are listed for that film.
--  Use tables `film_actor` and `film`. Use inner join.

SELECT * FROM film_actor;
Select * from film;
    
SELECT f.film_id, f.title, COUNT(a.actor_id) as "Number of Actors"

FROM 
	film AS f 
    INNER JOIN film_actor as a ON f.film_id = a.film_id
    GROUP BY (f.film_id);
 
 
 -- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
 
 SELECT * FROM inventory;
 SELECT * FROM film;
 
 SELECT COUNT(film_id) AS "Number of Copies"  FROM inventory
 WHERE film_id IN
	(SELECT film_id FROM film
    WHERE title = "Hunchback Impossible");
    
-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid
--  by each customer. List the customers alphabetically by last name:

SELECT * FROM payment;
SELECT * FROM customer;
 
SELECT 
	SUM(P.amount), 
	C.first_name,
    C.last_name
FROM customer as C
INNER JOIN payment as P ON c.customer_id = p.customer_id
GROUP BY (P.customer_id)
ORDER BY last_name;

-- * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
--  As an unintended consequence, films starting with the letters `K` and `Q` have also
-- soared in popularity. Use subqueries to display the titles of movies starting with 
-- the letters `K` and `Q` whose language is English.

SELECT * FROM film;
SELECT * FROM language;

SELECT title FROM film

WHERE title LIKE 'K%' OR  title LIKE 'Q%' AND language_id IN
	(SELECT language_id FROM language
    WHERE name = "English");

--  7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

SELECT * FROM film_actor;
SELECT * FROM actor;
SELECT * FROM film;

SELECT * FROM actor
WHERE actor_id IN
	(SELECT actor_id FROM film_actor
	WHERE film_id IN
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));
        
        
        
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names
-- and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT * from customer;
SELECT * from country;
SELECT * from address;
SELECT * from city;


SELECT c.first_name, c.last_name, c.email
FROM customer AS c
INNER JOIN address AS a ON c.address_id = a.address_id
INNER JOIN city AS t ON a.city_id = t.city_id
INNER JOIN country AS p ON t.country_id = p.country_id
WHERE p.country = "Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies
--  for a promotion. Identify all movies categorized as _family_ films.

SELECT * FROM film_category;
SELECT * FROM film;
SELECT * FROM category;

SELECT * FROM film
WHERE film_id IN

	(SELECT film_id FROM film_category
	WHERE category_id IN

		(SELECT category_id FROM category 
		WHERE name = 'Family'));
        
-- 7e. Display the most frequently rented movies in descending order.

SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM film;

SELECT f.title, COUNT(r.rental_id) AS 'Number of Rentals'
FROM rental as R
INNER JOIN inventory as I ON (r.inventory_id = I.inventory_id)
INNER JOIN film as F ON (I.film_id = F.film_id)
GROUP BY f.film_id
ORDER BY COUNT(r.rental_id) DESC;

-- TA's for some reason, the ORDER BY would not work for me when i had it as 'Number of Rentals; I DO NOT KNOW WH
--  AS I BELIEVE THIS SHOULD HAVE WORKED.  ANY IDEA WHY?????


-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT * FROM store;
SELECT * FROM payment;
SELECT * from rental;
SELECT * from inventory;


SELECT S.store_id, SUM(p.amount) AS "Store Sales"
FROM payment AS P 
INNER JOIN rental AS R ON (p.rental_id = r.rental_id)
INNER JOIN inventory AS I ON  (r.inventory_id = i.inventory_id)
INNER JOIN store AS S ON (i.store_id = s.store_id)
GROUP BY store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT * FROM store;
select * from city;
select * from country;
select * from address;



SELECT s.store_ID, c.city, p.country 
FROM store AS s 
INNER JOIN address AS a ON (s.address_id = a.address_id)
INNER JOIN city AS c ON (a.city_id = c.city_id)
INNER JOIN country AS p ON (c.country_id = p.country_id);

--  7h. List the top five genres in gross revenue in descending order.
-- (**Hint**: you may need to use the following tables: category, film_category, inventory, payment,
-- and rental.)

SELECT * from category;
select * from film_category;
select * from inventory;
select * from payment;
select * from rental;

SELECT c.name as "Genre" , SUM(p.amount) "Sales"
FROM category AS c 
INNER JOIN film_category AS f ON (c.category_id = f.category_id)
INNER JOIN inventory AS i on (f.film_id = i.film_id)
INNER JOIN rental AS r on (i.inventory_id = r.inventory_id)
INNER JOIN payment AS p on (r.rental_id = p.rental_id)
GROUP BY c.name
ORDER BY SUM(p.amount) DESC limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the 
-- Top five genres by gross revenue. Use the solution from the problem above to create a view.
--  If you haven't solved 7h, you can substitute another query to create a view.


CREATE VIEW Top_Five_Genres_by_Sales AS (
SELECT c.name as "Genre" , SUM(p.amount) "Sales"
FROM category AS c 
INNER JOIN film_category AS f ON (c.category_id = f.category_id)
INNER JOIN inventory AS i on (f.film_id = i.film_id)
INNER JOIN rental AS r on (i.inventory_id = r.inventory_id)
INNER JOIN payment AS p on (r.rental_id = p.rental_id)
GROUP BY c.name
ORDER BY SUM(p.amount) DESC limit 5);

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM Top_Five_Genres_by_Sales;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

DROP VIEW Top_Five_Genres_by_Sales;
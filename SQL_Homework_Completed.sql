USE Sakila;

-- 1a.
SELECT first_name, last_name
FROM actor;

-- 2a.

ALTER Table actor
ADD COLUMN Actor_Name VARCHAR (100);
SET SQL_SAFE_UPDATES = 0;

UPDATE actor SET  Actor_Name  = CONCAT(first_name, " ", last_name);

SELECT * FROM actor;

SET SQL_SAFE_UPDATES = 1;

-- 2b.
SELECT *
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c.
SELECT *
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name ASC;

-- 2d
SELECT country.country_id, country.country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. BLOB typically allows several different types of multimedia objects
-- including images and audio

ALTER Table actor
ADD COLUMN Decription BLOB;
SET SQL_SAFE_UPDATES = 0;

SELECT * FROM actor;

-- 3b. 
ALTER Table actor
DROP COLUMN Decription;

SELECT * FROM actor;

-- 4a. 
SELECT count(*), last_name 
FROM actor
GROUP BY last_name;

-- 4b. 
SELECT count(*), last_name 
FROM actor
GROUP BY last_name
HAVING count(*) >=2;

-- 4c. 
SELECT *
FROM actor
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

UPDATE actor
SET 
	first_name = 'HARPO',
	last_name = 'WILLIAMS'
WHERE
	actor_id = 172;

UPDATE actor SET  Actor_Name  = CONCAT(first_name, " ", last_name);

SELECT *
FROM actor
WHERE
	actor_id = 172;
    

-- 5
DESCRIBE address;

-- 6a
SELECT *
FROM staff;


SELECT *
FROM address;


SELECT first_name, last_name, address
FROM STAFF s
JOIN address a
ON s.address_id = a.address_id;

-- 6b
SELECT * 
FROM staff;

SELECT * 
FROM payment;

SELECT first_name, last_name, SUM(amount) AS Total
FROM STAFF s
JOIN payment p
ON s.staff_id = p.staff_id
GROUP BY s.first_name, s.last_name;

 -- 6c List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
 SELECT *
 from film_actor;
 
 SELECT * 
 from film;
 
 SELECT title, COUNT(*) AS Number_of_actors
 FROM film_actor a
 INNER JOIN film f
 ON a.film_id = f.film_id
 GROUP BY f.title;
 
 
 -- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
 
 SELECT * 
 from inventory;
 
 SELECT * 
 from film;
 
SELECT COUNT(*) AS Number_of_Hunchback_Impossible
FROM inventory i
JOIN film f
ON i.film_id = f.film_id
WHERE title = "Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

 SELECT * 
 FROM payment;

SELECT * 
FROM customer;

SELECT first_name, last_name, SUM(amount) AS 'Total Amount Paid'
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY first_name, last_name
ORDER BY last_name ASC;

 -- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films 
 -- starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies 
 -- starting with the letters K and Q whose language is English.
 
 
 SELECT * 
 FROM film;
 
SELECT * 
FROM language;
 
SELECT title
FROM film
WHERE title like 'K%' OR title like 'Q%'
AND title IN

(
SELECT title
FROM film
WHERE language_id = 1

);
 
 
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name
FROM actor
WHERE actor_id IN

(SELECT actor_id
FROM film_actor
WHERE film_id IN

(SELECT film_id
FROM film
WHERE title = 'Alone Trip'
)
);
 
 -- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses 
 -- of all Canadian customers. Use joins to retrieve this information.
 
 
 SELECT first_name, last_name, email
 FROM customer c
 JOIN address a
 ON (c.address_id = a.address_id)
 JOIN city 
 ON (a.city_id = city.city_id)
 JOIN country 
 ON (city.country_id = country.country_id)
 WHERE country = 'Canada';
 
 
 -- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
 -- Identify all movies categorized as famiy films.


SELECT *
FROM film;

SELECT *
FROM film_category;

SELECT *
FROM category;


 SELECT title
 FROM film f
 JOIN film_category c
 ON (f.film_id = c.film_id)
 JOIN category 
 ON (c.category_id = category.category_id)
 WHERE name = 'Family';
 
 
 -- 7e. Display the most frequently rented movies in descending order.
 
SELECT *
FROM film;
 
 
SELECT *
FROM inventory;
 
SELECT *
FROM rental;
 
 SELECT title, COUNT(*) AS Number_Rented
 FROM film
 JOIN inventory i
 ON (film.film_id = i.film_id)
 JOIN rental
 ON (i.inventory_id = rental.inventory_id)
 GROUP BY title ORDER BY Number_Rented Desc;
 
-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT *
FROM store;
 
SELECT *
FROM payment;

SELECT store_id, SUM(amount) AS 'Total Amount Per Store'
FROM payment p
JOIN store s
ON p.staff_id = s.manager_staff_id 
GROUP BY store_id;


-- 7g. Write a query to display for each store its store ID, city, and country.


SELECT *
FROM store;


SELECT *
FROM address;

 
SELECT *
FROM city;
 

SELECT *
FROM country;
 
SELECT store_id, city, country
FROM store s
JOIN address a
ON s.address_id = a.address_id
JOIN city c
ON a.city_id = c.city_id
JOIN country
ON c.country_id = country.country_id
GROUP BY store_id;


-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT *
FROM category;


SELECT *
FROM film_category;

SELECT *
FROM inventory;


SELECT *
FROM rental;


SELECT *
FROM payment;


SELECT name, SUM(amount) AS 'Total Gross'
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN inventory
ON film_category.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY name ORDER BY SUM(amount) DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.


CREATE VIEW Top_five_Genres AS
SELECT name, SUM(amount) AS 'Total Gross'
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN inventory
ON film_category.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY name ORDER BY SUM(amount) DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM Top_five_Genres; 

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.


DROP VIEW Top_five_Genres;



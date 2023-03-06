USE sakila;
-- 1.- How many copies of the film Hunchback Impossible exist in the inventory system?

#get filmid
select film_id from sakila.film
where title = 'Hunchback Impossible'; #Film_id = 439

#get number of copies 
SELECT COUNT(film_id) from sakila.inventory 
where film_id = 439; 

-- 2.- List all films whose length is longer than the average of all the films.

SELECT * FROM sakila.film
WHERE length > (SELECT avg(length) FROM sakila.film);

-- 3.- Use subqueries to display all actors who appear in the film Alone Trip.

SELECT CONCAT(a.first_name," ", a.last_name) AS full_name
FROM actor a
JOIN film_actor fa USING (actor_id)
WHERE fa. film_id IN (
 SELECT film_id
    FROM film
    WHERE title = 'ALONE TRIP');
    
-- 4.- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select title from sakila.film
JOIN sakila.film_category USING (film_id)
JOIN sakila.category USING (category_id)
WHERE name = 'Family';

-- 5.- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT CONCAT(first_name," ", last_name) AS full_name , email
FROM customer
WHERE address_id IN (
 SELECT address_id
 FROM address
 where city_id in 
    (
    SELECT city_id FROM city 
    join country using (country_id)
    where country='Canada'
    )
);

-- Joins
SELECT CONCAT(first_name," ", last_name) AS full_name , email
FROM customer 
JOIN address USING (address_id)
JOIN city USING (city_id)
JOIN country USING (country_id)
WHERE country = 'Canada';

-- 6.- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

#get actor_id
SELECT actor_id, count(film_id) as film from film_actor
group by actor_id
order by film DESC;

#finding the title
Select title from film
where film_id in (
select film_id from film 
join film_actor using (film_id) 
where film_actor.actor_id=107);

-- 7.- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

#get customer_id
SELECT customer_id , sum(amount) from payment
group by customer_id
order by sum(amount) DESC
LIMIT 1;

#Films title

select title from film 
where film_id in
 (
select film_id from film
join inventory using (film_id)
where inventory_id = (select inventory_id from rental where customer_id = 526)
);

SELECT title
FROM film
WHERE film_id IN (
 SELECT film_id
 FROM inventory
 WHERE inventory_id IN (
  SELECT inventory_id
  FROM rental
  WHERE customer_id = 526)
);

-- 8.- Customers who spent more than the average payments.

SELECT CONCAT(first_name," ", last_name) AS full_name
FROM customer
WHERE customer.customer_id IN (
 SELECT payment.customer_id
 FROM payment
 GROUP BY payment.customer_id
 HAVING AVG(payment.amount) > (
  SELECT AVG(amount)
  FROM payment)
);

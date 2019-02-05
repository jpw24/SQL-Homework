USE sakila;

#1
#1a Display the first and last names of all actors from the table 'actor'
SELECT first_name, last_name from actor;

#1b Display the first and last name of each actor in a single column in upper case letters. Name the column 'Actor Name'
SELECT CONCAT(first_name, " ", last_name) as "Actor Name" FROM actor;

#2
#2a  You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id,first_name,last_name from actor where first_name="Joe";

#2b Find all actors whose last name contain the letters GEN:
SELECT * from actor where last_name like "%gen%";

#2c Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that orde
SELECT * FROM actor where last_name like "%li%" order by last_name,first_name;

#2d Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id,country from Country where country in ("Afghanistan","Bangladesh","China");

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD description BLOB;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor DROP description;

#4a. List the last names of actors, as well as how many actors have that last name.
Select last_name,count(last_name) from actor group by last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
Select last_name,count(last_name) from actor group by last_name having count(last_name)>1;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
Update actor set first_name="Harpo",last_name="Williams" where last_name="Williams" AND first_name="Groucho";

#4d Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
Update actor set first_name="Groucho" where first_name="Harpo";

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
Select s.first_name,s.last_name,a.address from staff s INNER JOIN address a on s.address_id=a.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

select p.staff_id,sum(p.amount) as "Total amount rung up" from payment p inner join staff s on s.staff_id=p.staff_id where p.payment_date>='2005-08-01' and p.payment_date<='2005-08-31' group by staff_id;

#select payment_date from payment;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select f.title,count(fa.actor_id) as "Number of actors" from film f inner join film_actor fa on f.film_id=fa.film_id group by f.film_id;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
Select f.title as "Title",count(i.film_id) as "Number of Copies" from inventory i inner join film f on f.film_id=i.film_id where f.title= "Hunchback Impossible" group by f.film_id;

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select c.first_name as "First Name",c.last_name as "Last Name",sum(p.amount) as "Total paid per customer" from customer c inner join payment p on c.customer_id=p.customer_id group by c.customer_id order by c.last_name;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title from film where (title like "K%" or title like "Q%") and language_id in
(select language_id from language where name="English");

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
Select first_name as "First Name",last_name as "Last Name" from actor where actor_id in
	(select fa.actor_id from film_actor fa inner join film f on f.film_id=fa.film_id where f.title="Alone Trip");

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses 
#of all Canadian customers. Use joins to retrieve this information.
select concat(c.first_name," ",c.last_name) as "Customer Name",c.email from customer c inner join address a on c.address_id=a.address_id inner join city ci on ci.city_id=a.city_id inner join country co on co.country_id=ci.country_id where co.country="Canada";

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
#Identify all movies categorized as family films.

select f.title from film f inner join film_category fc on f.film_id=fc.film_id inner join category c on c.category_id=fc.category_id where c.name="Family";

#7e. Display the most frequently rented movies in descending order.
select f.title as "Movie Title",count(i.film_id) as "Frequency" from film f inner join inventory i on i.film_id=f.film_id inner join rental r on r.inventory_id=i.film_id group by f.film_id order by count(i.film_id) DESC;

#7f. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(p.amount) as "Total Payment" from store s inner join staff st on st.store_id=s.store_id inner join payment p on st.staff_id=p.staff_id group by s.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
select s.store_id, ci.city, co.country from store s inner join address a on a.address_id=s.address_id inner join city ci on a.city_id=ci.city_id inner join country co on co.country_id=ci.country_id group by store_id;

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select cat.name as "Genre",sum(p.amount) as "Gross Revenue" from category cat inner join film_category fc on fc.category_id=cat.category_id inner join inventory i on fc.film_id=i.film_id inner join rental re on re.inventory_id=i.inventory_id inner join payment p on re.rental_id=p.rental_id group by cat.name order by sum(p.amount) DESC limit 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW Top_Genres AS 
select cat.name as "Genre",sum(p.amount) as "Gross Revenue" from category cat inner join film_category fc on fc.category_id=cat.category_id inner join inventory i on fc.film_id=i.film_id inner join rental re on re.inventory_id=i.inventory_id inner join payment p on re.rental_id=p.rental_id group by cat.name order by sum(p.amount) DESC limit 5;

#8b. How would you display the view that you created in 8a?
Select * from Top_Genres;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW Top_Genres;
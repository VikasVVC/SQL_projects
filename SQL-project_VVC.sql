/* Q1: Who is the senior most employee based on job title? */

Select *from employee

select first_name, last_name 
from employee
order by levels desc 
limit 1


/* Q2: Which countries have the most Invoices? */

select *from invoice

select billing_country , count(billing_country) 
from invoice 
group by billing_country 
order by count(billing_country) desc

/* Q3: What are top 3 values of total invoice? */

Select total 
from invoice 
order by total desc
limit 3

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select *from invoice
select *from customer

select billing_city , sum(total) 
from invoice 
group by billing_city
order by sum(total) desc

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select c.first_name, c.last_name, sum(total) 
from customer as c
join invoice as inv
on c.customer_id = inv.customer_id
group by c.first_name, c.last_name
order by sum(total) desc
limit 1

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

select c.email, c.first_name, c.last_name 
from customer as c
join invoice as inv 
on c.customer_id = inv.customer_id
join invoice_line as invl
on invl.invoice_id = inv.invoice_id 
join track as tr 
on tr.track_id = invl.track_id 
join genre as gen
on gen.genre_id = tr.genre_id 
where gen.genre_id = '1'
order by c.email

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select *from album
select *from artist
select *from track

select ar.name, count(ar.name) 
from artist as ar
join album as al
on al.artist_id = ar.artist_id 
join track as tr
on tr.album_id = al.album_id
join genre as gen
on gen.genre_id = tr.genre_id
where gen.genre_id = '1'
group by ar.name
order by count(ar.name) desc
limit 10

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name, milliseconds
from track
where milliseconds >
(select avg(milliseconds)
from track)
order by milliseconds desc

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

select concat(c.first_name,c.last_name), ar.name,sum(invl.unit_price*invl.quantity) as "totalspent"
from customer as c
join invoice as inv 
on c.customer_id = inv.customer_id
join invoice_line as invl
on invl.invoice_id = inv.invoice_id 
join track as tr 
on tr.track_id = invl.track_id 
join album as al
on al.album_id = tr.album_id 
join artist as ar
on ar.artist_id = al.artist_id
group by c.first_name, c.last_name, ar.name
order by totalspent desc

/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

with cte as (select count(invl.quantity) as "totalqty" , c.country , row_number() over(partition by c.country order by count(invl.quantity) desc) as "row"
from customer as c
join invoice as inv 
on c.customer_id = inv.customer_id
join invoice_line as invl
on invl.invoice_id = inv.invoice_id 
join track as tr 
on tr.track_id = invl.track_id 
join genre as gen 
on gen.genre_id = tr.genre_id 
group by gen.name, c.country
			)
select *from cte
where row < 2

/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

with cte as (select sum(invl.unit_price*invl.quantity) as "totalqty" , c.first_name, c.last_name,c.country , row_number() over(partition by c.country order by sum(invl.unit_price*invl.quantity) desc) as "row"
from customer as c
join invoice as inv 
on c.customer_id = inv.customer_id
join invoice_line as invl
on invl.invoice_id = inv.invoice_id 
join track as tr 
on tr.track_id = invl.track_id 
join genre as gen 
on gen.genre_id = tr.genre_id 
group by gen.name, c.country,c.first_name, c.last_name
			)
select *from cte
where row < 2






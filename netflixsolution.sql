--Netflix project
drop table if exists netflix;
CREATE TABLE netflix
 (
	 show_id varchar (6),
	 type	varchar (10),
	 title	varchar(150),
	 director varchar(210),
	 casts varchar(1000),
	 country	varchar (154),
	 date_added varchar (50),
	 year_of_release int,
	 rating varchar (10),
	 duration varchar(15),
	 listed_in	varchar(150),
	 description varchar(250)
);
select count (*) as total_content from netflix;

select distinct type from netflix;

--15 business problems
--1.count the number of movies vs tv shows
select 
type, count(*) as total_content
from netflix 
group by type;

--2. find the most common rating for movies and tv shows.
select
type,
rating
from
(
	select 
	type,
	rating,
	count(*),
	rank() over(partition by type order by count(*)desc) as ranking
	from netflix
	group by 1, 2)	as t1
 where
	ranking= 1

--3.list all movies released in a specific year(2020)
select 
type,
title,
year_of_release
from netflix
where
type = 'Movie' and
year_of_release = 2020;

--4. find the top 5 countries with the most content on netflix,.
select  
unnest(string_to_array(country,',')) as new_country,
count(show_id)
from netflix
group by 1
order by 2 desc 
limit 5 ;

--5.identify the longest movie.
select * from netflix
where
type ='Movie' and
duration = (select max(duration)from netflix);

--6.find content added in the last 5 years
select *
from netflix
where 
to_date(date_added, 'Month, DD, YYYY') >= current_date 
-interval '5years';

--7.find all the movies/tv shows by director 'Kirsten Johnson'
select * from netflix
where
director ilike '%Kirsten Johnson%';

--8.list al tv shows with more than five seasons.
select * from netflix
where 
type = 'TV Show' and
duration >'5 Seasons';

--9.count the number of content in each genre
select
unnest(string_to_array(listed_in,',')) as genre,
count(show_id) as total_content
from netflix
group by 1
;

--10. find each year and the average number of content release by india on netflix. return top 5 years with highest average content
select 
extract(year from to_date(date_added, 'Month, DD, YYYY')) as year,
count(*),
round(count(*)::numeric/(select count(*)from netflix where country ='India')::numeric * 100,2) as average
from netflix
where country = 'India'
group by 1
order by 2 desc
limit 5
;

--11.list all movies that are documentaries

select * from netflix
where 
type = 'Movie'
and 
listed_in like '%Documentaries%';

--12.find all content without a director
select * from netflix 
where
director is null;

--13.find how many movies actor 'SalmanK Khan appeared in the last 10 years

select *
from netflix
where
type = 'Movie' and
casts ilike '%Salman Khan%'
and 
year_of_release = extract(year from current_date) - 10;

--find the top 10 actors who have appeared in the highest number of movies produces in india

select 
count(*) as total_shows,
unnest(string_to_array(casts,',')) as all_casts
from Netflix
where 
country ilike '%India%'
and 
type = 'Movie' 
group by 2
order by 1 desc
limit 10;

--15. categorize the content based o the presence of the keywords 'kill' and 'violence' int he decription field. label content containing these keywords as 'bad' and all other content as 'good'. count how many itms fall into each category.
with new_table
as
(
select *,
case
when
description ilike '%kill%'
or
description ilike '%violence%'
then 'bad_film'
else'good_film'
end category
from netflix
)
select
category,
count(*)as total_cotent
from new_table
group by 1;



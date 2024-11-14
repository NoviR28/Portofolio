-- Make a new table to keep the original data

CREATE TABLE sales LIKE datasales;
INSERT sales SELECT * FROM datasales;
SELECT * FROM sales limit 5;
DESCRIBE sales;

select count(*) from sales;

START TRANSACTION;
ROLLBACK;
-- Drop Any Column

ALTER TABLE sales 
    DROP COLUMN `Ship Date`,
    DROP COLUMN `Customer Name`,
    DROP COLUMN `Postal Code`,
    DROP COLUMN `Customer ID`,
    DROP COLUMN `Product ID`,
    DROP COLUMN `Country`,
    DROP COLUMN `Region`;
select * from sales limit 5;

-- Check and Indentify Duplicate using window function

-- identify the duplicate
select COUNT(*) as total_rows from sales; -- Number of rows before

select *, row_number() over(partition by `Order ID`) as rn from sales limit 5;

-- delete the duplicate
delete from sales where `Row ID` in
(select `Row ID` from 
(select *, row_number() over(partition by `Order ID`) 
as rn from sales limit 5) x where x.rn >1);

select COUNT(*) as total_rows from sales; -- Number of rows after

select * from sales limit 5;
    

-- Standarized the Data

# Update Order Date from text to date
update sales set `Order Date`= STR_TO_DATE(`Order Date`,"%m/%d/%Y");
alter table sales modify column `Order Date` Date;

select * from sales;

-- Identify Missing Values or Null - There is no missing or null values.

-- Exploratory Data Analysis (EDA)--

-- Create new table 2016-2018 
select Max(`Order Date`) as latest, Min(`Order Date`) as newest from sales;

create table sales2 like sales;
insert sales2 select * from sales;
delete from sales2 where `Order Date` < '2016-01-01' or `Order Date` > '2018-12-31';

select Max(`Order Date`) as latest, Min(`Order Date`) as newest from sales2;


-- How much total sales and avg sales each year?

select YEAR(`Order Date`) as `year`,
	sum(Sales) as `total sales`,
    sum(Sales)/12 as `average sales per month`
    from sales2 group by YEAR(`Order Date`) 
    order by YEAR(`Order Date`);
    
-- Which month has the most sales
select month(`Order Date`) as `month`,
	sum(Sales)/3 as `monthly sales`
    from sales2 group by month(`Order Date`) 
    order by sum(Sales)/3 desc;

-- What is the most frequently used shipping modes,  
select `Ship Mode`, count(*) as total
	from sales2 group by `Ship Mode`order by total desc;
    
-- where is the most visited cities?
select `City`, sum(Sales) as `total_sales`
	from sales2 group by `City` order by `total_sales` desc limit 3;
    

-- What is the most frequently shipped product categories?
select `Category`, count(*) as total
	from sales2 group by `Category` order by total desc;

-- Sales based on customer segementation
select `Segment`, sum(Sales) as `total sales`
	from sales2 group by `Segment`order by `total sales` desc;

-- Sales based on State
select `State`, count(*) as total
	from sales2 group by `State` order by total desc;


-- Sales based on the category and sub-category

with cte(Category, `year`, `Total sales`) as 
 (select Category, YEAR(`Order Date`), sum(`Sales`)
 from sales2 group by Category, YEAR(`Order Date`)),
category_by_rank as 
 (select *, dense_rank() over(partition by `Year`
    order by `Total Sales` desc) as ranking from cte
    where `Year` is not null)
    
select * from category_by_rank where ranking <=3;


select COUNT(*) as total_rows from sales2; -- Number of rows after
select sum(Sales) from sales2;

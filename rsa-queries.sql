create table retail_sales
 (transactions_id int primary key,
  sale_date date,
  Sale_time time,
  customer_id int,
  gender varchar(7),
  age int,
  cattegory varchar(15),
  quuantity int,
  price_per_unit float,
  cogs float,
  totsl_sale float);

  select * from retail_sales;

  select count(*) from retail_sales;

--data cleaning

  select * from retail_sales
  where transactions_id is null
  or sale_date is null
  or Sale_time is null
  or customer_id is null
  or gender is null
  or age is null
  or cattegory is null
  or quuantity is null
  or price_per_unit is null
  or cogs is null
  or totsl_sale is null;

  delete from retail_sales
  where transactions_id is null
  or sale_date is null
  or Sale_time is null
  or customer_id is null
  or gender is null
  or age is null
  or cattegory is null
  or quuantity is null
  or price_per_unit is null
  or cogs is null
  or totsl_sale is null;

  --Data Exploration

  --Determine the total number of records in the dataset.
SELECT COUNT(*) FROM retail_sales;

 --Find out how many unique customers are in the dataset.
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

 --Identify all unique product categories in the dataset.
SELECT DISTINCT cattegory FROM retail_sales;

 --Data Analysis & Findings

 --1. retrieve all columns for sales made on '2022-11-05':
select * from retail_sales where sale_date = '2022-11-05';

 --2. retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail_sales 
where
     cattegory = 'Clothing'
	 and 
	 to_char(sale_date, 'yyyy-mm') = '2022-11'
     and 
	 quuantity >=4;
	 
--3. calculate the total sales (total_sale) for each category.:
select
     cattegory,
	 sum(totsl_sale) as net_sales,
	 count(*) as total_orders
from retail_sales
group by 1;
   
--4. find the average age of customers who purchased items from the 'Beauty' category.:
select
     round(avg(age), 2) as avg_age
from retail_sales
where cattegory = 'Beauty';

--5. find all transactions where the total_sale is greater than 1000.:
select * from retail_sales 
where totsl_sale > 1000;

--6. find the total number of transactions (transaction_id) made by each gender in each category.:
select
     cattegory,
	 gender,
	 count(*) as total_trans
from retail_sales
group by
      cattegory,
	  gender
order by 1;

--7. calculate the average sale for each month. Find out best selling month in each year:
select 
      year,
	  month,
	  avg_sale
from 
(
select 
    extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(totsl_sale) as avg_sale,
	rank() over(partition by extract(year from sale_date)order by avg(totsl_sale) desc)
from retail_sales
group by 1, 2
) as t1
where rank = 1;

--8. find the top 5 customers based on the highest total sales.:
select
     customer_id,
	 sum(totsl_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

--9. find the number of unique customers who purchased items from each category.:
SELECT 
    cattegory,    
    count ( distinct customer_id) as unique_customer
FROM retail_sales
group by cattegory;

--10. create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
with hourly_sales
as
(
select *,
   case
       when extract (hour from sale_time) < 12 then 'morning'
	   when extract (hour from sale_time) between 12 and 17 then 'afternoon'
	   else 'evening'
   end as shift
from retail_sales
)
select 
     shift,
	 count(*) as total_orders
from hourly_sales
group by shift;

--end of project

select * from retail_sales;




  
  

  
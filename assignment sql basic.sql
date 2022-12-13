

--DATA PREPARATION AND UNDERSTANDING
--Answer 1
 select (select count(*) as customer from  [dbo].[Customer]) as customer_table, 
 (select count(*) as product from [dbo].[prod_cat_info]) as product_table ,
 (select count(*) as transactions from [dbo].[Transactions]) as trans_table;

 --Answer 2
 select count([total_amt]) from [dbo].[Transactions]
 where [total_amt] <0;


 --Answer 3

 alter table customer
 alter column DOB date;

 --answer 4
 
SELECT  DATEDIFF(YEAR, MIN(TRAN_DATE), MAX(tran_date)) AS YEARS,
DATEDIFF(MONTH, MIN(TRAN_DATE), MAX(tran_date)) AS MONTHS,
DATEDIFF(WEEK, MIN(TRAN_DATE), MAX(tran_date)) AS WEEKS, 
DATEDIFF(DAY, MIN(TRAN_DATE), MAX(tran_date)) AS [DAYS] 
FROM TRANSACTIONS;


 --Answer 5
 select top 1 p.[prod_cat_code],p.[prod_cat],c.[prod_sub_cat_code],c.[prod_subcat] from [dbo].[prod_cat_info] as p
 inner join [dbo].[prod_cat_info] as c
 on p.[prod_cat_code]=c.[prod_sub_cat_code]
 where c.[prod_subcat]='diy'
 
  





 --DATA ANALYSIS
 --Answer1 
select top 1 (store_type), count(store_type) as MOST_FREQUENT from Transactions
group by Store_type
order by MOST_FREQUENT desc; 

--Answer2
select --top 2(gender) ,
case when gender='M' then 'male'
when gender ='F' then 'female' end as gender  ,
 count( gender) as number from [dbo].[Customer]
group by Gender 
order by number desc;
 --this one you have to remove case etc coz that is so additional and unnecessary


--answer 3
select top 1 (city_code ) ,count(customer_id) as people from [dbo].[Customer]
group by city_code
order by people desc;

--Answer 4
select  count([prod_sub_cat_code]) as books_sub_count from [dbo].[prod_cat_info] 
where prod_cat= 'BOOKS' 


--Answer 5

select top 1 ( t.prod_cat_code), p.prod_cat ,count(qty) as qty_ordered from  Transactions as t
inner join prod_cat_info as p
on p.prod_cat_code=t.prod_cat_code
group by  t.prod_cat_code , p.prod_cat
order by qty_ordered desc ;





--Answer 6
select concat('Rs. ',format(sum([total_amt]),'0.##')) as Total_revenue from [dbo].[Transactions] as t
inner join [dbo].[prod_cat_info] as p
on p.[prod_cat_code]=t.[prod_cat_code] and t.prod_subcat_code=p.prod_sub_cat_code
where p.[prod_cat] IN ('BOOKS' , 'ELECTRONICS')



--Answer 7
select count(t )  as customers
from (select [cust_id], count([cust_id]) as t from [dbo].[Transactions]
where [total_amt]>0
group by [cust_id]
having count([cust_id])>10) as p;


--Answer 8
select  concat('Rs.' ,format(sum([total_amt]),'0.##')) as total_revenue from [dbo].[Transactions] as t
inner join [dbo].[prod_cat_info] as p
on p.[prod_cat_code]=t.[prod_cat_code] and p.prod_sub_cat_code = t.prod_subcat_code
where p.[prod_cat] in('electronics' , 'clothing')
and t.[Store_type]='flagship store' 


--Answer 9
--
select concat('Rs. ',format(sum([total_amt]),'0.##')) as total  from [dbo].[Transactions] t 
inner join [dbo].[Customer] c
on c.[customer_Id]= t.[cust_id] 
inner join [dbo].[prod_cat_info] p
on t.[prod_subcat_code]=p.[prod_sub_cat_code] and p.prod_cat_code=t.prod_cat_code
where [Gender]='M' and p.[prod_cat]='Electronics';



--Answer 10

select top 5 prod_subcat ,(sum (total_amt)/(select sum(total_amt) from Transactions))*100 as sales_percentage ,
(count(case when qty<0 then qty else null end)/ sum(qty) )* 100 as sales_percentage_returned
from Transactions t
inner join prod_cat_info p
on p.prod_sub_cat_code=t.prod_subcat_code and p.prod_cat_code=t.prod_cat_code
group by prod_subcat
order by sales_percentage desc;

  

--Answer 11


with age as(
select customer_id,  datediff(year,dob,getdate()) as years
from Customer --order by years
), 
dayss as ( select cust_id, DATEDIFF(day, tran_date,(select max(tran_date) from transactions))  as d 
from transactions t
--order by d
 )
 select customer_id , sum(total_amt )  as total from 
 Transactions t
 inner join age
 on t.cust_id= age.customer_Id
 inner join dayss
 on age.customer_Id=dayss.cust_id
 where years between 25 and 35
 and d>=30 
 group by customer_Id
 order by total ;


--Answer 12

with category as (select   prod_cat, t.prod_cat_code, max(qty) as q, 
DATEDIFF(MONTH, tran_date,(select max(tran_date) 
from transactions)) as months 
from Transactions t
inner join [dbo].[prod_cat_info] p
on p.[prod_cat_code]=t.[prod_cat_code]
group by t.prod_cat_code, prod_cat, tran_date )
select top 1 prod_cat , max(q)  as max_returns
from category 
where months >=3
group by prod_cat
order by max_returns desc;



--Answer 13

select top 1 store_type, count([Store_type]) as max_products, sum([total_amt]) as amt , sum([Qty]) as qtyy
from Transactions
group by Store_type
order by max_products desc, qtyy desc

--Answer 14

select prod_cat, avg(total_amt) as avg_revenue
from prod_cat_info p
inner join Transactions t
on p.prod_cat_code=t.prod_cat_code and p.prod_sub_cat_code=t.prod_subcat_code
group by prod_cat 
having avg(total_amt)  >  (select  avg(total_amt) from Transactions)



--Answer 15

select  prod_cat ,  prod_subcat, format(avg(total_amt),'0.##')  as Average , 
sum(total_amt)as Total 
from Transactions t
inner join prod_cat_info p
on p.prod_cat_code=t.prod_cat_code and  p.prod_sub_cat_code= t.prod_subcat_code
where prod_cat in ( select top 5 prod_cat from Transactions t
inner join prod_cat_info p
on p.prod_cat_code=t.prod_cat_code and  p.prod_sub_cat_code= t.prod_subcat_code
group by prod_cat, qty
order by qty desc)
group by  prod_cat, prod_subcat;
	

	 
 

Create database Pizzahut;

use Pizzahut;

Select * from orders;
select * from Orders_details;
Select * from pizza_types;
select * from pizzas;


/* 1. Retrieve the total number of orders placed. */

select count(order_id)
from orders;

/* 2. Calculate the total revenue generated from pizza sales. */

select round(sum(quantity * price),2) 
from orders_details OD inner join Pizzas P 
on OD.pizza_id = P.pizza_id;

/* 3. Identify the highest-priced pizza. */

select name, price
from pizza_types PT Inner join pizzas P
on PT.pizza_type_id = p.pizza_type_id
order by price desc limit 1;

/* 4.Identify the most common pizza size ordered. */

select size, count(order_details_id) as OrderCount
from pizzas p inner join orders_details OD
on P.Pizza_id = OD.Pizza_id
group by size order by OrderCount desc limit 1;

/* 5. List the top 5 most ordered pizza types along with their quantities */

select name, sum(quantity) SumofQty
from pizzas p inner join orders_details OD
on P.Pizza_id = OD.Pizza_id
Inner Join pizza_types PT
on P.pizza_type_id = PT.pizza_type_id
group by name order by Sumofqty desc limit 5;

/* 6. Find the total quantity of each pizza category ordered. */

select category, sum(quantity) SumofQty
from pizzas p inner join orders_details OD
on P.Pizza_id = OD.Pizza_id
Inner Join pizza_types PT
on P.pizza_type_id = PT.pizza_type_id
group by category;

/* 7. Determine the distribution of orders by hour of the day. */

Select Hour(order_time) as Hour, count(order_id) as count
from orders
group by Hour order by Hour;

/* 8. Find the category-wise distribution of pizzas. */

Select category, count(name)
from pizza_types
group by category;

/* 9. Group the orders by date and calculate the average number of pizzas ordered per day */

select round(avg(SumofQty),0) AvgPizzaOrderedPerDay
from
(Select Order_date, sum(quantity) SumofQty
from orders O inner join orders_details OD
on O.order_id = OD.Order_id
Group by order_date) as Temptable;

/* 10. Determine the top 3 most ordered pizza types based on revenue. */

Select name, sum(Quantity * Price) as Revenue
From pizza_types PT Inner join Pizzas P
on PT.pizza_type_id = p.Pizza_type_id
Inner Join Orders_details OD
on OD.pizza_id = P.pizza_id
Group by Name order by revenue desc limit 3;

/* 11. Calculate the percentage contribution of each pizza type to total revenue.*/

Select Category, (sum(Quantity * Price) / (select round(sum(quantity * price),2) 
from orders_details OD inner join Pizzas P 
on OD.pizza_id = P.pizza_id))*100 as Revenue
From pizza_types PT Inner join Pizzas P
on PT.pizza_type_id = p.Pizza_type_id
Inner Join Orders_details OD
on OD.pizza_id = P.pizza_id
Group by Category;

/* Q12 Analyze the cumulative revenue generated over time */

Select order_date, 
sum(Revenue) over(order by order_date) as CumulativeRevenue
from 
(Select order_date, sum(quantity * price) as Revenue
from Orders_details OD inner join Pizzas P
on OD.pizza_id = p.pizza_id
Inner join Orders O
on O.order_id = OD.Order_id
Group by order_date) as TempTable;

/* Q 13 Determine the top 3 most ordered pizza types based on revenue for each pizza category. */

select * from
(Select category, name, revenue,
rank() over(partition by category order by revenue) as RankNo
from
(Select Category, name, sum(Quantity * Price) as Revenue
from pizzas p inner join orders_details OD
on P.Pizza_id = OD.Pizza_id
Inner Join pizza_types PT
on P.pizza_type_id = PT.pizza_type_id
Group by category, name) as TempTable) as Temptable2
where RankNo <= 3;
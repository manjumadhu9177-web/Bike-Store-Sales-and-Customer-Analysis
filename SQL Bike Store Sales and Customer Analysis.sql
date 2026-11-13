create database bike_stores;
 use bike_stores;
create table brands(
brand_id int primary key,
brand_name varchar(100)
);
create table categories(
category_id int primary key,
category_name varchar(100)
);
create table customers(
customer_id int primary key,
first_name varchar(100),
last_name varchar(100),
phone varchar(100),
email varchar(50),
street varchar(100),
city varchar(100),
state varchar(50),
zip_code varchar(50)
);
create table order_items(
order_id int,
item_id int,
product_id int,
quantity int,
list_price decimal(10,2),
discount decimal(4,2),
total_price decimal(10,2),
product_name varchar(100),
primary key (order_id,item_id),
foreign key (order_id) references new(order_id)on delete cascade,
foreign key (product_id) references products(product_id)
);
 create table new(
 order_id int primary key,
 customer_id int,
 order_status varchar(50),
 order_date date,
 required_date date,
 shipped_date date,
 store_id int,
 staff_id int,
 foreign key (customer_id) references customers(customer_id),
 foreign key(store_id) references stores(store_id),
 foreign key(staff_id) references staffs(staff_id)
 ); 
 create table products(
 product_id int primary key,
 product_name varchar(100),
 brand_id int,
 category_id int,
 model_year int,
 list_price decimal(10,2),
 foreign key(brand_id) references brands(brand_id),
 foreign key(category_id) references categories(category_id)
 );
 create table staffs(
 staff_id int primary key,
 first_name varchar(100),
 last_name varchar(100),
 email varchar(100),
 phone varchar(50),
 active int,
 store_id int,
 manager_id int,
 foreign key(store_id) references stores(store_id),
 foreign key (manager_id) references staffs( staff_id)
 );
 create table stocks(
 store_id int,
 product_id int,
 quantity int,
 primary key (store_id,product_id),
 foreign key (store_id)references stores(store_id),
 foreign key(product_id) references products(product_id)
 );
 create table stores(
 store_id int primary key,
 store_name varchar(100),
 phone varchar(50),
 email varchar(100),
 street varchar(100),
 city varchar(100),
 state varchar(20),
 zip_code varchar(10)
 );
 drop database bike_stores;
 select*from staffs;
 ## INNER JOIN##
 
 select
 o.order_id,p.product_name,oi.quantity,oi.total_price
 from new o
 inner join order_items oi on o.order_id=oi.order_id
 inner join products p on oi.product_id=p.product_id;
 
 ##TOTAL SALES BY STORE##
 
 select
 o.store_id,sum(oi.total_price) as total_sales
 from new o
 inner join order_items oi on o.order_id=oi.order_id
 group by o.store_id;
 
 ##TOP 5 SELLING PRODUCTS##
 
 select
 p.product_name,
 sum(oi.quantity)as total_sold
 from order_items oi
 inner join products p on oi.product_id=p.product_id
 group by p.product_name
 order by total_sold desc
 limit 5;
 
 ##CUSTOMER PURCHASE SUMMARY##
 
 select
 c.customer_id,
 c.first_name,
 c.last_name,
 count(distinct o.order_id) as total_orders_placed,
 sum(oi.quantity) as total_items_purchased,
 sum(oi.total_price) as total_revenue
 from customers c
 inner join new o on c.customer_id=o.customer_id
 inner join order_items oi on o.order_id=oi.order_id
 group by c.customer_id,c.first_name,c.last_name
 order by total_revenue desc;

 show columns from new;
 
 ##SEGMENT CUSTOMER BY TOTAL SPEND##
 
 
 select
 c.customer_id,
 c.first_name,
 c.last_name,
sum(oi.total_price) as total_revenue,
 case
 when sum(oi.total_price)>5000 then'high'
 when sum(oi.total_price)>2000 then 'medium'
 else'low'
 end as segment
 from customers c
 inner join new o on c.customer_id=o.customer_id
 inner join order_items oi on o.order_id=oi.order_id
 group by c.customer_id,c.first_name,c.last_name
 order by total_revenue desc;   
 
 ##STAFF PERFORMANCE ANALYSIS##
 
 select
 s.staff_id,
 s.first_name,
 s.last_name,
 st.store_name,
 sum(oi.total_price) as revenue_generated,
 count(distinct o.order_id) as orders_handled
 from staffs s
 inner join new o on s.staff_id=o.staff_id
 inner join order_items oi on o.order_id=oi.order_id
 inner join stores st on o.store_id=st.store_id
 group by s.staff_id,s.first_name,s.last_name,st.store_name
 order by revenue_generated desc;
 
 ##STOCK ALERT QUERY##
 
  select
  st.store_name,p.product_name,sk.quantity
  from stocks sk
  inner join stores st on sk.store_id=st.store_id
  inner join products p on sk.product_id=p.product_id
  where sk.quantity <10
  order by sk.quantity asc;
  
  ##SEGMENTATION TABLE##

create table customer_segment(
customer_id int primary key, 
first_name varchar(50),
last_name varchar(50),
total_revenue decimal(10,2),
segment varchar(20)
);
use bike_stores;
select count(*)from new;
select count(distinct order_id)from new;
select order_id,order_date
from new
where order_id in(18,19,20,21);
select*from customer_segments limit 5;
select segment,count(*) as
total_customers
from customer_segments
group by segment;
--Simple

insert into "Art_gallery"."Login" VALUES('L26','abcd1234');
insert into "Art_gallery"."User" Values('L26','Abhay','Viradiya','1234567890','abc@gamil.com','28, gondal');
insert into "Art_gallery"."Post" Values('P60','L26','ML','course','study','5','1000');
select *
from "Art_gallery"."Post"
where post_id = 'P60'

select post_id, quantity, price
from "Art_gallery"."Order_details"
where order_id = 'O22'

select *
from "Art_gallery"."Like"
where user_id = 'L7'
order by like_date DESC

select sum(quantity*price)
from "Art_gallery"."Order_details"
where post_id = 'P1'

select *
from "Art_gallery"."QnA"
where post_id = 'P10'

select user_id, count(*) as no_of_order
from "Art_gallery"."Order"
group by user_id
order by no_of_order desc limit 5

select post_id,count(*) as no_of_like
from "Art_gallery"."Like"
group by post_id
order by no_of_like desc limit 5

select post_id
from "Art_gallery"."Favourite_post"
where user_id='L9'

select *
from "Art_gallery"."Post"
where art_category='dancing'

select post_id,avg(rate)
from "Art_gallery"."Rate"
group by(post_id)
order by(avg(rate)) desc

select *
from "Art_gallery"."Bidding"
where post_id = 'P55'

--Complex
select "Order".order_id, post_id, quantity, price
from "Art_gallery"."Order"
join "Art_gallery"."Order_details" on "Order_details".order_id = "Order".order_id
where user_id = 'L6'

select "Order".order_id, status, status_date
from "Art_gallery"."Order"
join "Art_gallery"."Track" on "Order".order_id = "Track".order_id
where user_id = 'L6'


select art_category, count(*) as like_count
from "Art_gallery"."Like" 
join "Art_gallery"."Post" on "Like".user_id='L9' and "Like".post_id = "Post".post_id
group by "Post".art_category 
order by like_count desc

select post_id, count(*) as no_of_returns
from "Art_gallery"."Refund"
join "Art_gallery"."Order_details" on "Order_details".order_id = "Refund".order_id
group by post_id
order by no_of_returns desc

select post_id, art_category, tag, quantity, price
from "Art_gallery"."Post"
where user_id in (select friend_id 
				 from "Art_gallery"."Friends"
				 where user_id = 'L12')
				 

CREATE VIEW like_info AS select post_id, count(*) as total_likes
						from "Art_gallery"."Like"
						group by(post_id);
select "Post".post_id,user_id,art_category,total_likes
from "Art_gallery"."Post", like_info
where "Post".post_id = "like_info".post_id
order by(total_likes) desc

select "Post".post_id,user_id,art_category,total_likes
from "Art_gallery"."Post", like_info
where "Post".post_id = "like_info".post_id
order by(total_likes) desc


select *
from "Art_gallery"."Cart_details"
where cart_id in (select cart_id
				from "Art_gallery"."Cart"
				where user_id = 'L16')




----------------------
create trigger beforeInsertTrigger
before INSERT
on "Art_gallery"."Login"
for each row
execute procedure "Art_gallery".beforeUserInsert();

create or replace function "Art_gallery".beforeUserInsert()
returns TRIGGER
language 'plpgsql'
as $body$
BEGIN
if new.login_id not in (select login_id from "Art_gallery"."Login")
then raise notice 'Congratulation! User added succesfully'; return new;
else raise notice 'User already exist in the database'; return old;
end if;
end;
$body$

---------------
create trigger afterInsertOrder
after insert
on "Art_gallery"."Order"
for each row
execute procedure "Art_gallery".afterOrder();

create or replace function "Art_gallery".afterOrder()
returns trigger
language 'plpgsql'
as $body$
BEGIN
UPDATE "Art_gallery"."Cart" 
set status = 'placed'
where cart_id = new.cart_id;
return new;
end;
$body$;

insert into "Art_gallery"."Order" values('O23','L9','C2','1000');

select *
from "Art_gallery"."Cart"

--------------

create or replace function "Art_gallery".total_income(u_id character varying)
returns decimal
LANGUAGE 'plpgsql'
AS $BODY$


begin

return (select sum(quantity*price)
from "Art_gallery"."Order_details"
where post_id in (select post_id
					from "Art_gallery"."Post"
					where user_id = u_id));


END;
$BODY$;

select "Art_gallery".total_income('L6') as totalIncome
---------












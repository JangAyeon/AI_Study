#매출액(일별)
select a.orderDate, 
sum(b.priceEach*b.quantityOrdered)
from orders a
left join orderdetails b
on a.orderNumber=b.orderNumber
group by 1;

#매출액(월별)
#substr 이용 (1부터 indexing) 
#(가져올 데이터, 시작부분, 시작으로부터 얼마나 떨어진 것까지 가져올지)
select substr(a.orderDate,1,7) as yyyy_mm,
sum(b.priceEach*b.quantityOrdered) as sales
from orders a
left join orderdetails b
on a.orderNumber=b.orderNumber
group by 1;

#매출액(년도별)
#substr 이용 (1부터 indexing) 
#(가져올 데이터, 시작부분, 시작으로부터 얼마나 떨어진 것까지 가져올지)
select substr(a.orderDate,1,4) as yyyy,
sum(b.priceEach*b.quantityOrdered) as sales
from orders a
left join orderdetails b
on a.orderNumber=b.orderNumber
group by 1;

#다수 물건을 구매할 고객이 있는지 개수 먼저 확인
select count(customernumber) as c_orders,
count(distinct customernumber) as d_c_orders
from orders; #(데이터의 중복 있음!!)

#일자별 구매자 수
select orderDate, count(distinct customernumber)
from orders
group by 1;

#월별 구매자 수
select substr(orderDate,1,4),
count(distinct customernumber)
from orders
group by 1;

#중복된 구매 건수 있는지 확인
select count(orderNumber) as c_purchase,
count(distinct orderNumber) d_c_purchase
from orders; #(중복 없음!!)

#년도별 구매 건수
select substr(orderdate,1,4),
count(distinct customerNumber) as d_c_orders
from orders
group by 1;

#월별 구매 건수
select substr(orderdate,1,7),
count(distinct customerNumber) as d_c_orders
from orders
group by 1;
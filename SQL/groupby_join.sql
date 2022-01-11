#customers 테이블을 이용해 country, city별 customerNumber 수 구하기
select country,count(customerNumber)
from customers;

select country,city,count(customerNumber)
from customers
group by 1,2;

#customers 테이블과 orders 테이블을 이용해 orderNumber와 country 출력
select b.orderNumber,a.country 
from customers a
left join orders b
on a.customerNumber = b.customerNumber;

#usa에 거주라는 고객이 주문한 ordernumber와 country
select b.orderNumber,a.country 
from customers a
left join orders b
on a.customerNumber = b.customerNumber
where a.country="USA";

#products 테이블에서 buyprice 칼럼으로 순위 매기기
#(오름차순 정렬, row_number,rank,dense_rank 모두 사용)
select buyprice, row_number() over (order by buyprice) as rownumber,
rank() over (order by buyprice) as rnk,
dense_rank() over (order by buyprice) as dense
from products;


#products 테이블에서 buyprice 칼럼으로 순위 매기기
#(내림차순 정렬, row_number,rank,dense_rank 모두 사용)
select buyprice, row_number() over (order by buyprice desc) as rownumber,
rank() over (order by buyprice desc) as rnk,
dense_rank() over (order by buyprice desc) as dense
from products;




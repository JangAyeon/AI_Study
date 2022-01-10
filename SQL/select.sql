select * from customers;

#Customer 테이블에서 customerNumber 조회
select customerNumber 
from customers;

#Payments 테이블에서 amount 총합과 checknumber 갯수 구하기
# as 사용해 별칭 부여 (실제 칼럼명 변경 X)
select sum(amount) as "amount 총합", 
count(checknumber)   "checknumber 갯수"
from Payments;

#Products 테이블에서 productName, productLine 조회
select productName, productLine
from Products;

#Products 테이블에서 productCode 갯수 구하고 컬럼명을 cnt_cd로 변경alter
select count(productCode) cnt_cd
from Products

#Orderdetails 테이블에서 ordernumber의 중복제거하고 조회
select distinct ordernumber
from Orderdetails;

#
SELECT priceeach 
from Orderdetails
where priceeach between 30 and 50;

#
SELECT priceeach 
from Orderdetails
where priceeach >= 30;

#
select customerNumber,country from customers
where country in("USA" , "CANADA");

#
select customerNumber from customers
where country not in("USA" , "CANADA");

#
select employeenumber from Employees
where reportsTo is null;

# 
select addressLine1 from customers
where addressLine1 like "%ST%";

-- 1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) 
-- değerlerini almak için sorgu yazın.

select product_name, quantity_per_unit from products;

-- 2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.

select product_id, product_name from products where discontinued = 0;

-- 3. Durdurulmayan (`Discontinued`) Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.

select product_id, product_name from products where discontinued != 0;

-- 4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.

select product_id, product_name, unit_price from products where unit_price < 20;

-- 5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.

select product_id, product_name, unit_price from products where unit_price between 15 and 25;

-- 6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.

select product_name, units_on_order, units_in_stock from products where units_in_stock < units_on_order;

-- 7. İsmi `a` ile başlayan ürünleri listeleyeniz.

select product_name from products where product_name like 'a%';

-- 8. İsmi `i` ile biten ürünleri listeleyeniz.

select product_name from products where product_name like 'i%';

-- 9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.

select product_name, unit_price, (unit_price*1.18) as unit_price_kdv from products;

-- 10. Fiyatı 30 dan büyük kaç ürün var?

select Count(*) from products where unit_price > 30;

-- 11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele

select lower(product_name) as lowercase_product_name, unit_price from products order by unit_price desc;

-- 12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır

select concat(first_name, ' ', last_name) as fullname from employees;

-- 13. Region alanı NULL olan kaç tedarikçim var?

select count(*) from Suppliers where region is null;

-- 14. a.Null olmayanlar?

select count(*) from Suppliers where region is not null;

-- 15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.

select concat('TR ', upper(product_name)) as modified_product_name from products;

-- 16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle.

select concat('TR ', product_name) as modified_product_name from products where unit_price < 20;

-- 17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

select product_name, unit_price from products order by unit_price desc limit 1;

-- 18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

select product_name, unit_price from products order by unit_price desc limit 10;

-- 19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
 
select product_name, unit_price from products where unit_price > (select avg(unit_price) from products);

-- 20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.

select sum(unit_price * quantity) AS total_revenue from order_details 
where product_id in (select product_id from products where units_in_stock > 0);

-- 21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.

select
    sum(case when Discontinued = 0 then 1 else 0 end) as active_products,
    sum(case when Discontinued = 1 then 1 else 0 end) as discontinued_products
from products;

-- 22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.

select p.product_name, p.unit_price, c.category_name from products p 
inner join categories c on p.category_id = c.category_id;

-- 23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.

select c.category_name, avg(p.unit_price) as average_price
from products p
inner join categories c on p.category_id = c.category_id
group by c.category_name;

-- 24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?

select p.product_name, p.unit_price, c.category_name
from products p
inner join categories c on p.category_id = c.category_id
order by p.unit_price desc
limit 1;

-- 25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı.

select 
    p.product_name,
	c.category_name,
	s.company_name
from 
    products p
inner join 
    categories c on p.category_id = c.category_id
inner join 
    suppliers s on p.supplier_id = s.supplier_id
inner join 
    order_details od on p.product_id = od.product_id
group by 
    p.product_name,
	c.category_name,
	s.company_name
order by 
    sum(od.quantity) desc
limit 1;

-- 26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.

select p.product_id, p.product_name, s.company_name, s.phone
from products p
inner join suppliers s on p.supplier_id = s.supplier_id
where p.units_in_stock = 0;

-- 27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı

select
    o.ship_address AS order_address,
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name
from
    orders o
inner join
    employees e on o.employee_id = e.employee_id
where
    DATE_PART('year', o.order_date) = 1998
    and DATE_PART('month', o.order_date) = 3;
	
-- 28. 1997 yılı şubat ayında kaç siparişim var?

select count(*) from orders 
where extract(year from order_date) = 1997 and extract(month from order_date) = 2;

-- 29. London şehrinden 1998 yılında kaç siparişim var?

select count(*) from orders 
where extract(year from order_date) = 1998 and ship_city = 'London';

-- 30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası

select c.contact_name, c.phone 
from customers c
inner join orders o on c.customer_id = o.customer_id
where DATE_PART('year', o.order_date) = 1997
group by c.contact_name, c.phone; 

-- 31. Taşıma ücreti 40 üzeri olan siparişlerim

select * from orders where freight>40;

-- 32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı

select o.ship_city, c.contact_name 
from orders o
inner join customers c on o.customer_id = c.customer_id
where o.freight>40;

-- 33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),

select to_char(o.order_date, 'YYYY-MM-DD') as order_date, o.ship_city,  concat(upper(e.first_name), ' ', upper(e.last_name)) as employee_name
from orders o
inner join employees e on o.employee_id = e.employee_id
where extract(year from o.order_date) = 1997; 

-- 34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )

select 
    c.contact_name,
    replace(replace(replace(c.phone, '(', ''), ')', ''), ' ', '') as phone_number
from 
    customers c
where 
    exists (
        select 1 
        from orders o 
        where o.customer_id = c.customer_id
        and extract(year from o.order_date) = 1997
    );
	
-- 35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad

select o.order_date as orderdate, c.contact_name as customer_contact_name, e.first_name as employee_first_name, e.last_name as employee_last_name from orders o
inner join customers c on o.customer_id = c.customer_id
inner join employees e on o.employee_id = e.employee_id;

-- 36. Geciken siparişlerim?

select 
    order_date,
    required_date,
    shipped_date,
    case 
        when shipped_date > required_date then 'Gecikmiş'
        else 'Gecikmemiş' 
    end as order_status
from 
    orders
where 
    shipped_date > required_date;
	
-- 37. Geciken siparişlerimin tarihi, müşterisinin adı

select 
    o.order_date,
    c.contact_name,
    case 
        when o.shipped_date > o.required_date then 'Gecikmiş'
        else 'Gecikmemiş' 
    end as order_status
from 
    orders o
inner join
    customers c on o.customer_id = c.customer_id
where 
    shipped_date > required_date;
	
-- 38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
	
select 
    p.product_name,
    c.category_name,
    od.quantity,
	od.order_id
from 
    order_details od
inner join 
    products p on od.product_id = p.product_id
inner join 
    categories c on p.category_id = c.category_id
where 
    od.order_id = 10248;	
	
-- 39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı

select 
    p.product_name,
    s.company_name as supplier_name
from 
    order_details od
inner join 
    products p on od.product_id = p.product_id
inner join 
    suppliers s on p.supplier_id = s.supplier_id
where 
    od.order_id = 10248;
	
-- 40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
	
select 
    p.product_name,
    sum(od.quantity) as total_quantity
from 
    orders o
inner join 
    order_details od on o.order_id = od.order_id
inner join 
    products p on od.product_id = p.product_id
where 
    extract(year from o.order_date) = 1997
    and o.employee_id = 3
group by 
    p.product_name;	
	
-- 41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
	
select 
	o.employee_id,
    concat(e.first_name, ' ', e.last_name) as employee_name,
	count(o.order_id) as total_sales
from 
    orders o
inner join employees e on o.employee_id = e.employee_id		
where extract(year from o.order_date) = 1997
group by o.employee_id, e.first_name, e.last_name
order by total_sales desc
limit 1;

-- 42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****

select 
	o.employee_id,
    concat(e.first_name, ' ', e.last_name) as employee_name,
	count(o.order_id) as total_sales
from 
    orders o
inner join employees e on o.employee_id = e.employee_id		
where extract(year from o.order_date) = 1997
group by o.employee_id, e.first_name, e.last_name
order by total_sales desc
limit 1;

-- 43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?

select
    p.product_name,
    p.unit_price as price,
    c.category_name
from
    products p
inner join
    categories c on p.category_id = c.category_id
order by
    p.unit_price desc
limit 1;

-- 44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre

select
    concat(e.first_name, ' ', e.last_name) as employee_name,
    o.order_date,
    o.order_id
from
    orders o
inner join
    employees e on o.employee_id = e.employee_id
order by
    o.order_date;
	
-- 45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?

SELECT
    AVG(od.unit_price) AS average_price,
    o.order_id
FROM
    order_details od
INNER JOIN
    orders o ON od.order_id = o.order_id
GROUP BY
    o.order_id
ORDER BY
    o.order_date DESC
LIMIT 5;

-- 46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

SELECT
    p.product_name,
    c.category_name,
    SUM(od.quantity) AS total_sales
FROM
    order_details od
INNER JOIN
    products p ON od.product_id = p.product_id
INNER JOIN
    categories c ON p.category_id = c.category_id
INNER JOIN
    orders o ON od.order_id = o.order_id
WHERE
    EXTRACT(MONTH FROM o.order_date) = 1 -- Ocak ayı
GROUP BY
    p.product_name,
    c.category_name;
	
-- 47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?

WITH avg_sales AS (
    SELECT AVG(quantity) AS average_sales
    FROM order_details
)

SELECT
    od.order_id,
    od.quantity
FROM
    order_details od
CROSS JOIN
    avg_sales
WHERE
    od.quantity > (SELECT average_sales FROM avg_sales);
	
-- 48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı

SELECT
    p.product_name,
    c.category_name,
    s.company_name AS supplier_name
FROM
    products p
INNER JOIN
    categories c ON p.category_id = c.category_id
INNER JOIN
    suppliers s ON p.supplier_id = s.supplier_id
INNER JOIN
    (
        SELECT
            product_id,
            SUM(quantity) AS total_quantity
        FROM
            order_details
        GROUP BY
            product_id
        ORDER BY
            total_quantity DESC
        LIMIT 1
    ) AS most_sold_product ON p.product_id = most_sold_product.product_id;
	
-- 49. Kaç ülkeden müşterim var

SELECT COUNT(DISTINCT country) AS num_of_countries
FROM customers;

-- 50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

SELECT
    e.employee_id,
    SUM(od.quantity) AS total_sold
FROM
    employees e
INNER JOIN
    orders o ON e.employee_id = o.employee_id
INNER JOIN
    order_details od ON o.order_id = od.order_id
WHERE
    e.employee_id = 3
    AND o.order_date >= '1998-12-31'
    AND o.order_date <= CURRENT_DATE
GROUP BY
    e.employee_id;
-- ---------------------------------


--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi

SELECT p.product_name, c.category_name, od.quantity FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE od.order_id = 10248;

--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı

SELECT p.product_name, s.company_name FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE od.order_id = 10248;

--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti

SELECT p.product_name, od.quantity FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN employees e ON o.employee_id = e.employee_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997 AND e.employee_id = 3;

--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad

--************* 41 ile aynı soru *********************

--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****

--************* 42 ile aynı soru *********************


--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?

--************* 43 ile aynı soru *********************

--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre

--************* 44 ile aynı soru *********************

--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?

--************* 45 ile aynı soru *********************

--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

--************* 46 ile aynı soru *********************

--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?

--************* 47 ile aynı soru *********************

--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı

--************* 47 ile aynı soru *********************

--62. Kaç ülkeden müşterim var

--************* 48 ile aynı soru *********************

--63. Hangi ülkeden kaç müşterimiz var

SELECT country, COUNT(*) AS customer_count FROM customers GROUP BY country;

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

-- Anlamadım bu soruyu

--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
--internetten baktım
SELECT SUM(total_price) AS total_revenue
FROM (
    SELECT SUM(od.unit_price * od.quantity) AS total_price
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    WHERE od.product_id = 10
    AND o.order_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '3 month')
    AND o.order_date <= CURRENT_DATE
    GROUP BY o.order_id
) AS subquery;


--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?

SELECT e.employee_id, e.first_name, e.last_name, COUNT(*) AS total_orders FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
GROUP BY e.employee_id;

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun

SELECT c.customer_id, c.company_name FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL; 

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri

SELECT company_name, contact_name, address, city, country FROM customers
WHERE country = 'Brazil';

--69. Brezilya’da olmayan müşteriler

SELECT company_name, contact_name, address, city, country FROM customers WHERE NOT country = 'Brazil';

-- ---------------------------------

-- 70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler

SELECT *
FROM customers
WHERE country IN ('Spain', 'France', 'Germany');

-- 71. Faks numarasını bilmediğim müşteriler

SELECT *
FROM customers
WHERE fax IS NULL;

-- 72. Londra’da ya da Paris’de bulunan müşterilerim

SELECT *
FROM customers
WHERE city IN ('London', 'Paris');

-- 73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler

SELECT * FROM customers
WHERE city = 'Mexico D.F' AND contact_title = 'owner';

-- 74. C ile başlayan ürünlerimin isimleri ve fiyatları

SELECT product_name, unit_price
FROM products
WHERE product_name LIKE 'C%';

-- 75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri

SELECT first_name, last_name, birth_date
FROM employees
WHERE first_name LIKE 'A%';

-- 76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları

SELECT company_name FROM customers
WHERE company_name LIKE '%RESTAURANT%';

-- 77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları

SELECT product_name, unit_price
FROM products
WHERE unit_price BETWEEN 50 AND 100;

-- 78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri

SELECT order_id, order_date
FROM orders
WHERE order_date BETWEEN '1996-07-01' AND '1996-12-31';

-- 79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler

SELECT contact_name FROM customers
WHERE country IN ('Spain', 'France', 'Germany');

-- 80. Faks numarasını bilmediğim müşteriler

SELECT * FROM customers
WHERE fax IS NULL OR fax = '';

-- 81. Müşterilerimi ülkeye göre sıralıyorum:

SELECT * FROM customers ORDER BY country;

-- 82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz

SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC;

-- 83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz

SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC, units_in_stock ASC;

-- 84. 1 Numaralı kategoride kaç ürün vardır..?

SELECT COUNT(*) AS number_of_products
FROM products
WHERE category_id = 1;

-- 85. Kaç farklı ülkeye ihracat yapıyorum..?

SELECT COUNT(DISTINCT ship_country) AS number_of_countries
FROM orders;

-- 86. a.Bu ülkeler hangileri..?

SELECT DISTINCT ship_country
FROM orders;

-- 87. En Pahalı 5 ürün

SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 5;

-- 88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?

SELECT COUNT(*) AS order_count
FROM orders
WHERE customer_id = 'ALFKI';

-- 89. Ürünlerimin toplam maliyeti

SELECT SUM(unit_price * units_in_stock) AS total_cost
FROM products;

-- 90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?

SELECT SUM(od.unit_price * od.quantity) AS total_revenue
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id;

-- 91. Ortalama Ürün Fiyatım

SELECT AVG(unit_price) AS average_price
FROM products;

-- 92. En Pahalı Ürünün Adı

SELECT product_name
FROM products
ORDER BY unit_price DESC
LIMIT 1;

-- 93. En az kazandıran sipariş

SELECT order_id, SUM(unit_price * quantity) AS total_revenue
FROM order_details
GROUP BY order_id
ORDER BY total_revenue ASC
LIMIT 1;

-- 94. Müşterilerimin içinde en uzun isimli müşteri

SELECT contact_name
FROM customers
ORDER BY LENGTH(contact_name) DESC
LIMIT 1;

-- 95. Çalışanlarımın Ad, Soyad ve Yaşları

SELECT first_name, last_name, 
    DATE_PART('year', AGE(NOW(), birth_date)) AS age
FROM employees;

-- 96. Hangi üründen toplam kaç adet alınmış..?

SELECT product_id, SUM(quantity) AS total_quantity
FROM order_details
GROUP BY product_id;

-- 97. Hangi siparişte toplam ne kadar kazanmışım..?

SELECT order_id, SUM(unit_price * quantity) AS total_revenue
FROM order_details
GROUP BY order_id;

-- 98. Hangi kategoride toplam kaç adet ürün bulunuyor..?

SELECT category_id, COUNT(*) AS total_products
FROM products
GROUP BY category_id
ORDER BY category_id ASC;

-- 99. 1000 Adetten fazla satılan ürünler?

SELECT product_id, SUM(quantity) AS total_quantity
FROM order_details
GROUP BY product_id
HAVING SUM(quantity) > 1000;

-- 100. Hangi Müşterilerim hiç sipariş vermemiş..?

SELECT c.customer_id, c.contact_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;
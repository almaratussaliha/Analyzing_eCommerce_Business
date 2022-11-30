# show table
select *from customers_dataset cd limit 5;
select *from order_payments_dataset opd limit 5;
select *from order_items_dataset oid limit 5;
select *from order_reviews_dataset ord2 limit 5;
select *from orders_dataset od limit 5;
select *from sellers_dataset sd limit 5;
select *from geolocation_dataset gd limit 5;
select *from product_dataset_new pdn limit 5;

### no. 1 
# add foreign key to each column
-- table order_reviews_dataset 
ALTER TABLE order_reviews_dataset ADD CONSTRAINT fk_order_id FOREIGN KEY (order_id) 
REFERENCES orders_dataset(order_id);


-- table order_payments_dataset 
ALTER TABLE order_payments_dataset ADD CONSTRAINT fk_order_id FOREIGN KEY (order_id)
REFERENCES orders_dataset(order_id);

-- table orders_dataset
ALTER TABLE orders_dataset ADD CONSTRAINT fk_customer_id
FOREIGN KEY (customer_id) REFERENCES customers_dataset(customer_id);

-- table order_items_dataset 
ALTER TABLE order_items_dataset ADD CONSTRAINT fk_seller_id
FOREIGN KEY (seller_id) REFERENCES sellers_dataset(seller_id);

ALTER TABLE order_items_dataset ADD CONSTRAINT fk_seller_id
FOREIGN KEY (seller_id) REFERENCES sellers_dataset(seller_id);

ALTER TABLE order_items_dataset ADD CONSTRAINT fk_product_id
FOREIGN KEY (product_id) REFERENCES product_dataset(product_id);

ALTER TABLE order_items_dataset ADD CONSTRAINT fk_order_id
FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id);

# primary key for geolocation_dataset
-- delete rows if geo_zip+code>1
DELETE FROM geolocation_dataset 
WHERE geolocation_zip_code_prefix IN (
		SELECT geolocation_zip_code_prefix FROM (
			SELECT geolocation_zip_code_prefix, COUNT(*) FROM geolocation_dataset
			GROUP BY 1 
			HAVING COUNT(*)>1 
			ORDER BY 2 DESC
		) AS geo_del
	)
SELECT geolocation_zip_code_prefix, COUNT(geolocation_zip_code_prefix)
FROM geolocation_dataset
GROUP BY 1

--- primary key geolocation_dataset
ALTER TABLE geolocation_dataset ADD CONSTRAINT geolocation_dataset_pkey
PRIMARY KEY (geolocation_zip_code_prefix)


-- table sellers_dataset
ALTER TABLE sellers_dataset ADD CONSTRAINT fk_seller_zip_code_prefix
FOREIGN KEY (seller_zip_code_prefix) REFERENCES geolocation_dataset(geolocation_zip_code_prefix)

-- table customer_dataset
SELECT *FROM customers_dataset LIMIT 2
ALTER TABLE customers_dataset ADD CONSTRAINT fk_customers_zip_code_prefix
FOREIGN KEY (customer_zip_code_prefix) REFERENCES geolocation_dataset(geolocation_zip_code_prefix)


### no.2 Annual Customer Activity Growth Analysis 
-- 1. Jumlah customer active perbulan dalam setahun 
SELECT x.tahun, ROUND(AVG(total_customer), 0) rata_customer_aktif
FROM (
SELECT date_part('year', ods.order_purchase_timestamp) tahun, 
	 	date_part('month', ods.order_purchase_timestamp) bulan, 
		COUNT( DISTINCT csd.customer_unique_id) total_customer 
FROM orders_dataset ods
JOIN customers_dataset csd ON ods.customer_id = csd.customer_id
GROUP BY 1,2 
ORDER BY 1,2 ) x
GROUP BY 1

-- 2. customer baru
SELECT *FROM customers_dataset LIMIT 3
SELECT *FROM orders_dataset LIMIT 3
SELECT date_part('year', new_order) tahun,
		COUNT(x.customer_unique_id) customer_baru
FROM (
		SELECT csd.customer_unique_id, MIN(ods.order_purchase_timestamp) new_order
		FROM orders_dataset ods JOIN customers_dataset csd 
		ON ods.customer_id = csd.customer_id
		GROUP BY 1
	) x
GROUP BY  1
ORDER BY 1

-- 3. customer yang repeat order setiap tahun
SELECT x.tahun, COUNT(x.jumlah_customer) cust_repeat_order
FROM (
		SELECT date_part('year', ods.order_purchase_timestamp) tahun,
		csd.customer_unique_id,
		COUNT(csd.customer_unique_id) jumlah_customer,
		COUNT(ods.order_id) jumlah_order
		FROM orders_dataset ods JOIN customers_dataset csd 
		ON ods.customer_id = csd.customer_id
		GROUP BY 1,2
		HAVING COUNT(ods.order_id) > 1
	) x
GROUP BY 1
ORDER BY 1

-- 4. rata-rata jumlah order customer tiap tahun
SELECT *FROM customers_dataset LIMIT 3
SELECT *FROM orders_dataset LIMIT 3
SELECT tahun, ROUND(AVG(x.total_order),3) rata_rata_order
FROM (
		SELECT date_part('year', ods.order_purchase_timestamp) tahun,
				csd.customer_unique_id total_customer,
		COUNT(ods.order_id) total_order
		FROM orders_dataset ods JOIN customers_dataset csd
			ON ods.customer_id = csd.customer_id
		GROUP BY 1,2 ) x
GROUP BY 1

-- 5. menggabungkan ketiga metrik ke dalam satu tabel dengan Common Table Expression
WITH rata_rata_active_users AS (
	SELECT x.tahun, ROUND(AVG(total_customer), 0) rata_customer_aktif
	FROM (
			SELECT date_part('year', ods.order_purchase_timestamp) tahun, 
	 				date_part('month', ods.order_purchase_timestamp) bulan, 
			COUNT( DISTINCT csd.customer_unique_id) total_customer 
			FROM orders_dataset ods
			JOIN customers_dataset csd ON ods.customer_id = csd.customer_id
			GROUP BY 1,2 
			ORDER BY 1,2 ) x
			GROUP BY 1
),
total_customer AS (
			SELECT date_part('year', new_order) tahun,
			COUNT(x.customer_unique_id) customer_baru
			FROM (
					SELECT csd.customer_unique_id, MIN(ods.order_purchase_timestamp) new_order
					FROM orders_dataset ods JOIN customers_dataset csd 
					ON ods.customer_id = csd.customer_id
					GROUP BY 1
				) x
			GROUP BY  1
			ORDER BY 1
),
customer_repeat_order AS (
			SELECT x.tahun, COUNT(x.jumlah_customer) cust_repeat_order
			FROM (
					SELECT date_part('year', ods.order_purchase_timestamp) tahun,
					csd.customer_unique_id,
					COUNT(csd.customer_unique_id) jumlah_customer,
					COUNT(ods.order_id) jumlah_order
					FROM orders_dataset ods JOIN customers_dataset csd 
					ON ods.customer_id = csd.customer_id
					GROUP BY 1,2
					HAVING COUNT(ods.order_id) > 1
				) x
			GROUP BY 1
			ORDER BY 1
),
frekuensi_order AS (
			SELECT tahun, ROUND(AVG(x.total_order),3) rata_rata_order
			FROM (
					SELECT date_part('year', ods.order_purchase_timestamp) tahun,
					csd.customer_unique_id total_customer,
					COUNT(ods.order_id) total_order
					FROM orders_dataset ods JOIN customers_dataset csd
					ON ods.customer_id = csd.customer_id
					GROUP BY 1,2 
				) x
			GROUP BY 1
)
SELECT au.tahun, au.rata_customer_aktif, ts.customer_baru, cro.cust_repeat_order, fo.rata_rata_order
FROM rata_rata_active_users au 
JOIN total_customer ts
	ON au.tahun = ts.tahun
JOIN customer_repeat_order cro 
	ON au.tahun = cro.tahun
JOIN frekuensi_order fo 
	ON au.tahun = fo.tahun

### no.3 Annual Product Category Quality Analysis
-- 1. Membuat tabel baru berisi revenue pertahun
CREATE TABLE revenue_per_tahun AS (
			SELECT date_part('year', ods.order_purchase_timestamp) tahun, 
			SUM(oid.price + oid.freight_value) revenue_per_tahun
			FROM orders_dataset ods
			JOIN order_items_dataset oid
				ON ods.order_id = oid.order_id 
			WHERE ods.order_status IN (
					SELECT ods.order_status
					FROM orders_dataset ods
					WHERE ods.order_status = 'delivered'
				)
			GROUP BY 1
) 

-- 2. Membuat tabel berisi informasi jumlah cancel order
SELECT *FROM orders_dataset LIMIT 5
select *from order_items_dataset LIMIT 10
SELECT *FROM order_payments_dataset LIMIT 10

CREATE TABLE canceled_orders AS (
		SELECT date_part('year', ods.order_purchase_timestamp) tahun,
		COUNT(ods.order_id) total_canceled_order
		FROM orders_dataset ods
		LEFT JOIN order_items_dataset oid
			ON ods.order_id = oid.order_id
		WHERE ods.order_status ='canceled' 
		GROUP BY 1
		ORDER BY 1
)

-- 3. kategori produk dengan pendapatan total tertinggi
CREATE TABLE top_kategori_per_tahun AS (
		SELECT x.tahun, x.top_kategori, x.total_revenue FROM (
				SELECT date_part('year', ods.order_purchase_timestamp) tahun,
					pd.product_category_name top_kategori, 
					SUM(oid.price+oid.freight_value) total_revenue,
					RANK() OVER (PARTITION BY date_part('year', ods.order_purchase_timestamp)
					ORDER BY SUM(oid.price+oid.freight_value) DESC) r
				FROM order_items_dataset oid 
				JOIN orders_dataset ods
					ON oid.order_id = ods.order_id
				JOIN product_dataset pd
					ON pd.product_id = oid.product_id
				WHERE ods.order_status = 'delivered' 
				GROUP BY 1,2 ) x
		WHERE r = 1
)

-- 4. top canceled category
CREATE TABLE top_cancel_per_tahun AS (
		SELECT tahun, top_cancel, total_cancel FROM (
				SELECT date_part('year', ods.order_purchase_timestamp) tahun,
					pd.product_category_name top_cancel, 
					COUNT(pd.product_id) total_cancel,
					RANK() OVER (PARTITION BY date_part('year', ods.order_purchase_timestamp)
					ORDER BY COUNT(ods.order_id) DESC) r
				FROM order_items_dataset oid 
				JOIN orders_dataset ods
					ON oid.order_id = ods.order_id
				JOIN product_dataset pd
					ON pd.product_id = oid.product_id
				WHERE ods.order_status = 'canceled' 
				GROUP BY 1,2 ) x
		WHERE r = 1
)

-- 5.  menggabungkan semua tabel baru
SELECT rev.tahun, rev.revenue_per_tahun, co.total_canceled_order,
		topkat.top_kategori, topkat.total_revenue, 
		topcan.top_cancel, topcan.total_cancel
FROM revenue_per_tahun rev 
JOIN canceled_orders co
	ON rev.tahun = co.tahun
JOIN top_kategori_per_tahun topkat
	ON rev.tahun = topkat.tahun
JOIN top_cancel_per_tahun topcan
	ON rev.tahun = topcan.tahun


### no.4 Analysis of Annual Payment Type usage 
-- 1. jumlah pengguna masing-masing type bayar
SELECT opd.payment_type, COUNT(ods.order_id) jumlah_pengguna
FROM order_payments_dataset opd 
JOIN orders_dataset ods
	ON opd.order_id = ods.order_id
GROUP BY 1
ORDER BY 2 DESC

-- 2. jumlah pengguna masing-masing tipe pembayaran
WITH py AS (
	SELECT date_part('year', ods.order_purchase_timestamp) tahun,
	 		opd.payment_type, COUNT(ods.order_id) jumlah_pengguna
	FROM order_payments_dataset opd 
	JOIN orders_dataset ods 
		ON opd.order_id = ods.order_id
	GROUP BY 1,2
)
SELECT payment_type, 
			SUM(CASE WHEN tahun = '2016' THEN jumlah_pengguna ELSE 0 END) tahun_2016,
			SUM(CASE WHEN tahun = '2017' THEN jumlah_pengguna ELSE 0 END) tahun_2017,
			SUM(CASE WHEN tahun = '2018' THEN jumlah_pengguna ELSE 0 END) tahun_2018
FROM py
GROUP BY 1
ORDER BY 2					




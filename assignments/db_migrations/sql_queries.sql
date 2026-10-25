-- 1. Δημιουργία βάσης δεδομένων
-- με όνομα 'eshop_db_kostas'
CREATE DATABASE eshop_db_kostas
OWNER postgres
ENCODING 'UTF8'
TEMPLATE template0;

-- 2. Δημιουργία πίνακα users
CREATE TABLE users(
id SERIAL PRIMARY KEY,
username VARCHAR(100) NOT NULL,
email VARCHAR(150) UNIQUE,
password VARCHAR(200) NOT NULL
);

-- 3. Δημιουργία πίνακα product_types
-- Το πεδίο slug είναι πάντοτε lowercase
-- και χρησιμοποιείται για εσωτερικές συγκρίσεις.
-- ΤΟ πεδίο display_name χρησιμοποιείται για 
-- εκτύπωση στη γραφική διεπαφή
CREATE TABLE product_types(
id SERIAL PRIMARY KEY,
slug VARCHAR(30) UNIQUE,
display_name VARCHAR(30)
);

-- 4. Δημιουργία πίνακα products
CREATE TABLE products(
id SERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
description TEXT,
product_type INT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (product_type) REFERENCES product_types(id) ON DELETE CASCADE
);

-- 5. Δημιουργία πίνακα order_info
CREATE TABLE order_info(
id SERIAL PRIMARY KEY,
user_id INT,
order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
total_price DECIMAL(10, 2),
status VARCHAR(30),
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 6. Δημιουργία πίνακα order_items
CREATE TABLE order_items(
id SERIAL PRIMARY KEY,
order_id INT,
product_variant_id INT,
quantity INT,
unit_price DECIMAL(10, 2),
FOREIGN KEY (order_id) REFERENCES order_info(id) ON DELETE CASCADE,
FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE CASCADE
);

-- 7. Δημιουργία πίνακα reviews
CREATE TABLE reviews(
id SERIAL PRIMARY KEY,
user_id INT,
product_variant_id INT,
rating INT CHECK (rating BETWEEN 1 AND 5),
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE CASCADE
);

-- 8. Δημιουργία πίνακα likes
CREATE TABLE likes(
id SERIAL PRIMARY KEY,
user_id INT,
product_variant_id INT,
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE CASCADE
);

-- 9. Δημιουργία πίνακα product_variants
CREATE TABLE product_variants(
id SERIAL PRIMARY KEY,
sku VARCHAR(20) NOT NULL UNIQUE,
product_id INT,
price DECIMAL(10, 2),
FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 10. Προσθήκη πεδίου με όνομα content στον πίνακα reviews
ALTER TABLE reviews
ADD content TEXT;

-- 11. Δημιουργία πίνακα order_status. 
-- Ο πίνακας αυτός αποθηκεύει τις δυνατές τιμές της στήλης status 
-- του πίνακα order_info. Αυτή η υλοποίηση επιτρέπει να γίνεται επιλογή τιμής 
-- από περιορισμένο αριθμό επιλογών, κάτι χρήσιμο για καλύτερη τυποποίηση
-- της παραγγελίας, αλλά και μεταγενέστερη σύνδεση με το αντικειμενοστραφές
-- μοντέλο κώδικα πιθανής μελλοντικής εφαρμογής διαχείρισης inventory.
CREATE TABLE order_status(
id SERIAL PRIMARY KEY,
name TEXT UNIQUE

INSERT INTO order_status(name) VALUES
('Pending'),
('Paid'),
('Shipped'),
('Completed'),
('Cancelled');

-- 12. Αλλαγή τύπου δεδομένων του πεδίου status στον πίνακα order_info
-- σε INT και μετατροπή του σε FOREIGN KEY που παραπέμπει στον νεοδημιουργηθέντα
-- πίνακα order_status. Χρησιμοποιούμε USING status::integer για να γίνει αυτόματα
-- το casting. Δημιουργούμε νέο constraint δίνοντάς του την ονομασία 
-- fk_order_status για ευκολότερη μελλοντική αναφορά σε περίπτωση μετατροπής του
-- ή debugging.
ALTER TABLE order_info
ALTER COLUMN status TYPE INT
USING status::integer;

ALTER TABLE order_info
ADD CONSTRAINT fk_order_status
FOREIGN KEY (status) REFERENCES order_status(id);

-- 13. Προσθήκη πεδίου parent_id στον πίνακα product_types.
-- Δημιουργία νέου constraint με ονομασία fk_product_types 
-- που ορίζει το νεοδημιουργηθέν πεδίο ως foreign key
-- που αναφέρεται στο πεδίο id του ίδιου πίνακα (αυτο-αναφορά).
-- Αυτή η δομή θα μας επιτρέψει την εύκολη δημιουργία
-- ιεραρχημένων κατηγοριών προϊόντων, χωρίς την ανάγκη
-- να δημιουργήσουμε ξεχωριστούς πίνακες για την καθεμία
-- (μοντέλο adjacency-list model).
ALTER TABLE product_types
ADD COLUMN parent_id INT;

ALTER TABLE product_types
ADD CONSTRAINT fk_product_types
FOREIGN KEY (parent_id) REFERENCES product_types(id);

-- 14a. Εισαγωγή mock δεδομένων στους πίνακες
-- για έλεγχο της βάσης δεδομένων. Εισάγουμε προοδευτικά
-- τους γενικότερους τύπους και κατόπιν τους υπο-τύπους
-- έως τους τύπους "φύλλα" (leaf types)
INSERT INTO product_types (slug, display_name, parent_id) VALUES
('electronics', 'Electronics', NULL),
('arts_crafts', 'Arts & Crafts', NULL),
('software', 'Software', NULL),
('toys_games', 'Toys & Games', NULL);

-- 14b. Συνέχεια εισαγωγής δεδομένων
INSERT INTO product_types (slug, display_name, parent_id) VALUES
('computers_accessories', 'Computers & Accessories',
    (
    SELECT id FROM product_types
	WHERE slug = 'electronics'
	)
),
('painting_drawing', 'Painting & Drawing', 
    (
    SELECT id FROM product_types
	WHERE slug = 'arts_crafts'
	)
),
('antivirus_security', 'Antivirus Security', 
    (
    SELECT id FROM product_types
	WHERE slug = 'software'
	)
),
('business_office', 'Business Office', 
    (
    SELECT id FROM product_types
	WHERE slug = 'software'
	)
),
('games_accessories', 'Games & Accessories', 
    (
    SELECT id FROM product_types
	WHERE slug = 'toys_games'
	)
),
('dolls_accessories', 'Dolls & Accessories', 
    (
    SELECT id FROM product_types
	WHERE slug = 'toys_games'
	)
);

-- 14c. Συνέχεια εισαγωγής δεδομένων
INSERT INTO product_types (slug, display_name, parent_id) VALUES
('data_storage', 'Data Storage', 
    (
	SELECT id FROM product_types
	WHERE slug = 'computers_accessories'
	)
),
('art_paper', 'Art Paper',
    (
    SELECT id FROM product_types 
	WHERE slug = 'painting_drawing'
	)
),
('internet_security_suites', 'Internet Security Suites',
    (
    SELECT id FROM product_types
	WHERE slug = 'antivirus_security'
	)
),
('document_management', 'Document Management', 
    (
    SELECT id FROM product_types
	WHERE slug = 'business_office'
	)
),
('floor_games', 'Floor Games', 
    (
    SELECT id FROM product_types
	WHERE slug = 'games_accessories'
	)
),
('dolls', 'Dolls', 
    (
    SELECT id FROM product_types
	WHERE slug = 'dolls_accessories'
	)
);

-- 14d. Συνέχεια εισαγωγής δεδομένων
INSERT INTO product_types (slug, display_name, parent_id) VALUES
('external_hard_drives', 'External Hard Drives', 
    (
    SELECT id FROM product_types
	WHERE slug = 'data_storage'
	)
),
('sketchbooks_notebooks', 'Sketchbooks & Notebooks',
    (
    SELECT id FROM product_types
	WHERE slug = 'art_paper'
	)
);

INSERT INTO product_types (slug, display_name, parent_id) VALUES
('usb_flash_drives', 'USB Flash Drives', 
    (
    SELECT id FROM product_types
	WHERE slug = 'data_storage'
	)
);

-- 15. Εισαγωγή mock δεδομένων στον πίνακα products
INSERT INTO products (name, description, product_type) VALUES
('UnionSine Portable External Hard Drive',
'HDD-USB 3.0 for PC, Mac, Laptop, PS4, Xbox one, Xbox 360',
36),
('Lexar JumpDrive',
'Lexar JumpDrive S80 USB 3.2 Gen 1 Flash Drive, External Storage, Up to 150MB/s Read',
38),
('Fuxi 9" x 12" Sketch Book',
'Top Spiral Bound Sketch Pad, Acid-Free Drawing Paper',
37),
('Norton 360 Ready',
'Antivirus software pre-paid subscription for 10 Devices with Auto-Renewal [Download]',
32),
('Adobe Acrobat Pro',
'PDF Software | Convert, Edit, E-Sign, Protect | Activation Required',
33),
('Giant 4 Row Game',
'Game with Carrying Bag and Mesh Fabric 4-to-Score Game Set Suitable for Family Gatherings',
34),
('Yummiland Large Doll',
'Nia Candy Fluff with Scented Lip Gloss, Ages 4+',
35);

-- 16. Εισαγωγή mock δεδομένων στον πίνακα product_variants
INSERT INTO product_variants (sku, product_id, price) VALUES
('EXT-SIN-1TB-BLK', 1, 55.59),
('EXT-SIN-500-BLK', 1, 30.75),
('EXT-SIN-500-PNK', 1, 29.21),
('JDR-LXR-512-BLK', 2, 64.01),
('JDR-LXR-256-BLK', 2, 43.02),
('SKT-FXI-100-BLK', 3, 8.60),
('SKT-FXI-100-RED', 3, 8.60),
('SKT-FXI-050-BRN', 3, 4.30),
('SKT-FXI-050-YEL', 3, 4.30),
('SEC-N360-PRM-YEAR', 4, 38.71),
('SEC-N360-LFL-YEAR', 4, 94.65),
('SEC-N360-LFL-MONTH', 4, 15.48),
('OFC-ADB-PRO-AUTO', 5, 206.42),
('GME-TGS-ROW-BLR', 6, 88.62),
('GME-TGS-ROW-ORA', 6, 86.04),
('GME-TGS-ROW-DOR', 6, 86.04),
('GME-TGS-ROW-RED', 6, 86.04),
('DOL-YUM-NCD-LRG', 7, 11.64);

-- 17. Εισαγωγή δεδομένων στον πίνακα users
INSERT INTO users (username, email, password, first_name, last_name) VALUES
('chekhov1860', 'chekhov@gmail.com', '123#ghj', 'Anton', 'Chekhov'),
('fyodor1821', 'fyodor@outlook.com', 'jkg#r21', 'Fyodor', 'Dostoyevsky'),
('americano99', 'info@hemingway.com', 'he$fj55', 'Ernest', 'Hemingway'),
('jekyll1850', 'contact@robert.stevenson.com', '35$#jhj', 'Robert', 'Stevenson'),
('rumirose', 'rumi@gmail.com', 'r567#kj', 'Rumi', ''),
('wordsworth1770', 'info@wordsworth.com', 'fgo456#', 'William', 'Wordsworth'),
('robertfrost1874', 'robert@yahoo.com', '45Lma#s', 'Robert', 'Frost'),
('lauralove', 'contact@petrarca.com', '345&ghd', 'Francesco', 'Petrarca');

-- 18. Εισαγωγή δεδομένων στον πίνακα order_info
INSERT INTO order_info (user_id, total_price, status) VALUES
(1, 25.80, 1),
(4, 59.89, 5),
(8, 183.72, 4),
(2, 331.17, 3),
(5, 110.12, 2),
(7, 158.27, 4);

-- 19. Εισαγωγή δεδομένων στον πίνακα order_items
INSERT INTO order_items (order_id, product_variant_id, quantity, unit_price) VALUES
(1, 6, 3, 8.60),
(2, 9, 1, 4.30),
(2, 1, 1, 55.59),
(3, 18, 1, 11.64),
(3, 17, 1, 86.04),
(3, 5, 2, 43.02),
(4, 10, 1, 38.71),
(4, 13, 1, 206.42),
(4, 5, 2, 43.02),
(5, 7, 2, 8.60),
(5, 8, 1, 4.30),
(5, 14, 1, 88.62),
(6, 3, 1, 29.21),
(6, 5, 3, 43.02);

-- 20. Εισαγωγή δεδομένων στον πίνακα reviews
INSERT INTO reviews (user_id, product_variant_id, rating, content) VALUES
(5, 8, 4, 'I am very happy with the product. It was worth the money.'),
(7, 3, 5, 'Excellent quality and speed. Worth its money.'),
(1, 6, 4, 'Very good quality sketchbook. I will definitely prefer it again.'),
(7, 5, 2, 'Not satisfied. Very slow and has a tendency to overheat. Avoid at all costs!'),
(5, 14, 3, 'Not bad, but rather cheap quality. Good for its price.'),
(2, 10, 5, 'Norton is the best in internet security. This subscription is definitely worth it.'),
(4, 1, 3, 'Mediocre construction, bur rather fast. You get what you pay, I guess.');

-- 21. Εισαγωγή δεδομένων στον πίνακα likes
INSERT INTO likes (user_id, product_variant_id) VALUES
(3, 7),
(3, 2),
(4, 18),
(8, 1),
(4, 3),
(7, 15),
(6, 15),
(6, 2),
(7, 10),
(4, 11),
(1, 1),
(2, 5),
(2, 5),
(1, 2),
(7, 7);

-- 22. Εισαγωγή επιπλέον όγκου δεδομένων (νέα ID από 9 έως 10000)
-- στον πίνακα users για καλύτερο έλεγχο απόδοσης
-- μετά από δημιουργία ευρετηρίου
INSERT INTO users (username, email, password, first_name, last_name) 
SELECT  
'user_' || i, 
'user_' || i || '@example.com', 
'pass123',
'Name_' || i,
'Surname_' || i
FROM generate_series(9, 10000) AS i;

-- 23. Εισαγωγή επιπλέον όγκου δεδομένων (νέα ID από 8 έως 10000)
-- στον πίνακα reviews για καλύτερο έλεγχο απόδοσης
-- μετά από δημιουργία ευρετηρίου
INSERT INTO reviews (user_id, product_variant_id, rating, content) 
SELECT 
FLOOR(RANDOM() * 10000 + 1)::INTEGER, 
FLOOR(RANDOM() * 7 + 1)::INTEGER,
FLOOR(RANDOM() * 5 + 1)::INTEGER,
'Generic review content.'
FROM generate_series(8, 10000);

-- 24. Εκτέλεση ενδεικτικού σύνθετου test query για την αξιολόγηση 
-- απόδοσης δημιουργίας ευρετηρίου
SELECT u.username, pv.sku, p.name, r.rating, r.content
FROM users u
JOIN reviews r ON u.id = r.user_id
JOIN product_variants pv ON r.product_variant_id = pv.id
JOIN products p ON pv.product_id = p.id
ORDER BY u.username ASC;

-- 25. Εκτέλεση EXPLAIN ANALYZE σε query με σύνθετο join ΠΡΙΝ τη δημιουργία
-- ευρετηρίου
EXPLAIN ANALYZE
SELECT u.username, pv.sku, p.name, r.rating, r.content
FROM users u
JOIN reviews r ON u.id = r.user_id
JOIN product_variants pv ON r.product_variant_id = pv.id
JOIN products p ON pv.product_id = p.id
ORDER BY u.username ASC;

-- 26. Δημιουργία ευρετηρίου () σε foreign key
-- στους πίνακες reviews (column: user_id) 
-- και product_variants (column: product_id)
CREATE INDEX idx_reviews_user_id
ON reviews(user_id);

CREATE INDEX idx_product_variants_product_id
ON product_variants(product_id);

-- 27. Εκτέλεση EXPLAIN ANALYZE σε query με σύνθετο join ΜΕΤΑ
-- τη δημιουργία ευρετηρίου
EXPLAIN ANALYZE
SELECT u.username, pv.sku, p.name, r.rating, r.content
FROM users u
JOIN reviews r ON u.id = r.user_id
JOIN product_variants pv ON r.product_variant_id = pv.id
JOIN products p ON pv.product_id = p.id
ORDER BY u.username ASC;

-- 28. Εκτέλεση απλών και σύνθετων queries
-- για εξέταση των δεδομένων από διάφορες 
-- οπτικές γωνίες

-- 28a. Επιλογή username χρήστη και αντιστοιχίση με review 
-- και κωδικό/όνομα προϊόντος στο οποίο αντιστοιχεί
-- (ίδιο με screenshot 24)
SELECT u.username, pv.sku, p.name, r.rating, r.content
FROM users u
JOIN reviews r ON u.id = r.user_id
JOIN product_variants pv ON r.product_variant_id = pv.id
JOIN products p ON pv.product_id = p.id
ORDER BY u.username ASC;

-- 28b. Επιλογή όλων των προϊόντων που έχουν παραγγείλλει 
-- χρήστες με εμφάνιση usernames, κωδικού/ονομασίας προϊόντος
-- και ποσότητας τεμαχίων
SELECT u.username, p.name, pv.sku, oitems.quantity
FROM users u
JOIN order_info oinfo ON u.id = oinfo.user_id
JOIN order_items oitems ON oinfo.id = oitems.order_id
JOIN product_variants pv ON oitems.product_variant_id = pv.id
JOIN products p ON pv.product_id = p.id
ORDER BY u.username ASC;

-- 28c. Επιλογή όλων των παραγγελιών με συνολική τιμή
-- πάνω από ορισμένο όριο
SELECT * FROM order_info
WHERE total_price > 100;

-- 28d. Επιλογή του συνολικού αριθμού τεμαχίων που έχει παραγγείλλει
-- ο κάθε χρήστης
SELECT u.first_name, u.last_name, oitems.order_id, SUM(oitems.quantity) AS total_quantity
FROM users u
JOIN order_info oinfo ON u.id = oinfo.user_id
JOIN order_items oitems ON oinfo.id = oitems.order_id
GROUP BY u.id, oitems.order_id
ORDER BY total_quantity DESC;

-- 28e. Επιλογή του συνολικού αριθμού likes του κάθε χρήστη
SELECT u.id, u.first_name, u.last_name, COUNT(l.id) AS total_likes
FROM users u
JOIN likes l ON u.id = l.user_id
GROUP BY u.id
ORDER BY total_likes DESC;

-- 28f. Επιλογή όλων των χρηστών με Google Mail
SELECT * FROM users 
WHERE email LIKE '%gmail.com';

-- 28g. Εμφάνιση του συνολικού αριθμού παραλλαγών (variants)
-- για κάθε προϊόν
SELECT p.name AS product, COUNT(pv.id) AS number_of_variants
FROM products p
JOIN product_variants pv ON p.id = pv.product_id
GROUP BY p.name;

-- 28h. Εμφάνιση συνολικού αριθμού παραγγελιών σε κάθε 
-- κατάσταση εξυπηρέτησης
SELECT ostatus.name AS status, COUNT(oinfo.id) AS number_of_orders
FROM order_status ostatus
JOIN order_info oinfo ON ostatus.id = oinfo.status
GROUP BY ostatus.name;

-- 28i. Εμφάνιση μέσου όρου του συνολικού αριθμού των ratings
SELECT ROUND(AVG(reviews.rating), 2) AS average_review_rating
FROM reviews;

-- 28j. Εμφάνιση μέσου όρου του συνολικού αριθμού των ratings
-- για κάθε χρήστη με id μικρότερο του 9 (συμπεριλαμβάνονται και χρήστες δίχως reviews)
SELECT u.username, ROUND(AVG(r.rating), 2) AS average_review_rating
FROM reviews r
RIGHT JOIN users u ON r.user_id = u.id
WHERE u.id < 9
GROUP BY u.username;

-- 28k. Εμφάνιση συνολικού αριθμού προϊόντων 
-- σε κάθε γενικό τύπο (base type) προϊόντος.
-- Εδώ αξιοποιείται η δομή adjacency list 
-- του πίνακα product_types. Εκτελούμε recursive CTE 
-- (Common Table Expression) για να το πετύχουμε
WITH RECURSIVE category_tree AS (

    SELECT
        id,
        display_name,
        id AS root_id
    FROM product_types
    WHERE parent_id IS NULL

    UNION ALL

    SELECT
        pt.id,
        pt.display_name,
        ct.root_id
    FROM product_types pt
    JOIN category_tree ct
        ON pt.parent_id = ct.id
)

SELECT
    root.display_name AS base_product_type,
    COUNT(p.id) AS total_number_of_products
FROM category_tree ct
JOIN product_types root
    ON root.id = ct.root_id
LEFT JOIN products p
    ON p.product_type = ct.id
GROUP BY root.display_name
ORDER BY root.display_name;

-- 28l. Εμφάνιση συνολικού αριθμού παραγγελιών
-- και συνολικού κόστους
SELECT COUNT(*) AS number_of_orders, SUM(total_price) AS total_price
FROM order_info;

-- 29a. Αλλαγή τιμής προϊόντος
UPDATE product_variants
SET price = 9.00
WHERE id = 6;

-- 29b. Αλλαγή email χρήστη
UPDATE users
SET email = 'contact@rumi.com'
WHERE id = 5;

-- 29c. Αλλαγή status στην παραγγελία με ID = 3 
-- από Completed σε Paid
UPDATE order_info
SET status = 2
WHERE id = 3;

-- 30. Διαγραφή του χρήστη με id = 2 και 4 από τον πίνακα users.
-- Λόγω ON DELETE CASCADE σβήνονται αυτόματα και οι παραγγελίες τους
-- όπως φαίνεται στον πίνακα order_info
DELETE FROM users
WHERE id = 2;

DELETE FROM users
WHERE id = 4;
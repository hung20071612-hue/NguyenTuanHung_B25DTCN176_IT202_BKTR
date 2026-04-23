CREATE DATABASE BookStoreDB;
USE BookStoreDB;

CREATE TABLE Category (
	category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE Book (
	book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    status INT DEFAULT 1,
    publish_date DATE,
    price DECIMAL(14,2),
    category_id INT,
    FOREIGN KEY(category_id) REFERENCES Category(category_id)
);

CREATE TABLE BookOrder  (
	order_id INT PRIMARY KEY auto_increment,
    customer_name VARCHAR(100) NOT NULL,
    book_id INT,
    FOREIGN KEY(book_id) REFERENCES Book(book_id),
    order_date DATE DEFAULT (CURRENT_DATE()),
    delivery_date DATE
);

ALTER TABLE Book 
ADD COLUMN author_name VARCHAR(100) NOT NULL;

ALTER TABLE BookOrder
CHANGE customer_name customer_name VARCHAR(200) NOT NULL;

ALTER TABLE BookOrder
CHANGE delivery_date delivery_date DATE CHECK(delivery_date >= order_date);



INSERT INTO Category (category_name,description)
VALUES 
('IT & Tech','Sách lập trình'),
('Business','Sách kinh doanh'),
('Novel','Tiểu thuyết');

INSERT INTO Book (title,status,publish_date,price,category_id,author_name)
VALUES 
('Clean Code',1,'2020-05-10',500000,1,'Robert C. Martin'),
('Đắc Nhân Tâm',0,'2018-08-20',150000,2,'Dale Carnegie'),
('JavaScript Nâng cao',1,'2023-01-15',350000,1,'Kyle Simpson'),
('Nhà Giả Kim',0,'2015-11-25',120000,3,'Paulo Coelho');

INSERT INTO BookOrder (order_id,customer_name,book_id,order_date,delivery_date)
VALUES
(101,'Nguyen Hai Nam',1,'2025-01-10','2025-01-15'),
(102,'Tran Bao Ngoc',3,'2025-02-05','2025-02-10'),
(103,'Le Hoang Yen',4,'2025-01-10',NULL);

update book
set price = price + 50000
where cateId = 1;

update book
set deliveryDate = '2025-12-31'
where deliveryDate is null;

delete from bookOrder
where orderDate < '2025-02-01';



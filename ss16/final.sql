CREATE DATABASE bruh;
USE bruh;

CREATE TABLE Customers (
	customer_id VARCHAR(6) PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(10) UNIQUE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    register_date DATE DEFAULT(CURRENT_DATE)
);

CREATE TABLE Internet_Packages (
	package_id VARCHAR(6) PRIMARY KEY,
    package_name VARCHAR(50) NOT NULL,
    max_speed INT CHECK(max_speed > 0) NOT NULL,
    monthly_fee DECIMAL(10,2) NOT NULL CHECK(monthly_fee > 0)
);

CREATE TABLE Subscriptions (
	subscription_id VARCHAR(6) PRIMARY KEY,
    customer_id VARCHAR(6) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    package_id VARCHAR(6) NOT NULL,
    FOREIGN KEY (package_id) REFERENCES Internet_Packages(package_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(10) NOT NULL
);

CREATE TABLE Support_Tickets (
	ticket_id VARCHAR(6) PRIMARY KEY,
    subscription_id VARCHAR(6) NOT NULL,
    FOREIGN KEY(subscription_id) REFERENCES Subscriptions(subscription_id),
    created_date DATE NOT NULL,
    issue_content VARCHAR(200) NOT NULL,
    status VARCHAR(10) NOT NULL
);

CREATE TABLE Ticket_Processing_Log (
	log_id VARCHAR(6) PRIMARY KEY,
    ticket_id VARCHAR(6) NOT NULL,
    FOREIGN KEY (ticket_id) REFERENCES Support_Tickets(ticket_id),
    action_detail VARCHAR(200) NOT NULL,
    recorded_at DATETIME NOT NULL,
    processor VARCHAR(10) NOT NULL
);

INSERT INTO Customers (customer_id, full_name, phone_number, email, register_date)
VALUES
('C001', 'Nguyen Minh Quan', '0901112233', 'quan.nm@gmail.com', '2024-01-10'),
('C002', 'Tran Bao Chau', '0988777666', 'chau.tb@yahoo.com', '2024-04-15'),
('C003', 'Le Hoang Kiet', '0903334455', 'kiet.lh@gmail.com', '2025-03-20'),
('C004', 'Pham Gia Bao', '0355556677', 'bao.pg@outlook.com', '2025-09-01'),
('C005', 'Hoang Minh Thu', '0779998811', 'thu.hm@gmail.com', '2026-02-01');

INSERT INTO Internet_Packages (package_id, package_name, max_Speed, monthly_fee)
VALUES
('PKG01', 'Fiber Basic', 100, 250000),
('PKG02', 'Fiber Premium', 300, 500000),
('PKG03', 'Fiber Business', 500, 1200000),
('PKG04', 'Gaming Ultra', 1000, 2000000),
('PKG05', 'Home Economy', 50, 180000);

INSERT INTO Subscriptions (subscription_id, customer_id, package_id, start_date, end_date, status)
VALUES
('SUB101', 'C001', 'PKG01', '2024-01-10', '2025-01-10', 'Expired'),
('SUB102', 'C002', 'PKG02', '2024-04-15', '2026-04-15', 'Active'),
('SUB103', 'C003', 'PKG03', '2025-03-20', '2027-03-20', 'Active'),
('SUB104', 'C004', 'PKG05', '2025-09-01', '2026-09-01', 'Active'),
('SUB105', 'C005', 'PKG04', '2026-02-01', '2027-02-01', 'Active');

INSERT INTO Support_Tickets (ticket_id, subscription_id, created_date, issue_content, status)
VALUES
('TIC901', 'SUB102', '2024-06-01', 'Mat ket noi internet', 'Resolved'),
('TIC902', 'SUB103', '2025-05-10', 'Mang cham vao buoi toi', 'Pending'),
('TIC903', 'SUB101', '2024-11-15', 'Loi modem wifi', 'Resolved'),
('TIC904', 'SUB104', '2025-12-20', 'Khong vao duoc mang', 'Rejected'),
('TIC905', 'SUB105', '2026-03-05', 'Yeu cau nang cap modem', 'Pending');

INSERT INTO Ticket_Processing_Log (log_id, ticket_id, action_detail, recorded_at, processor)
VALUES
('L001', 'TIC901', 'Da kiem tra duong truyen', '2024-06-01 09:00:00', 'Staff_01'),
('L002', 'TIC901', 'Hoan tat sua loi internet', '2024-06-01 14:00:00', 'Staff_01'),
('L003', 'TIC902', 'Dang xu ly toc do mang', '2025-05-11 10:30:00', 'Staff_02'),
('L004', 'TIC904', 'Tu choi ho tro do loi khach hang', '2025-12-21 15:00:00', 'Staff_03'),
('L005', 'TIC905', 'Da tiep nhan yeu cau nang cap', '2026-03-05 16:30:00', 'Staff_04');

UPDATE Internet_Packages
SET monthly_fee = monthly_fee * 1.1
WHERE max_speed > 300;

DELETE FROM Ticket_Processing_Log
WHERE recorded_at < '2025-01-01 00:00:00';

SELECT *
FROM Subscriptions
WHERE status LIKE 'Active' AND YEAR(end_date) = 2027;

SELECT full_name, email
FROM Customers 
WHERE full_name Like '%Hoang%' AND (YEAR(register_date) BETWEEN 2025 AND YEAR(CURRENT_DATE())) ;

SELECT * 
FROM Internet_Packages
ORDER BY monthly_fee DESC
LIMIT 3 OFFSET 3;

SELECT full_name, package_name, register_date, issue_content
FROM Customers C
LEFT JOIN Subscriptions S ON S.customer_id = C.customer_id
LEFT JOIN Internet_Packages I ON I.package_id = S.package_id
LEFT JOIN Support_Tickets Sup ON Sup.subscription_id = S.subscription_id;

SELECT full_name 
FROM Customers C
JOIN Subscriptions S ON S.customer_id = C.customer_id
JOIN Support_Tickets Sup ON Sup.subscription_id = S.subscription_id
WHERE Sup.status LIKE 'Resolved'
GROUP BY full_name
HAVING COUNT(S.status) >= 1;

SELECT I.package_id, package_name
FROM Internet_Packages I
JOIN Subscriptions S ON I.package_id = S.package_id
GROUP BY I.package_id, package_name
ORDER BY COUNT(I.package_id) DESC
LIMIT 1;

CREATE INDEX idx_subscription_status_date ON Subscriptions(status, start_date);

CREATE VIEW vw_customer_package_summary AS
SELECT full_name, COUNT(S.package_id) total_package, SUM(I.monthly_fee) total_fee
FROM Customers C
JOIN Subscriptions S ON S.customer_id = C.customer_id
JOIN Internet_Packages I ON I.package_id = S.package_id
GROUP BY full_name;

SELECT * FROM vw_customer_package_summary;

DELIMITER //
CREATE TRIGGER trg_after_ticket_resolved
AFTER UPDATE ON Support_Tickets
FOR EACH ROW
BEGIN
	INSERT INTO 
END //
DELIMITER ;


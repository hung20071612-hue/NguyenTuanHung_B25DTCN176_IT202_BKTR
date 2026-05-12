create database botro_session15;

use botro_session15;

-- Tạo students
create table students (
	student_id varchar(5) primary key,
    full_name varchar(50) not null,
    total_debt decimal(10, 2) default 0
);

-- Tạo subjects 
create table subjects (
	subject_id varchar(5) primary key,
    subject_name varchar(50) not null,
    credits int check(credits > 0)
);

-- Tạo grades 
create table grades (
	student_id varchar(5),
    subject_id varchar(5),
    score decimal(4, 2) check (score between 0 and 10),
    primary key(student_id, subject_id),
    foreign key(student_id) references students(student_id),
    foreign key(subject_id) references subjects(subject_id)
);

-- Tạo grade_log
create table grade_log (
	log_id int primary key auto_increment,
    student_id varchar(5),
    old_score decimal(4, 2),
    new_score decimal(4, 2),
    change_date datetime default current_timestamp,
    foreign key(student_id) references students(student_id)
);

-- Thêm dữ liệu cho các bảng
insert into students(student_id, full_name, total_debt)
values 	('SV001', 'Nguyễn Văn A', 10000000),
		('SV002', 'Nguyễn Văn B', 20000000),
		('SV003', 'Nguyễn Văn C', 20000000),
		('SV004', 'Nguyễn Văn D', 40000000),
		('SV005', 'Nguyễn Văn E', 50000000);

insert into subjects (subject_id, subject_name, credits)
values 	('SJ001', 'Toán', 4),
		('SJ002', 'Ngữ Văn', 3),
    	('SJ003', 'Tiếng Anh', 3),
		('SJ004', 'Hóa học', 1),
		('SJ005', 'Sinh học', 2);

insert into grades (student_id, subject_id, score)
values 	('SV001', 'SJ003', 8),
		('SV002', 'SJ001', 7),
		('SV003', 'SJ004', 10),	
		('SV004', 'SJ005', 6),
		('SV005', 'SJ002', 2);

SELECT * FROM students;
SELECT * FROM grades;


DELIMITER //

CREATE TRIGGER tg_check_score
BEFORE INSERT ON grades
FOR EACH ROW
BEGIN 
	if NEW.score < 0 THEN 
	SET NEW.score = 0;
    ELSEIF NEW.score > 10 THEN
    SET NEW.score = 10;
    END IF;
END //
DELIMITER ;

SHOW TRIGGERS;

START TRANSACTION;

INSERT INTO students (student_id, full_name)
VALUES
('SV02','Ha Bich Ngoc');

UPDATE students
SET total_debt = 5000000
WHERE student_id = 'SV02';
COMMIT;

DELIMITER //

CREATE TRIGGER tg_log_grade_update 
AFTER UPDATE ON grades
FOR EACH ROW
BEGIN
	IF OLD.score <> NEW.score THEN
    INSERT INTO grade_log (student_id,old_score,new_score)
    VALUES ('SV001',OLD.score,NEW.score);
    END IF;
END //

DELIMITER ;


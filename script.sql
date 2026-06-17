# PA01-complex-select
-- Practical Assignment 1 "Complex Select"

create database PA01;

use PA01;

-- Creating Tables

create table Teachers (
Teacher_Id serial primary key,
Teacher_Name varchar(100),
Direction varchar(100)
);

create table Courses (
Course_Id serial primary key,
Course_Name varchar(100),
Price decimal(10,2),
Teacher_Id int,
foreign key (Teacher_Id) references Teachers(Teacher_Id)
);

create table Students (
Student_Id serial primary key,
Student_Name varchar(100),
Email varchar(100),
Registration_Year int
);

create table Registrations (
Registration_Id serial primary key,
Student_Id int,
Course_Id int,
Registration_Date date,
Grade decimal(4,2),
foreign key (Student_Id) references Students(Student_Id),
foreign key (Course_Id) references Courses(Course_Id)
);

create table Reviews (
Review_Id serial primary key,
Student_Id int,
Course_Id int,
Rating int,
Review_Date date,
foreign key (Student_Id)  references Students(Student_Id),
foreign key (Course_Id) references Courses(Course_Id)
);

-- Insert data into Teachers

insert into Teachers (Teacher_Name, Direction) values
('Anna Bulka', 'Cybersecurity'),
('Bob Borsch', 'Data Science'),
('Andrii Pampushka', 'DevOps'),
('David Panakota', 'UI Designer');

-- Insert data into Courses

insert into Courses (Course_Name, Price, Teacher_Id) values
('Network Security Fundamentals', 99.99, 1),
('Python for Data Science', 119.99, 2),
('Docker & Kubernetes Fundamentals', 99.99, 3),
('CI/CD Pipelines with GitHub Actions', 89.99, 3),
('Figma UI Design from Scratch', 74.99, 4);

-- Insert data into Students

insert into Students (Student_Name, Email, Registration_Year) values
('Vanya Semechki', 'vanya@example.com', 2025),
('Olya Sup', 'olya@example.com', 2024),
('Sonya Tarilka', 'sonya@example.com', 2022),
('Danya Dzerkalo', 'danya@example.com', 2023),
('Oleg Papir', 'oleg@example.com', 2024);

-- Insert data into Registrations

insert into Registrations (Student_Id, Course_Id, Registration_Date, Grade) values
(1, 1, '2024-01-10', 92.5),
(1, 2, '2024-02-15', 87.0),
(2, 3, '2024-01-20', 95.0),
(3, 4, '2024-03-01', 78.5),
(4, 5, '2024-01-12', 91.0),
(5, 1, '2024-01-12', 91.0),
(5, 3, '2024-02-20', 85.5),
(2, 4, '2024-04-01', 90.0),
(3, 2, '2024-04-05', 76.0),
(4, 1, '2024-04-10', 94.5);

-- Insert data into Reviews

insert into Reviews (Student_Id, Course_Id, Rating, Review_Date) values
(1, 1, 5, '2024-02-01'),
(1, 2, 4, '2024-03-01'),
(2, 3, 5, '2024-02-10'),
(3, 4, 3, '2024-03-20'),
(4, 5, 4, '2024-04-01'),
(5, 1, 5, '2024-02-05'),
(5, 3, 4, '2024-03-15'),
(2, 4, 5, '2024-04-20');


-- Complex Select --
select s.student_name,
c.course_name,
t.teacher_name,
count(r.registration_id) as total_registrations,
round(avg(r.grade), 2) as average_grade
from registrations r
join students s on r.student_id = s.student_id
join courses c on r.course_id = c.course_id
join teachers t on c.teacher_id = t.teacher_id
join reviews rv on rv.student_id = r.student_id and rv.course_id = r.course_id
where r.grade >= 78.5
group by s.student_name, c.course_name, t.teacher_name
order by average_grade desc;

-- UNION --

select student_name,
email,
'2024' as registration_year_union
from students
where registration_year = '2024'
union
select student_name,
email,
'2025' as registration_year_union
from students
where registration_year = '2025';

-- CTE --

with avg_ratings as (
select r.course_id,
round(avg(rating), 2) as avg_rating,
count(review_id) as total_reviews
from reviews r
group by r.course_id
)
select c.course_name,
t.teacher_name,
ar.avg_rating,
ar.total_reviews
from avg_ratings ar
join courses c on ar.course_id = c.course_id
join teachers t on ar.course_id = t.teacher_id
order by ar.avg_rating desc;
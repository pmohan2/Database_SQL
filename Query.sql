create database tinyhub;
use tinyhub;
Create table tinyhub.users(
email_id varchar(100) not null primary key,
Displayname varchar(100) unique not null,
password varchar(10) not null,
account_type varchar(10) not null
);
Create table tinyhub.department(
Department_id int not null primary key,
Department_name varchar(100) not null
);
Create table tinyhub.courses(
courses_id int not null primary key,
courses_name varchar(100) not null,
Department_id int,
foreign key(Department_id) references department(Department_id)
);
Create table tinyhub.program(
program_id int not null,
program_name varchar(100) not null,
Department_id int,
foreign key(Department_id) references department(Department_id),
primary key(program_id)
);
Create table tinyhub.semester(
years varchar(100) not null,
season varchar(100) not null,
primary key(years,season)
);
Create table tinyhub.student(
student_id int not null primary key,
Student_name varchar(100) not null,
DOB date not null,
Enroll_year varchar(100),
email_id varchar(100) not null,
foreign key(email_id) references users(email_id)
);
Create table tinyhub.professor(
Professor_id int not null primary key,
Professor_name varchar(100) not null,
DOB date not null,
employment_year varchar(100),
email_id varchar(100) not null,
designation varchar(100),
Department_id int,
foreign key(email_id) references users(email_id),
foreign key(Department_id) references department(Department_id)
);
Create table tinyhub.staff(
staff_id int not null primary key,
staff_name varchar(100) not null,
DOB date not null,
employment_year varchar(100),
email_id varchar(100) not null,
designation varchar(100),
Department_id int,
foreign key(email_id) references users(email_id),
foreign key(Department_id) references department(Department_id)
);
Create table tinyhub.major_in(
student_id int,
Department_id int,
foreign key(student_id) references student(student_id),
foreign key(Department_id) references department(Department_id)
);
Create table tinyhub.pursue(
student_id int not null,
Department_id int not null references major_in(Department_id),
program_id int not null,
foreign key(student_id) references major_in(student_id),
foreign key(Department_id) references program(Department_id),
foreign key(program_id) references program(program_id)
);
create table tinyhub.registered(
student_id int not null,
years varchar(100) not null,
season varchar(100) not null,
foreign key(student_id) references major_in(student_id),
foreign key(years,season) references semester(years,season)
);
create table tinyhub.isopen(
courses_id int not null references courses(courses_id),
years varchar(100) not null,
season varchar(100) not null,
capacity int not null,
foreign key(years,season) references semester(years,season),
primary key(courses_id,years,season)
);
create table tinyhub.prerequisite(
courses_id int not null references courses(courses_id),
prerequisite_id int DEFAULT 0,
foreign key(prerequisite_id) references courses(courses_id)
);
create table tinyhub.student_prereq(
student_id int references registered(student_id),
courses_id int references courses(courses_id),
prerequisite_id int DEFAULT 0 references prerequisite(prerequisite_id),
cleared char default 'T',
check (cleared like 'T'),
primary key(courses_id,student_id)
);
create table tinyhub.enroll(
student_id int not null references student_prereq(student_id),
overall_grade char default 'N',
check (overall_grade in ('A','B','C','D','F')),
courses_id int not null references student_prereq(course_id),
years varchar(100) not null references registered(years),
season varchar(100) not null references registered(season),
foreign key(years,season) references isopen(years,season),
foreign key(courses_id) references isopen(courses_id),
primary key(student_id, years, season)
);
create table tinyhub.TA(
student_id int not null,
years varchar(100) not null,
season varchar(100) not null, 
courses_id int not null,
foreign key(years,season) references isopen(years,season),
foreign key(courses_id) references isopen(courses_id),
foreign key(student_id) references student(student_id)
);
create table tinyhub.teaches(
Professor_id int not null references professor(Professor_id),
years varchar(100) not null,
season varchar(100) not null, 
courses_id int not null,
foreign key(years,season) references isopen(years,season),
foreign key(courses_id) references isopen(courses_id)
);
create table tinyhub.feedback(
student_id int not null,
Professor_id int not null references teaches(Professor_id),
courses_id int not null references teaches(courses_id),
descriptions varchar(100),
foreign key(courses_id) references enroll(courses_id),
foreign key(student_id) references enroll(student_id)
);
Create table tinyhub.exams(
exams_id int primary key,
exam_name varchar(100) not null,
courses_id int not null,
foreign key(courses_id) references isopen(courses_id)
);
Create table tinyhub.problem(
Problem_id int primary key,
exams_id int,
foreign key(exams_id) references exams(exams_id)
);
create table tinyhub.Attends(
student_id int not null,
courses_id int not null,
exams_id int not null,
overall_grade char,
check (overall_grade in ('A','B','C','D','F')),
foreign key(courses_id) references enroll(courses_id),
foreign key(student_id) references enroll(student_id),
foreign key(exams_id) references exams(exams_id)
);
Create table tinyhub.student_exam(
student_id int not null, 
exams_id int not null,
score int,
courses_id int not null,
Problem_id int not null,
foreign key(courses_id) references Attends(courses_id),
foreign key(student_id) references Attends(student_id),
foreign key(exams_id) references Attends(exams_id),
foreign key(Problem_id) references problem(Problem_id)
);


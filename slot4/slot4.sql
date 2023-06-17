create database DML
use DML
go
--1
create schema Students
go
CREATE TABLE Students.student (
    SID INT PRIMARY KEY NOT NULL ,
    S_FNAME VARCHAR(20) NOT NULL,
    S_LNAME VARCHAR(30) NOT NULL,
	unique(SID)
)

create table Students.Course(
	CID int primary key not null,
	C_NAME varchar(30) not null
)

create table Students.Course_Grades (
	CGID int primary key not null,
	Semester char(4) not null, --phai dien du 4 ki tu
	CID int not null,
	SID int not null,
	FOREIGN KEY (CID) REFERENCES Students.Course(CID),
	FOREIGN KEY (SID) REFERENCES Students.Student(SID),
	Grade char (2) not null,
	UNIQUE(CGID)
)
--2
INSERT INTO Students.Student (SID, S_FNAME, S_LNAME)
VALUES (12345, 'Chris', 'Rock'),
	   (23456, 'Chris', 'Farley'),
	   (34567, 'David', 'Spade'),
	   (45678, 'Liz', 'Lemon'),
	   (56789, 'Jack', 'Donaghy');

INSERT INTO Students.Course_Grades(CGID, Semester, CID, SID, Grade)
VALUES  (2010101, 'SP10', 101005, 34567, 'D+'),
	    (2010308, 'FA10', 101005, 34567, 'A'),
		(2010309, 'FA10', 101001, 45678, 'B+'),
		(2011308, 'FA11', 101003, 23456, 'B'),
		(2012206, 'SU12', 101002, 56789, 'A+');

INSERT INTO Students.Course (CID, C_Name) 
VALUES (101001, 'Intro to Computers'),
		(101002, 'Programming'),
		(101003, 'Databases'),
		(101004, 'Websites'),
		(101005, 'IS Management');

--3
alter table Students.Student
alter column S_FName varchar(30);
--4
alter table Students.Course
	add
	Faculty_LName varchar(30) not null default 'TBD';
--5
UPDATE Students.Course
SET Faculty_LName = 'Potter', C_NAME = 'Intro to Wizardry'
WHERE CID = 101001;
--6
EXEC SP_RENAME 'Students.Course.C_Name','Course_Name';
--7
DELETE FROM Students.Course WHERE Course_Name='websites';
--8
DROP TABLE Students.Student
--9
DELETE FROM Students.Course
--10
ALTER TABLE Students.Course_Grades DROP CONSTRAINT CID_FK;
ALTER TABLE Students.Course_Grades DROP CONSTRAINT SID_FK;

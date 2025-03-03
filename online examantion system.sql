CREATE TABLE Department (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL UNIQUE
);


CREATE TABLE Student (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Year INT NOT NULL,
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Department(ID) ON DELETE CASCADE
);


CREATE TABLE Course (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Duration INT NOT NULL,
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Department(ID) ON DELETE CASCADE
);

CREATE TABLE Student_Course (
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(ID) ,
    FOREIGN KEY (CourseID) REFERENCES Course(ID) 
);

CREATE TABLE Question (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Text NVARCHAR(MAX) NOT NULL,
    Answer NVARCHAR(MAX) NOT NULL,
    Type NVARCHAR(50) NOT NULL CHECK (Type IN ('multichoice', 'true/false')),
	Mark int not null
);

ALTER TABLE Question 
ADD CourseID INT NOT NULL
CONSTRAINT FK_Question_Course FOREIGN KEY (CourseID) REFERENCES Course(ID);

CREATE TABLE Choice (
    ID INT PRIMARY KEY IDENTITY(1,1),
    QuestionID INT NOT NULL,
    Text NVARCHAR(MAX) NOT NULL,
    FOREIGN KEY (QuestionID) REFERENCES Question(ID) ON DELETE CASCADE
);

CREATE TABLE Exam (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Date DATE NOT NULL,
    Duration INT NOT NULL,
    CourseID INT NOT NULL,
    FOREIGN KEY (CourseID) REFERENCES Course(ID) ON DELETE CASCADE
);

CREATE TABLE Student_Exam (
    StudentID INT NOT NULL,
    ExamID INT NOT NULL,
    PRIMARY KEY (StudentID, ExamID),
    FOREIGN KEY (StudentID) REFERENCES Student(ID) ,
    FOREIGN KEY (ExamID) REFERENCES Exam(ID) 
);


CREATE TABLE Exam_Question (
    ExamID INT NOT NULL,
    QuestionID INT NOT NULL,
    PRIMARY KEY (ExamID, QuestionID),
    FOREIGN KEY (ExamID) REFERENCES Exam(ID) ON DELETE CASCADE,
    FOREIGN KEY (QuestionID) REFERENCES Question(ID) ON DELETE CASCADE
);


CREATE TABLE Answer (
    ID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    ExamID INT NOT NULL,
    QuestionID INT NOT NULL,
    ChoiceID INT NULL, 
    AnswerText NVARCHAR(255) NULL, 
    IsCorrect BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (StudentID) REFERENCES Student(ID) ,
    FOREIGN KEY (ExamID) REFERENCES Exam(ID) ,
    FOREIGN KEY (QuestionID) REFERENCES Question(ID) ,
    FOREIGN KEY (ChoiceID) REFERENCES Choice(ID)
);


create table Instructor
(
id int primary key identity(1,1),
name  nvarchar(60) not null ,
age int  ,
dep_id  int not null,
FOREIGN KEY (dep_id) REFERENCES Department(ID)
);


create table Topic
(
id int primary key identity(1,1),
name  nvarchar(60) not null ,
course_id  int not null,
FOREIGN KEY (course_id) REFERENCES Course(ID)
);



create table Instructor_course
(
instructor_id int not null ,
course_id int not null ,

primary key(instructor_id,course_id),
foreign key (instructor_id) references Instructor(id),
foreign key (course_id) references Course(ID)

)
--------------------------------------------------------------------------------------------------------------

---- stored procedure for student table

---select 
create proc get_students  
	as 
		select * from Student 

get_students 

-- select by id 
alter proc get_studentById @id int  
	as 
	if exists (select ID  from Student where Student.ID = @id)
		select * from Student
		where Student.ID =  @id ; 
	else
		select 'No student with this id'

-- insert procedure

create proc insert_student @name nvarchar(255) ,@year int , @deparmentID int
as 
	
	insert into Student ("Name","Year","DepartmentID")
	values (@name,@year,@deparmentID)


insert_student 'Marcos Shehata',4,1

-- delete procedure


alter proc delete_student @studentId int  
as 
	if exists (select ID  from Student where Student.ID = @studentId)
		delete from Student
		where Student.ID = @studentId 
	else
		select 'No student with this id'

delete_student 1002


-- update procedure


alter proc update_student_Name @studentId int , @newname nvarchar(255)
as 
	if exists (select ID  from Student where Student.ID = @studentId)
		update  Student
		set Name = @newname
		where Student.ID = @studentId 
	else
		select 'No student with this id'

update_student_Name 1003 , 'Morcos shehata'



alter proc update_student_year @studentId int , @newYear int
as 
	if exists (select ID  from Student where Student.ID = @studentId)
		update  Student
		set Year = @newYear
		where Student.ID = @studentId 
	else
		select 'No student with this id'

update_student_year 10060 , 5








---- stored procedure for  Course Table

----- -- get all coruses
create proc get_Courses
	as 
		select * from Course 

get_Courses

----- -- get coruse by id 

create proc get_CourseById @id int  
	as 
		select * from Course
		where Course.ID =  @id ; 

get_CourseById 1 


------ update course by id 

alter proc update_courseById @id int , @CourseName nvarchar(255)
as 
	if exists (select ID from Course where Course.ID = @id)
		update Course
		set course.Name = @CourseName
		where Course.ID = @id 
	else
		select 'No course with this ID'


-- add course 

alter proc add_course @name nvarchar(255) , @duration int ,@depId int  
as 
	if exists (select ID from Department where ID = @depId)
		insert into Course ("Name","Duration","DepartmentID")
		values (@name,@duration,@depId)
	else
		select 'not department with this name'

add_course 'newcourse',20 , 1

-- stored procedure  delete course by id 
create proc delete_course @id int 
as 
	if exists (select ID from Course where ID = @id)
		delete from Course
		where ID = @id
	else
		select 'no course with this id'


delete_course 1002
	


--- department 

-- select department 

create proc get_departments 
as 
	select * from Department 


get_departments


-- insert 

create proc insert_department @name nvarchar(255)
as 
	insert into Department ("Name")
	values(@name)


insert_department 'newdep'


-- delete 

create proc delete_department @id int 
as 
	if exists (select * from Department where ID = @id)
		delete from Department
		where ID = @id 
	else
	  select 'no department with this id'


delete_department 1002


-- update 

create proc update_department @id int , @newName nvarchar(255) 
as 
	if exists (select * from Department where ID = @id)
		update Department
		set Name =@newName
		where ID = @id
	else
	  select 'no department with this id'


update_department 1003 , 'updartedName'




--- topic 


-- select 

create  proc get_topics
as
	select * from Topic

get_topics

-- insert 

create proc add_topic @name nvarchar(255) ,@courseid int 
as 
	if exists (select * from Course where ID =@courseid)
		insert into Topic ("name","course_id")
		values (@name,@courseid)

add_topic 'newtopic',1


-- update 
create proc update_topic @id int , @newname nvarchar(255)
as 
	if exists (select * from Topic where id =@id)
		update Topic
		set name =@newname  
		where id = @id

	else 
		select 'no topic with this id'



update_topic 10 , 'updatedtopic'
	


create proc delete_topic @id int 
as 
	if exists (select * from Topic where id =@id)
		delete from Topic
		where id = @id 
	else 
		select 'no topic with this id '

delete_topic 10



-- instructor 

-- select 

create proc get_instructors  
as 
	select * from Instructor 


get_instructors  


--- update instructor

create proc update_instructor @id int , @newName nvarchar(255)
as 
	if exists (select * from Instructor where id =@id)
		update Instructor 
		set name  = @newName 
		where id = @id
	else
		select 'not instructor with this id'


-- insert instructor 
create proc add_instructor @name nvarchar(255) , @age int , @depID int 
as 
	if exists (select * from Department where ID = @depID )
		insert into Instructor ("name","age","dep_id")
		values (@name,@age,@depID)
	else 
		select 'no instructor with this id'
	

create proc delete_instructor @id int
as 
	if exists (select * from Instructor where id =@id)
		delete from Instructor
		where id= @id
	else 
		select 'no instructor with this id'		
	


----------------------------------------------------------------------------------------------

--- exam generation 

alter proc Exam_generation @course nvarchar(255), @mcq int , @tf int 
as 
	declare @courseID int , @examID int ;
	select @courseID = Course.ID  from Course where Name = @course
	if @courseID  is not null 
		begin
		-------add exam in exam table-----
		insert into Exam ("Name","Duration","Date","CourseID")
		 
		values  (CONCAT(@course,' ','Exam'),25,GETDATE(),@courseID)
		
		set @examID = SCOPE_IDENTITY() ;

		--------------
		insert into Exam_Question ("ExamID",QuestionID)
		select 
		@examID ,ID
		from 
		(
		select top (@mcq) ID from Question
		where Type = 'multichoice' and CourseID = @courseID
		order by NEWID()) as mcqQ

		insert into Exam_Question ("ExamID",QuestionID)
		select 
		@examID ,ID
		from 
		(select top (@tf) ID from Question
		where Type = 'true/false'and CourseID = @courseID
		order by NEWID()) as tfQ
		end
	else
		select 'NO course with this id';





Exam_generation 'Data Structures' , 2 ,2


-----------exam Answer stored procedure ------

alter proc exam_answers @examId int , @studentId int ,@questionID int , @AnswerText nvarchar(255) = ''
as 
	if exists (select * from Student where ID= @studentId)  and exists(select * from Exam where ID = @examId)

		if exists (select * from Exam_Question where QuestionID = @questionID and ExamID = @examId)
				insert into Answer ("ExamID","StudentID","QuestionID","AnswerText")
				values (@examId,@studentId,@questionID,@AnswerText)

	else
		select 'no exam or studen with this id'
			
			

exam_answers 3 ,1,7,'false'


create proc Exam_correction	@examId int , @studentId int
as
	if exists (select * from Answer where ExamID = @examId and StudentID = @studentId)
	begin
		declare @studentResult int , @total int ; 
		
		select @studentResult  = isnull(sum(Mark),0)   from Answer A 
		left join Question Q
		on Q.ID = A.QuestionID and Q.Answer = A.AnswerText 
		where A.ExamID = @examId  and A.StudentID = @studentId	

		select @total = sum(Mark)   from Exam_Question 
			join Question Q
			on QuestionID = Q.ID 
			where ExamID = @examId
		select @studentResult  StudentMark , @total ExamMark ; 
		end ;
	else 
		select 'student didnt take this exam'


-- student take exam 
Exam_correction 3,1

-- Student didn't take exam 
Exam_correction 3,20





---------------------------------------------------------------------------------
--•	Report that takes course ID and returns its topics.

create proc get_course_topic @courseID int 
as 
	select Course.Name Course , Topic.name Topic from Course 
	join Topic
	on Topic.course_id = Course.ID 
	where Course.ID=@courseID


get_course_topic 1 



-- •	Report that takes exam number and returns Questions in it.
create proc  get_exam_questions @examId int
as
	select Q.Text Question , Q.Answer ,Q.Mark from Exam_Question  EQ
	join Question Q
	on EQ.QuestionID = Q.ID
	where EQ.ExamID = @examId 


get_exam_questions 3 

-- •Report that takes the instructor ID and returns the name of the courses that he teaches and the number of students per course. 


alter proc get_instructor_courses_students @id int 
as
	if exists(select * from Instructor where id = @id)
		Select c.Name CourseName , count(Student.ID) StudentNumber from Instructor_course insC
		join Course c
		on  insC.course_id = c.ID
		join Student_Course stdc
		on stdc.CourseID= c.ID 
		join Student
		on stdc.StudentID = Student.ID 
		where insC.instructor_id = @id
		group by c.Name


get_instructor_courses_students 1



create proc get_exam_question_answers @examId int , @studentId int 
as 
	if exists (select * from Student where ID = @studentId) and exists (select * from Exam where ID = @examId)	
	
			select Q.Text Question , A.AnswerText StudentAnswer  from Answer A
			join Question Q
			on A.QuestionID = Q.ID
			where A.ExamID = @examId and A.StudentID = @studentId

get_exam_question_answers 3 , 1

-- •	Report that takes the student ID and returns the grades of the student in all courses.
create proc get_student_Courses @studentId int
as 
	select Course.Name  CourseName,  isnull(sum(Mark),0)  StudentMark  from Answer A 
	left join Question Q
	on Q.ID = A.QuestionID and Q.Answer = A.AnswerText 
	join Exam 
	on A.ExamID = Exam.ID 
	join Course 
	on Exam.CourseID = Course.ID
	where  A.StudentID = @studentId
	group by Course.Name



get_student_Courses  1 


-- •	Report that returns the students information according to Department No parameter.

create proc get_student_info_by_department @DepId int 
as 
	select  Department.Name DepartmentName , Student.Name StudentName , Student.Year StudentYear  from Student 
	join Department
	on Student.DepartmentID = Department.ID 
	where DepartmentID  = @DepId


get_student_info_by_department 1 




--1. Write a query that displays Full name of an employee who has more than3 letters in his/her First Name.
select e.Fname+' '+e.Lname as [Fullname]
from Employee e
where LEN(e.Fname)>3


--2. Write a query to display the total number of Programming books available in the library with alias name ‘NO OF PROGRAMMING BOOKS’
select COUNT(c.id) as [NO OF PROGRAMMING BOOKS]
from Book b,Category c
where b.Cat_id=c.Id and c.Cat_name='Programming'

--3. Write a query to display the number of books published by (HarperCollins) with the alias name 'NO_OF_BOOKS'. 
select *
from Book b,Publisher p
where b.Publisher_id=p.Id and p.Name='HarperCollins'

--4. Write a query to display the User SSN and name, date of borrowing and due date of the User whose due date is before July 2022.
select u.SSN,u.User_Name,b.Borrow_date,b.Due_date
from Borrowing b,Users u
where b.User_ssn=u.SSN and b.Due_date<'2022-07-01'

--5. Write a query to display book title, author name and display in the following format,' [Book Title] is written by [Author Name]. 
select concat ('[',b.Title,'] is written by [',a.Name,'].') as [Books and their writers]
from Book b,Book_Author ba,Author a
where b.Id=ba.Book_id and a.Id=ba.Author_id 

--6. Write a query to display the name of users who have letter 'A' in their names.
select u.User_Name
from Users u
where u.User_Name like '%a%'

--7. Write a query that display user SSN who makes the most borrowing
select top(1) b.User_ssn,count(b.user_ssn) as [user redundancy]
from borrowing b
group by b.User_ssn
order by  count(b.user_ssn) desc

--8. Write a query that displays the total amount of money that each user paid for borrowing books.
select b.User_ssn,sum(b.Amount) as [total money paid]
from borrowing b
group by b.User_ssn

--9. write a query that displays the category which has the book that has the minimum amount of money for borrowing.
select c.Cat_name
from Category c
where c.Cat_name= (select top (1) c.Cat_name
                   from Borrowing br, Book b, Category c
                   where br.Book_id = b.Id and b.Cat_id=c.Id 
	               order by br.Amount)


--10.write a query that displays the email of an employee if it's not found,display address if it's not found, display date of birthday
select coalesce(e.Email,e.address, CAST(e.DOB AS VARCHAR),'No info') as [Employee info]
from Employee e


--11. Write a query to list the category and number of books in each category with the alias name 'Count Of Books'.
select Cat_id,count(b.id) as[Count Of Books]
from Category c , Book b
where c.Id=b.Cat_id
group by Cat_id


--12. Write a query that display books id which is not found in floor num = 1 and shelf-code = A1
select b.Id
from book b,shelf sh
where b.Shelf_code=sh.Code and sh.Floor_num!=1 and sh.Code!='A1'

--13.Write a query that displays the floor number , Number of Blocks and number of employees working on that floor
select f.Number,f.Num_blocks,count(e.id) as [No. of employees]
from floor f,employee e
where f.Number=e.Floor_no
group by f.number,f.Num_blocks

--14.Display Book Title and User Name to designate Borrowing that occurred within the period ‘3/1/2022’ and ‘10/1/2022’.
select b.Title,u.User_Name
from Borrowing br,Book b,Users u
where br.Book_id=b.Id and br.User_ssn=u.SSN and br.Borrow_date >= '2022-03-01'AND br.Borrow_date <= '2022-10-01';

--15.Display Employee Full Name and Name Of his/her Supervisor as Supervisor Name.
select emp.Fname +' '+emp.Lname as [Employee fullname] ,super.Fname +' '+super.Lname as [Supervisor fullname]
from Employee emp,Employee super
where emp.Super_id=super.Id

--16.Select Employee name and his/her salary but if there is no salary display Employee bonus.
select emp.Fname +' '+emp.Lname as [Employee fullname],COALESCE(Salary, bouns) AS SalaryOrBonus
from Employee emp

--17.Display max and min salary for Employees
select MIN(e.salary) as [Min Salary],Max(e.salary) as[Max Salary]
from Employee e


--18.Write a function that take Number and display if it is even or odd
create FUNCTION CheckEvenOdd(@number int)
returns varchar(50)
AS
BEGIN
    DECLARE @result varchar(50)
    IF @number % 2 = 0
        SET @result = CAST(@number AS varchar(50)) + ' is even.'
    ELSE
        SET @result = CAST(@number AS varchar(50)) + ' is odd.'
    RETURN @result
END;


SELECT dbo.CheckEvenOdd(2) AS even_or_odd;
SELECT dbo.CheckEvenOdd(3) AS even_or_odd;


--19.write a function that take category name and display Title of books in that category
create function GetBooksByCategory(@CatName varchar(20))
returns table
as
return(
select b.Title
from Book b, Category c
where b.Cat_id=c.Id and c.Cat_name=@CatName
)


select *
from dbo.GetBooksByCategory('programming')


--20. write a function that takes the phone of the user and displays Book Title , user-name, amount of money and due-date. 
create function GetBorrowInfoByUserPhone(@Phone varchar(11))
returns table
as
return(
select b.Title,u.User_Name ,br.Amount,br.Due_date
from User_phones uph,Users u,Borrowing br,Book b
where uph.Phone_num=@Phone and uph.User_ssn=br.User_ssn and br.User_ssn=u.SSN and br.Book_id=b.Id
)

select *
from dbo.GetBorrowInfoByUserPhone('0102354545')

--Write a function that take user name and check if it's duplicatedreturn Message in the following format ([User Name] is Repeated[Count] times) if it's not duplicated display msg with this format [username] is not duplicated,if it's not Found Return [User Name] is Notfound

CREATE FUNCTION check_username_duplicate(@username VARCHAR(50))
RETURNS @table table(
message varchar(100)
)
as
begin
declare @count int
select @count=count(u.SSN)
from Users u
where u.User_Name=@username

if(@count>1)
insert into @table
select concat(@username,' is repeated ',@count,' times')
else if(@count=1)
insert into @table
select concat(@username,' is not duplicated')
else
insert into @table
select concat(@username,' is not found')

return 
end

select *
from dbo.check_username_duplicate('Amr Ahmed')


--22.Create a scalar function that takes date and Format to return Date With That Format.

CREATE FUNCTION dbo.GetFormattedDate
(
    @inputDate DATE,
    @format VARCHAR(20)
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @formattedDate VARCHAR(50);
    SET @formattedDate = FORMAT(@inputDate, @format);

    RETURN @formattedDate;
END;


SELECT dbo.GetFormattedDate('2023-07-19', 'dd/MM/yyyy') AS FormattedDate;
SELECT dbo.GetFormattedDate('2023-07-19', 'MMM yyyy') AS FormattedDate;

--23.Create a stored procedure to show the number of books per Category.
create procedure SP_GetBooksPerCategory
as
select c.Cat_name,count(b.id) as [No Of Books in category]
from Book b,Category c
where b.Cat_id=c.Id
group by c.Cat_name

exec SP_GetBooksPerCategory

--24.Create a stored procedure that will be used in case there is an old manager procedure should take 3 parameters (old Emp.id, new Emp.id and the floor number) and it will be used to update the floor table. 
create Procedure SP_UpdateFloorManager( @oldManagerId int, @newManagerId int,@floorNumber int)
as
begin
update Floor
set MG_ID=@newManagerId
where Number=@floorNumber and MG_ID=@oldManagerId
end

EXEC SP_UpdateFloorManager @oldManagerId =3, @newManagerId = 1, @floorNumber =1;


--25.Create a view AlexAndCairoEmp that displays Employee data for users who live in Alex or Cairo. 
CREATE VIEW AlexAndCairoEmp AS
SELECT *
FROM Employee
WHERE Address IN ('Alex', 'Cairo');

SELECT * FROM AlexAndCairoEmp;

--26.create a view "V2" That displays number of books per shelf
CREATE VIEW V2 
AS
SELECT sh.Code as[Shelf code], count(b.id) as [number of shelf's books]
from Book b,Shelf sh
where b.Shelf_code=sh.Code
group by sh.code

select *
from V2

--27.create a view "V3" That display the shelf code that have maximum number of books using the previous view "V2" {
CREATE VIEW V3 AS
SELECT V2.[Shelf code] as [Shelf code with maximum books]
FROM V2
WHERE V2.[number of shelf's books] = (
    SELECT MAX([number of shelf's books]) FROM V2
)

select * from v3

--28
CREATE TABLE ReturnedBooks (
    UserSSN VARCHAR(10),
    BookId INT ,
    DueDate DATE,
    ReturnDate DATE ,
    Fees int,
    PRIMARY KEY (UserSSN, BookId)
);

alter TRIGGER CheckReturnDate
ON ReturnedBooks
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO ReturnedBooks (UserSSN, BookId, DueDate, ReturnDate, Fees)
    SELECT UserSSN, BookId, DueDate, ReturnDate, NULL 
    FROM inserted;

    UPDATE rb
    SET Fees = CASE 
        WHEN rb.ReturnDate > rb.DueDate THEN COALESCE(rb.Fees, 0) +(0.2 * COALESCE((SELECT Amount FROM Borrowing b WHERE b.User_SSN = rb.UserSSN AND b.Book_Id = rb.BookId), 0))
        ELSE 0
    END
    FROM ReturnedBooks rb ,inserted i 
	where rb.UserSSN = i.UserSSN AND rb.BookId = i.BookId;
END


INSERT INTO ReturnedBooks (UserSSN, BookId, DueDate, ReturnDate)
VALUES
    ('1', 3, '2023-07-15', '2023-07-16'), -- Returned one day late
    ('2', 3, '2023-07-10', '2023-07-09'); -- Returned one day early


--29 
insert into floor
values( 7,2,20,GETDATE())


update floor
set MG_ID=12
where MG_ID=5

update floor
set MG_ID=5
where Number=6

--30

CREATE VIEW v_2006_check AS
SELECT *
FROM floor
WHERE Hiring_Date BETWEEN '2022-03-01' AND '2022-12-31'
WITH CHECK OPTION

INSERT INTO floor (mg_id, number, num_blocks, Hiring_Date)
VALUES (2, 6, 2, '2023-08-07')
--that will not work for 2 reasons 
--first:  the provided HiringDate is '2023-07-08', it does not fall between 1st March and 31st December of 2022. Therefore, this row will not be inserted, and you will get an error due to the condition specified in the view.
--second: there is already a floor with number 6 and that can't be duplicated


INSERT INTO floor (mg_id, number, num_blocks, Hiring_Date)
VALUES (4, 7, 8, '2022-08-04')
--these data won't make a conflict with the condition i made when i created the view but there will be a problem.
--in question 29 i inserted a new floor to the table with the number 7 and the number of the floor can't be duplicated (PK)
--if i had inserted it with any other number (8 for example) there wouldn't have been a problem



--31
create trigger PreventAllActions
on employee
instead of insert,update,delete
as
print 'You can not take any action with this table'

delete from Employee


--32
--A. 
insert into User_phones
values('50','01024430384')
--The INSERT statement conflicted with the FOREIGN KEY constraint "FK_User_phones_User". The conflict occurred in table "dbo.Users", column 'SSN'.


--B.
drop trigger PreventAllActions  --drop the trigger which prevent all modifications 

update employee 
set id=21
where id=20
--The DELETE statement conflicted with the REFERENCE constraint "FK_Borrowing_Employee". The conflict occurred in table "dbo.Borrowing", column 'Emp_id'.

--C
delete from Employee
where id=1
--The DELETE statement conflicted with the REFERENCE constraint "FK_Borrowing_Employee". The conflict occurred in table "dbo.Borrowing", column 'Emp_id'.

--D
delete from Employee
where id=12
--The DELETE statement conflicted with the REFERENCE constraint "FK_Borrowing_Employee". The conflict occurred in table "dbo.Borrowing", column 'Emp_id'.

--E
CREATE nonclustered INDEX Employee_Salary
ON Employee (Salary);
--non clustered index will be done without any problems
--can't make clustered index (already made with the primary key)
-- can't make unique index because salary column accept null values and could have duplicated values




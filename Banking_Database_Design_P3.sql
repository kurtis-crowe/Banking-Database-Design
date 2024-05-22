--Part 3 Assignment 4 --
--Kurtis Crowe--


--Query 8--
--return dept_names from department table showing all departments that are assigned to at least one instructor 
--use SET operator
SELECT dept_name
FROM department
INTERSECT
SELECT dept_name FROM instructor
ORDER BY dept_name;

--Query 9--
--return list of course_ids from course table that do not have any prereqs--
--sort from smalest to largest--
--use a set operator--
SELECT course_id FROM course
EXCEPT
select course_id FROM prereq
ORDER BY course_id;

--Query 10--
--return dept_names alphabetical--
--department has a budget less than $50000--
--department has at least one instructor whose salary is greater than $100,000
--department has at least one student whose total credits = highest total credits taken by any student
--no hardcode maximum total credits, instead use an approach that works if this number changes
--include 1 set operator and 1 subquery--
--NO JOINS--
SELECT DISTINCT dept_name FROM department 
WHERE budget < 50000::NUMERIC
UNION
SELECT DISTINCT dept_name FROM instructor
WHERE salary > 100000::NUMERIC
UNION
SELECT DISTINCT dept_name FROM student 
WHERE tot_cred = (SELECT MAX(tot_cred) FROM student)
ORDER BY dept_name;

--Query 11--

SELECT DISTINCT c1.course_id, c1.title as course_name, c2.course_id as prereq_id, c2.title as prereq_name FROM course AS c1
JOIN prereq as pre on c1.course_id = pre.course_id
JOIN course as c2 on pre.prereq_id = c2.course_id


--Query 12--
--Write a query to find the id of each student who has never taken a course at the university. Your
--solution must use an OUTER JOIN- do not use any subqueries or set operations
--Do not simply use the tot_cred field in the student table as it may not accurately indicate if
--a student has taken courses.
--Adding a student to the database who has not attended any
--classes can help validate your query.

--inserting a student named Kurtis Crowe in table to validate if my query is working correctly, as I am not returning any results
INSERT INTO student (ID, name, dept_name, tot_cred)
VALUES ('11111', 'Kurtis Crowe', 'Comp. Sci.', 0);
--after inserting my name in account, I am able to validate this query as my ID populates in the query below as I have not taken any courses
SELECT s.ID
FROM student AS s
LEFT JOIN takes AS t ON s.ID = t.ID
WHERE t.ID IS NULL and s.tot_cred = 0;





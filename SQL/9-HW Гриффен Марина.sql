-- 1. Создайте модифицируемое представление для получения сведений обо всех студентах, 
--    круглых отличниках. Используя это представление, напишите запрос обновления, 
--    "расжалующий" их в троечников.

create view TOP_STUDENT as
select *
from STUDENTS 
where ID in (select STUDENT_ID from EXAM_MARKS group by STUDENT_ID having avg(MARK)=5)

select *
from TOP_STUDENT

begin transaction
update EXAM_MARKS
set MARK=3
where STUDENT_ID in (select STUDENT_ID from EXAM_MARKS group by STUDENT_ID having avg(MARK)=5)
rollback

-- 2. Создайте представление для получения сведений о количестве студентов 
--    обучающихся в каждом городе.

create view QUANTITY_STUD as
select U.CITY, count(s.ID) as qnt
from UNIVERSITIES as u join STUDENTS as s on u.ID=s.UNIV_ID
group by u.CITY

select *
from QUANTITY_STUD

-- 3. Создайте представление для получения сведений по каждому студенту: 
--    его ID, фамилию, имя, средний и общий баллы.

create view INFO as
select S.ID, S.SURNAME, S.NAME, avg(em.MARK) as averege_mark, sum(em.MARK) as sum_mark
from STUDENTS as s join EXAM_MARKS as em on s.ID=em.STUDENT_ID
group by em.STUDENT_ID, s.ID, s.SURNAME, s.NAME

select *
from INFO


-- 4. Создайте представление для получения сведений о студенте фамилия, 
--    имя, а также количестве экзаменов, которые он сдал успешно, и количество,
--    которое ему еще нужно досдать (с учетом пересдач двоек).


-- 5. Какие из представленных ниже представлений являются обновляемыми?

-- D. CREATE VIEW NULLCITIES
--    AS SELECT ID, SURNAME, CITY
--    FROM STUDENTS
--    WHERE CITY IS NULL
--    OR SURNAME BETWEEN 'А' AND 'Д'
--    WITH CHECK OPTION


-- 6. Создайте представление таблицы STUDENTS с именем STIP, включающее поля 
--    STIPEND и ID и позволяющее вводить или изменять значение поля 
--    стипендия, но только в пределах от 100 д о 500.

create view STIP as
select ID
      ,SURNAME
      ,NAME
      ,GENDER
      ,STIPEND
      ,COURSE
      ,CITY
      ,BIRTHDAY
      ,UNIV_ID
from STUDENTS
where STIPEND between 100 and 500
with check option

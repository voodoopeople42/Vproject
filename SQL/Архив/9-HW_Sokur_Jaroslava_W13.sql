-- 1. Создайте представление для получения сведений обо всех студентах, 
--    круглых отличниках. Напишите запрос "расжалующий" их в троешников, 
--    в каком случае сработает такой скрипт.(не понимаю суть вопроса)
create view SUPER_STUDENT as
select*
from STUDENTS 
where ID in (select STUDENT_ID from EXAM_MARKS group by STUDENT_ID having avg(MARK)=5)

select*from SUPER_STUDENT

begin transaction
update EXAM_MARKS
set MARK=3
where STUDENT_ID in (select STUDENT_ID from EXAM_MARKS group by STUDENT_ID having avg(MARK)=5)
rollback

-- 2. Создайте представление для получения сведений о количестве студентов 
--    обучающихся в каждом городе.
create view KOL_STUD_V_GORODE as
select U.CITY, count(s.ID) kol_stud
from UNIVERSITIES u join STUDENTS s on u.ID=s.UNIV_ID
group by u.CITY

select*from KOL_STUD_V_GORODE


-- 3. Создайте представление для получения сведений по каждому студенту: 
--    его ID, фамилию, имя, средний и общий баллы.
create view Infotmation as
select S.ID, S.SURNAME, S.NAME, avg(em.MARK) sred_b, sum(em.MARK) sum_b
from STUDENTS s join EXAM_MARKS em on s.ID=em.STUDENT_ID
group by em.STUDENT_ID, s.ID, s.SURNAME, s.NAME

select*from Infotmation
-- 4. Создайте представление для получения сведений о студенте фамилия, 
--    имя, а также количестве экзаменов, которые он сдал, и количество,
--    которое ему еще нужно досдать.

--У нас же нет перечня предметов по курсу или университету, которые должны быть обязательно сданы.

-- 5. Какие из представленных ниже представлений являются обновляемыми?

-- C. CREATE VIEW THIRDEXAM
--    AS SELECT *
--    FROM DAILYEXAM
--    WHERE EXAM_DATE = '2012/06/03'



-- 6. Создайте представление таблицы STUDENTS с именем STIP, включающее поля 
--    STIPEND и ID и позволяющее вводить или изменять значение поля 
--    стипендия, но только в пределах от 100 д о 500.

-- Я загрузла, нам нужно редактировать в выведенной таблице, ну мне кажется или мы это не учили?
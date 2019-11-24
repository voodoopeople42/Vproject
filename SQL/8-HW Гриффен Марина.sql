-- /* Везде, где необходимо данные придумать самостоятельно. */
--Для каждого задания (кроме 4-го) можете использовать конструкцию
-------------------------
-- начать транзакцию
begin transaction
-- проверка до изменений
SELECT * FROM EXAM_MARKS
-- изменения
-- insert into SUBJECTS (ID,NAME,HOURS,SEMESTER) values (25,'Этика',58,2),(26,'Астрономия',34,1)
-- insert into EXAM_MARKS ...
-- delete from EXAM_MARKS where SUBJ_ID in (...)
-- проверка после изменений
SELECT * FROM EXAM_MARKS --WHERE STUDENT_ID > 120
-- отменить транзакцию
rollback


-- 1. Необходимо добавить двух новых студентов для нового учебного 
--    заведения "Винницкий Медицинский Университет".

begin tran

insert into UNIVERSITIES
      (ID
      ,NAME
      ,RATING
      ,CITY)
values (16
      ,'Винницкий Медицинский Университет'
      ,555
      ,'Винница')

select * from UNIVERSITIES

insert into STUDENTS
		(ID
      ,SURNAME
      ,NAME
      ,GENDER
      ,STIPEND
      ,COURSE
      ,CITY
      ,BIRTHDAY
      ,UNIV_ID)
values 
		(46
	  ,'Пупкин'
      ,'Егор'
	  ,'m'
	  ,450
	  ,3
	  ,'Киев'
	  ,'19981003'
	  ,16)
	  ,
	   (47
	  ,'Кроль'
      ,'Олег'
	  ,'m'
	  ,750
	  ,3
	  ,'Киев'
	  ,'19981004'
	  ,16)


select * from STUDENTS

rollback

-- 2. Добавить еще один институт для города Ивано-Франковск, 
--    1-2 преподавателей, преподающих в нем, 1-2 студента,
--    а так же внести новые данные в экзаменационную таблицу.

begin tran
insert into UNIVERSITIES
      (ID
      ,NAME
      ,RATING
      ,CITY)
values (16
      ,'ІФНТУНГ'
      ,700
      ,'Ивано-Франковск')
	  
	  
select * from UNIVERSITIES

insert into LECTURERS
       (ID
      ,SURNAME
      ,NAME
      ,CITY
      ,UNIV_ID)
values (26
      ,'Клапченко'
      ,'ВР'
      ,'Ивано-Франковск'
      ,16)
	  
	  
select * from LECTURERS

insert into STUDENTS
		(ID
      ,SURNAME
      ,NAME
      ,GENDER
      ,STIPEND
      ,COURSE
      ,CITY
      ,BIRTHDAY
      ,UNIV_ID)
values 
		(46
	  ,'Королев'
      ,'Степан'
	  ,'m'
	  ,450
	  ,3
	  ,'Ивано-Франковск'
	  ,'19981003'
	  ,16)

select * from STUDENTS

insert into EXAM_MARKS 
       (ID
      ,STUDENT_ID
      ,SUBJ_ID
      ,MARK
      ,EXAM_DATE)
	  
values (121
      ,46
      ,4
      ,5
      ,20160903)

rollback
	  

-- 3. Известно, что студенты Павленко и Пименчук перевелись в ОНПУ. 
--    Модифицируйте соответствующие таблицы и поля.

begin tran

select * from STUDENTS where SURNAME = 'Павленко' or SURNAME = 'Пименчук'

update STUDENTS
set UNIV_ID = 
	(select
		ID
	from UNIVERSITIES
	where name = 'ОНПУ')
where SURNAME = 'Павленко' or SURNAME = 'Пименчук'

select * from STUDENTS where SURNAME = 'Павленко' or SURNAME = 'Пименчук'

rollback

-- 4. В учебных заведениях Украины проведена реформа и все студенты, 
--    у которых средний бал не превышает 3.5 балла - отчислены из институтов. 
--    Сделайте все необходимые удаления из БД.
--    Примечание: предварительно "отчисляемых" сохранить в архивационной таблице


-- 5. Студентам со средним балом 4.75 начислить 12.5% к стипендии,
--    со средним балом 5 добавить 200 грн.
--    Выполните соответствующие изменения в БД.

begin tran

Update STUDENTS
set STIPEND=STIPEND+(STIPEND*0.125)
where ID in (select STUDENT_ID from EXAM_MARKS group by STUDENT_ID having avg(Mark)=4.75)

Update STUDENTS
set STIPEND=STIPEND+200
where Id in (select STUDENT_ID from EXAM_MARKS group by STUDENT_ID having avg(Mark)=5)

rollback

-- 6. Необходимо удалить все предметы, по котором не было получено ни одной оценки.
--    Если таковые отсутствуют, попробуйте смоделировать данную ситуацию.

select
sb.name
--,count(em.MARK)
from SUBJECTS as sb
left outer join EXAM_MARKS as em on sb.ID = em.SUBJ_ID
group by sb.name
having count(em.MARK) = 0

select * from EXAM_MARKS

begin tran

select * from SUBJECTS

insert into SUBJECTS
      (ID
      ,NAME
      ,HOURS
      ,SEMESTER)

values (8
      ,'Французкий'
      ,25
      ,3)


select * from SUBJECTS

delete from SUBJECTS
where NAME = 
	(select
	sb.name
	--,count(em.MARK)
	from SUBJECTS sb
	left outer join EXAM_MARKS em on sb.ID = em.SUBJ_ID
	group by sb.name
	having count(em.MARK) = 0)

rollback

-- 7. Лектор 3 ушел на пенсию, необходимо корректно удалить о нем данные.

begin tran
delete from SUBJ_LECT
where LECTURER_ID=3
delete from LECTURERS
where id=3

select*from LECTURERS
rollback

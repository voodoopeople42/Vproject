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
insert into UNIVERSITIES
values ((select (max(ID)+1) from UNIVERSITIES), 'Медицынский Университет', null, 'Винница')
Insert into STUDENTS
values ((select (max (ID)+1) from STUDENTS), 'Новый#1', null, null, null, null, null, null, (select max(ID) from UNIVERSITIES))
Insert into STUDENTS
values ((select (max (ID)+1) from STUDENTS), 'Новый#2', null, null, null, null, null, null, (select max(ID) from UNIVERSITIES))

select*from STUDENTS


-- 2. Добавить еще один институт для города Ивано-Франковск, 
--    1-2 преподавателей, преподающих в нем, 1-2 студента,
--    а так же внести новые данные в экзаменационную таблицу.
insert into UNIVERSITIES
values ((select (max(ID)+1) from UNIVERSITIES), 'Новый_инст', null, 'Ивано-Франковск')
insert into LECTURERS
values ((select (max(id)+1) from LECTURERS), 'Новый препод', null, null, (select max(ID) from UNIVERSITIES))
insert into LECTURERS
values ((select (max(id)+1) from LECTURERS), 'Новый препод_2', null, null, (select max(ID) from UNIVERSITIES))
Insert into STUDENTS
values ((select (max (ID)+1) from STUDENTS), 'Новый студент #1', null, null, null, null, null, null, (select max(ID) from UNIVERSITIES))
Insert into STUDENTS
values ((select (max (ID)+1) from STUDENTS), 'Новый студент #2', null, null, null, null, null, null, (select max(ID) from UNIVERSITIES))
insert into EXAM_MARKS
Values ((select max(ID) from STUDENTS), null, null, null)
insert into EXAM_MARKS
Values ((select max (ID)-1 from STUDENTS), null, null, null)


select*from LECTURERS L join UNIVERSITIES U on l.UNIV_ID=u.ID
						join STUDENTS st on st.UNIV_ID=u.ID
						join EXAM_MARKS em on em.STUDENT_ID=st.ID

-- 3. Известно, что студенты Павленко и Пименчук перевелись в КПИ. 
--    Модифицируйте соответствующие таблицы и поля.
update STUDENTS
set UNIV_ID=(select id from UNIVERSITIES where name='КПИ')
where SURNAME in ('Павленко', 'Пименчук')

select*from UNIVERSITIES
select*from STUDENTS where SURNAME in ('Павленко', 'Пименчук')


-- 4. В учебных заведениях Украины проведена реформа и все студенты, 
--    у которых средний бал не превышает 3.5 балла - отчислены из институтов. 
--    Сделайте все необходимые удаления из БД.
--    Примечание: предварительно "отчисляемых" сохранить в архивационной таблице
insert into STUDENTS_ARCHIVE
select*
from STUDENTS
where id in (select student_id from EXAM_MARKS group by STUDENT_ID having avg(mark)<3.5)

delete from EXAM_MARKS
where STUDENT_ID in (select student_id from EXAM_MARKS group by STUDENT_ID having avg(mark)<3.5)

delete from STUDENTS
where not exists (select*from EXAM_MARKS em where em.STUDENT_ID=STUDENTS.ID)

select* from STUDENTS

-- 5. Студентам со средним балом 4.75 начислить 12.5% к стипендии,
--    со средним балом 5 добавить 200 грн.
--    Выполните соответствующие изменения в БД.
Update STUDENTS
set STIPEND=STIPEND+(STIPEND*0.125)
where Id in (select STUDENT_ID from EXAM_MARKS group by STUDENT_ID having Avg(Mark)=4.75)

Update STUDENTS
set STIPEND=STIPEND+200
where Id in (select STUDENT_ID from EXAM_MARKS group by STUDENT_ID having Avg(Mark)=5)


-- 6. Необходимо удалить все предметы, по котором не было получено ни одной оценки.
--    Если таковые отсутствуют, попробуйте смоделировать данную ситуацию.
update EXAM_MARKS
set MARK=null
where SUBJ_ID=2

delete from SUBJ_LECT
where SUBJ_ID in(select SUBJ_ID from EXAM_MARKS where MARK is null)
delete from EXAM_MARKS
where Mark is null
delete from SUBJECTS
where not exists (select* from EXAM_MARKS em where em.SUBJ_ID=SUBJECTS.ID)

select*
from SUBJECTS


-- 7. Лектор 3 ушел на пенсию, необходимо корректно удалить о нем данные.
delete from SUBJ_LECT
where LECTURER_ID=3
delete from LECTURERS
where id=3

select*from LECTURERS
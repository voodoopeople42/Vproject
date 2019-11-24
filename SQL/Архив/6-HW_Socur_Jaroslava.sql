-- 1. Напишите запрос с EXISTS, позволяющий вывести данные обо всех студентах, 
--    обучающихся в вузах с рейтингом не попадающим в диапазон от 488 до 571
select *
from STUDENTS s
	where exists(select* from UNIVERSITIES u
					where not u.RATING between 488 and 571
					 and 
					 u.ID=s.UNIV_ID)

-- 2. Напишите запрос с EXISTS, выбирающий всех студентов, для которых в том же городе, 
--    где живет и учится студент, существуют другие университеты, в которых он не учится.
select*
from STUDENTS s
where city= any(select city from UNIVERSITIES group by city having COUNT(ID)>1) and
						 not exists(select city from UNIVERSITIES u where s.CITY<>u.CITY and s.UNIV_ID=u.ID) 

-- 3. Напишите запрос, выбирающий из таблицы SUBJECTS данные о названиях предметов обучения, 
--    по которым были успешно сданы экзамены более чем 12 студентами, за первые 10 дней сессии. 
--    Используйте EXISTS. Примечание: по возможности выходная выборка не должна учитывать
--    пересдач.
select NAME
from SUBJECTS s
where exists(select s_id from (select EXAM_DATE, SUBJ_ID s_id, STUDENT_ID, MARK from EXAM_MARKS where EXAM_DATE
 between (select min(EXAM_DATE) from EXAM_MARKS) and (select min(EXAM_DATE)+10 from EXAM_MARKS) 
 and MARK>=3 group by SUBJ_ID, EXAM_DATE,  STUDENT_ID, MARK) q where q.s_id=s.ID
	group by q.s_id having COUNT(q.s_id)>12) 
-- 4. Напишите запрос EXISTS, выбирающий фамилии всех лекторов, преподающих в университетах
--    с рейтингом, превосходящим рейтинг каждого харьковского универа.
Select SURNAME
from LECTURERS l
	where exists (select* from UNIVERSITIES u where l.UNIV_ID=u.ID and RATING>(Select max(RATING)
				from UNIVERSITIES where CITY='Харьков') )
-- 5. Напишите 2 запроса, использующий ANY и ALL, выполняющий выборку данных о студентах, 
--    у которых в городе их постоянного местожительства нет университета.
select*
from STUDENTS
where city <> all(select CITY from UNIVERSITIES)

select*
from STUDENTS
where not city=any(select CITY from UNIVERSITIES)

-- 6. Напишите запрос выдающий имена и фамилии студентов, которые получили
--    максимальные оценки в первый и последний день сессии.
--    Подсказка: выборка должна содержать по крайне мере 2х студентов.
select Name, Surname
from STUDENTS s
where id in (select STUDENT_ID from EXAM_MARKS em where(MARK=(select max(mark) from EXAM_MARKS em where EXAM_DATE=(select min(EXAM_DATE) from EXAM_MARKS)) and
														EXAM_DATE=(select min(EXAM_DATE) from EXAM_MARKS)) 
																or
																	(MARK=(select max(mark) from EXAM_MARKS em where EXAM_DATE=(select max(EXAM_DATE) from EXAM_MARKS em)) 
																					and EXAM_DATE=(select max(EXAM_DATE) from EXAM_MARKS)))

-- 7. Напишите запрос EXISTS, выводящий кол-во студентов каждого курса, которые успешно 
--    сдали экзамены, и при этом не получивших ни одной двойки.
select COURSE, COUNT(COURSE)
from STUDENTS
where ID in (select STUDENT_ID from EXAM_MARKS group by STUDENT_ID having min(MARK)>=3)
group by COURSE
-- 8. Напишите запрос EXISTS на выдачу названий предметов обучения, 
--    по которым было получено максимальное кол-во оценок
select Name
from SUBJECTS s
 where exists (select* from EXAM_MARKS em where s.ID=em.SUBJ_ID having count(MARK)=
										(select max(q.cnt_mr) from (
										      select count(mark) cnt_mr, SUBJ_ID from EXAM_MARKS em  group by SUBJ_ID) q))

-- 9. Напишите команду, которая выдает список фамилий студентов по алфавиту, 
--    с колонкой комментарием: 'успевает' у студентов , имеющих все положительные оценки, 
--    'не успевает' для сдававших экзамены, но имеющих хотя бы одну 
--    неудовлетворительную оценку, и комментарием 'не сдавал' – для всех остальных.
--    Примечание: по возможности воспользуйтесь операторами ALL и ANY.
select 'успевает', SURNAME surn 
from STUDENTS s
where 3<=all(select MARK from EXAM_MARKS em where s.ID=em.STUDENT_ID) and exists (select MARK from EXAM_MARKS em where s.ID=em.STUDENT_ID)
union all
select 'не успевает', SURNAME 
from STUDENTS s
where 2=any(select MARK from EXAM_MARKS em where s.ID=em.STUDENT_ID)
union all
select 'не сдавал', SURNAME -- под вопросом
from STUDENTS s
where -1>=all(select MARK from EXAM_MARKS em where s.ID=em.STUDENT_ID)

-- 10. Создайте объединение двух запросов, которые выдают значения полей 
--     NAME, CITY, RATING для всех университетов. Те из них, у которых рейтинг 
--     равен или выше 500, должны иметь комментарий 'Высокий', все остальные – 'Низкий'.
select Name, CITY, RATING, case when RATING>500 then 'Высокий' else 'Низкий' end комментарий
from UNIVERSITIES
-- не понимаю зачем обьеденять если так всё просто можно сделать
select Name, City, Rating, 'Высокий'
from UNIVERSITIES
where RATING>=500 
union
select Name, City, Rating, 'Низкий'
from UNIVERSITIES
where RATING<=500 
-- 11. Напишите UNION запрос на выдачу списка фамилий студентов 4-5 курсов в виде 3х полей выборки:
--     SURNAME, 'студент <значение поля COURSE> курса', STIPEND
--     включив в список преподавателей в виде
--     SURNAME, 'преподаватель из <значение поля CITY>', <значение зарплаты в зависимости от города проживания (придумать самим)>
--     отсортировать по фамилии
--     Примечание: достаточно учесть 4-5 городов.
select SURNAME, 'cтудент '+cast (COURSE as varchar)+' курса', cast(STIPEND as varchar)
from STUDENTS
where COURSE>=4
union
select SURNAME, 'преподаватель из '+CITY, case when city='Львов' then '500'
											   when city='Днепропетровск' then '600'
											   when city='Харьков' then '700'
											   when city='Луцк' then '800'
											   else 'no data' end
from LECTURERS
order by SURNAME

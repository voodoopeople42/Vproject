-- 1. Напишите запрос с EXISTS, позволяющий вывести данные обо всех студентах, 
--    обучающихся в вузах с рейтингом не попадающим в диапазон от 488 до 571

select * 
from STUDENTS as s
where exists(
    select 1
	from UNIVERSITIES as u
	where not u.RATING between 488 and 571 and u.ID = s.UNIV_ID)

-- 2. Напишите запрос с EXISTS, выбирающий всех студентов, для которых в том же городе, 
--    где живет и учится студент, существуют другие университеты, в которых он не учится.
--    Cтудент учится и живет в одном и том же городе и при этом у него есть альтернатива перевода в 
--    другой университет, не покидая своего города

select *
from STUDENTS as s
where city = any(select city 
                 from UNIVERSITIES 
                 group by city 
				 having count(ID)>1) and
 not exists(select city 
            from UNIVERSITIES as u 
			where s.CITY<>u.CITY and s.UNIV_ID=u.ID) 


-- 3. Напишите запрос, выбирающий из таблицы SUBJECTS данные о названиях предметов обучения, 
--    экзамены по которым были хоть как-то сданы более чем 12 студентами, за первые 10 дней сессии. 
--    Используйте EXISTS. Примечание: по возможности выходная выборка должна быть без пересдач.

select NAME
from SUBJECTS as s
where exists(
        select s_id from (
		   select EXAM_DATE, SUBJ_ID s_id, STUDENT_ID, MARK 
		   from EXAM_MARKS 
		   where EXAM_DATE between (
		      select min(EXAM_DATE) 
			  from EXAM_MARKS) and (
			     select min(EXAM_DATE)+10 
				 from EXAM_MARKS) 
      and MARK>=3 group by SUBJ_ID, EXAM_DATE,  STUDENT_ID, MARK) as q 
	  where q.s_id=s.ID
	group by q.s_id having count(q.s_id)>12) 

-- 4. Напишите запрос EXISTS, выбирающий фамилии всех лекторов, преподающих в университетах
--    с рейтингом, превосходящим рейтинг каждого харьковского универа.

select SURNAME
from LECTURERS as l
where EXISTS (
     select 1
	 from UNIVERSITIES as u 
	 where l.UNIV_ID = u.ID
	 and RATING > all
	     (select RATING from UNIVERSITIES where CITY = 'Харьков'))


-- 5. Напишите 2 запроса, использующий ANY и ALL, выполняющий выборку данных о студентах, 
--    у которых в городе их постоянного местожительства нет университета.

select *
from STUDENTS
where CITY <> all (select CITY from UNIVERSITIES)

select *
from STUDENTS
where not CITY = any (select CITY from UNIVERSITIES)



-- 6. Напишите запрос выдающий имена и фамилии студентов, которые получили
--    максимальные оценки в первый и последний день сессии.
--    Подсказка: выборка должна содержать по крайне мере 2х студентов.

select NAME
      ,SURNAME
from STUDENTS as s
where id in (
   select STUDENT_ID 
   from EXAM_MARKS as em 
   where(MARK=(
      select max(mark) 
	  from EXAM_MARKS as em 
	  where EXAM_DATE=(
	      select min(EXAM_DATE) 
		  from EXAM_MARKS)) and
		EXAM_DATE=(
		   select min(EXAM_DATE)
		   from EXAM_MARKS)) or
	(MARK=(
	        select max(mark) 
	        from EXAM_MARKS as em 
	        where EXAM_DATE=(
	          select max(EXAM_DATE) 
	          from EXAM_MARKS em)) and EXAM_DATE=(
			     select max(EXAM_DATE) 
				 from EXAM_MARKS)))



-- 7. Напишите запрос EXISTS, выводящий кол-во студентов каждого курса, которые успешно 
--    сдали экзамены, и при этом не получивших ни одной двойки.

select COURSE 
      ,count(COURSE) as qnt
from STUDENTS s
where EXISTS (
    select 1
	from EXAM_MARKS as em
	where MARK >=3 and s.ID = em.STUDENT_ID)
group by COURSE



-- 8. Напишите запрос EXISTS на выдачу названий предметов обучения, 
--    по которым было получено максимальное кол-во оценок.

select NAME
from SUBJECTS as s
where EXISTS (
    select 1
	from EXAM_MARKS as em
	where s.ID = em.SUBJ_ID)
	having count (MARK) =
	(
	  select max (MARK) 
	   from EXAM_MARKS )


-- 9. Напишите команду, которая выдает список фамилий студентов по алфавиту, 
--    с колонкой комментарием: 'успевает' у студентов , имеющих все положительные оценки, 
--    'не успевает' для сдававших экзамены, но имеющих хотя бы одну 
--    неудовлетворительную оценку, и комментарием 'не сдавал' – для всех остальных.
--    Примечание: по возможности воспользуйтесь операторами ALL и ANY.

select 'успевает', SURNAME as surn 
from STUDENTS as s
where 3<=all(select MARK 
             from EXAM_MARKS as em 
			 where s.ID=em.STUDENT_ID) and exists (select MARK 
												   from EXAM_MARKS as em 
												   where s.ID=em.STUDENT_ID)
union all
select 'не успевает', SURNAME 
from STUDENTS as s
where 2=any(select MARK 
			from EXAM_MARKS as em 
			where s.ID=em.STUDENT_ID)
union all
select 'не сдавал', SURNAME 
from STUDENTS as s
where -1>=all(select MARK 
			  from EXAM_MARKS as em 
			  where s.ID=em.STUDENT_ID)

-- 10. Создайте объединение двух запросов, которые выдают значения полей 
--     NAME, CITY, RATING для всех университетов. Те из них, у которых рейтинг 
--     равен или выше 500, должны иметь комментарий 'Высокий', все остальные – 'Низкий'.

select NAME
      ,CITY
	  ,RATING
,case
when RATING >= 500 then 'Высокий' else 'Низкий'
end 
from UNIVERSITIES



-- 11. Напишите UNION запрос на выдачу списка фамилий студентов 4-5 курсов в виде 3х полей выборки:
--     SURNAME, 'студент <значение поля COURSE> курса', STIPEND
--     включив в список преподавателей в виде
--     SURNAME, 'преподаватель из <значение поля CITY>', <значение зарплаты в зависимости от города проживания (придумать самим)>
--     отсортировать по фамилии
--     Примечание: достаточно учесть 4-5 городов.



-- 0. Отобразите для каждого из курсов количество парней и девушек. 
select
	COURSE
   ,GENDER
   ,COUNT(GENDER) as 'Количество'
from STUDENTS
group by COURSE, GENDER
order by course;

-- 1. Напишите запрос для таблицы EXAM_MARKS, выдающий даты, для которых средний балл 
--    находиться в диапазоне от 4.22 до 4.77. Формат даты для вывода на экран: 
--    день месяць, например, 05 Jun.

select 
   left(convert(nvarchar(8), EXAM_DATE, 113),6) as dt

from EXAM_MARKS
group by EXAM_DATE
having AVG (MARK) between 4.22 and 4.77

-- 2. Напишите запрос, который по таблице EXAM_MARKS позволяет найти период времени,
--    в течении которого студент сдавал сессию, количество сдаваемых предметов, количество пересдач, 
--	  а также их максимальные и минимальные оценки. В выборке дожлен присутствовать идентификатор студента.
--    Примечание: таблица оценок - покрывает одну сессию, промежуток времени -
--    количество дней, которые провел студент на этой сессии - от первого до 
--    последнего экзамена включительно
--    Примечание-2: функция DAY() для решения не подходит! 


-- 3. Покажите список идентификаторов студентов, которые имеют пересдачи. 

select STUDENT_ID
from EXAM_MARKS
group by SUBJ_ID, STUDENT_ID
having count (*) > 1


-- 4. Напишите запрос, отображающий список предметов обучения, вычитываемых за самый короткий 
--    промежуток времени, отсортированный в порядке убывания семестров. Поле семестра в 
--    выходных данных должно быть первым, за ним должны следовать наименование и 
--    идентификатор предмета обучения.

select SEMESTER
      ,NAME
	  ,ID
from SUBJECTS
where HOURS = (select min (hours) from SUBJECTS)
order by SEMESTER desc;


-- 5. Напишите запрос с подзапросом для получения данных обо всех положительных оценках(4, 5) Марины 
--    Шуст (предположим, что ее персональный номер неизвестен), идентификаторов предметов и дат 
--    их сдачи.

select MARK
      ,SUBJ_ID
	  ,EXAM_DATE
	  ,STUDENT_ID
from EXAM_MARKS
where MARK in (4, 5) 
    and STUDENT_ID = 
         (select ID 
           from STUDENTS
            where SURNAME = 'Шуст' and NAME = 'Марина')

-- 6. Покажите сумму баллов для каждой даты сдачи экзаменов, при том, что средний балл не равен 
--    среднему арифметическому между максимальной и минимальной оценкой. Данные расчитать только 
--    для студенток. Результат выведите в порядке убывания сумм баллов, а дату в формате dd/mm/yyyy.


select CONVERT(nvarchar(10), EXAM_DATE, 103)
		, SUM(MARK) as SUM_MARKS
from EXAM_MARKS
where STUDENT_ID in (select ID 
						from STUDENTS
						where GENDER = 'f')
group by EXAM_DATE
having AVG(MARK) <> (select (MAX(MARK) + MIN(MARK) ) / 2
						from EXAM_MARKS)
order by SUM_MARKS desc;

-- 7. Покажите имена и фамилии всех студентов, у которых средний балл по предметам
--    с идентификаторами 1 и 2 превышает средний балл этого же студента
--    по всем остальным предметам. Используйте вложенные подзапросы, а также конструкцию
--    AVG(case...), либо коррелирующий подзапрос.
--    Примечание: может так оказаться, что по "остальным" предметам (не 1ый и не 2ой) не было
--    получено ни одной оценки, в таком случае принять средний бал за 0 - для этого можно
--    использовать функцию ISNULL().

-- не поняла 

-- 8. Напишите запрос, выполняющий вывод общего суммарного и среднего баллов каждого 
--    экзаменованого второкурсника, его идентификатор и кол-во полученных оценок при условии, 
--    что он успешно сдал 3 и более предметов.

select STUDENT_ID 
      ,SUM(MARK) as summary
      ,AVG(MARK) as average
	  ,count(MARK) as quantity

from EXAM_MARKS
where STUDENT_ID in(	  
	  select id
	  from STUDENTS
	  where COURSE = 2
) and MARK > 2
group by
	student_id
having count(distinct subj_id) >= 3 
order by
	student_id;

-- 9. Вывести названия всех предметов, средний балл которых превышает средний балл по всем 
--    предметам университетов г.Днепра. Используйте вложенные подзапросы.

select ID
from UNIVERSITIES 
where CITY = 'Днепр'

select ID
from STUDENTS
where UNIV_ID in (select ID
                   from UNIVERSITIES 
                    where CITY = 'Днепр')
select *
from EXAM_MARKS
where STUDENT_ID in(select ID
from STUDENTS
where UNIV_ID in (select ID
                   from UNIVERSITIES 
                    where CITY = 'Днепр'
					)
					)
select SUBJ_ID, avg (MARK)
from EXAM_MARKS
group by SUBJ_ID


select avg(mark)
     from EXAM_MARKS
        where STUDENT_ID in(select ID
                              from STUDENTS
                                where UNIV_ID in (select ID
                                                    from UNIVERSITIES 
                                                      where CITY = 'Днепр'
					)
					)

select SUBJ_ID
from (select SUBJ_ID, avg (MARK) as avg_mark
          from EXAM_MARKS
            group by SUBJ_ID
	 ) as yes
where avg_mark > (select avg(mark)
     from EXAM_MARKS
        where STUDENT_ID in(select ID
                              from STUDENTS
                                where UNIV_ID in (select ID
                                                    from UNIVERSITIES 
                                                      where CITY = 'Днепр'
					)
					))

select NAME 
from SUBJECTS
where ID in (select SUBJ_ID
from (select SUBJ_ID, avg (MARK) as avg_mark
          from EXAM_MARKS
            group by SUBJ_ID
	 ) as yes
where avg_mark > (select avg(mark)
     from EXAM_MARKS
        where STUDENT_ID in(select ID
                              from STUDENTS
                                where UNIV_ID in (select ID
                                                    from UNIVERSITIES 
                                                      where CITY = 'Днепр'
					)
					))
)
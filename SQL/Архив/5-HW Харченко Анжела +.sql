-- 0. Отобразите для каждого из курсов количество парней и девушек. 

select COURSE
		, GENDER
		, COUNT(*) as GENDER_Quantity
from STUDENTS
group by COURSE, GENDER
order by COURSE, GENDER;
-- sum(case gender
--			when 'm' then 1
--			else null
--     end

-- 1. Напишите запрос для таблицы EXAM_MARKS, выдающий даты, для которых средний балл 
--    находиться в диапазоне от 4.22 до 4.77. Формат даты для вывода на экран: 
--    день месяць, например, 05 Jun.

select LEFT(CONVERT(nvarchar(10), EXAM_DATE, 6), 6)	
		/*, AVG(MARK) */		
from EXAM_MARKS
group by EXAM_DATE
having AVG(MARK) BETWEEN 4.22 AND 4.77;

-- 2. Напишите запрос, который по таблице EXAM_MARKS позволяет найти период времени,
--    в течении которого студент сдавал сессию, количество сдаваемых предметов, количество пересдач, 
--	  а также их максимальные и минимальные оценки. В выборке дожлен присутствовать идентификатор студента.
--    Примечание: таблица оценок - покрывает одну сессию, промежуток времени -
--    количество дней, которые провел студент на этой сессии - от первого до 
--    последнего экзамена включительно
--    Примечание-2: функция DAY() для решения не подходит! 

select STUDENT_ID
		, DATEDIFF(dd, MIN(EXAM_DATE), MAX(EXAM_DATE)) + 1	as Session_duration	--период времени, в течении которого студент сдавал сессию		
		, COUNT(SUBJ_ID) as Q_Subject	-- количество сдаваемых предметов
		, COUNT(case MARK
					when 2.000 then 1
				end) as Q_Retake_exam	-- количество пересдач
		, MAX(MARK) as MAX_Mark			-- максимальная оценка
		, MIN(MARK) as MIN_Mark			-- минимальная оценка
from EXAM_MARKS
group by STUDENT_ID
order by STUDENT_ID;

-- 3. Покажите список идентификаторов студентов, которые имеют пересдачи. 

select distinct STUDENT_ID
				/*, MARK */	
from EXAM_MARKS
where MARK = 2
order by STUDENT_ID;
-- это просто список студентов (без повторений), которые имеют пересдачи

-- 4. Напишите запрос, отображающий список предметов обучения, вычитываемых за самый короткий 
--    промежуток времени, отсортированный в порядке убывания семестров. Поле семестра в 
--    выходных данных должно быть первым, за ним должны следовать наименование и 
--    идентификатор предмета обучения.

select SEMESTER
		, NAME
		, ID	
		/*, HOURS */
from SUBJECTS
where HOURS = (select MIN(HOURS) 
					from SUBJECTS)
order by SEMESTER desc;

-- 5. Напишите запрос с подзапросом для получения данных обо всех положительных оценках(4, 5) Марины 
--    Шуст (предположим, что ее персональный номер неизвестен), идентификаторов предметов и дат 
--    их сдачи.

select MARK
		, SUBJ_ID
		, EXAM_DATE
		, STUDENT_ID 
from EXAM_MARKS
where MARK IN (4, 5)
			AND STUDENT_ID = (select ID 
								from STUDENTS
								where SURNAME = 'Шуст' AND NAME = 'Марина')

-- 6. Покажите сумму баллов для каждой даты сдачи экзаменов, при том, что средний балл не равен 
--    среднему арифметическому между максимальной и минимальной оценкой. Данные расчитать только 
--    для студенток. Результат выведите в порядке убывания сумм баллов, а дату в формате dd/mm/yyyy.

select CONVERT(nvarchar(10), EXAM_DATE, 103)
		, SUM(MARK) as SUM_MARKS
from EXAM_MARKS
where STUDENT_ID IN (select ID 
						from STUDENTS
						where GENDER = 'f') -- только для студенток
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

select SURNAME
		, NAME
		, ID
from STUDENTS S
where S.ID = (select STUDENT_ID
				from EXAM_MARKS
					where STUDENT_ID = S.ID	AND SUBJ_ID IN (1, 2)			
				group by STUDENT_ID
				having AVG(MARK) > (select ISNULL(AVG(MARK), 0)
										from EXAM_MARKS
										where STUDENT_ID = S.ID AND (SUBJ_ID NOT IN (1, 2))));

-- 8. Напишите запрос, выполняющий вывод общего суммарного и среднего баллов каждого 
--    экзаменованого второкурсника, его идентификатор и кол-во полученных оценок при условии, 
--    что он успешно сдал 3 и более предметов.

select SUM(MARK) as SUM_MARK
		, AVG(MARK) as AVG_MARK
		, STUDENT_ID
		, COUNT(MARK) as Quantity_MARK
from EXAM_MARKS
where STUDENT_ID IN (select ID 
						from STUDENTS
						where COURSE = 2)	-- второкурсник 'm'/'f' 
				AND MARK IN (4, 5) -- успешно сдал включает оценку 3
group by STUDENT_ID
having COUNT(SUBJ_ID) >= 3; -- COUNT(distinct SUBJ_ID) чтобы исключить пересдачи

-- 9. Вывести названия всех предметов, средний балл которых превышает средний балл по всем 
--    предметам университетов г.Днепра. Используйте вложенные подзапросы.

select NAME
		/*, SUBJECTS.ID */
from SUBJECTS 
where SUBJECTS.ID IN (select EM.SUBJ_ID
						from EXAM_MARKS EM
						where EM.SUBJ_ID = SUBJECTS.ID
						group by EM.SUBJ_ID
						having AVG(MARK) > 
(select AVG(MARK)
	from EXAM_MARKS EM
	where EM.SUBJ_ID IN (select SUBJECTS.ID
							from SUBJECTS
							where SUBJECTS.ID IN (select SUBJ_ID
													from SUBJ_LECT
													where LECTURER_ID IN (select L.ID
																			from LECTURERS L
																			where L.UNIV_ID IN (select U.ID
																								from UNIVERSITIES U
																								where U.CITY = 'Днепр'))))));
-- не правильно. Сегодня на занятии рассмотрим
/*
select SUBJ_ID, AVG(MARK)
from EXAM_MARKS
group by SUBJ_ID; */

/*
----------------------------------
-- 'Днепр' AVG(MARK) = 3.264705
----------------------------------
select AVG(MARK)
	from EXAM_MARKS EM
	where EM.SUBJ_ID IN (select SUBJECTS.ID
							from SUBJECTS
							where SUBJECTS.ID IN (select SUBJ_ID
													from SUBJ_LECT
													where LECTURER_ID IN (select L.ID
																			from LECTURERS L
																			where L.UNIV_ID IN (select U.ID
																								from UNIVERSITIES U
																								where U.CITY = 'Днепр')))); */
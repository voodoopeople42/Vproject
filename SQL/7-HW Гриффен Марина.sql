-- 1. Напишите запрос, выдающий список фамилий преподавателей английского
--    языка с названиями университетов, в которых они преподают.
--    Отсортируйте запрос по городу, где расположен университ, а
--    затем по фамилии лектора.

 select SURNAME
      ,UNIVERSITIES.NAME
from LECTURERS
 join SUBJ_LECT on LECTURERS.ID=SUBJ_LECT.LECTURER_ID
 join SUBJECTS on SUBJECTS.ID=SUBJ_LECT.SUBJ_ID
 join UNIVERSITIES on LECTURERS.UNIV_ID=UNIVERSITIES.ID
where SUBJECTS.NAME = 'Английский'
order by UNIVERSITIES.CITY
        ,LECTURERS.SURNAME
	

-- 2. Напишите запрос, который выполняет вывод данных о фамилиях, сдававших экзамены 
--    студентов, учащихся в Б.Церкви, вместе с наименованием каждого сданного ими предмета, 
--    оценкой и датой сдачи.

select SURNAME
      ,SUBJECTS.NAME
	  ,MARK
	  , EXAM_DATE
	  ,(select city from UNIVERSITIES
where CITY =  ('Белая Церковь'))
from EXAM_MARKS join students on students.id = exam_marks.student_id 
                join subjects on subjects.id = exam_marks.subj_id
			   

-- 3. Используя оператор JOIN, выведите объединенный список городов с указанием количества 
--    учащихся в них студентов и преподающих там же преподавателей.

-- 		Задачу нужно нужно понимать так: вывести  список городов, в которых расположены университеты. Для каждого 
-- 		такого города указать количество студентов обучающихся в этом городе всесте с количеством преподавателей
-- 		преподающих в этом городе

-- 4. Напишите запрос который выдает фамилии всех преподавателей и наименование предметов,
--    которые они читают в КПИ

select SURNAME
      ,SUBJECTS.NAME
from LECTURERS
 join SUBJ_LECT on LECTURERS.ID=SUBJ_LECT.LECTURER_ID
 join SUBJECTS on SUBJECTS.ID=SUBJ_LECT.SUBJ_ID
 join UNIVERSITIES on LECTURERS.UNIV_ID=UNIVERSITIES.ID
where UNIVERSITIES.NAME='КПИ'

 
-- 5. Покажите всех студентов-двоешников, кто получил только неудовлетворительные оценки (2) 
--    и по каким предметам, а также тех кто не сдал ни одного экзамена. 
--    В выходных данных должны быть приведены фамилии студентов, названия предметов и 
--    оценка, если оценки нет, заменить ее на прочерк.

select STUDENTS.SURNAME
      ,SUBJECTS.NAME
	  ,MARK
	from EXAM_MARKS
	join STUDENTS on STUDENTS.ID = EXAM_MARKS.STUDENT_ID
	join SUBJECTS on SUBJECTS.ID = EXAM_MARKS.SUBJ_ID and EXAM_MARKS.MARK = 2

-- 6. Напишите запрос, который выполняет вывод списка университетов с рейтингом, 
--    превышающим 490, вместе со значением максимального размера стипендии, 
--    получаемой студентами в этих университетах.

select UNIVERSITIES.NAME
	  ,STUDENTS.STIPEND
	from UNIVERSITIES cross join STUDENTS
	where  UNIVERSITIES.RATING > 490 and STUDENTS.STIPEND = (select  max (STUDENTS.STIPEND) from STUDENTS)

-- 7. Расчитать средний бал по оценкам студентов для каждого университета, 
--    умноженный на 100, округленный до целого, и вычислить разницу с текущим значением
--    рейтинга университета.

 select
  u.NAME
  ,cast((round(avg(mark), 2)*100) as int) as 'NEW_RATING'
  ,cast((u.rating - round(avg(mark), 2)*100) as int) as 'DELTA'
from UNIVERSITIES as u
   join STUDENTS as s on s.UNIV_ID=u.id
   join EXAM_MARKS as em on em.STUDENT_ID=s.ID
group by u.NAME, u.RATING;

-- 8. Написать запрос, выдающий список всех фамилий лекторов из Киева попарно. 
--    При этом не включать в список комбинации фамилий самих с собой,
--    то есть комбинацию типа "Коцюба-Коцюба", а также комбинации фамилий, 
--    отличающиеся порядком следования, т.е. включать лишь одну из двух 
--    комбинаций типа "Хижна-Коцюба" или "Коцюба-Хижна".

select lec.SURNAME + '-' + lc.SURNAME
	from LECTURERS as lec join LECTURERS as lc on lec.ID <> lc.ID
	where lec.CITY = 'Киев' and lc.CITY = 'Киев'


-- 9. Выдать информацию о всех университетах, всех предметах и фамилиях преподавателей, 
--    если в университете для конкретного предмета преподаватель отсутствует, то его фамилию
--    вывести на экран как прочерк '-' (воспользуйтесь ф-ей isnull)

-- 10. Кто из преподавателей и сколько поставил пятерок за свой предмет?



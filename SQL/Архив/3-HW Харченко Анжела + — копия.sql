--  !!! В выходной выборке должны присутствовать только запрашиваемые в условии поля.

-- 1. Напишите один запрос с использованием псевдонимов для таблиц и псевдонимов полей, 
--    выбирающий все возможные комбинации городов (CITY) из таблиц 
--    STUDENTS, LECTURERS и UNIVERSITIES
--    строки не должны повторяться, убедитесь в выводе только уникальных троек городов
--    Внимание: убедитесь, что каждая колонка выборки имеет свое уникальное имя
select distinct 
	S.CITY as "Город_Студенты"
	,L.CITY as "Город_Преподаватели"
	,U.CITY as "Город_Университеты"
from STUDENTS as S, LECTURERS as L, UNIVERSITIES as U
order by S.CITY, L.CITY, U.CITY;

-- 2. Напишите запрос для вывода полей в следущем порядке: семестр, в котором он
--    читается, идентификатора (номера ID) предмета обучения, его наименования и 
--    количества отводимых на этот предмет часов для всех строк таблицы SUBJECTS
select 
	SEMESTER	--семестр
	,ID		--идентификатор (номер ID) предмета обучения
	,NAME --наименование предмета обучения
	,HOURS --количество часов, отводимых на предмета обучения
from SUBJECTS
order by SEMESTER, ID, NAME;

-- 3. Выведите все строки таблицы EXAM_MARKS, в которых предмет обучения SUBJ_ID равен 4
select 
	SUBJ_ID
	/* * */ -- а можно было бы воспользоваться строчным комментарием
from EXAM_MARKS
where SUBJ_ID = 4;

-- 4. Необходимо выбирать все данные, в следующем порядке 
--    Стипендия, Курс, Фамилия, Имя  из таблицы STUDENTS, причем интересуют
--    студенты, родившиеся после '1993-07-21'
select 
	STIPEND as "Стипендия"
	,COURSE as "Курс"
	,SURNAME as "Фамилия"
	,NAME as "Имя"
	/*,BIRTHDAY as "Д.р. > '1993-07-21'"*/
from STUDENTS
where BIRTHDAY > '1993-07-21'
order by BIRTHDAY, SURNAME, NAME;

-- 5. Вывести на экран все предметы: их наименования и кол-во часов для каждого из них
--    в 1-м семестре и при этом кол-во часов не должно превышать 41
select 
	NAME as "Предмет"
	,HOURS "Кол-во часов"
	/*,SEMESTER	*/
from SUBJECTS
where SEMESTER = 1 AND HOURS <= 41;

-- 6. Напишите запрос, позволяющий вывести из таблицы EXAM_MARKS уникальные 
--    значения экзаменационных оценок, которые были получены '2012-06-12'
select distinct 
	MARK as "Экзаменационные оценки"
	/*,EXAM_DATE*/
from EXAM_MARKS
where EXAM_DATE = '2012-06-12';

-- 7. Выведите список фамилий студентов, обучающихся на третьем и последующих 
--    курсах и при этом проживающих не в Киеве, не Харькове и не Львове.
select
	SURNAME
	/*,COURSE
	,CITY*/
from STUDENTS
where COURSE >= 3 AND NOT CITY IN ('Киев', 'Харьков', 'Львов')
order by COURSE, SURNAME;

-- 8. Покажите данные о фамилии, имени и номере курса для студентов, 
--    получающих стипендию в диапазоне от 450 до 650, не включая 
--    эти граничные суммы. Приведите несколько вариантов решения этой задачи.

--Вариает №1 (Полнота = 100%)
select
	SURNAME as "Фамилия"
	,NAME as "Имя"
	,COURSE as "Курс"
	/*,STIPEND as "Стипендия"*/
from STUDENTS
where STIPEND > 450 AND STIPEND < 650
order by COURSE, STIPEND desc, SURNAME, NAME;

--Вариает №2 (Полнота = 100%)
select
	SURNAME as "Фамилия"
	,NAME as "Имя"
	,COURSE as "Курс"
	/*,STIPEND as "Стипендия"*/
from STUDENTS
where STIPEND BETWEEN 450.01 AND 649.99
order by COURSE, STIPEND desc, SURNAME, NAME;

--Вариает №3 (Полнота = 100%) -- ну тут вы явно перемудрили)))
select
	SURNAME as "Фамилия"
	,NAME as "Имя"
	,COURSE as "Курс"
	/*,STIPEND as "Стипендия"*/
from STUDENTS
where STIPEND NOT IN (select distinct STIPEND
						from STUDENTS
						where STIPEND <= 450 OR STIPEND >= 650)
order by COURSE, STIPEND desc, SURNAME, NAME;

-- 9. Напишите запрос, выполняющий выборку из таблицы LECTURERS всех фамилий
--    преподавателей, проживающих во Львове, либо же преподающих в университете
--    с идентификатором 14
select
	SURNAME as "Фамилия Преподавателя"
	/*,CITY as "Город проживания"
	,UNIV_ID as "Идентификатор Университета"*/
from LECTURERS
where CITY = 'Львов' OR UNIV_ID = 14
order by SURNAME;

-- 10. Выясните в каких городах (названия) расположены университеты,  
--     рейтинг которых составляет 528 +/- 47 баллов.
select
	CITY as "Расположение Университета"
	/*,NAME as "Университет"
	,RATING as "Рейтинг Университета"*/
from UNIVERSITIES
where RATING BETWEEN (528 - 47) AND (528 + 47)
order by CITY, RATING desc;

-- 11. Отобрать список фамилий студентов родившихся в Киеве, их имен и дат рождений 
--     для всех нечетных курсов.
select
	SURNAME as "Фамилия"
	,NAME as "Имя"
	,BIRTHDAY as "Дата рождения"
	/*,CITY as "Город"
	,COURSE as "Курс"*/
from STUDENTS
where 
	CITY = 'Киев'
	AND 
	COURSE%2 = 1 /*для всех нечетных курсов*/
order by COURSE, SURNAME, NAME, BIRTHDAY;

-- 12. Упростите выражение фильтрации (избавтесь от NOT) и дайте логическую формулировку запроса?
-- SELECT * FROM STUDENTS WHERE (STIPEND < 500 OR NOT (BIRTHDAY >= '1993-01-01' AND ID > 9))
-- Подсказка: после упрощения, запрос должен возвращать ту же выборку, что и оригинальный

 /*SELECT * 
 FROM STUDENTS 
 WHERE (STIPEND < 500 OR NOT (BIRTHDAY >= '1993-01-01' AND ID > 9));*/

-- Решение:
-- Применяем Правило Де Моргана для для упрощения выражения:
-- NOT (BIRTHDAY >= '1993-01-01' AND ID > 9) = ¬(𝑎 ⋀ 𝑏)= ¬𝑎 ⋁ ¬𝑏
/*Текст запроса*/
-- Напишите запрос для вывода всех полей таблицы STUDENTS, в котором результирующие записи удовлетворяют следующим условиям:
-- 1) Стипендия студента не превышает 500
-- "ИЛИ" 
-- 2) Дата рождения Студента меньше '1993-01-01'
-- "ИЛИ"
-- 3) Идентификатор Студента меньше или равен 9.

SELECT * 
 FROM STUDENTS 
 WHERE STIPEND < 500 OR BIRTHDAY < '1993-01-01' OR ID <= 9;

 -- 13. Упростите выражение фильтрации (избавтесь от NOT) и дайте логическую формулировку запроса?
-- SELECT * FROM STUDENTS WHERE NOT ((BIRTHDAY = '1993-06-07' OR STIPEND > 500) AND ID >= 9)
-- Подсказка: после упрощения, запрос должен возвращать ту же выборку, что и оригинальный

SELECT * 
FROM STUDENTS 
WHERE NOT ((BIRTHDAY = '1993-06-07' OR STIPEND > 500) AND ID >= 9);

-- Решение:
/* Правила Де Моргана
 ¬(𝑎 ⋀ 𝑏)= ¬𝑎 ⋁ ¬𝑏
 ¬(𝑎 ⋁ 𝑏)= ¬𝑎 ⋀ ¬𝑏 */
-- Последовательно применяем Правила Де Моргана для упрощения выражения: 
-- NOT ((BIRTHDAY = '1993-06-07' OR STIPEND > 500) AND ID >= 9) = ¬((𝑎 ⋁ 𝑏) ⋀ c) = ¬(𝑎 ⋁ 𝑏) ⋁ ¬c = (¬𝑎 ⋀ ¬𝑏) ⋁ ¬c
/*Текст запроса*/
-- Напишите запрос для вывода всех полей таблицы STUDENTS, в котором результирующие записи удовлетворяют следующим условиям:
-- 1) Дата рождения Студента не равна дате '1993-01-01' "И" Стипендия студента не превышает 500
-- "ИЛИ" 
-- 2) Идентификатор Студента меньше 9.

SELECT * 
FROM STUDENTS 
WHERE (BIRTHDAY <> '1993-06-07' AND STIPEND <= 500) OR ID < 9;
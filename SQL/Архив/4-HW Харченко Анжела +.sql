-- Внимание! Во всех результирующих выборках должны быть учтены все записи, даже
-- те, которые содержать NULL поля, однако, склейка не должна быть NULL записью!
-- Для этого используйте либо CASE, либо функцию 
-- ISNULL(<выражение>, <значение по умолчанию>) -- Microsoft SQL Server
-- IFNULL(<выражение>, <значение по умолчанию>) -- MySQL
-- COALESCE(<выражение>, <значение по умолчанию>) -- ANSI SQL (стандарт)
-- Соблюдать это условие достаточно для двух полей BIRTHDAY и UNIV_ID.
-- В качестве <значения по умолчания> используйте строку 'unknown'.

-- 1. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала один столбец типа varchar, содержащий последовательность разделенных 
--    символом ';' (точка с запятой) значений столбцов этой таблицы, и при этом 
--    текстовые значения должны отображаться прописными символами (верхний регистр), 
--    то есть быть представленными в следующем виде: 
--    1;КАБАНОВ;ВИТАЛИЙ;M;550;4;ХАРЬКОВ;01/12/1990;2.
--    ...
--    примечание: в выборку должны попасть студенты из любого города из 5 букв
select CONCAT(ID, ';'
				, UPPER(SURNAME), ';'
				, UPPER(NAME), ';'
				, UPPER(GENDER), ';'
				, CAST(ROUND(STIPEND, 0) as int), ';'
				, COURSE, ';'				
				, UPPER(CITY), ';'
				, ISNULL(CONVERT(nvarchar(10), BIRTHDAY, 103), '<unknown>'), ';'
				, ISNULL(CONVERT(nvarchar(10), UNIV_ID), '<unknown>'), '.') as "Выходная таблица"	
from STUDENTS
where LEN(CITY) = 5;

-- 2. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде: 
--    В.КАБАНОВ;местожительства-ХАРЬКОВ;родился-01.12.90
--    ...
--    примечание: в выборку должны попасть студенты, фамилия которых содержит вторую
--    букву 'е' и предпоследнюю букву 'и', либо же фамилия заканчивается на 'ц'
select CONCAT(LEFT(NAME, 1), '.'
				, UPPER(SURNAME), ';'
				, 'местожительства-'								
				, UPPER(CITY), ';'
				, case GENDER -- по условию задачи это самодеятельность, но вам + в карму )))
					when 'm' then 'родился-'
					when 'f' then 'родилась-'
				  end
				, ISNULL(CONVERT(nvarchar(10), BIRTHDAY, 4), '<unknown>')) as "Выходная таблица"	
				/*, ID */
from STUDENTS
where SURNAME LIKE '_е%и_' OR SURNAME LIKE '%ц';

-- 3. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    т.цилюрик;местожительства-Херсон; учится на IV курсе
--    ...
--    примечание: курс указать римскими цифрами (воспользуйтесь CASE), 
--    отобрать студентов, стипендия которых кратна 200
select CONCAT(LEFT(LOWER(NAME), 1), '.'
			, LOWER(SURNAME), ';'
			, 'местожительства-'
			, CITY, ';'
			, '  учится  на  '
			, case
				when COURSE = 1 then 'I'
				when COURSE = 2 then 'II'
				when COURSE = 3 then 'III'
				when COURSE = 4 then 'IV'
				when COURSE = 5 then 'V'
			  end
			,'  курсе ') as "Выходная таблица"	
from STUDENTS
where STIPEND % 200 = 0;

-- 4. Составьте запрос для таблицы STUDENT таким образом, чтобы выборка 
--    содержала столбец в следующего вида:
--     Нина Федосеева из г.Днепропетровск родилась в 1992 году
--     ...
--     Дмитрий Коваленко из г.Хмельницкий родился в 1993 году
--     ...
--     примечание: для всех городов, в которых более 8 букв

select CONCAT(NAME, ' '
				, SURNAME, '  из  г.'								
				, CITY
				, case GENDER
					when 'm' then '  родился  в  '
					when 'f' then '  родилась  в  '
				  end
				, ISNULL(CONVERT(nvarchar(10), YEAR(BIRTHDAY), 101), '<unknown>')
				, '  году') as "Выходная таблица"	
				/*, id */
from STUDENTS
where LEN(CITY) > 8;

-- 5. Вывести фамилии, имена студентов и величину получаемых ими стипендий, 
--    при этом значения стипендий первокурсников должны быть увеличены на 17.5%

select SURNAME
		, NAME
		/*, COURSE
		, STIPEND */	
		, case COURSE
			when 1 then CAST(STIPEND * (1 + 17.5/100) as decimal(18,2))
			else STIPEND
		  end as STIPEND_Updated
from STUDENTS;

-- 6. Вывести наименования всех учебных заведений и их расстояния 
--    (придумать/нагуглить/взять на глаз) до Киева.

select NAME as "Наименование Университета"
				/*, CITY as "Город_Университеты" */
				, case Name
					when 'БНАУ' then 84
					when 'ДПИ' then 450
					when 'ДНТУ' then 693
					when 'ЗДИА' then 512
					when 'ЛГУ' then 533
					when 'ЛПУ' then 540
					when 'ОНПУ' then 472
					when 'ТНТУ' then 416
					when 'ХАИ' then 472
					when 'ХНАДУ' then 480
					when 'ХСХА' then 533
				  end as 'Расстояние до Киева, км'
from UNIVERSITIES
where CITY <> 'Киев' /* исключаем из result set записи с Городом "Киев" */
order by CITY, NAME;

-- 7. Вывести все учебные заведения и их две последние цифры рейтинга.

select distinct NAME as "Наименование Университета"
				/*, RATING as "Рейтинг Университета" */
				, RIGHT(CONVERT(nvarchar(10), RATING), 2) as RATING_Truncated				 		
from UNIVERSITIES
order by NAME;

-- 8. Составьте запрос для таблицы UNIVERSITY таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    Код-1;КПИ-г.Киев;Рейтинг относительно ДНТУ(501) +756
--    ...
--    Код-11;КНУСА-г.Киев;рейтинг относительно ДНТУ(501) -18
--    ...
--    примечание: рейтинг вычислить относительно ДНТУшного, а также должен 
--    присутствовать знак (+/-), рейтинг ДНТУ заранее известен = 501

select CONCAT('Код-',ID, ';'
				, NAME 
				, '-г.', CITY, ';'
				/*, RATING */
				, case
					when RATING > 501 then 'Рейтинг  относительно  ДНТУ(501)  ' + '+' + CONVERT(nvarchar(10), (RATING - 501))
					when RATING < 501 then 'рейтинг  относительно  ДНТУ(501)  ' + CONVERT(nvarchar(10), (RATING - 501))
				  end) as "Выходная таблица"			
from UNIVERSITIES
where RATING <> 501 /* исключаем из result set запись с "ДНТУ" */
order by NAME;

-- 9. Составьте запрос для таблицы UNIVERSITY таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    Код-1;КПИ-г.Киев;рейтинг состоит из 12 сотен
--    Код-2;КНУ-г.Киев;рейтинг состоит из 6 сотен
--    ...
--    примечание: в рейтинге необходимо указать кол-во сотен

select CONCAT('Код-',ID, ';'
				, NAME 
				, '-г.', CITY, ';'
				/*, RATING */
				, 'рейтинг  состоит  из  ' + CONVERT(nvarchar(10), RATING/100) + '  сотен') as "Выходная таблица"			
from UNIVERSITIES
order by NAME;

-- 10	Получить список студентов, который содержит следующие поля
--		Фамилия студента
--		Дата рождения студента
--		Знак зодиака студента
--		информацию о знаках зодиака можно получить, например, здесь
--		http://astro101.ru/about-astrology/683-znaki-zodiaka-po-chislam-mesjacam-stihijam.html
--		для определения месяца в дате использовать функцию month(date). Например, если birthday равно '20-04-1998',
--		то  month(birthday) равно 4
--		для определения дня в дате использовать функцию day. day(birthday) равно 20
--		для значения NULL должно быть выведено значение 'Неизвестно'

-- вы первая предложили такое решение (+++)
select SURNAME as 'Фамилия студента'		
		, BIRTHDAY as 'Дата рождения студента'		
		/* case-выражение релевантно для невысокосного года и высокосного года */		
		, case
			when BIRTHDAY BETWEEN convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0321', 102) 
								AND convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0420', 102) then 'Овен'
			when BIRTHDAY BETWEEN convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0421', 102) 
								AND convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0520', 102) then 'Телец'
			when BIRTHDAY BETWEEN convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0521', 102) 
								AND convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0621', 102) then 'Близнецы'
			when BIRTHDAY BETWEEN convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0622', 102) 
								AND convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0722', 102) then 'Рак'
			when BIRTHDAY BETWEEN convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0723', 102) 
								AND convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0823', 102) then 'Лев'
			when BIRTHDAY BETWEEN convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0824', 102) 
								AND convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0923', 102) then 'Дева'
			when BIRTHDAY BETWEEN convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0924', 102) 
								AND convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '1023', 102) then 'Весы'
			when BIRTHDAY BETWEEN convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '1024', 102) 
								AND convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '1122', 102) then 'Скорпион'
			when BIRTHDAY BETWEEN convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '1123', 102) 
								AND convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '1221', 102) then 'Стрелец'
			when BIRTHDAY BETWEEN convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '1222', 102) 
								AND convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '1231', 102) then 'Козерог'
			when BIRTHDAY BETWEEN convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0101', 102) 
								AND convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0120', 102) then 'Козерог'
			when BIRTHDAY BETWEEN convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0121', 102) 
								AND convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0218', 102) then 'Водолей'
			when BIRTHDAY BETWEEN convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0219', 102) 
								AND convert(datetime, convert(nvarchar(10), YEAR(BIRTHDAY)) + '0320', 102) then 'Рыбы'
			when BIRTHDAY IS NULL then 'Неизвестно'	
											
		  end as 'Знак зодиака'
from STUDENTS
order by MONTH(BIRTHDAY), DAY(BIRTHDAY), YEAR(BIRTHDAY);
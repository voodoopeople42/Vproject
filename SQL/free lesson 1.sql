/***************************************************************************************/
/*                                                                                     */
/*                                          3-HW                                       */
/*                                                                                     */
/***************************************************************************************/
-- 3-HW-4. Необходимо выбирать все данные, в следующем порядке 
--    Стипендия, Курс, Фамилия, Имя  из таблицы STUDENTS, причем интересуют
--    студенты, родившиеся после '1993-07-21'
select 
	stipend
	,course
	,surname
	,name 
--	,birthday
from STUDENTS	
where birthday > '19930721';

-- ************************ Показать опастность неявных преобразований *******************
select 
	stipend
	,course
	,surname
	,name 
	,birthday
from STUDENTS	
where birthday > 1993-07-21;

select cast(getdate() as int);
select cast(43669 as datetime);

-- для MySql все сложнее
select unix_timestamp(current_date());
select from_unixtime(1547071200,'%Y-%m-%d'); 

-- 3-HW-9. Напишите запрос, выполняющий выборку из таблицы LECTURERS всех фамилий
--    преподавателей, проживающих во Львове, либо же преподающих в университете
--    с идентификатором 14
select
	surname
    --,univ_id
    --,city
from LECTURERS
where city = 'Львов' or univ_id = 14;

-- 3-HW-11. Отобрать список фамилий студентов родившихся в Киеве, их имен и дат рождений 
--     для всех нечетных курсов.
select
	surname
	,name
	,birthday
--	,course
from STUDENTS
where course % 2 <> 0 and city = 'Киев'

-- 3-HW-13. Упростите выражение фильтрации (избавтесь от NOT) и дайте логическую формулировку запроса?
-- SELECT * FROM STUDENTS WHERE NOT ((BIRTHDAY = '1993-06-07' OR STIPEND > 500) AND ID >= 9)
-- Подсказка: после упрощения, запрос должен возвращать ту же выборку, что и оригинальный
select
	*
from STUDENTS
where not((BIRTHDAY = '19930607' or STIPEND > 500) and ID >= 9);

-- шаг первый. Вносим not в скобки
select
	*
from STUDENTS
where (not (BIRTHDAY = '19930607' or STIPEND > 500) or ID < 9);

-- шаг второй. Вносим not во внутренние скобки
select
	*
from STUDENTS
where ((BIRTHDAY <> '19930607' and STIPEND <= 500) or ID < 9);

-- шаг третий. Используя знания о приоритетности операторов избавляемся от скобок
select
	*
from STUDENTS
where (BIRTHDAY <> '19930607' and STIPEND <= 500 or ID < 9);

/***************************************************************************************/
/*                                                                                     */
/*                                          4-HW                                       */
/*                                                                                     */
/***************************************************************************************/
-- 4-HW-1. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала один столбец типа varchar, содержащий последовательность разделенных 
--    символом ';' (точка с запятой) значений столбцов этой таблицы, и при этом 
--    текстовые значения должны отображаться прописными символами (верхний регистр), 
--    то есть быть представленными в следующем виде: 
--    1;КАБАНОВ;ВИТАЛИЙ;M;550;4;ХАРЬКОВ;01/12/1990;2.
--    ...
--    примечание: в выборку должны попасть студенты из любого города из 5 букв
-- шаг 1
select
	ID
	,SURNAME
	,NAME
	,GENDER
	,STIPEND
	,COURSE
	,CITY
	,BIRTHDAY
	,UNIV_ID
from STUDENTS
where len(CITY) = 5

-- шаг 2
select
	ID
	,UPPER(SURNAME)
	,UPPER(NAME)
	,UPPER(GENDER)
	,STIPEND
	,COURSE
	,UPPER(CITY)
	,convert(nvarchar(10), BIRTHDAY, 103)
	,UNIV_ID
from STUDENTS
where len(CITY) = 5

-- шаг 3. Ошибка 
select
	cast(ID as varchar(3))
	,UPPER(SURNAME)
	,UPPER(NAME)
	,UPPER(GENDER)
	,cast(STIPEND as varchar(5))	-- <<< ошибка здесь
	,cast(COURSE as varchar(2))
	,UPPER(CITY)
	,convert(nvarchar(10), BIRTHDAY, 103)
	,cast(UNIV_ID as varchar(3))
from STUDENTS
where len(CITY) = 5

-- шаг 4. Ошибка 
select
	cast(ID as varchar(3))
	,UPPER(SURNAME)
	,UPPER(NAME)
	,UPPER(GENDER)
	,cast(STIPEND as varchar(6))
	,cast(COURSE as varchar(2))
	,UPPER(CITY)
	,convert(nvarchar(10), BIRTHDAY, 103)
	,cast(isnull(UNIV_ID, 'Unknown') as varchar(7)) -- <<< Ошибка здесь
from STUDENTS
where len(CITY) = 5

-- шаг 5.  
select
	cast(ID as varchar(3))
	,UPPER(SURNAME)
	,UPPER(NAME)
	,UPPER(GENDER)
	,cast(STIPEND as varchar(6))
	,cast(COURSE as varchar(2))
	,UPPER(CITY)
	,isnull(convert(nvarchar(10), BIRTHDAY, 103), 'Unknown')
	,isnull(cast(UNIV_ID as varchar(7)), 'Unknown')
from STUDENTS
where len(CITY) = 5;

-- для MySQL
select
	cast(ID as char(3))
	,UPPER(SURNAME)
	,UPPER(NAME)
	,UPPER(GENDER)
	,cast(STIPEND as char(6))
	,cast(COURSE as char(2))
	,UPPER(CITY)
	,ifnull(date_format(BIRTHDAY, '%d-%m-%Y'), 'Unknown') as bd
	,ifnull(cast(UNIV_ID as char(7)), 'Unknown') as univ_id
from STUDENTS
where character_length(CITY) = 5;


-- шаг 6.  
select
	concat(
		cast(ID as varchar(3))
		,';',UPPER(SURNAME)
		,';',UPPER(NAME)
		,';',UPPER(GENDER)
		,';',cast(STIPEND as varchar(6))
		,';',cast(COURSE as varchar(2))
		,';',UPPER(CITY)
		,';',isnull(convert(nvarchar(10), BIRTHDAY, 103), 'Unknown')
		,';',isnull(cast(UNIV_ID as varchar(7)), 'Unknown')
	)
from STUDENTS
where len(CITY) = 5;

-- шаг 7. Оптимизация
select
	upper(concat(
		cast(ID as varchar(3))
		,';',SURNAME
		,';',NAME
		,';',GENDER
		,';',cast(STIPEND as varchar(6))
		,';',cast(COURSE as varchar(2))
		,';',CITY
		,';',isnull(convert(nvarchar(10), BIRTHDAY, 103), 'Unknown')
		,';',isnull(cast(UNIV_ID as varchar(7)), 'Unknown')
	))
from STUDENTS
where len(CITY) = 5;


-- для MySQL
select
	upper(concat(
		cast(ID as char(3)), ' '
		,SURNAME, ' '
		,NAME, ' '
		,GENDER, ' '
		,cast(STIPEND as char(6)), ' '
		,cast(COURSE as char(2)), ' '
		,CITY, ' '
		,ifnull(date_format(BIRTHDAY, '%d-%m-%Y'), 'Unknown'), ' '
		,ifnull(cast(UNIV_ID as char(7)), 'Unknown'), ' '
	)) as fld
from STUDENTS
where character_length(CITY) = 5;

-- 4-HW-2. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде: 
--    В.КАБАНОВ;местожительства-ХАРЬКОВ;родился-01.12.90
--    ...
--    примечание: в выборку должны попасть студенты, фамилия которых содержит вторую
--    букву 'е' и предпоследнюю букву 'и', либо же фамилия заканчивается на 'ц'


select 		
	concat (
		left (name, 1)
		, '.'
		, upper (surname)
		, ';'
		, 'местожительства-'
		, upper (city)
		, ';'
		, 'родился-'
		, coalesce(convert (varchar(10), birthday, 4), 'unknown')		
	) as 'st_info'
from 
	STUDENTS
where
	surname like '_е%и_' or surname like '%ц';

-- 4-HW-3. Составьте запрос для таблицы STUDENT таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    т.цилюрик;местожительства-Херсон; учится на IV курсе
--    ...
--    примечание: курс указать римскими цифрами (воспользуйтесь CASE), 
--    отобрать студентов, стипендия которых кратна 200
select
	concat (
		lower (left (name, 1))
		, '.'
		, lower (surname)
		, ';'
		, 'местожительства-'
		, city
		, '; учится на '
		, case course
			when 1 then 'I'
			when 2 then 'II'
			when 3 then 'III'
			when 4 then 'IV'
			when 5 then 'V'
			else 'wrong course'
		end
		, ' курсе'
	)	
as 'st_info'
from 
	STUDENTS
where
	stipend % 200 = 0;


-- 4-HW-5. Вывести фамилии, имена студентов и величину получаемых ими стипендий, 
--    при этом значения стипендий первокурсников должны быть увеличены на 17.5%

--1 шаг
select
	surname
	,name
	,stipend
	,course
from STUDENTS;

-- 2 шаг
select
	surname
	,name
	, case course
		when 1 then stipend * 1.175
		else stipend
	end as stipend
	,stipend as stipend_original
	,course
from STUDENTS;

-- 3 шаг
select
	surname
	,name
	, case course
		when 1 then stipend * 1.175
		else stipend
	end as stipend
	--,stipend as stipend_original
	--,course
from STUDENTS;

-- 4-HW-7. Вывести все учебные заведения и их две последние цифры рейтинга.
select
	name
   ,right(rating,2) last_2_dig
from UNIVERSITIES;

select
	name
   ,right(cast(rating as varchar(10)),2) last_2_dig
from UNIVERSITIES;

-- 4-HW-8. Составьте запрос для таблицы UNIVERSITY таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    Код-1;КПИ-г.Киев;Рейтинг относительно ДНТУ(501) +756
--    ...
--    Код-11;КНУСА-г.Киев;рейтинг относительно ДНТУ(501) -18
--    ...
--    примечание: рейтинг вычислить относительно ДНТУшного, а также должен 
--    присутствовать знак (+/-), рейтинг ДНТУ заранее известен = 501

-- шаг 1
select
	'Код-'
	+ CAST(ID as varchar)
	+ ';'
	+ NAME
	+ '-г.'
	+ CITY
	+ ';рейтинг относительно ДНТУ(501) '
	+ CAST(RATING - 501 as varchar) as UNIV_INFO
from UNIVERSITIES;

-- шаг 2
select
	'Код-'
	+ CAST(ID as varchar)
	+ ';'
	+ NAME
	+ '-г.'
	+ CITY
	+ ';рейтинг относительно ДНТУ(501) '
	+ case
		when RATING - 501 > 0 then '+'
		else ''
	  end
	+ CAST(RATING - 501 as varchar) as UNIV_INFO
from UNIVERSITIES;

-- 4-HW-9. Составьте запрос для таблицы UNIVERSITY таким образом, чтобы выходная таблица 
--    содержала всего один столбец в следующем виде:
--    Код-1;КПИ-г.Киев;рейтинг состоит из 12 сотен
--    Код-2;КНУ-г.Киев;рейтинг состоит из 6 сотен
--    ...
--    примечание: в рейтинге необходимо указать кол-во сотен
select 
	'Код-' 
	+ cast(id as varchar(3)) + ';'
	+ NAME + '-г.' + CITY +  ';рейтинг состоит из '
	+ cast(floor(RATING / 100.) as varchar(2)) + ' сотен' as col1
--    ,rating
from UNIVERSITIES;

-- для MySQL
select 
	concat(
		'Код-' 
		,cast(id as char(3)) + ';'
		,NAME
		,'-г.'
		, CITY
		, ';рейтинг состоит из '
		, cast(floor(RATING / 100.) as char(2)) 
		, ' сотен')
from UNIVERSITIES;

-- рассмотреть!
select 
	199 / 10
	,ceiling(199 / 10)
	,floor(199 /10);

select 
	199.0 / 10
	,ceiling(199.0 / 10)
	,floor(199.0 /10);


/***************************************************************************************/
/*                                                                                     */
/*                                          5-HW                                       */
/*                                                                                     */
/***************************************************************************************/

-- 5-HW-0. Отобразите для каждого из курсов количество парней и девушек. 

select
	COURSE
   ,GENDER
   ,COUNT(GENDER) as 'Quantity'
from STUDENTS
group by COURSE, GENDER
order by course;

-- более элегантное решение
select
	course
	,count(
		case gender
			when 'f' then 1
			else null -- не 0. Потому, что значение 0 будет учитываться при подсчете, а null нет
		end) 'countf'
	,count(
		case gender
			when 'm' then 1
			else null
		end) 'countm'
from STUDENTS
group by course;

-- 5-HW-1. Напишите запрос для таблицы EXAM_MARKS, выдающий даты, для которых средний балл 
--    находится в диапазоне от 4.22 до 4.77. Формат даты для вывода на экран: 
--    день месяць, например, 05 Jun.

select 
	left(convert(nvarchar(20), EXAM_DATE, 113), 6) as dt
from EXAM_MARKS
group by EXAM_DATE
having avg(mark) between 4.22 and 4.77

-- MySQL
select 
    date_format(EXAM_DATE, '%d %M') as dt
from EXAM_MARKS
group by EXAM_DATE
having avg(mark) between 4.22 and 4.77


-- 2. Напишите запрос, который по таблице EXAM_MARKS позволяет найти период времени,
--    в течении которого студент сдавал сессию, количество сдаваемых предметов, количество пересдач, 
--	  а также их максимальные и минимальные оценки. В выборке дожлен присутствовать идентификатор студента.
--    Примечание: таблица оценок - покрывает одну сессию, промежуток времени -
--    количество дней, которые провел студент на этой сессии - от первого до 
--    последнего экзамена включительно
--    Примечание-2: функция DAY() для решения не подходит! 
select
	student_id
	,datediff(dd, min(exam_date), max(exam_date)) + 1 as term
	,count(distinct subj_id) as subj_total
	,count(subj_id) - count(distinct subj_id) as failure
	,max(mark) as maxm
	,min(mark) as minm
from EXAM_MARKS
group by 
	STUDENT_ID;

-- 5-HW-3. Покажите список идентификаторов студентов, которые имеют пересдачи. 
select
	student_id
from EXAM_MARKS
group by subj_id, student_id
	having count(*) > 1;

select 
	student_id
from EXAM_MARKS
group by student_id
having count(subj_id) <> count(distinct subj_id);

-- 5-HW-4. Напишите запрос, отображающий список предметов обучения, вычитываемых за самый короткий 
--    промежуток времени, отсортированный в порядке убывания семестров. Поле семестра в 
--    выходных данных должно быть первым, за ним должны следовать наименование и 
--    идентификатор предмета обучения.
select 
	semester
	, name
	, id
from SUBJECTS
where hours = (select min(hours) from SUBJECTS)
order by 1 desc; -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Можно, но не нужно!

-- 5-HW-6. Покажите сумму баллов для каждой даты сдачи экзаменов, при том, что средний балл не равен 
--    среднему арифметическому между максимальной и минимальной оценкой. Данные расчитать только 
--    для студенток. Результат выведите в порядке убывания сумм баллов, а дату в формате dd/mm/yyyy.

-- шаг 1 - выбираем оценки студенток
select
	*
from EXAM_MARKS 
where student_id in (select id from STUDENTS where gender = 'f');

-- шаг 2 -- считаем сумму балов по датам и выводим результат в требуемом порядке
select
	sum(mark) as sm
	,convert(varchar(10), exam_date, 103) as dt
from EXAM_MARKS 
where student_id in (select id from STUDENTS where gender = 'f')
group by exam_date
order by sm desc;

-- шаг 3 - фильтруем группы в соответствии с условиями задачи
select
	sum(mark) as sm
	,convert(varchar(10), exam_date, 103) as dt
from EXAM_MARKS
where student_id in (select id from STUDENTS where gender = 'f')
group by EXAM_DATE
having avg(mark) <> (max(mark) + min(mark)) / 2
order by sum(mark) desc;

-- 5-HW-7. Покажите имена всех студентов, имеющих средний балл, по предметам с идентификаторами 
--    1 и 2, который превышает средний общий балл по всем остальным оценкам. 
--    Используйте вложенный подзапрос.
/*
	Очевидно, что поскольку в условии задачи требуется вывести имя и фамилию студента, то мы должны 
	сделать выборку из таблицы STUDENTS, поскольку именно в ней содержится информация о именах и фамилиях.
	Таким образом наш результирующий запрос должен выглядеть приблизительно так:

	select 
		name
		, surname
	from STUDENTS
	where id in (........) -- список идентификаторов студентов, которые отвечают условиям задачи
*/

-- шаг 1. Выбираем идентификаторы студентов средний бал которых по предметам 1 и 2 больше, например 4-х
select 
	student_id 
from EXAM_MARKS as em
where subj_id in (1, 2) 
group by student_id 
having isnull(avg(mark),0) > 4; -- isnull на случай, если студент не сдавал предметы 1 или 2

-- шаг 2. Считаем средний бал по предметам НЕ 1 и 2 какого-либо произвольного студента. Например 
-- студента с идентификатором 2. 
select 
	isnull(avg(mark), 0) 
from EXAM_MARKS as sub 
where sub.student_id = 2 and subj_id not in (1,2)

-- шаг 3. Корреляция. Очевидно, что если вместо двойки передавать другие значения
-- идентификатора студента, то средний бал будет считаться именно для этих студентов. Значит 
-- свяжем запрос из шага 1 с запросом из шага 2 (сделаем корреляцию по студенту)
select 
	student_id 
from EXAM_MARKS as em
where subj_id in (1, 2) 
group by student_id 
having isnull(avg(mark), 0) > (
								select isnull(avg(mark), 0) 
								from EXAM_MARKS as sub 
								where sub.student_id = em.student_id and subj_id not in (1,2)
);
--                                               ^
--                       На каждом шаге вычисления внешнего запросасюда будет передаваться 
--                       значение идентификатора студента (из внешнего запроса). 

-- шаг 4. Формируем результирующий запрос
select 
	name
	, surname
from students
where id in (
	select 
		student_id 
	from EXAM_MARKS as em
	where subj_id in (1, 2) 
	group by student_id 
	having isnull(avg(mark), 0) > (select 
							isnull(avg(mark), 0) 
						from EXAM_MARKS as sub 
						where sub.student_id = em.student_id and subj_id not in (1,2))
);

-- 5-HW-8. Напишите запрос, выполняющий вывод общего суммарного и среднего баллов каждого 
--    экзаменованого второкурсника, его идентификатор и кол-во полученных оценок при условии, 
--    что он успешно сдал 3 и более предметов.
select
	student_id
   ,sum(mark) total_mark
   ,avg(mark) avg_mark
   ,count(mark) mark_qty
from EXAM_MARKS
where student_id in (
				-- подзапрос вернет идентификаторы второкурсников
				select
					id
				from STUDENTS
				where course = 2
)  and mark > 2 -- условие того, что сдал успешно
group by
	student_id
having count(distinct subj_id) >= 3 -- 3 и более предметов
order by
	student_id;

-- 9. Напишите запрос к таблице SUBJECTS, выдающий названия всех предметов, средний балл
--    которых выше среднего балла по всем предметам университетов г.Днепра. 
--    Используйте вложенный подзапрос.

-- шаг №5: вывести все названия предметов
select distinct name
from SUBJECTS as S
where id in (
	-- шаг №4: получить все индентификаторы предметов, средний балл которых превышает
	--         средний балл всех предметов г.Днепра
    select subj_id
    from EXAM_MARKS
    group by subj_id
    having avg(mark)>(
    	-- шаг №3: вычислить среднее значение по всем предметам вузов г.Днепр 
    	--         (оно же - средняя оценка для всех студентов шага №2)
        select avg(mark) 
        from EXAM_MARKS 
        where student_id in (
        					-- шаг №2: получить ID всех студентов, учащихся в вузах Днепра
                            select id 
                            from STUDENTS
                            where univ_id in (
                            				 -- шаг №1: получить все ID вузов Днепра
                                              select id from UNIVERSITIES where city='Днепр'
                                             )
                            )
        )
);

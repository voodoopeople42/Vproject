/***************************************************************************************/
/*                                                                                     */
/*                                          6-HW                                       */
/*                                                                                     */
/***************************************************************************************/

-- 6-HW-2. Напишите запрос с EXISTS, выбирающий всех студентов, для которых в том же городе, 
--    где живет и учится студент, существуют другие университеты, в которых он не учится.
--    Cтудент учится и живет в одном и том же городе и при этом у него есть альтернатива перевода в 
--    другой университет, не покидая своего города.

--    Показать студентов, которые живут и учатся в одном и том же городе и в этом же городе существуют другие университеты помимо 
--    того, в котором данный студент учится.  Например, студент X живет в Киеве и учится в КПИ. Но в Киеве есть и другие 
--    университеты, куда студент может перевестись, не покидая города своего проживания.
--    Использовать оператор EXISTS

--	шаг 1. Выбрать студентов студентов, которые обучаются в том же городе, где и живут (имеется ввиду
--	место постоянного жительства
select
	* 
from STUDENTS as s where 
	exists (select 1 from UNIVERSITIES as u where s.univ_id = u.id and s.city = u.city);

-- шаг 2. Выбрать студентов, которые живут и обучаются в городе, где есть униветситеты
-- в которых данный студент не учится
select
	* 
from STUDENTS as s where 
	exists (select 1 from UNIVERSITIES as u where s.univ_id <> u.id and s.city = u.city);

-- шаг 3. Делаем пересечение выборок. Т.е. строим такую выборку, которая будет содержать
-- только тех студентов, которые попали как в первую, так и во вторую выборку
select
	* 
from STUDENTS as s where 
	exists (select 1 from UNIVERSITIES as u where s.univ_id = u.id and s.city = u.city)
	and
	exists (select 1 from UNIVERSITIES as u where s.univ_id <> u.id and s.city = u.city);

-- используя пересечение
select
	* 
from STUDENTS as s where 
	exists (select 1 from UNIVERSITIES as u where s.univ_id = u.id and s.city = u.city)
intersect
select
	* 
from STUDENTS as s where 
	exists (select 1 from UNIVERSITIES as u where s.univ_id <> u.id and s.city = u.city);


-- 6-HW-3. Напишите запрос, выбирающий из таблицы SUBJECTS данные о названиях предметов обучения, 
--    экзамены по которым были хоть как-то сданы более чем 12 студентами, за первые 10 дней сессии. 
--    Используйте EXISTS. Примечание: по возможности выходная выборка должна быть без пересдач.

-- шаг 1. Выбираем все предметы по которым были получены положительные оценки за первых 10 дней сессии
select 
	subj_id 
from EXAM_MARKS 
where 
	mark > 2 
	and exam_date < (select dateadd(day, 10, min(exam_date)) from EXAM_MARKS)
group by subj_id

-- шаг 2. В каждой группе предметов должно быть не менее 12 разных студентов
select 
	subj_id 
from EXAM_MARKS 
where 
	mark > 2 
	and exam_date < (select dateadd(day, 10, min(exam_date)) from EXAM_MARKS)
group by subj_id
having count(distinct student_id) > 12;

--  Как посмотреть результаты по какому-то конкретному предмету? Например с номером 4
select 
	subj_id 
from EXAM_MARKS 
where 
	subj_id = 4
	and mark > 2 
	and exam_date < (select dateadd(day, 10, min(exam_date)) from EXAM_MARKS)
group by subj_id
having count(distinct student_id) > 12;

-- шаг 3. результат - коррелируем предметы 
select
	name
from SUBJECTS s
where exists(
	select
		1
	from EXAM_MARKS
	where s.id = subj_id
		and mark > 2
		and exam_date < (select dateadd(day,10,min(exam_date))	from EXAM_MARKS	)
	group by
		subj_id
	having count(distinct student_id) > 12
);

-- 6-HW-5. Напишите 2 запроса, использующий ANY и ALL, выполняющий выборку данных о студентах, 
--    у которых в городе их постоянного местожительства нет университета.
select 
	* 
from STUDENTS  where city <> all (select city from UNIVERSITIES);

select 
	* 
from STUDENTS where not city = any (select city from UNIVERSITIES);

-- НЕПРАВИЛЬНО
select 
	* 
from STUDENTS where city <> any(select city from UNIVERSITIES);

-- 6-HW-6. Напишите запрос выдающий имена и фамилии студентов, которые получили
--    максимальные оценки в первый и последний день сессии.
--    Подсказка: выборка должна содержать по крайне мере 2х студентов.
select
	name
	,surname
from STUDENTS s where exists (
	-- выбираем студентов, которые получили максимальные оценки
	-- в первый день сессии
	select 1 from EXAM_MARKS as em
	where 
		s.id = em.student_id 
		and em.exam_date = (select min(exam_date) from EXAM_MARKS) -- минимальная дата это и есть первый день сессии
		and em.mark = (select max(mark) from EXAM_MARKS where exam_date = em.exam_date) 
)
union all -- !!!!!!!!!! один и тот же студент может быть подходящим кандидатом в первый и последний день сессии
select
	name
	,surname
from STUDENTS s where exists (
	select 1 from EXAM_MARKS em
	where 
		s.id = student_id 
		and exam_date = (select max(exam_date) from EXAM_MARKS) -- максимальная дата это и есть последний день сессии
		and mark = (select max(mark) from EXAM_MARKS where exam_date = em.exam_date) 
)

-- Пример использования оператора select в списке полей другого оператора select
-- Подсчитать количество студентов мужчин и женщин, вывести 
-- процентное сообношение мужчин и женщин
-- Рассмотреть проблему вычислений (сумма процентов не равна 100)

select 
	gender
	,count(*) as cnt
	,count(*) * 100 / (select count(*) from STUDENTS) as [percent]
from STUDENTS
group by gender;

-- 7-HW-6 Напишите запрос EXISTS, который выполняет вывод данных об кол-ве успешно 
--    сдававших экзамены (без двоек) студентов для каждого курса.

-- шаг 1 - группировка по курсам
select 
	course
	, count(*) as qty
from students s
group by course

-- шаг 2 - находим таких студентов у которых минимальная оценка больше 2
--
-- для студента 1 результат пустое множество. Следовательно у этого студента есть двойка
select 1
from exam_marks 
where student_id  = 1 
having min(mark) > 2
-- проверка
select * from EXAM_MARKS where student_id = 1

-- для студента 2 результат непустое множество. Студент сдал все экзамены успешно
select 1
from exam_marks 
where student_id  = 2 
having min(mark) > 2
-- проверка
select * from EXAM_MARKS where student_id = 2

-- шаг 3 - корелляция
select 
	course
	, count(*) as qty
from students s
where exists (
    select 1 
    from exam_marks 
    where student_id  = s.id
    having min(mark) > 2
    )
group by course

-- другое решение
select
	course
   ,count(id) Qty
from students s
where exists (
	select	1
	from EXAM_MARKS e1
	where not exists (
				-- выбираем студентов у которых есть двойки
				select	1
				from EXAM_MARKS e2
				where 
					mark < 3
					and e1.student_id = e2.student_id
	)
	and s.id = e1.student_id
)
group by course;


-- 8-HW-6 Напишите запрос на выдачу названий всех предметов обучения, 
--    по которым было получено больше всего оценок.

-- шаг 1. Количество оценок по предметам
select
	subj_id
	, count(mark)
from EXAM_MARKS
group by
	subj_id;

-- наш искомый предмет 
select * from SUBJECTS where id = 3;

-- подставляем вместо тройки нужный запрос
select 
	name
from SUBJECTS where id in (
	select
		subj_id
	from EXAM_MARKS
	group by
		subj_id
	having count(mark) >= all (select count(mark) from EXAM_MARKS group by subj_id )
);

-- переписываем in с использованием exists
select 
	name
from SUBJECTS as s where exists (
	select	1
	from EXAM_MARKS
	where s.id = subj_id
	group by
		SUBJ_ID
	having count(mark) >= all (select count(mark) from EXAM_MARKS group by subj_id )
);

-- другое решение
select
	s.name
from SUBJECTS  as s
where s.ID = (
				select top 1
					e.subj_id
				from EXAM_MARKS as e
				group by
					e.subj_id
				order by
					count(*) desc
);

-- MySql

select
	s.name
from SUBJECTS as s
where S.ID = (
				select 
					e.subj_id
				from EXAM_MARKS as e
				group by
					e.subj_id
				order by
					count(*) desc
				limit 0, 1                                        
);



/***************************************************************************************/
/*                                                                                     */
/*                                          7-HW                                       */
/*                                                                                     */
/***************************************************************************************/

-- 7-HW-2. Напишите запрос, который выполняет вывод данных о фамилиях, сдававших экзамены 
--    студентов, учащихся в Б.Церкви, вместе с наименованием каждого сданного ими предмета, 
--    оценкой и датой сдачи.

select 
	s.surname
	,sb.name
	,em.mark
	,em.exam_date
from STUDENTS as s
	inner join UNIVERSITIES as u on s.univ_id = u.id and u.city = 'Белая Церковь'
	inner join EXAM_MARKS as em on em.student_id = s.id and em.mark > 2
	inner join SUBJECTS sb on em.subj_id = sb.id;

-- 7-HW-3. Используя опратор JOIN , выведите объединенный список городов с указанием количества 
--    учащихся студентов и преподающих в них преподавателей.

-- нужно бы переформулировать задачу так: вывести  список городов, в которых расположены университеты. Для каждого 
-- такого города указать количество студентов обучающихся в этом городе студентов всесте с количеством преподавателей
-- преподающих в этом городе

select 
	u.city
	, count(distinct s.id) qty_stu
	, count(distinct l.id) qty_lec
from
    universities u 
     left outer join students s on s.univ_id=u.id
     left outer join lecturers l on l.univ_id=u.id
group by u.city;

-- или
select
	ss.city
   ,qty_students
   ,qty_lecturers
from (
	select
		u.city
	   ,count(s.id) qty_students
	from STUDENTS s
		 right join UNIVERSITIES u on s.univ_id = u.id
	group by
		u.city
) ss inner join (
	select
		u.city
	   ,count(l.id) qty_lecturers
	from LECTURERS l
		 right join UNIVERSITIES u on l.univ_id = u.id
	group by
		u.city
) uu on ss.city = uu.city;

-- если же сформулировть задачу так: показать список всех городов, которые встречаются в таблицах 
-- STUDENTS, LECTURERS, UNIVERSITIES (т.е. объединенной список городов). Для каждого города из полученного 
-- списка указать количество студентов и преподавателей живущих в этом городе, то решение будет таким:
select
	t.city
	,isnull(ts.st_count, 0) as st_count
	,isnull(tl.lec_count, 0) as lec_count
	,isnull(t2.u_count, 0) as u_count
from (
	-- этот подзапрос возвращает список всех городов из 
	-- таблиц STUDENTS, LECTURERS, UNIVERSITIES
	select city from STUDENTS
	union 
	select city from LECTURERS
	union 
	select city from UNIVERSITIES
) as t 
	left outer join (
		-- количество студентов по городам
		select	
			city 
			,count(id) as st_count
		from STUDENTS
		group by city
	) as ts on t.city = ts.city 
	left outer join (
		-- количество преподавателей по городам
		select	
			city 
			,count(id) as lec_count
		from LECTURERS
		group by city
	) as tl on t.city = tl.city
	left outer join (
		-- факультативно. Количество университетов по городам
		select	
			city 
			,count(id) as u_count
		from UNIVERSITIES
		group by city
	) as t2 on t.city = t2.city
order by t.city;

-- 7-HW-4. Напишите запрос который выдает фамилии всех преподавателей и наименование предметов,
--    которые они читают в КПИ
select
	l.surname
   ,j.name
from UNIVERSITIES as u
	 inner join LECTURERS as l on u.id = l.univ_id
	 inner join SUBJ_LECT as sl on sl.lecturer_id = l.id
	 inner join SUBJECTS as j on sl.subj_id = j.id
where u.name = 'КПИ';

-- 7-HW-5. Покажите всех студентов-двоешников, кто получил только неудовлетворительные оценки (2) 
--    и по каким предметам, а также тех кто не сдал ни одного экзамена. 
--    В выходных данных должны быть приведены фамилии студентов, названия предметов и 
--    оценка, если оценки нет, заменить ее на прочерк.

-- шаг 1 - список студентов получивших только неудовлетворительные оценки
select
	student_id
from EXAM_MARKS e 
group by student_id
having max(mark) <= 2;

-- шаг 2 - по каким предметам эти студенты получили двойки
select 
	e.student_id
	,e.mark
	,sb.name
from EXAM_MARKS e
	inner join SUBJECTS sb on e.subj_id = sb.id
where e.student_id in (
	-- список идентификаторов студентов получивших
	-- только неудовлетворительные оценки
	select
		student_id
	from EXAM_MARKS e 
	group by student_id
	having max(mark) <= 2
);

-- шаг 3 - используем EXISTS
select 
	e.student_id
	,e.mark
	,sb.name
from EXAM_MARKS e
	inner join SUBJECTS sb on e.subj_id = sb.id
where exists (
	-- данный студет получил только двойки
	select
		ei.student_id
	from EXAM_MARKS as ei 
	where ei.student_id = e.student_id
	group by ei.student_id
	having max(ei.mark) <= 2
);
	
-- шаг 3 - нас интересует только факт существования студента-двоешника, но не его идентификатор
select 
	e.student_id
	,e.mark
	,sb.name
from EXAM_MARKS e
	inner join SUBJECTS sb on e.subj_id = sb.id
where exists (
	-- данный студет получил только двойки
	select
		1 --ei.student_id
	from EXAM_MARKS as ei 
	where ei.student_id = e.student_id
	-- group by ei.student_id -- убрав колонку можно убрать группировку
	having max(ei.mark) <= 2
);

-- шаг 4 - добавляем связь со студентами для того, что бы получить имя и фамилию студента-двоешника
select 
	s.name
	,s.surname
	,sb.name
	,e.mark
from EXAM_MARKS e
	inner join SUBJECTS sb on e.subj_id = sb.id
	inner join STUDENTS s on e.student_id = s.id
where exists (
	-- данный студет получил только двойки
	select
		1
	from EXAM_MARKS as ei 
	where ei.student_id = e.student_id
	having max(ei.mark) <= 2
);

-- шаг 5 -- меняем тип связи с таблицей студентов для того, что бы включить
--	в выборку тех студентов, которые не сдавали экзамены
select 
	s.name
	,s.surname
	,sb.name
	,e.mark
from EXAM_MARKS e
	inner join SUBJECTS sb on e.subj_id = sb.id
	right outer join STUDENTS s on e.student_id = s.id
where exists (
	-- данный студет получил только двойки
	select
		1
	from EXAM_MARKS as ei 
	where ei.student_id = e.student_id
	having max(ei.mark) <= 2
);

-- шаг 6 - выборка не изменилась! Это происходит потому,
-- что условие where exists жестко ограничивает выборку 
-- студентами-двоешниками. Выполним запрос без этого условия
select 
	s.name
	,s.surname
	,sb.name
	,e.mark
from EXAM_MARKS e
	inner join SUBJECTS sb on e.subj_id = sb.id
	right outer join STUDENTS s on e.student_id = s.id

-- шаг 7 - ослабляем условие where так, что бы включить
-- студентов не сдававших экзамен
select 
	s.name
	,s.surname
	,isnull(sb.name, '-') as sbj
	,isnull(cast(e.mark as varchar(5)), '-') as mark
from EXAM_MARKS e
	inner join SUBJECTS sb on e.subj_id = sb.id
	right outer join STUDENTS s on e.student_id = s.id
where exists (
	-- данный студет получил только двойки
	select
		1
	from EXAM_MARKS as ei 
	where ei.student_id = e.student_id
	having max(ei.mark) <= 2
) or e.mark is null;

-- 7-HW-6. Напишите запрос, который выполняет вывод списка университетов с рейтингом, 
--    превышающим 490, вместе со значением максимального размера стипендии, 
--    получаемой студентами в этих университетах.
select
	n.name
   ,isnull(m.max_st, 0) as stipend
from
(
	select
		NAME
	   ,ID
	from UNIVERSITIES
	where RATING > 490
) as n
left outer join -- !!!!!!!!!!!!!!!!!!!!!!!!!!
(
	select
		MAX(stipend) as max_st
	   ,UNIV_ID
	from STUDENTS
	group by
		UNIV_ID
) m on n.ID = m.UNIV_ID;

-- 7-HW-7. Расчитать средний бал по оценкам студентов для каждого университета, 
--    умноженный на 100, округленный до целого, и вычислить разницу с текущим значением
--    рейтинга университета.
select
	u.name
   ,u.rating
   ,b.rating as calculated_rating
   ,u.rating - b.rating delta
from UNIVERSITIES as u inner join (
	select
		s.univ_id
	   ,cast(round(avg(mark) * 100,0) as int) rating
	from EXAM_MARKS as e
		 join STUDENTS as s on e.student_id = s.id
	group by
		s.univ_id
) as b on u.id = b.univ_id
order by
	delta desc;

-- 7-HW-8. Написать запрос, выдающий список всех фамилий лекторов из Киева попарно. 
--    При этом не включать в список комбинации фамилий самих с собой,
--    то есть комбинацию типа "Иванов-Иванов", а также комбинации фамилий, 
--    отличающиеся порядком следования, т.е. включать лишь одну из двух 
--    комбинаций типа "Иванов-Петров" или "Петров-Иванов".
select 
	t1.surname
	, t1.id
	, t2.id
	, t2.surname
from lecturers t1
	cross join lecturers t2 
where 
	t1.id > t2.id
	and t1.city='Киев' and t2.city='Киев'


select t1.surname+'-'+t2.surname
from lecturers t1
	inner join lecturers t2 on t1.id > t2.id and t1.city = t2.city and t1.city='Киев'

-- 7-HW-9.  Выдать информацию о всех университетах, всех предметах и фамилиях преподавателей, 
--    если в университете для конкретного предмета преподаватель отсутствует, то его фамилию
--    вывести на экран как прочерк '-' (воспользуйтесь ф-ей isnull)
select
	u.name univ_name
   ,s.name subj
   ,isnull(ls.surname,'-') surname_l
from UNIVERSITIES as u
	 cross join SUBJECTS as s
	 left join
			(
				-- список преподавателей с привязкой к университету
				-- и предмету, который преподаватель преподает в этом университете
				select
					l.id
				   ,l.surname
				   ,l.univ_id
				   ,sl.subj_id
				from LECTURERS as l
					 inner join SUBJ_LECT sl on l.id = sl.lecturer_id
			) as ls on s.id = ls.subj_id and u.id = ls.univ_id;


-- 7-HW-10. Кто из преподавателей и сколько поставил пятерок за свой предмет?
select 
	l.surname
	, count(mark) five
from EXAM_MARKS e 
	inner join STUDENTS s on e.student_id=s.id
    inner join lecturers l on s.univ_id=l.univ_id
    inner join subj_lect sl on sl.lecturer_id=l.id and sl.subj_id=e.subj_id
where mark = 5
group by l.surname
order by five desc;


/***************************************************************************************/
/*                                                                                     */
/*                                          9-HW                                       */
/*                                                                                     */
/***************************************************************************************/

-- 9-HW-1. Создайте модифицируемое представление для получения сведений обо всех студентах, 
--    круглых отличниках. Используя это представление, напишите запрос обновления, 
--    "расжалующий" их в троечников.
create view v_best_students as 
select 
	s.id
	,s.name
	,s.surname
	,em.subj_id
	,em.mark
from STUDENTS as s 
	inner join EXAM_MARKS as em on s.id = em.student_id 
	inner join (	
		select
			student_id
		from EXAM_MARKS
		group by
			student_id
		having min(mark) = 5	
	) as t on em.student_id = t.student_id;
go

select * from v_best_students;
select 
	em.* 
from EXAM_MARKS as em inner join (	
		select
			student_id
		from EXAM_MARKS
		group by
			student_id
		having min(mark) = 5	
	) as t on em.student_id = t.student_id;


begin tran
update v_best_students set
	mark = 3;

select * from v_best_students;
select 
	em.* 
from EXAM_MARKS as em inner join (	
		select
			student_id
		from EXAM_MARKS
		group by
			student_id
		having min(mark) = 5	
	) as t on em.student_id = t.student_id;
rollback;

drop view v_best_students;

-- 9-HW-4. Создайте представление для получения сведений о студенте фамилия, 
--    имя, а также количестве экзаменов, которые он сдал успешно, и количество,
--    которое ему еще нужно досдать (с учетом пересдач двоек).

/*
по условию, во всех университетах, на всех курсах преподают все предметы, которые
есть в таблице SUBJECTS. Следовательно, каждый студент должен сдать столько экзаменов,
сколько есть записей в таблице SUBJECTSю
*/
select 
	stat.*
	, c.qty-stat.exam_done as exam_will_do 
from
    (select count(*) qty from SUBJECTS) C 
	cross join
    (        
		-- шаг 2
	    --  список студентов вместе с количеством полученых 
		-- положительных оценок
        select 
			surname
			, name
			, count(e.mark) as exam_done
        from 
            STUDENTS as s left join (
					-- шаг 1
					-- список студентов, которые сдали экзамены (оценка > 2)
					-- вместе с полученной оценкой
                    select 
						student_id
						,mark
                    from EXAM_MARKS
                    where mark > 2
                ) as e on s.id = e.student_id
            group by surname, name
    ) stat;

-- 9-HW-6. Создайте представление таблицы STUDENTS с именем STIP, включающее поля 
--    STIPEND и ID и позволяющее вводить или изменять значение поля 
--    стипендия, но только в пределах от 100 д о 500.

create view STIP as 
select id
      ,surname
      ,name
      ,gender
      ,stipend
      ,course
      ,city
      ,birthday
      ,univ_id
from STUDENTS
where stipend between 100 and 500
with check option;

/***************************************************************************************/
/*                                                                                     */
/*                                  Lesson 10                                          */
/*                                                                                     */
/***************************************************************************************/

create table tbl_example
(
	id int
	, sname nvarchar(50)
	, course int
	, bdate datetime
);

alter table tbl_example alter column id int not null;
alter table tbl_example alter column course  int not null;

alter table tbl_example add constraint PK_Key primary key (id);
alter table tbl_example add constraint Course_chk check (course in(1,2,3,4,5));

create index IDX_Bday on tbl_example (bdate desc);
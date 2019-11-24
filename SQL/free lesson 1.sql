/***************************************************************************************/
/*                                                                                     */
/*                                          3-HW                                       */
/*                                                                                     */
/***************************************************************************************/
-- 3-HW-4. ���������� �������� ��� ������, � ��������� ������� 
--    ���������, ����, �������, ���  �� ������� STUDENTS, ������ ����������
--    ��������, ���������� ����� '1993-07-21'
select 
	stipend
	,course
	,surname
	,name 
--	,birthday
from STUDENTS	
where birthday > '19930721';

-- ************************ �������� ���������� ������� �������������� *******************
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

-- ��� MySql ��� �������
select unix_timestamp(current_date());
select from_unixtime(1547071200,'%Y-%m-%d'); 

-- 3-HW-9. �������� ������, ����������� ������� �� ������� LECTURERS ���� �������
--    ��������������, ����������� �� ������, ���� �� ����������� � ������������
--    � ��������������� 14
select
	surname
    --,univ_id
    --,city
from LECTURERS
where city = '�����' or univ_id = 14;

-- 3-HW-11. �������� ������ ������� ��������� ���������� � �����, �� ���� � ��� �������� 
--     ��� ���� �������� ������.
select
	surname
	,name
	,birthday
--	,course
from STUDENTS
where course % 2 <> 0 and city = '����'

-- 3-HW-13. ��������� ��������� ���������� (��������� �� NOT) � ����� ���������� ������������ �������?
-- SELECT * FROM STUDENTS WHERE NOT ((BIRTHDAY = '1993-06-07' OR STIPEND > 500) AND ID >= 9)
-- ���������: ����� ���������, ������ ������ ���������� �� �� �������, ��� � ������������
select
	*
from STUDENTS
where not((BIRTHDAY = '19930607' or STIPEND > 500) and ID >= 9);

-- ��� ������. ������ not � ������
select
	*
from STUDENTS
where (not (BIRTHDAY = '19930607' or STIPEND > 500) or ID < 9);

-- ��� ������. ������ not �� ���������� ������
select
	*
from STUDENTS
where ((BIRTHDAY <> '19930607' and STIPEND <= 500) or ID < 9);

-- ��� ������. ��������� ������ � �������������� ���������� ����������� �� ������
select
	*
from STUDENTS
where (BIRTHDAY <> '19930607' and STIPEND <= 500 or ID < 9);

/***************************************************************************************/
/*                                                                                     */
/*                                          4-HW                                       */
/*                                                                                     */
/***************************************************************************************/
-- 4-HW-1. ��������� ������ ��� ������� STUDENT ����� �������, ����� �������� ������� 
--    ��������� ���� ������� ���� varchar, ���������� ������������������ ����������� 
--    �������� ';' (����� � �������) �������� �������� ���� �������, � ��� ���� 
--    ��������� �������� ������ ������������ ���������� ��������� (������� �������), 
--    �� ���� ���� ��������������� � ��������� ����: 
--    1;�������;�������;M;550;4;�������;01/12/1990;2.
--    ...
--    ����������: � ������� ������ ������� �������� �� ������ ������ �� 5 ����
-- ��� 1
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

-- ��� 2
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

-- ��� 3. ������ 
select
	cast(ID as varchar(3))
	,UPPER(SURNAME)
	,UPPER(NAME)
	,UPPER(GENDER)
	,cast(STIPEND as varchar(5))	-- <<< ������ �����
	,cast(COURSE as varchar(2))
	,UPPER(CITY)
	,convert(nvarchar(10), BIRTHDAY, 103)
	,cast(UNIV_ID as varchar(3))
from STUDENTS
where len(CITY) = 5

-- ��� 4. ������ 
select
	cast(ID as varchar(3))
	,UPPER(SURNAME)
	,UPPER(NAME)
	,UPPER(GENDER)
	,cast(STIPEND as varchar(6))
	,cast(COURSE as varchar(2))
	,UPPER(CITY)
	,convert(nvarchar(10), BIRTHDAY, 103)
	,cast(isnull(UNIV_ID, 'Unknown') as varchar(7)) -- <<< ������ �����
from STUDENTS
where len(CITY) = 5

-- ��� 5.  
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

-- ��� MySQL
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


-- ��� 6.  
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

-- ��� 7. �����������
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


-- ��� MySQL
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

-- 4-HW-2. ��������� ������ ��� ������� STUDENT ����� �������, ����� �������� ������� 
--    ��������� ����� ���� ������� � ��������� ����: 
--    �.�������;���������������-�������;�������-01.12.90
--    ...
--    ����������: � ������� ������ ������� ��������, ������� ������� �������� ������
--    ����� '�' � ������������� ����� '�', ���� �� ������� ������������� �� '�'


select 		
	concat (
		left (name, 1)
		, '.'
		, upper (surname)
		, ';'
		, '���������������-'
		, upper (city)
		, ';'
		, '�������-'
		, coalesce(convert (varchar(10), birthday, 4), 'unknown')		
	) as 'st_info'
from 
	STUDENTS
where
	surname like '_�%�_' or surname like '%�';

-- 4-HW-3. ��������� ������ ��� ������� STUDENT ����� �������, ����� �������� ������� 
--    ��������� ����� ���� ������� � ��������� ����:
--    �.�������;���������������-������; ������ �� IV �����
--    ...
--    ����������: ���� ������� �������� ������� (�������������� CASE), 
--    �������� ���������, ��������� ������� ������ 200
select
	concat (
		lower (left (name, 1))
		, '.'
		, lower (surname)
		, ';'
		, '���������������-'
		, city
		, '; ������ �� '
		, case course
			when 1 then 'I'
			when 2 then 'II'
			when 3 then 'III'
			when 4 then 'IV'
			when 5 then 'V'
			else 'wrong course'
		end
		, ' �����'
	)	
as 'st_info'
from 
	STUDENTS
where
	stipend % 200 = 0;


-- 4-HW-5. ������� �������, ����� ��������� � �������� ���������� ��� ���������, 
--    ��� ���� �������� ��������� �������������� ������ ���� ��������� �� 17.5%

--1 ���
select
	surname
	,name
	,stipend
	,course
from STUDENTS;

-- 2 ���
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

-- 3 ���
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

-- 4-HW-7. ������� ��� ������� ��������� � �� ��� ��������� ����� ��������.
select
	name
   ,right(rating,2) last_2_dig
from UNIVERSITIES;

select
	name
   ,right(cast(rating as varchar(10)),2) last_2_dig
from UNIVERSITIES;

-- 4-HW-8. ��������� ������ ��� ������� UNIVERSITY ����� �������, ����� �������� ������� 
--    ��������� ����� ���� ������� � ��������� ����:
--    ���-1;���-�.����;������� ������������ ����(501) +756
--    ...
--    ���-11;�����-�.����;������� ������������ ����(501) -18
--    ...
--    ����������: ������� ��������� ������������ ���������, � ����� ������ 
--    �������������� ���� (+/-), ������� ���� ������� �������� = 501

-- ��� 1
select
	'���-'
	+ CAST(ID as varchar)
	+ ';'
	+ NAME
	+ '-�.'
	+ CITY
	+ ';������� ������������ ����(501) '
	+ CAST(RATING - 501 as varchar) as UNIV_INFO
from UNIVERSITIES;

-- ��� 2
select
	'���-'
	+ CAST(ID as varchar)
	+ ';'
	+ NAME
	+ '-�.'
	+ CITY
	+ ';������� ������������ ����(501) '
	+ case
		when RATING - 501 > 0 then '+'
		else ''
	  end
	+ CAST(RATING - 501 as varchar) as UNIV_INFO
from UNIVERSITIES;

-- 4-HW-9. ��������� ������ ��� ������� UNIVERSITY ����� �������, ����� �������� ������� 
--    ��������� ����� ���� ������� � ��������� ����:
--    ���-1;���-�.����;������� ������� �� 12 �����
--    ���-2;���-�.����;������� ������� �� 6 �����
--    ...
--    ����������: � �������� ���������� ������� ���-�� �����
select 
	'���-' 
	+ cast(id as varchar(3)) + ';'
	+ NAME + '-�.' + CITY +  ';������� ������� �� '
	+ cast(floor(RATING / 100.) as varchar(2)) + ' �����' as col1
--    ,rating
from UNIVERSITIES;

-- ��� MySQL
select 
	concat(
		'���-' 
		,cast(id as char(3)) + ';'
		,NAME
		,'-�.'
		, CITY
		, ';������� ������� �� '
		, cast(floor(RATING / 100.) as char(2)) 
		, ' �����')
from UNIVERSITIES;

-- �����������!
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

-- 5-HW-0. ���������� ��� ������� �� ������ ���������� ������ � �������. 

select
	COURSE
   ,GENDER
   ,COUNT(GENDER) as 'Quantity'
from STUDENTS
group by COURSE, GENDER
order by course;

-- ����� ���������� �������
select
	course
	,count(
		case gender
			when 'f' then 1
			else null -- �� 0. ������, ��� �������� 0 ����� ����������� ��� ��������, � null ���
		end) 'countf'
	,count(
		case gender
			when 'm' then 1
			else null
		end) 'countm'
from STUDENTS
group by course;

-- 5-HW-1. �������� ������ ��� ������� EXAM_MARKS, �������� ����, ��� ������� ������� ���� 
--    ��������� � ��������� �� 4.22 �� 4.77. ������ ���� ��� ������ �� �����: 
--    ���� ������, ��������, 05 Jun.

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


-- 2. �������� ������, ������� �� ������� EXAM_MARKS ��������� ����� ������ �������,
--    � ������� �������� ������� ������ ������, ���������� ��������� ���������, ���������� ��������, 
--	  � ����� �� ������������ � ����������� ������. � ������� ������ �������������� ������������� ��������.
--    ����������: ������� ������ - ��������� ���� ������, ���������� ������� -
--    ���������� ����, ������� ������ ������� �� ���� ������ - �� ������� �� 
--    ���������� �������� ������������
--    ����������-2: ������� DAY() ��� ������� �� ��������! 
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

-- 5-HW-3. �������� ������ ��������������� ���������, ������� ����� ���������. 
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

-- 5-HW-4. �������� ������, ������������ ������ ��������� ��������, ������������ �� ����� �������� 
--    ���������� �������, ��������������� � ������� �������� ���������. ���� �������� � 
--    �������� ������ ������ ���� ������, �� ��� ������ ��������� ������������ � 
--    ������������� �������� ��������.
select 
	semester
	, name
	, id
from SUBJECTS
where hours = (select min(hours) from SUBJECTS)
order by 1 desc; -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! �����, �� �� �����!

-- 5-HW-6. �������� ����� ������ ��� ������ ���� ����� ���������, ��� ���, ��� ������� ���� �� ����� 
--    �������� ��������������� ����� ������������ � ����������� �������. ������ ��������� ������ 
--    ��� ���������. ��������� �������� � ������� �������� ���� ������, � ���� � ������� dd/mm/yyyy.

-- ��� 1 - �������� ������ ���������
select
	*
from EXAM_MARKS 
where student_id in (select id from STUDENTS where gender = 'f');

-- ��� 2 -- ������� ����� ����� �� ����� � ������� ��������� � ��������� �������
select
	sum(mark) as sm
	,convert(varchar(10), exam_date, 103) as dt
from EXAM_MARKS 
where student_id in (select id from STUDENTS where gender = 'f')
group by exam_date
order by sm desc;

-- ��� 3 - ��������� ������ � ������������ � ��������� ������
select
	sum(mark) as sm
	,convert(varchar(10), exam_date, 103) as dt
from EXAM_MARKS
where student_id in (select id from STUDENTS where gender = 'f')
group by EXAM_DATE
having avg(mark) <> (max(mark) + min(mark)) / 2
order by sum(mark) desc;

-- 5-HW-7. �������� ����� ���� ���������, ������� ������� ����, �� ��������� � ���������������� 
--    1 � 2, ������� ��������� ������� ����� ���� �� ���� ��������� �������. 
--    ����������� ��������� ���������.
/*
	��������, ��� ��������� � ������� ������ ��������� ������� ��� � ������� ��������, �� �� ������ 
	������� ������� �� ������� STUDENTS, ��������� ������ � ��� ���������� ���������� � ������ � ��������.
	����� ������� ��� �������������� ������ ������ ��������� �������������� ���:

	select 
		name
		, surname
	from STUDENTS
	where id in (........) -- ������ ��������������� ���������, ������� �������� �������� ������
*/

-- ��� 1. �������� �������������� ��������� ������� ��� ������� �� ��������� 1 � 2 ������, �������� 4-�
select 
	student_id 
from EXAM_MARKS as em
where subj_id in (1, 2) 
group by student_id 
having isnull(avg(mark),0) > 4; -- isnull �� ������, ���� ������� �� ������ �������� 1 ��� 2

-- ��� 2. ������� ������� ��� �� ��������� �� 1 � 2 ������-���� ������������� ��������. �������� 
-- �������� � ��������������� 2. 
select 
	isnull(avg(mark), 0) 
from EXAM_MARKS as sub 
where sub.student_id = 2 and subj_id not in (1,2)

-- ��� 3. ����������. ��������, ��� ���� ������ ������ ���������� ������ ��������
-- �������������� ��������, �� ������� ��� ����� ��������� ������ ��� ���� ���������. ������ 
-- ������ ������ �� ���� 1 � �������� �� ���� 2 (������� ���������� �� ��������)
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
--                       �� ������ ���� ���������� �������� ����������� ����� ������������ 
--                       �������� �������������� �������� (�� �������� �������). 

-- ��� 4. ��������� �������������� ������
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

-- 5-HW-8. �������� ������, ����������� ����� ������ ���������� � �������� ������ ������� 
--    �������������� �������������, ��� ������������� � ���-�� ���������� ������ ��� �������, 
--    ��� �� ������� ���� 3 � ����� ���������.
select
	student_id
   ,sum(mark) total_mark
   ,avg(mark) avg_mark
   ,count(mark) mark_qty
from EXAM_MARKS
where student_id in (
				-- ��������� ������ �������������� ��������������
				select
					id
				from STUDENTS
				where course = 2
)  and mark > 2 -- ������� ����, ��� ���� �������
group by
	student_id
having count(distinct subj_id) >= 3 -- 3 � ����� ���������
order by
	student_id;

-- 9. �������� ������ � ������� SUBJECTS, �������� �������� ���� ���������, ������� ����
--    ������� ���� �������� ����� �� ���� ��������� ������������� �.������. 
--    ����������� ��������� ���������.

-- ��� �5: ������� ��� �������� ���������
select distinct name
from SUBJECTS as S
where id in (
	-- ��� �4: �������� ��� ��������������� ���������, ������� ���� ������� ���������
	--         ������� ���� ���� ��������� �.������
    select subj_id
    from EXAM_MARKS
    group by subj_id
    having avg(mark)>(
    	-- ��� �3: ��������� ������� �������� �� ���� ��������� ����� �.����� 
    	--         (��� �� - ������� ������ ��� ���� ��������� ���� �2)
        select avg(mark) 
        from EXAM_MARKS 
        where student_id in (
        					-- ��� �2: �������� ID ���� ���������, �������� � ����� ������
                            select id 
                            from STUDENTS
                            where univ_id in (
                            				 -- ��� �1: �������� ��� ID ����� ������
                                              select id from UNIVERSITIES where city='�����'
                                             )
                            )
        )
);

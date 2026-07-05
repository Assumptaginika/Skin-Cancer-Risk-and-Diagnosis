--Task 1: Patient Demographic Risk Analysis
--Goal: Understand which demographic groups are most affected by skin cancer conditions. .
--1. Which age group has the highest number of skin cancer diagnoses?
select
case when age  between 0 and 20 then 'child'
	when age  between 21 and  35 then 'youth'
	when age  between 36 and  50 then 'adult'
	when age  between 51 and  70 then 'older adult'
	when age  between 71 and  100 then 'elderly' 
	end as age_group,

	sum(case when skin_cancer_history = 'true' then 1 else 0 end) as cancer_count
from table1
group by age_group
order by cancer_count desc


--2. What is the distribution of diagnoses between male and female patients?
select gender,
sum(case when skin_cancer_history = 'true' then 1 else 0 end) as cancer_count
from table1
group by gender;

--3. Which body regions record the highest number of patients with malignant diagnoses?
select region, sum(case when diagnostic = 'MEL' then 1 else 0 end) as Malignant_diagnosis
from table2
group by region
order by Malignant_diagnosis desc;


--4. How many patients have a previous history of skin cancer?
select count(patient_id) as total_skin_cancer_patients
from table1
where skin_cancer_history = 'true';


-- Task 2: Lesion Growth & Diagnosis Analysis
--Goal: Analyze lesion characteristics and identify indicators of dangerous skin conditions.
--1. Which diagnosis category appears most frequently?
select  diagnostic, 
	count(*) as diagnostic_count
from table2
group by diagnostic
order by diagnostic_count desc;


--2. How many lesions were reported as growing over time?
select count(*) grown_lesion
from table2
where grew = 'true'


--3. Which symptoms are most commonly associated with lesions?

select
	sum(case when itch = 'true' then 1 else 0 end) as itch,
	sum(case when grew = 'true' then 1 else 0 end) as grew,
	sum(case when hurt = 'true' then 1 else 0 end) as hurt,
	sum(case when changed = 'true' then 1 else 0 end) as changed,
	sum(case when bleed = 'true' then 1 else 0 end) as bleed,
	sum(case when elevation = 'true' then 1 else 0 end) as elevation
from table2

	
--4. How many lesions were biopsied before diagnosis confirmation?
select count(*) as biopsed_region 
from table2
where biopsed = 'true'

--5. Which diagnosis type has the highest average lesion diameter?
select 
	round(avg((diameter_1 + diameter_2) / 2)) as avg_diameter,
	diagnostic 
from table2
group by diagnostic
order by avg_diameter desc
limit 1;


--Task 3: Environmental Healthcare Analysis
--Goal: Understand how environmental conditions influence diagnosis patterns.
--1. Which body region has the highest number of diagnosed cases?
select region,
count(*) as total_diagnosis
from table2
group by region
order by total_diagnosis desc;

--2. How many patients lack access to piped water?
select 
count(*) as has_piped_water
from table1
where has_piped_water ='true';


--3. How many patients do not have access to sewage systems?
select 
	count(*) as has_sewage
from table1
where has_sewage_system ='true';


--4. Which body regions report the highest number of biopsied lesions?
select region, 
	sum(case when biopsed ='true' then 1 else 0 end) as total_biopsy
from table2
group by region
order by total_biopsy desc;

--5. Is there a relationship between poor sanitation access and severe diagnosis outcomes?
select t2.diagnostic, 
	t1.has_sewage_system, 
	count(*) as cases,
	ROUND(
        COUNT(*) * 100 / SUM(COUNT(*)) OVER(PARTITION BY t1.has_sewage_system)) AS percentage

from table2 t2
join table1 t1
on t2.patient_id = t1.patient_id
group by t2.diagnostic, t1.has_sewage_system
order by cases desc;


--Task 4: Lifestyle & Behavioral Risk Analysis
--Goal: Evaluate how lifestyle habits contribute to skin cancer risks and lesion severity.
--1. How many patients are smokers?

select count(*) as smoking_patients
from table1
where smoke = 'true'

--2. How many patients consume alcohol regularly?

select count(*) as drinks_alchohol
from table1
where drink = 'true'

--3. Which diagnosis types are most common among smokers?
select count(case when t1.smoke = 'true' then 1 else 0 end) as total_smokers, t2.diagnostic
from table1 t1
join table2 t2
on t1.patient_id = t2.patient_id
group by t2.diagnostic
order by total_smokers desc;

--4. What percentage of smokers also consume alcohol?

SELECT 
    SUM(CASE WHEN drink = 'true' THEN 1 ELSE 0 END) AS total_drinkers,

    SUM(CASE WHEN smoke = 'true' THEN 1 ELSE 0 END) AS total_smokers,

    round(SUM(CASE WHEN drink = 'true' AND smoke = 'true' THEN 1 ELSE 0 END) * 100.0 /
    SUM(CASE WHEN smoke = 'true' THEN 1 ELSE 0 END)) AS percentage_smokers_who_drink
FROM table1;


--5. Are patients who both smoke and drink more likely to develop malignant conditions?

select 
	(case when drink = 'true' and smoke = 'true' then 'smoker_and_drink' else 'others' end) as group_type,
	
	count(*) as total_patients,
	
	sum(case when cancer_history = 'true' and skin_cancer_history = 'true' then 1 else 0 end) as malignant_cases
from table1

group by (case when drink = 'true' and smoke= 'true' then 'smoker_and_drink' else 'others' end)


--6. Which lifestyle factor has the strongest relationship with severe diagnosis outcomes?
select 'Smoking' factor, 
	count(t1.patient_id) as MEL
from table1 t1
join table2 t2
on t1.patient_id = t2.patient_id
where smoke = 'true' and diagnostic = 'MEL'

UNION ALL

select 'Drinking' factor, 
	count(t1.patient_id) as MEL
from table1 t1
join table2 t2
on t1.patient_id = t2.patient_id
where drink = 'true' and diagnostic = 'MEL'



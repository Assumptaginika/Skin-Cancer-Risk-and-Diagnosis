# Skin Cancer Risk Intelligence & Patient Diagnosis Optimization

## Company Introduction
### Dermalife Oncology & Research Institute is a specialized healthcare organization dedicated to combating skin cancer through clinical research, advanced diagnostics,and population health analytics. The institute manages thousands of patient records across multiple healthcare regions and continuously monitors patient symptoms, lesion characteristics, hereditary risk factors, and environmental conditions to improve diagnostic accuracy and treatment outcomes.

## The Health Problem
### DORI has experienced a significant rise in late-stage skin cancer diagnoses, high-risk lesion progression, and recurring patient complications, particularly among elderly and underserved populations. Healthcare administrators also suspect that environmental conditions, hereditary history, smoking, alcohol consumption, and poor sanitation access are major contributors to the increasing skin cancer risk.

## Data Dictionary
| Column Header | Description | Data Type |
|---------------|-----------------|-------------|
|patient_id | Unique identifier assigned to each patient | VARCHAR |
| smoke | Indicates whether the patient smokes| BOOLEAN|
|drink |Indicates whether the patient consumes alcohol |BOOLEAN|
|background_father |Patient’s paternal ancestry/background |VARCHAR|
| background_mother | Patient’s maternal ancestry/background |VARCHAR|
|age| Patient age |INTEGER|
| pesticide |Indicates exposure to pesticides |BOOLEAN|
|gender |Patient gender |VARCHAR|
|skin_cancer_history |Indicates previous skin cancer history |BOOLEAN|
|cancer_history |Indicates previous cancer history |BOOLEAN|
|has_piped_water| Indicates access to piped water |BOOLEAN|
|has_sewage_system |Indicates access to sewage systems |BOOLEAN|
|patient_id |Unique identifier assigned to each patient |VARCHAR|
|lesion_id| Unique identifier assigned to each lesion| INTEGER|
|fitzpatrick |Skin type classification based on sensitivity to UV exposure| INTEGER|
|region| Body region where the lesion is located |VARCHAR|
|diameter_1 |Primary lesion diameter measurement| NUMERIC|
|diameter_2 |Secondary lesion diameter measurement |NUMERIC|
|diagnostic |Final diagnosis category for the lesion |VARCHAR|
|itch |Indicates whether the lesion causes itching |BOOLEAN|
|grew| Indicates whether the lesion has increased in size| BOOLEAN|
|hurt |Indicates whether the lesion is painful |BOOLEAN|
|changed |Indicates whether the lesion appearance changed |BOOLEAN|
|bleed |Indicates whether the lesion bleeds |BOOLEAN|
|elevation |Indicates whether the lesion is elevated |BOOLEAN|
|img_id| Image identifier linked to lesion records |VARCHAR|
|biopsed |Indicates whether the lesion was biopsied for further medical examination and confirmation |BOOLEAN|

## Key Analytical Question, corresponding queries and Output
### Task 1: Patient Demographic Risk Analysis
### Goal: Understand which demographic groups are most affected by skin cancer conditions. .

##### 1. Which age group has the highest number of skin cancer diagnoses?
``` sql
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

"age_group"	"cancer_count"
"older adult"	  126
"adult"	        29
"child"         2
"elderly"      	60
"youth"        	7
```
##### 2. What is the distribution of diagnoses between male and female patients?
``` sql
select gender,
sum(case when skin_cancer_history = 'true' then 1 else 0 end) as cancer_count
from table1
group by gender;


"gender"	"cancer_count"
"MALE"	    109
"FEMALE"	   115
```
##### 3. Which body regions record the highest number of patients with malignant diagnoses?
``` sql
select region, sum(case when diagnostic = 'MEL' then 1 else 0 end) as Malignant_diagnosis
from table2
group by region
order by Malignant_diagnosis desc;

Output:
"region" "Malignant_diagnosis
"BACK"      	4
"ARM"	        3
"FACE"      	2
"FOREARM"    	2
"THIGH"      	2
"NECK"	      1
"CHEST"	      1
"ABDOMEN"    	1
"EAR"        	1
"LIP"	        0
"SCALP"      	0
"HAND"	      0
"NOSE"	      0
"FOOT"	      0
```
##### 4. How many patients have a previous history of skin cancer?
``` sql
select count(patient_id) as total_skin_cancer_patients
from table1
where skin_cancer_history = 'true';

 Output:  224 patients has previous skin cancer diagnosis

```
### Task 2: Lesion Growth & Diagnosis Analysis
### Goal: Analyze lesion characteristics and identify indicators of dangerous skin conditions.
#### 1. Which diagnosis category appears most frequently?
``` sql

select  diagnostic, 
	count(*) as diagnostic_count
from table2
group by diagnostic
order by diagnostic_count desc;

Output:
"diagnostic"	"diagnostic_count"
"ACK"          	461
"BCC"	          273
"NEV"          	144
"SEK"          	137
"SCC"           56
"MEL"	           17
```
#### 2. How many lesions were reported as growing over time?

``` sql
select count(*) grown_lesion
from table2
where grew = 'true'

Output = 510
```
#### 3. Which symptoms are most commonly associated with lesions?
``` sql
select
	sum(case when itch = 'true' then 1 else 0 end) as itch,
	sum(case when grew = 'true' then 1 else 0 end) as grew,
	sum(case when hurt = 'true' then 1 else 0 end) as hurt,
	sum(case when changed = 'true' then 1 else 0 end) as changed,
	sum(case when bleed = 'true' then 1 else 0 end) as bleed,
	sum(case when elevation = 'true' then 1 else 0 end) as elevation
from table2

"itch" "grew" "hurt" "changed" "bleed" "elevation"
  670	   510	  151	    99	     222	     611
```


#### 4. How many lesions were biopsied before diagnosis confirmation?
 ``` sql
select count(*) as biopsed_region 
from table2
where biopsed = 'true'


 output = 458
```

#### 5. Which diagnosis type has the highest average lesion diameter?

``` sql
select 
	round(avg((diameter_1 + diameter_2) / 2)) as avg_diameter,
	diagnostic 
from table2
group by diagnostic
order by avg_diameter desc
limit 1;

Output:
"avg_diameter"	"diagnostic"
14	"MEL"
```

### Task 3: Environmental Healthcare Analysis
### Goal: Understand how environmental conditions influence diagnosis patterns.

#### 1. Which body region has the highest number of diagnosed cases?
``` sql
select region,
count(*) as total_diagnosis
from table2
group by region
order by total_diagnosis desc;

Output:
"region"    "total_diagnosis"
"FACE"	        278
"FOREARM"	      219
"CHEST"	        124
"BACK"	        105
"ARM"	           92
"NOSE"	         68
"HAND"	         55
"NECK"	         37
"THIGH"	         35
"EAR"	           32
"ABDOMEN"	       20
"SCALP"	         11
"LIP"            	7
"FOOT"	          5
```

#### 2. How many patients lack access to piped water?
``` sql
select 
count(*) as has_piped_water
from table1
where has_piped_water ='true';

Ouput : 306
```
#### 3. How many patients do not have access to sewage systems?
``` sql
select 
	count(*) as has_sewage
from table1
where has_sewage_system ='true';

Output: 273
```

#### 4. Which body regions report the highest number of biopsied lesions?
``` sql
select region, 
	sum(case when biopsed ='true' then 1 else 0 end) as total_biopsy
from table2
group by region
order by total_biopsy desc;

Output:
"region"	        "total_biopsy"
"FACE"	               124
"CHEST"	                63
"NOSE"	                54
"BACK"                	45
"FOREARM"              	44
"ARM"	                  37
"NECK"	                24
"EAR"	                  20
"THIGH"                	17
"HAND"	                16
"LIP"	                   6
"ABDOMEN"                5
"FOOT"	                 3
"SCALP"	                 0
```

#### 5. Is there a relationship between poor sanitation access and severe diagnosis outcomes?
``` sql
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
```

### Task 4: Lifestyle & Behavioral Risk Analysis
### Goal: Evaluate how lifestyle habits contribute to skin cancer risks and lesion severity.

#### 1. How many patients are smokers?

``` sql
select count(*) as smoking_patients
from table1
where smoke = 'true'

Output : 62
```
#### 2. How many patients consume alcohol regularly?
``` sql
select count(*) as drinks_alchohol
from table1
where drink = 'true'

Output: 138
```
#### 3. Which diagnosis types are most common among smokers?
``` sql
select count(case when t1.smoke = 'true' then 1 else 0 end) as total_smokers, t2.diagnostic
from table1 t1
join table2 t2
on t1.patient_id = t2.patient_id
group by t2.diagnostic
order by total_smokers desc;


Output:
"total_smokers"	"diagnostic"
461	            "ACK"
273            	"BCC"
144            	"NEV"
137            	"SEK"
56	            "SCC"
17	             "MEL"

```
#### 4. What percentage of smokers also consume alcohol?

 Output
 ``` sql
SELECT 
    SUM(CASE WHEN drink = 'true' THEN 1 ELSE 0 END) AS total_drinkers,

    SUM(CASE WHEN smoke = 'true' THEN 1 ELSE 0 END) AS total_smokers,

    round(SUM(CASE WHEN drink = 'true' AND smoke = 'true' THEN 1 ELSE 0 END) * 100.0 /
    SUM(CASE WHEN smoke = 'true' THEN 1 ELSE 0 END)) AS percentage_smokers_who_drink
FROM table1;

Output:
"total_drinkers"	"total_smokers"	"percentage_smokers_who_drink"
  138	                62	                45

``` 
#### 5. Are patients who both smoke and drink more likely to develop malignant conditions?
``` sql
select 
	(case when drink = 'true' and smoke = 'true' then 'smoker_and_drink' else 'others' end) as group_type,
	
	count(*) as total_patients,
	
	sum(case when cancer_history = 'true' and skin_cancer_history = 'true' then 1 else 0 end) as malignant_cases
from table1

group by (case when drink = 'true' and smoke= 'true' then 'smoker_and_drink' else 'others' end)


Output:
"group_type"  "total_patients"  "malignant_cases
"others"	            1060	            114
"smoker_and_drink"	    28	             8

```

#### 6. Which lifestyle factor has the strongest relationship with severe diagnosis outcomes?
``` sql
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


Output:
"factor"	    "mel"
"Smoking"	      2
"Drinking"	    5
```

## Key Insights and Outcome
### Task 1: Patient Demographic Risk Analysis

#### Insight: Older adults (126 cases) and elderly patients (60 cases) account for the vast majority of skin cancer history, while children and youth are rarely affected. Diagnoses are nearly evenly split between female (115) and male (109) patients. The back has the highest count of malignant (MEL) diagnoses, and 224 patients overall have a prior skin cancer history.

#### Outcome: Age is the strongest demographic risk factor, supporting targeted screening programs for patients over 50, while gender-neutral outreach is appropriate given the near-even split.

### Task 2: Lesion Growth & Diagnosis Analysis

#### Insight: Actinic Keratosis (ACK) is the most common diagnosis (461 cases), far ahead of malignant melanoma (MEL, 17 cases). Growth (510) and elevation (611) are the most frequently reported lesion symptoms, and MEL lesions have the largest average diameter (14mm) of any diagnosis type. 458 lesions were biopsied to confirm diagnosis.

#### Outcome: Larger, elevated, and growing lesions are the clearest clinical red flags, and diameter can serve as a practical triage indicator for prioritizing biopsy referrals, especially for suspected melanoma.

### Task 3: Environmental Healthcare Analysis

#### Insight: The face (278 cases) and forearm (219 cases) are the most commonly diagnosed and most frequently biopsied body regions, likely reflecting sun exposure patterns. 306 patients lack piped water access and 273 lack sewage access, though the relationship between sanitation and diagnosis severity requires further breakdown by diagnosis type.

#### Outcome: Sun-exposed regions (face, forearms) should be prioritized in screening protocols; sanitation access data suggests a socioeconomic dimension worth exploring further as a potential risk correlate.

### Task 4: Lifestyle & Behavioral Risk Analysis

#### Insight: Only 62 patients smoke and 138 drink alcohol, a small subset of the overall population, with about 45% of smokers also drinking. Patients who both smoke and drink show a higher proportional rate of malignant cases (8 out of 28, about 29%) compared to others (114 out of 1,060, about 11%). Drinking alone showed a stronger association with MEL diagnoses (5 cases) than smoking alone (2 cases).

#### Outcome: Combined smoking and drinking behavior more than doubles the malignant case rate, positioning this group as a high-priority cohort for targeted lifestyle counseling and more frequent screening.


### Overall Project Outcome: 
#### The analysis identifies age, sun-exposed body regions, lesion size/growth, and combined smoking-and-drinking behavior as the strongest predictors of skin cancer risk and severity, giving clinical and public health teams clear, data-backed criteria for prioritizing screening and outreach efforts.



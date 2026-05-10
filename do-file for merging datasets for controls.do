use "D:\R\fln_research\fs_bd.dta"

/*PARENTAL INVOLVEMENT

Let's harmonize variables to calculate parental involvement, the variables are: 
PR6 has information on whether someone helped child with homework
PR7 has information on whether child's school has governing body
PR8 has information on whether parent attended a school meeting
PR9A has information on whether parents met with teacher to address child's difficulties
PR9B has information on whether parents discussed budget with child
PR10 has information whether the student has received a student or report card
PR11A has information on whether parents attended celebration in the past 12 months
PR11B has information on whether parents went to school to discuss child's progress. */

foreach var of var PR6  PR7 PR8  PR9A  PR9B PR10 PR11A PR11B {
replace `var'=0 if `var'==2|`var'==8|`var'==9
}

/* Let's recode variables PR8, PR9A and PR9B. This is because PR8 is a subgroup of PR7, and PR9A and
PR9B are subgroups of PR8, and therefore we recode them to address
any discrepancy in data*/

replace PR8=0 if PR7==0

replace PR9A=0 if PR8==0

replace PR9B=0 if PR8==0

tab PR6

tab PR7

tab PR8

tab PR9A

tab PR9B

label define lblname19 0 "Didn't involve" 1 "Involved"

label values PR9B lblname19

tab PR9B

tab PR10

tab PR11A

tab PR11B

tab PR3, nol

gen PR3a=.

replace PR3a=0 if PR3==0

replace PR3a=1 if inrange(PR3, 1, 10)

tab PR3a

tab CB8B

/*Since this study focuses on primary education level in Bangladesh, let us limit the observations to Grade 1-5 */

keep if CB8B >= 1 & CB8B <= 5

tab CB8B

/* Let's see whether the observations are limited to primary level only */

tab CB5A

tab CB5A, nolab

drop if CB5A==2

tab caretakerdis

tab caretakerdis, nol

replace caretakerdis=. if caretakerdis==9

tab caretakerdis, missing

tab PR3

tab PR3, nol

replace PR3=. if PR3==99

tab PR3, missing

/**** Parental involvement in school management  ****/

* Financial involvement: parents discuss budget/fund use
gen fin_pi = .
replace fin_pi = 1 if PR9B == 1
replace fin_pi = 0 if PR9B == 0

* Non-financial involvement: meetings or educational issues
gen non_finpi = .
replace non_finpi = 1 if PR8 == 1 | PR9A == 1
replace non_finpi = 0 if PR8 == 0 & PR9A == 0

* Optional: zero out if no governing body (PR7 == 0)
replace fin_pi = 0 if PR7 == 0
replace non_finpi = 0 if PR7 == 0

tab fin_pi

tab non_finpi

br PR7 PR8 PR9A PR9B fin_pi non_finpi

*** Other controls ***
tab CB8B

rename CB8B grade

tab grade

tab grade, nol

replace grade=. if grade==9

drop if grade==.

/* Since grade attended is a categorical variable, let us create dummy variables out of it */

tab grade, gen(grade)

tab grade1

tab windex5

tab windex5, nol

drop if windex5==0

/* Let us create dummy variables for wealth index */

tab windex5, gen(wealth)

tab wealth1

tab HH6

generate rural = ( HH6==2)

replace rural=0 if rural !=1

tab rural

generate urban = ( HH6==1)

replace urban=0 if urban !=1

tab urban

tab HL4

tab HL4, nol

generate female = ( HL4 == 2)

replace female = 0 if female != 1

tab female

tab HH7

tab HH7, nol

tab fsdisability

tab fsdisability, nolab

generate child_disability = (fsdisability==1)

replace child_disability = 0 if child_disability != 1

tab child_disability

tab ethnicity

tab ethnicity, nol

generate non_bengali = ( ethnicity==2)

replace non_bengali = 0 if non_bengali != 1

tab non_bengali

tab caretakerdis

tab caretakerdis, nolab

generate caretaker_disability = (caretakerdis==1)

replace caretaker_disability = 0 if caretaker_disability != 1

tab caretaker_disability

rename HH52 num_child

tab melevel, missing

/* Since mother's level of education is a categorial variable, let us create dummy variables out of it */

tab melevel, gen(melevel)

tab melevel1


*** Merging fs and hl datasets ***

duplicates report HH1 HH2 LN HL4 CB8A grade HH6 HH7 HH7A windex5 ethnicity melevel schage

/* Duplicates report shows that there's only 1 copy for the above mentioned variables. Therefore, we can merge the datasets based on these variables */

merge 1:1 HH1 HH2 LN HL4 CB8A grade HH6 HH7 HH7A windex5 ethnicity melevel schage using "D:\R\Master's thesis\hl_bd.dta" 

/* We want to keep the observations that were matched */

keep if _merge==3

*** Controls from another dataset ***

tab felevel

tab felevel, nol

replace felevel=. if felevel==5 | felevel==9

tab felevel, missing

tab melevel

tab ED11

tab ED11, nol

replace ED11=. if ED11==8 | ED11==9

tab ED11, missing

tab felevel

tab felevel, missing

**** drop if felevel==.

tab felevel, nolab

/* Since father's education level is categorical, let us create dummy variables out of it */

tab felevel, gen(felevels)

tab felevels1

tab helevel

tab helevel, nol

replace helevel=. if helevel==9

label define lblname31 0 "None or preprimary" 1 "Primary" 2 "Secondary" 3 "Higher secondary+"

label values helevel lblname31 

tab helevel, gen(helevel)

tab ED11

tab ED11, nol

rename ED11 type_school

tab type_school

tab type_school, missing

drop if type_school==.

tab type_school

label define lblname32 1 "Public" 2 "Religious" 3 "Private" 4 "NGO" 6 "Others"
label values type_school lblname32

/* Since type of school is a categorical variable, let us create dummy variables for the type of school */

tab type_school, gen(types_school)

tab types_school1

tab ED12

tab ED12, nol

rename ED12 tuition

tab tuition

replace tuition=. if tuition==8 | tuition==9

tab tuition

gen tuition_status=.

replace tuition_status= 1 if tuition==1

replace tuition_status=0 if tuition==2

tab tuition_status

label define lblname111 0 "No tuition support" 1 "Tuition support"

label values tuition_status lblname111

tab tuition_status

tab ED14

tab ED14, nol

rename ED14 material_support

replace material_support=. if material_support==8

tab material_support, missing

tab material_support, gen(material_support)

tab material_support1

label define lblname20 0 "Not supported" 1 "Supported"

label values material_support1 lblname20

tab material_support1

rename HH7 division

tab division, gen(division)
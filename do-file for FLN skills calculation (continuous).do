/* This Do-File is for calculating the foundational literacy and numeracy skills in alternative way (continuous and grade-standardized). The grade-standardized continuous outcomes are helpful to run models like fixed effects, 2SLS, RD etc. */

/* Let us import the merged dataset that contains fs data from MICS6 2019 Bangladesh */

use "D:\R\fln_research\fs_bd.dta"

describe
summarize
keep if CB3 >= 7 & CB3 <= 14

/*  We need to generate variables to measure numeracy and liiteracy skills if foundation learning module
was taken. FL28==1 means the interview was completed, and therefore includes the foundational 
module.
The variables being generated are:
FOR LITERACY: 
	target represents the total number of words read;
	read_corr represents number of correctly read words of the text; 
	alit represents response to the literal questions;
	alnfe represents response to the inferential questions;
	readskill represents foundational literacy skills among children.              
	
FOR NUMERACY: 
	target_num represents identifying and reading numbers 
	number_read represents identifying and reading numbers correctly;
	number_dis represents response to number discrimination tasks;
	number_add represents response to addition tasks;
	number_patt represents reponse to number pattern tasks;
	numbskill reperesents foundational numeracy skills among children  */

foreach var in target read_corr read_corr1 alit alnfe readskill readskill1 target_num target_num1 number_read number_read1 number_dis number_dis1 number_add number_add1 number_patt number_patt1 numbskill numbskill1 {
gen `var'=0 if FL28==1
}

/* FOUNDATIONAL LITERACY SKILLS

To calculate foundation literacy skills (readskill), we need to replace values for read_corr, alit, alnfe. 
read_corr==x represents child read x% of words correctly
alit==x represents child respondes to the x number of questions out of three literal question correctly 
alnfe===x represents child responses to the x number of questions out of two inferential question correctly 
Each sub step below relates to this */

/*  4a. For read_corr:  First derive the reading target. To do this, we need to replace the values for target based on FL19W */

foreach num of numlist 1/72 {
replace target=target+1 if FL19W`num'==0
}
gen target1= FL20A - FL20B if (FL20B<.)

/*4b. Now, let's calculate the value for the numbers of correctly read words */

replace read_corr=target/72 if (target!=.&FL10==1)
replace read_corr1=target1/72 if (target1!=.&FL10==1)
replace read_corr1=. if target1==.

/*4c. For alit: Let's replace values using variable FL22A, FL22B and FL22C related with literal questions from FL module */

replace alit= alit+1 if FL22A==1
replace alit=alit+1 if FL22B==1
replace alit=alit+1 if FL22C==1

/*4d. For alnfe: Replace values using variables FL22D and FL22E related with inferential questions from FL module */

replace alnfe=alnfe+1 if FL22D==1
replace alnfe=alnfe+1 if FL22E==1

/* Calculate foundational reading skills if all tasks are correctly performed  */

replace readskill=alit/3 + read_corr + alnfe/2
tab readskill

/* To ensure equal weights to the read_corr, alit, and alnfe items, as in the original calculation by UNICEF, we divided the alit, read_corr, and alnfe scores by total questions in the respective items. Thus, those items contribute equally to readskill. This is how we can get continuous foundational literacy skill variable keeping the same logic of MICS6 guidebook */

replace readskill1 = alit/3 + read_corr1 + alnfe/2 
replace readskill1=. if read_corr1==.
tab readskill1, missing

/* If a child can get a score of 2.90 or above, she/he has foundational literacy skills. That means, if a child reads 77 words (90%) correctly, answer three literal and two inferential questions correctly, she/he has foundational literacy skills. */

gen fls=.
replace fls=1 if (readskill>=2.90 & readskill1!=.)
replace fls=0 if readskill<2.90
tab fls, missing
tab fls

/* The "fls" variable is the binary indicator of foundational literacy skills. This is exactly what MICS6 guidelines suggest */

gen fls1=.
replace fls1=1 if (readskill1>=2.90 & readskill1!=.)
replace fls1=0 if readskill1<2.90
tab fls1
tab fls1, missing

/*FOUNDATIONAL NUMERACY SKILLS

To calculate foundation numeracy skills (numbskill), let's replace values for number_read, number_dis, number_add, number_patt. 
number_read==x represents child having correctly identified and read x numbers out of all numbers;
number_dis==x represents child having correctly responded to x numbers of tasks out of all number discrimination tasks;
number_add==x represents child having correctly responded to x number of tasks out of all number addition tasks
number_patt==x represents child having correctly responded to x number of tasks out of all number pattern tasks
Each sub step below relates to this.*/

/*6a. For number_read: Let's first derive whether number reading target was met or not. To do so, replace value for target_num based on 
correctly reading numbers. FL23A==1, FL23B==1, FL23C==1, FL23D==1,FL23E==1,FL23F==1 represents correctly reading that number */

foreach var in FL23A FL23B FL23C FL23D FL23E FL23F {
replace target_num=target_num+1 if `var'==1
}

/*6b. Let's replace value for number_read if all numbers were read correctly  */

replace number_read=target_num


/*6c. For number_dis: Let's replace values if all number displacement questions were answered correctly. 
 FL24A==1, FL24B==1, FL24C==1, FL24D==1, FL24E==1, FL24F==1 represents correctly answering all number displacement questions*/
 
replace number_dis= number_dis + 1 if FL24A==1
replace number_dis= number_dis + 1 if FL24B==1
replace number_dis= number_dis + 1 if FL24C==1
replace number_dis= number_dis + 1 if FL24D==1
replace number_dis= number_dis + 1 if FL24E==1

/*6d. For number_add: Let's replace values if number addition questions were answered correctly.
 FL25A==1, FL25B==1, FL25C==1, FL25D==1, FL25E==1, FL25F==1 represents correctly answering all number addition questions */
 
replace number_add= number_add + 1 if FL25A==1
replace number_add= number_add + 1 if FL25B==1
replace number_add= number_add + 1 if FL25C==1
replace number_add= number_add + 1 if FL25D==1
replace number_add= number_add + 1 if FL25E==1

/*6e. For number_patt: Replace values if number pattern questions were answered correctly.
 FL27A==1, FL27B==1, FL27C==1 represents correctly answering all number pattern questions */
 
replace number_patt= number_patt + 1 if FL27A==1
replace number_patt= number_patt + 1 if FL27B==1
replace number_patt= number_patt + 1 if FL27C==1 
replace number_patt= number_patt + 1 if FL27D==1
replace number_patt= number_patt + 1 if FL27E==1


/* Calculate foundational numeracy skills if all tasks are correct */

replace numbskill= number_read/6 + number_dis/5 + number_add/5 + number_patt/5
tab numbskill

/* Same as literacy skills, we divided the scores in each time by the number of questions in the item. Thus, each item contribute equally to the numeracy skills. */

gen fns=.
replace fns=1 if numbskill>=4
replace fns=0 if numbskill<4
tab fns

/* The "fls" variable is the binary indicator of foundational literacy skills. This is exactly what MICS6 guidelines suggest */

/* Alternative calculation of foundational numeracy skills */
 
replace target_num1=0
replace number_read1=0
replace number_dis1=0
replace number_add1=0
replace number_patt1=0

* Identify correct number reading
foreach var in FL23A FL23B FL23C FL23D FL23E FL23F {
    replace target_num1 = target_num1 + 1 if `var' == 1
}
replace number_read1 = target_num1

* Number discrimination tasks
foreach var in FL24A FL24B FL24C FL24D FL24E {
    replace number_dis1 = number_dis1 + 1 if `var' == 1
}

* Addition tasks
foreach var in FL25A FL25B FL25C FL25D FL25E {
    replace number_add1 = number_add1 + 1 if `var' == 1
}

* Number pattern tasks
foreach var in FL27A FL27B FL27C FL27D FL27E {
    replace number_patt1 = number_patt1 + 1 if `var' == 1
}
* Compute total numeracy skill score
replace numbskill1 = number_read1/6 + number_dis1/5 + number_add1/5 + number_patt1/5

 
* Set numbskill1 to missing if child attempted none (no 1 or 2 in any item)
gen has_valid = 0
foreach var in FL23A FL23B FL23C FL23D FL23E FL23F FL24A FL24B FL24C FL24D FL24E FL25A FL25B FL25C FL25D FL25E FL27A FL27B FL27C FL27D FL27E {
    replace has_valid = has_valid | inlist(`var', 1, 2)
}
replace numbskill1 = . if has_valid == 0
drop has_valid
tab numbskill1
tab numbskill1, missing
gen fns1=.
replace fns1=1 if numbskill1>=4 & numbskill1!=.
replace fns1=0 if numbskill1<4
replace fns1=. if numbskill1==.
tab fns1, missing
tab fns1
replace readskill=. if numbskill1==.
replace numbskill=. if numbskill1==.


 *** Standardization of the outcome variable ***

egen z_readskill=std(readskill)
egen z_numbskill=std(numbskill)
tab z_readskill
tab z_numbskill
     
	 ******** Grade-adjusted FLN skills ******

egen gaz_litskill = std(readskill), by(grade)
tab gaz_litskill	 
egen gaz_numbskill = std(numbskill), by(grade)
tab gaz_numbskill

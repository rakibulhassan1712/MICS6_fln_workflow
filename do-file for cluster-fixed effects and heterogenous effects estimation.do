/* This do-file is for getting summary statistics, cluster-fixed effects estimation, and estimation of heterogenous effects */

/* Importing the merged dataset for further analysis */

use "D:\R\fln_research\fs_bd.dta"


/* Let us summarize all the relevant variables */

summarize readskill readskill1 numbskill numbskill1 fls fls1 fns fns1 z_readskill z_numbskill gaz_litskill gaz_numbskill material_support1 tuition_status fin_pi non_finpi PR3a PR6 PR10 PR11A PR11B wealth1 wealth2 wealth3 wealth4 wealth5 helevel1 helevel2 helevel3 helevel4 rural female child_disability schage num_child caretaker_disability grade1 grade2 grade3 grade4 grade5 types_school1 types_school2 types_school3 types_school4 types_school5 non_bengali age_order


misstable summarize readskill readskill1 numbskill numbskill1 fls fls1 fns fns1 z_readskill z_numbskill gaz_litskill gaz_numbskill material_support1 tuition_status fin_pi non_finpi PR3a PR6 PR10 PR11A PR11B wealth1 wealth2 wealth3 wealth4 wealth5 helevel1 helevel2 helevel3 helevel4 rural female child_disability schage num_child caretaker_disability grade1 grade2 grade3 grade4 grade5 types_school1 types_school2 types_school3 types_school4 types_school5 non_bengali age_order


drop if numbskill==.

drop if fls==.

drop if fns==.

drop if PR6==.

drop if helevel1==.

drop if material_support1==.

drop if tuition_status==.

misstable summarize readskill numbskill fls fns z_readskill z_numbskill gaz_litskill gaz_numbskill material_support1 tuition_status fin_pi non_finpi PR3a PR6 PR10 PR11A PR11B wealth1 wealth2 wealth3 wealth4 wealth5 helevel1 helevel2 helevel3 helevel4 rural female child_disability schage num_child caretaker_disability grade1 grade2 grade3 grade4 grade5 types_school1 types_school2 types_school3 types_school4 types_school5 non_bengali age_order

summarize readskill numbskill fls fns z_readskill z_numbskill gaz_litskill gaz_numbskill material_support1 tuition_status fin_pi non_finpi PR3a PR6 PR10 PR11A PR11B wealth1 wealth2 wealth3 wealth4 wealth5 helevel1 helevel2 helevel3 helevel4 rural female child_disability schage num_child caretaker_disability grade1 grade2 grade3 grade4 grade5 types_school1 types_school2 types_school3 types_school4 types_school5 non_bengali age_order


  *** Summary table by treatment ***
estpost ttest readskill numbskill fls fns z_readskill z_numbskill gaz_litskill gaz_numbskill non_finpi wealth1 wealth2 wealth3 wealth4 wealth5 helevel1 helevel2 helevel3 helevel4 rural material_support1 PR3a PR6 PR10 PR11A PR11B female grade1 grade2 grade3 grade4 grade5 types_school1 types_school2 types_school3 types_school4 types_school5 child_disability num_child caretaker_disability non_bengali schage tuition_status age_order, by(fin_pi)

esttab, cells("mu_1 (fmt(3)) mu_2(fmt(3)) b(fmt(3)) p(fmt(3))") star(* 0.10 ** 0.05 *** 0.01)

estpost ttest readskill numbskill fls fns z_readskill z_numbskill gaz_litskill gaz_numbskill fin_pi wealth1 wealth2 wealth3 wealth4 wealth5 helevel1 helevel2 helevel3 helevel4 rural material_support1 PR3a PR6 PR10 PR11A PR11B female grade1 grade2 grade3 grade4 grade5 types_school1 types_school2 types_school3 types_school4 types_school5 child_disability num_child caretaker_disability non_bengali schage tuition_status age_order, by(non_finpi)

esttab, cells("mu_1 (fmt(3)) mu_2(fmt(3)) b(fmt(3)) p(fmt(3))") star(* 0.10 ** 0.05 *** 0.01)


*** Parental involvement in school financial management ***

      *** Cluster fixed effects ***

reghdfe gaz_litskill (fin_pi non_finpi)##i.windex5 i.helevel material_support1 PR3a PR6 PR10 PR11A PR11B female child_disability num_child caretaker_disability i.type_school non_bengali schage tuition_status age_order [pw=fsweight], absorb(HH1) vce(cluster HH1)

testparm 1.fin_pi#i.windex5

margins i.windex5#fin_pi

marginsplot, title("Predicted literacy scores by financial management and household wealth", size(medsmall)) xtitle("Household wealth quintile", size(small)) ytitle("Predicted foundational literacy score (SD)", size(small)) xlabel(1 "Poorest" 2 "Second" 3 "Middle" 4 "Fourth" 5 "Richest", labsize(small)) legend(order(1 "Not involved" 2 "Involved") size(small)) 


margins windex5, dydx(fin_pi)

marginsplot

testparm i.windex5#non_finpi

margins i.windex5#non_finpi

marginsplot, title("Predicted literacy scores by non-financial management and household wealth", size(medsmall)) xtitle("Household wealth quintile", size(small)) ytitle("Predicted foundational literacy score (SD)", size(small)) xlabel(1 "Poorest" 2 "Second" 3 "Middle" 4 "Fourth" 5 "Richest", labsize(small)) legend(order(1 "Not involved" 2 "Involved") size(small)) 

margins windex5, dydx(non_finpi)

*** To test whether financial or non-financial involvement has stronger effects among all wealth groups *** 
 
margins windex5, dydx(fin_pi non_finpi)
lincom _b[1.fin_pi] - _b[1.non_finpi]
 
*** To test whether financial or non-financial involvement has stronger effects overall ***
margins, dydx(fin_pi non_finpi) post
lincom _b[1.fin_pi] - _b[1.non_finpi]

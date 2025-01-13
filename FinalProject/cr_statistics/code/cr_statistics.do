/*****************************************************************************
					Replicate Hours and Wages Statistics 
****************************************************************************/ 
clear all 
cap log close 
log using ..\output\empirical_replication.log, replace 
set scheme plotplainblind

* Import CPS Data 
u ..\..\cr_cps_data\output\raw_cps_data if eligorg == 1, clear 

* Keep ORG from 9/1995 to 8/2007 
gen date = mdy(month,1,year) 

gen monthly_date = mofd(date)

keep if inrange(monthly_date,mofd(mdy(9,1,1995)),mofd(mdy(8,1,2007)))

* Sample Selection: Men 25-64 who worked only one job with usual weekly hours over 10, not enrolled in school, and not self employed 
* Keep men 
keep if sex == 1 

* Keep in age range
keep if inrange(age,25,64) 

* Keep if one job 
keep if multjob == 1 

* Keep those who aren't self-employed 
keep if ~inrange(classwkr,13,14)

* Not enrolled 
* keep if schlcoll == 5 

* Over 10 Usual weekly hours 
keep if uhrswork1 >= 10 

* Paper replication 
* Variables of interest: usual weekly hours at main job (uhrswork1) and usual weekly earnings at main job (earnweek)

* Figure I 
* Create hours bins 
replace uhrswork1 =. if uhrswork1 >= 997
gen person = 1 

gen hours_bin =. 
replace hours_bin = 1 if inrange(uhrswork1,.,35)
replace hours_bin = 2 if inrange(uhrswork1,35,39)
replace hours_bin = 3 if inrange(uhrswork1,40,44)
replace hours_bin = 4 if inrange(uhrswork1,45,49)
replace hours_bin = 5 if inrange(uhrswork1,50,.)
replace hours_bin =. if missing(uhrswork1)

label define hours_bin_lbl 1 "<35" 2 "35-29" 3 "40-44" 4 "45-49" 5 "50+"
label values hours_bin hours_bin_lbl

* Histogram weights need to be integers, final weight without decimals 
gen hist_weight = wtfinl*10000

graph bar (percent) person, over(hours_bin) b1title("Hours Bin") ytitle("Share in %") blabel(bar)  saving(hours_bin, replace)

gen long_hours_bin=. 
replace long_hours_bin = 0 if inrange(uhrswork1,10,49)
replace long_hours_bin = 1 if inrange(uhrswork1,50,54)
replace long_hours_bin = 2 if inrange(uhrswork1,55,59)
replace long_hours_bin = 3 if inrange(uhrswork1,60,64)
replace long_hours_bin = 4 if inrange(uhrswork1,65,69)
replace long_hours_bin = 5 if inrange(uhrswork1,70,74)
replace long_hours_bin = 6 if inrange(uhrswork1,75,79)
replace long_hours_bin = 7 if inrange(uhrswork1,80,.)
replace long_hours_bin =. if missing(uhrswork1)
label define long_hours_bin_lbl 1 "50-54" 2 "55-59" 3 "60-64" 4 "65-69" 5 "70-74" 6 "75-79" 7 "80+"
label values long_hours_bin long_hours_bin_lbl

graph bar (percent) person if long_hours_bin != 0,  over(long_hours_bin) b1title("Long Hours Bin") ytitle("Share in %") blabel(bar) saving(long_hours_bin, replace)

graph combine hours_bin.gph long_hours_bin.gph
graph export ..\output\figure1.png, replace 

* Figure II
gen age_bin=. 
replace age_bin = 1 if inrange(age,25,34) 
replace age_bin = 2 if inrange(age,35,44)
replace age_bin = 3 if inrange(age,45,54)
replace age_bin = 4 if inrange(age,55,64)
label define age_bin_lbl 1 "25-34" 2 "35-44" 3 "45-54" 4 "55-64"
label values age_bin age_bin_lbl

graph bar (percent) person,  over(age_bin) asyvars over(hours_bin) b1title("Hours Bin") ytitle("Share in %") legend(position(6) cols(4)) saving(age_bins, replace)

gen educ_bin=. 
replace educ_bin = 1 if inrange(educ,.,71)
replace educ_bin = 2 if inrange(educ,72,92) 
replace educ_bin = 3 if inrange(educ,111,111)
replace educ_bin = 4 if inrange(educ,123,.)
label define educ_bin_lbl 1 "LHS" 2 "HS" 3 "Bach" 4 "Bach+" 
label values educ_bin educ_bin_lbl 

graph bar (percent) person,  over(educ_bin) asyvars over(hours_bin) b1title("Hours Bin") ytitle("Share in %") legend(position(6) cols(4)) saving(educ_bins, replace)

graph combine age_bins.gph educ_bins.gph 
graph export ..\output\figure2.png, replace 

* Figure III 
gen wage_hour_bins=. 
forvalues i = 1(1)14 {
	local hr_start = 5*(`i'+1) 
	local hr_end = 5*(`i'+2) - 1
	
	replace wage_hour_bins = `i' if inrange(uhrswork1,`hr_start',`hr_end') 
}
label define wage_hour_bins_lbl 1 "10-14" 2 "15-19" 3 "20-24" 4 "25-29" 5 "30-34" 6 "35-39" 7 "40-44" 8 "45-49" 9 "50-54" 10 "55-59" 11 "60-64" 12 "65-69" 13 "70-74" 14 "75-79" 15 "80+"
label values wage_hour_bins wage_hour_bins_lbl

replace wage_hour_bins = 15 if inrange(uhrswork1,80,99)

gen lhr_wage = log(earnweek/uhrswork1)
gen learnings = log(earnweek) 
gen lhrs = log(uhrswork1)

gen age2 = age^2
gen married = (marst == 1 | marst == 2)

gen race_cat=. 
replace race_cat = 1 if race == 200 
replace race_cat = 2 if hispan > 1 & missing(race_cat) 
replace race_cat = 3 if missing(race_cat)

label define race_cat_lbl 1 "Black" 2 "Hispanic" 3 "Non-Black Non-Hispanic"
label values race_cat race_cat_lbl

gen public = (classwkr == 22 | classwkr == 23) 
label define public_lbl 1 "Private" 2 "Public"
label values public public_lbl

gen metro_area = (metro == 2 | metro == 3 | metro == 4)

save ..\temp\pre_regression.dta, replace 

* Log of Hourly Wages
u ..\temp\pre_regression, clear 

statsby _b _se: reg lhr_wage ib7.wage_hour_bins age age2 i.educ_bin i.year i.married i.month i.race_cat i.public i.metro_area i.statefip i.union, robust

preserve 
keep _stat_111 _stat_112 _stat_113 _stat_114 _stat_115 _stat_116 _stat_117 _stat_118 _stat_119 _stat_120 _stat_121 _stat_122 _stat_123 _stat_124 _stat_125

xpose, clear 

rename v1 se1 

gen hours = (_n + 1)*5

tempfile se1 
save `se1'

restore 

keep _stat_1 _stat_2 _stat_3 _stat_4 _stat_5 _stat_6 _stat_7 _stat_8 _stat_9 _stat_10 _stat_11 _stat_12 _stat_13 _stat_14 _stat_15  

xpose, clear 

gen hours = (_n + 1)*5 

merge 1:1 hours using `se1' 

gen low = v1 - se1*1.96 
gen high = v1 + se1*1.96 

graph twoway (connected v1 hours) (rarea low high hours, fcolor(%30)), legend(order(2) lab(2 "95% CI") position(6)) xtitle("Hours bin (usual weekly hours)") ytitle("log of Hourly Wages") 
graph export ..\output\figure3_a.png, replace 

* Log Earnings 
u ..\temp\pre_regression, clear 

statsby _b _se: reg learnings ib7.wage_hour_bins age age2 i.educ_bin i.year i.married i.month i.race_cat i.public i.metro_area i.statefip i.union, robust

preserve 
keep _stat_111 _stat_112 _stat_113 _stat_114 _stat_115 _stat_116 _stat_117 _stat_118 _stat_119 _stat_120 _stat_121 _stat_122 _stat_123 _stat_124 _stat_125

xpose, clear 

rename v1 se2 

gen hours = (_n + 1)*5

tempfile se2 
save `se2'

restore 

keep _stat_1 _stat_2 _stat_3 _stat_4 _stat_5 _stat_6 _stat_7 _stat_8 _stat_9 _stat_10 _stat_11 _stat_12 _stat_13 _stat_14 _stat_15  

xpose, clear 

gen hours = (_n + 1)*5 

merge 1:1 hours using `se2' 

gen low = v1 - se2*1.96 
gen high = v1 + se2*1.96 

graph twoway (connected v1 hours) (rarea low high hours, fcolor(%30)), legend(order(2) lab(2 "95% CI") position(6)) xtitle("Hours bin (usual weekly hours)") ytitle("log of Weekly Earnings") 
graph export ..\output\figure3_b.png, replace 

* Figure IV 
* I'm not cleaning that many datasets, so looking at panels (A)-(D)

u ..\temp\pre_regression, clear 

* Generate Occupation Categories 
gen occ_cat=. 
replace occ_cat = 1 if inrange(occ2010,0,430)
replace occ_cat = 2 if inrange(occ2010,500,730)
replace occ_cat = 3 if inrange(occ2010,800,950)
replace occ_cat = 4 if inrange(occ2010,1000,1240)
replace occ_cat = 5 if inrange(occ2010,1300,1540)
replace occ_cat = 6 if inrange(occ2010,1550,1560)
replace occ_cat = 7 if inrange(occ2010,1600,1980)
replace occ_cat = 8 if inrange(occ2010,2000,2060)
replace occ_cat = 9 if inrange(occ2010,2100,2150)
replace occ_cat = 10 if inrange(occ2010,2200,2550)
replace occ_cat = 11 if inrange(occ2010,2600,2920)
replace occ_cat = 12 if inrange(occ2010,3000,3650)
replace occ_cat = 13 if inrange(occ2010,3700,3950)
replace occ_cat = 14 if inrange(occ2010,4000,4150)
replace occ_cat = 15 if inrange(occ2010,4200,4250)
replace occ_cat = 16 if inrange(occ2010,4300,4650)
replace occ_cat = 17 if inrange(occ2010,4700,4965)
replace occ_cat = 18 if inrange(occ2010,5000,5940)
replace occ_cat = 19 if inrange(occ2010,6000,6130)
replace occ_cat = 20 if inrange(occ2010,6200,6765)
replace occ_cat = 21 if inrange(occ2010,6800,6940)
replace occ_cat = 22 if inrange(occ2010,7000,7630)
replace occ_cat = 23 if inrange(occ2010,7700,8965)
replace occ_cat = 24 if inrange(occ2010,9000,9750)

* Generate Industry Categories 
gen ind_cat=. 
replace ind_cat = 1 if inrange(ind1990,10,32)
replace ind_cat = 2 if inrange(ind1990,40,50)
replace ind_cat = 3 if inrange(ind1990,60,60)
replace ind_cat = 4 if inrange(ind1990,100,392)
replace ind_cat = 5 if inrange(ind1990,400,472)
replace ind_cat = 6 if inrange(ind1990,500,571)
replace ind_cat = 7 if inrange(ind1990,580,691)
replace ind_cat = 8 if inrange(ind1990,700,712)
replace ind_cat = 9 if inrange(ind1990,721,760)
replace ind_cat = 10 if inrange(ind1990,761,791)
replace ind_cat = 11 if inrange(ind1990,800,810)
replace ind_cat = 12 if inrange(ind1990,812,893)
replace ind_cat = 13 if inrange(ind1990,900,932)

save ..\temp\pre_regression.dta, replace 

* Age 
u ..\temp\pre_regression, clear 

statsby _b, by(age_bin): reg lhr_wage ib7.wage_hour_bins age age2 i.educ_bin i.year i.married i.month i.race_cat i.public i.metro_area i.statefip i.union, robust

keep _stat_1 _stat_2 _stat_3 _stat_4 _stat_5 _stat_6 _stat_7 _stat_8 _stat_9 _stat_10 _stat_11 _stat_12 _stat_13 _stat_14 _stat_15 age_bin

xpose, clear 

drop if _n == 1 
gen hours = (_n + 1)*5

graph twoway (connected v1 hours) (connected v2 hours)  (connected v3 hours)  (connected v4 hours), yline(0) xline(40) legend(lab(1 "25-34") lab(2 "35-44") lab(3 "45-54") lab(4 "55-64") position(6) cols(4)) ytitle("Log of Hourly Wage") xtitle("Hours bin (usual weekly hours)")
graph export ..\output\figure4_a.png, replace 

* Education 
u ..\temp\pre_regression, clear 

statsby _b, by(educ_bin): reg lhr_wage ib7.wage_hour_bins age age2 i.educ_bin i.year i.married i.month i.race_cat i.public i.metro_area i.statefip i.union, robust

keep _stat_1 _stat_2 _stat_3 _stat_4 _stat_5 _stat_6 _stat_7 _stat_8 _stat_9 _stat_10 _stat_11 _stat_12 _stat_13 _stat_14 _stat_15 educ_bin

xpose, clear 

drop if _n == 1 
gen hours = (_n + 1)*5

graph twoway (connected v1 hours) (connected v2 hours)  (connected v3 hours)  (connected v4 hours), yline(0) xline(40) legend(lab(1 "LHS") lab(2 "HS") lab(3 "Bach") lab(4 "Bach+") position(6) cols(4)) ytitle("Log of Hourly Wage") xtitle("Hours bin (usual weekly hours)")
graph export ..\output\figure4_b.png, replace 

* Occupation 
u ..\temp\pre_regression, clear  

statsby _b, by(occ_cat): reg lhr_wage ib7.wage_hour_bins age age2 i.educ_bin i.year i.married i.month i.race_cat i.public i.metro_area i.statefip i.union, robust

keep _stat_1 _stat_2 _stat_3 _stat_4 _stat_5 _stat_6 _stat_7 _stat_8 _stat_9 _stat_10 _stat_11 _stat_12 _stat_13 _stat_14 _stat_15 occ_cat

xpose, clear 

drop if _n == 1 

gen hours = (_n + 1)*5

graph twoway (connected v1 hours) (connected v2 hours)  (connected v3 hours)  (connected v4 hours) (connected v5 hours)(connected v6 hours)(connected v7 hours)(connected v8 hours)(connected v9 hours)(connected v10 hours)(connected v11 hours)(connected v12 hours)(connected v13 hours)(connected v14 hours)(connected v15 hours)(connected v16 hours)(connected v17 hours)(connected v18 hours)(connected v19 hours)(connected v20 hours)(connected v21 hours)(connected v22 hours)(connected v23 hours)(connected v24 hours) , yline(0) xline(40) legend(off) ytitle("Log of Hourly Wage") xtitle("Hours bin (usual weekly hours)")
graph export ..\output\figure4_c.png, replace 

* Industry 
u ..\temp\pre_regression, clear  

statsby _b, by(ind_cat): reg lhr_wage ib7.wage_hour_bins age age2 i.educ_bin i.year i.married i.month i.race_cat i.public i.metro_area i.statefip i.union, robust

keep _stat_1 _stat_2 _stat_3 _stat_4 _stat_5 _stat_6 _stat_7 _stat_8 _stat_9 _stat_10 _stat_11 _stat_12 _stat_13 _stat_14 _stat_15 ind_cat

xpose, clear 

drop if _n == 1 

gen hours = (_n + 1)*5

graph twoway (connected v1 hours) (connected v2 hours)  (connected v3 hours)  (connected v4 hours) (connected v5 hours)(connected v6 hours)(connected v7 hours)(connected v8 hours)(connected v9 hours)(connected v10 hours)(connected v11 hours)(connected v12 hours)(connected v13 hours) , yline(0) xline(40) legend(off) ytitle("Log of Hourly Wage") xtitle("Hours bin (usual weekly hours)")
graph export ..\output\figure4_d.png, replace 

* Figure V 
u ..\temp\pre_regression, clear 

statsby _b _se, by(paidhour): reg lhr_wage ib7.wage_hour_bins age age2 i.educ_bin i.year i.married i.month i.race_cat i.public i.metro_area i.statefip i.union, robust 
preserve 

keep paidhour _stat_111 _stat_112 _stat_113 _stat_114 _stat_115 _stat_116 _stat_117 _stat_118 _stat_119 _stat_121 _stat_120 _stat_122 _stat_123 _stat_124 _stat_125 

xpose, clear 

drop if _n == 1 

gen hours = (_n + 1)*5

rename v1 se_1 
rename v2 se_2

tempfile se_file
save `se_file'

restore 

keep _stat_1 _stat_2 _stat_3 _stat_4 _stat_5 _stat_6 _stat_7 _stat_8 _stat_9 _stat_10 _stat_11 _stat_12 _stat_13 _stat_14 _stat_15 paidhour 


xpose, clear 

drop if _n == 1 

gen hours = (_n + 1)*5

merge 1:1 hours using `se_file'

gen low1 = v1 - se_1*1.96 
gen high1 = v1 + se_1*1.96 
gen low2 = v2 - se_2*1.96 
gen high2 = v2 + se_2*1.96 

graph twoway (connected v1 hours) (connected v2 hours) (rarea low1 high1 hours, fcolor(%30)) (rarea low2 high2 hours, fcolor(%30)), yline(0) xline(40) legend( order(1 2) lab(1 "Salary") lab(2 "Hourly")) ytitle("Log of Hourly Wage") xtitle("Hours bin (usual weekly hours)")
graph export ..\output\figure5.png, replace 

*******************
* Table I 
*******************
u ..\..\cr_cps_data\output\raw_cps_data if asecflag == 1, clear 

* Sample Selection: Men 25-64 who worked only one job with usual weekly hours over 10, not enrolled in school, and not self employed 
* Keep men 
keep if sex == 1 

* Keep in age range
keep if inrange(age,25,64) 

* Keep if one job 
* keep if multjob == 1 

* Keep those who aren't self-employed 
* keep if ~inrange(classwkr,13,14)

* Not enrolled 
* keep if schlcoll == 5 

* Over 10 Usual weekly hours 
keep if uhrswork1 >= 10 

gen age_bin=. 
replace age_bin = 1 if inrange(age,25,34) 
replace age_bin = 2 if inrange(age,35,44)
replace age_bin = 3 if inrange(age,45,54)
replace age_bin = 4 if inrange(age,55,64)
label define age_bin_lbl 1 "25-34" 2 "35-44" 3 "45-54" 4 "55-64"
label values age_bin age_bin_lbl

gen educ_bin=. 
replace educ_bin = 1 if inrange(educ,.,71)
replace educ_bin = 2 if inrange(educ,72,92) 
replace educ_bin = 3 if inrange(educ,111,111)
replace educ_bin = 4 if inrange(educ,123,.)
label define educ_bin_lbl 1 "LHS" 2 "HS" 3 "Bach" 4 "Bach+" 
label values educ_bin educ_bin_lbl 

gen race_cat=. 
replace race_cat = 1 if race == 200 
replace race_cat = 2 if hispan > 1 & missing(race_cat) 
replace race_cat = 3 if missing(race_cat)

label define race_cat_lbl 1 "Black" 2 "Hispanic" 3 "Non-Black Non-Hispanic"
label values race_cat race_cat_lbl

gen married = (marst == 1 | marst == 2)

gen nonlabor_income = ftotval - incwage 

xtile nonlabor_quint = nonlabor_income, nq(5)

reg uhrswork1 i.age_bin i.race_cat i.married nchild nchlt5 i.nonlabor_quint

save ..\temp\pre_r2, replace 

* Row 1 (All regressors)
u ..\temp\pre_r2, clear 

statsby e(r2), by(educ_bin): reg uhrswork1 i.age_bin i.race_cat i.married nchild nchlt5 i.nonlabor_quint, robust

save ..\output\table1_row1_panela.dta, replace 

* Row 2 (no age)
u ..\temp\pre_r2, clear 

statsby e(r2), by(educ_bin): reg uhrswork1 i.race_cat i.married nchild nchlt5 i.nonlabor_quint, robust

save ..\output\table1_row2_panela.dta, replace 

* Row 3 (no race)
u ..\temp\pre_r2, clear 

statsby e(r2), by(educ_bin): reg uhrswork1 i.age_bin i.married nchild nchlt5 i.nonlabor_quint, robust

save ..\output\table1_row3_panela.dta, replace 

* Row 4 (no marital status) 
u ..\temp\pre_r2, clear 

statsby e(r2), by(educ_bin): reg uhrswork1 i.age_bin i.race_cat nchild nchlt5 i.nonlabor_quint, robust

save ..\output\table1_row4_panela.dta, replace 

* Row 5 (no child variables)
u ..\temp\pre_r2, clear 

statsby e(r2), by(educ_bin): reg uhrswork1 i.age_bin i.race_cat i.married i.nonlabor_quint, robust

save ..\output\table1_row5_panela.dta, replace 

* Row 6 (no income quintile)
u ..\temp\pre_r2, clear 

statsby e(r2), by(educ_bin): reg uhrswork1 i.age_bin i.race_cat i.married nchild nchlt5, robust

save ..\output\table1_row6_panela.dta, replace 

* Match and regress 
* I. Sample Selection 
* Drop those who are missing their cpsidp/cpsid and ditch those in the ASEC oversample (id == 0)
u ..\temp\pre_r2, clear 

drop if cpsidp == 0 | cpsidp ==.
drop if cpsid == 0 | cpsid ==. 

* drop if demographics aren't available 
drop if age ==. | sex ==. | race ==. 
drop if asecflag == 0

* clean income
local list ="hhincome inctot incwage"
foreach var in `list' {
	replace `var'=. if inlist(`var', 999999999,999999998,99999999,99999998,999999,999998,9999999,9999998,99999)
}

* Generate duplicates to find out who appears twice 
sort cpsidp sex race year
by cpsidp sex race: gen dup = cond(_N==1,0,_n)

* Create Year 1 variables 
preserve

keep if dup == 1 

rename year year1 

local list = "statefip county metfips metro hhincome pernum wtfinl cpsidv asecwt earnweek2 hourwage2 relate age race marst popstat nchild nchlt5 bpl citizen hispan empstat labforce occ occ2010 occ1990 ind1990 occ1950 ind ind1950 classwkr uhrswork1 uhrswork2 ahrsworkt ahrswork1 wkstat multjob numjob educ ftotval inctot incwage hourwage paidhour union earnweek uhrsworkorg wksworkorg eligorg educ_bin age_bin race_cat married nonlabor_quint"

foreach var in `list' {
rename `var' `var'_year1
}

bys cpsid cpsidp sex: gen dup2 = cond(_N==1,0,_n)
drop if dup2 > 1

tempfile year1
save `year1'

* Create Year 2 variables 
restore
keep if dup == 2

rename year year2 

gen year1 = year2 - 1 

foreach var in `list' {
rename `var' `var'_year2
}

bys cpsid cpsidp sex: gen dup2 = cond(_N==1,0,_n)
drop if dup2 > 1

* Merge Year 1 and Year 2 
merge 1:1 cpsid cpsidp sex using `year1'


reg uhrswork1_year2 uhrswork1_year1 i.age_bin_year2 i.race_cat_year2 i.married_year2 nchild_year2 nchlt5_year2 i.nonlabor_quint_year2, robust

save ..\temp\pre_r2_2, replace 

* Row 1 (All regressors)
u ..\temp\pre_r2_2, clear 

statsby e(r2), by(educ_bin_year2): reg uhrswork1_year2 uhrswork1_year1 i.age_bin_year2 i.race_cat_year2 i.married_year2 nchild_year2 nchlt5_year2 i.nonlabor_quint_year2, robust

save ..\output\table1_row1_panelb.dta, replace 

* Row 2 (no age)
u ..\temp\pre_r2_2, clear 

statsby e(r2), by(educ_bin_year2): reg uhrswork1_year2 uhrswork1_year1 i.race_cat_year2 i.married_year2 nchild_year2 nchlt5_year2 i.nonlabor_quint_year2, robust

save ..\output\table1_row2_panelb.dta, replace 

* Row 3 (no race)
u ..\temp\pre_r2_2, clear 

statsby e(r2), by(educ_bin_year2): reg uhrswork1_year2 uhrswork1_year1 i.age_bin_year2 i.married_year2 nchild_year2 nchlt5_year2 i.nonlabor_quint_year2, robust

save ..\output\table1_row3_panelb.dta, replace 

* Row 4 (no marital status) 
u ..\temp\pre_r2_2, clear 

statsby e(r2), by(educ_bin_year2): reg uhrswork1_year2 uhrswork1_year1 i.age_bin_year2 i.race_cat_year2 nchild_year2 nchlt5_year2 i.nonlabor_quint_year2, robust

save ..\output\table1_row4_panelb.dta, replace 

* Row 5 (no child variables)
u ..\temp\pre_r2_2, clear 

statsby e(r2), by(educ_bin_year2): reg uhrswork1_year2 uhrswork1_year1 i.age_bin_year2 i.race_cat_year2 i.married_year2 i.nonlabor_quint_year2, robust

save ..\output\table1_row5_panelb.dta, replace 

* Row 6 (no income quintile)
u ..\temp\pre_r2_2, clear 

statsby e(r2), by(educ_bin_year2): reg uhrswork1_year2 uhrswork1_year1 i.age_bin_year2 i.race_cat_year2 i.married_year2 nchild_year2 nchlt5_year2, robust

save ..\output\table1_row6_panelb.dta, replace 

cap log close 
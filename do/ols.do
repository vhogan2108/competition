* competion law paper
* adpated from FL Attendance paper
* Read in the data and deal with date issues
* In excel manually format the date column to be a consistent format: best is custom "DD/MM/YYYY"
* In excel save as "CSV UTF-8 (Comma delimited)" rather than plain "CSV (Comma delimited)".



global paper "competition"
global outtype "booktabs"
*global outtype "rtf "



**********************************
clear
set more 1
global root: env research_home // set on every computer
global home "$root/Papers/$paper"
cd "$home"
pwd

if "`c(mode)'" == "batch" {
    set graphics off	// this allows for graph export to work in batch mode in linux
		      	// not necessary unless running file from command line	
}

global x=subinstr("$S_DATE $S_TIME",":", " ", 3)
global x = subinstr("$x", " ", "_", 5)
di "$x"


**************************************************************


use "./data/coded/coded.dta", clear

xi i.period

*prelim
global depvar "prelim"
regress $depvar risk_c ,robust
estadd local FE "No"
estadd local chair "No"
estimates store risk_$depvar

regress $depvar risk_c bte cbp prevcas compnos mkt_total, robust
estadd local FE "No"
estadd local chair "No"
estimates store all_$depvar

regress $depvar risk_c bte cbp prevcas compnos mkt_total policy,robust
estadd local FE "Yes"
estadd local chair "No"
estimates store period_$depvar

regress $depvar bte cbp prevcas compnos mkt_total policy chair_* mem_* d_*, robust
estadd local FE "Yes"
estadd local chair "Yes"
estimates store chair_$depvar



* rempro
keep if prelim==0
global depvar "rempro"
regress $depvar risk_c ,robust
estadd local FE "No"
estadd local chair "No"
estimates store risk_$depvar

regress $depvar risk_c bte cbp prevcas compnos mkt_total, robust
estadd local FE "No"
estadd local chair "No"
estimates store all_$depvar

regress $depvar risk_c bte cbp prevcas compnos mkt_total _Iperiod*,robust
estadd local FE "Yes"
estadd local chair "No"
estimates store period_$depvar

regress $depvar bte cbp prevcas compnos mkt_total _Iperiod* chair_*, robust
estadd local FE "Yes"
estadd local chair "Yes"
estimates store chair_$depvar

*duration
global depvar "duration"
regress $depvar risk_c ,robust
estadd local FE "No"
estadd local chair "No"
estimates store risk_$depvar

regress $depvar risk_c bte cbp prevcas compnos mkt_total, robust
estadd local FE "No"
estadd local chair "No"
estimates store all_$depvar

regress $depvar risk_c bte cbp prevcas compnos mkt_total _Iperiod*,robust
estadd local FE "Yes"
estadd local chair "No"
estimates store period_$depvar

regress $depvar bte cbp prevcas compnos mkt_total _Iperiod* chair_*, robust
estadd local FE "Yes"
estadd local chair "Yes"
estimates store chair_$depvar


#delimit ;
global options "replace $outtype compress nogaps nolabel nodepvars 
	numbers  mlab(none) star(* 0.10 ** 0.05 *** 0.01) nonotes
	keep(risk_c bte cbp prevcas compnos mkt_total policy chair_* d_* mem_*)
	stats(FE chair N r2,labels("Period FE" "Chair FE" "Obs." "R2"))
	addn(" Robust standard errors." 
	     "* p\textless0.10, ** p\textless0.05, *** p\textless0.01.")" ;		
#delimit cr

esttab  risk_prelim all_prelim period_prelim chair_prelim  using "./output/prelim" , $options ///
			title(Cleared on Preliminary Investigation\label{prelim}) 
						
esttab  risk_rempro all_rempro period_rempro chair_rempro  using "./output/rempro" , $options ///
			title(Remedied or Prohibited\label{rempro}) 			

esttab  risk_duration all_duration period_duration  chair_duration  using "./output/duration" , $options ///
			title(Duration\label{duration}) 	

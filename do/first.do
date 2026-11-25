* competion law paper
* tables etc


global paper "competition"
global outtype "smcl type"
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


* cases by period
estpost tabstat prelim detinv rempro, ///
    by(period) statistics(sum) columns(variables)

esttab  using "./output/period.tex", replace booktabs ///
    cells("prelim(fmt(0)) detinv(fmt(0)) rempro(fmt(0))") ///
    collabels("Cleared" "Investigated" "Remdiated") ///
    noobs nonumber nomtitles ///
    title("Case Summary by period \label{period}") 

* summary statz

estpost summarize duration prelim detinv rempro risk_a risk_b risk_c risk_na mkt_total compnos bte cbp prevcas smnp hhi

esttab using "./output/summary.tex", replace booktabs ///
    cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) min(fmt(3)) max(fmt(3))") ///
    label nonumber nomtitles noobs ///
    collabels("N" "Mean" "Std. Dev." "Min" "Max") ///
    title("Descriptive Statistics \label{summ}") 

display as result "first.do executed successfully."

exit

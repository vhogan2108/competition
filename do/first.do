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



display as result "first.do executed successfully."

exit
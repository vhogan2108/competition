* competion law paper
* code the variables


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

use "./data/coded/raw.dta", clear

* code categorical vars
mvencode  mkt* chair_* mem_* d_* risk_*, mv(0) override


gen risk=risk_a+2*risk_b+3*risk_c
gen mkt=mkt_a+2*mkt_b+3*mkt_c


label define x_lbl 1 "A" 2 "B" 3 "C"
label values risk x_lbl
label values mkt x_lbl

gen chairman=chair_bm+2*chair_bp+3*chair_dp+4*chair_ig+5*chair_jf+6*chair_jg+7*chair_pk
gen member=mem_tc+2*mem_eh+3*mem_pg+4*mem_sw+5*mem_gf+6*mem_nm+7*mem_sc+8*mem_pk+9*mem_bm+10*mem_ub
gen dir=d_dn+2*d_ck+3*d_ib+4*d_as



label define chairs 1 "BM" 2 "BP" 3 "DP" 4 "IG"+5 "JF" 6 "JG" 7 "PK"
label define members 1 "TC" 2 "EH" 3 "PG" 4 "SW" 5 "GF" 6 "NM" 7 "SC" 8 "PK" 9 "BM" 10 "UB"
label define directors 1 "DN" 2 "CK" 3 "IB" 4 "AS" 

label values chairman chairs
label values member members
label values dir directors

*time
gen period=0 if year <=2014
replace period=1 if year >=2015 & year <=2018
replace period=2 if year >=2019 & year<=2022
replace period=3 if year >=2023 & year<2026
label define time 0 "2003-2014" 1 "2015-2018" 2 "2019-2022" 3 "2023-2025"
label values period time
label variable period "Year Interval"
gen policy=(period!=0)
label variable policy "Post 2014"



label data "coded data read from raw.dta on $x"

save "./data/coded/coded.dta", replace

display as result "coded.do executed successfully."

exit

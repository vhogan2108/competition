* competion law paper
* adpated from FL Attendance paper
* Read in the data and deal with date issues
* read in cvs formats to deal with date issue
* In excel manually format the date column to be a consistent format: best is custom "DD/MM/YYYY"
* In excel save as "CSV UTF-8 (Comma delimited)" rather than plain "CSV (Comma delimited)".



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
global file "./data/raw/VH HHI Cases Data"

import excel "$file" , sheet("for stata") cellrange(A3:BM671) clear firstrow

rename *,lower

* label variables from variables tab of the spreadsheet

label variable year "Year"
label variable cases_total "Total Cases_total"
label variable caseno "Case Number"
label variable casename "Case Name"
label variable notification "Noticfication Date"
label variable decision "Decision Date"


label variable	duration	"	Number of days from notification to decision	"
label variable	detinv	"	Case subject to detailed investigation i.e. extended Phase 1 or Phase 2	"
label variable	rempro	"	Merger remedied or prohibited.	"
label variable	prelim	"	Case cleared following preliminary (Phase 1) investigation.	"

label variable	risk_a	"	Low risk of competitive harm	"
label variable	risk_b	"	Medium risk of competitive harm	"
label variable	risk_c	"	High risk of competitive harm	"
label variable	risk_na	"	Insufficient data to define risk	"
label variable	mkt_total	"	Total number of markets identified in case	"
label variable	mkt_a	"	Number of low risk markets identified in case	"
label variable	mkt_a	"	Bnumber of medium risk markets identified in case	"
label variable	mkt_a	"	Number of highrisk markets identified in case	"
label variable	mkt_na	"	Number of markets that could not be classified	"
label variable	nace	"	NACE 2 Digit Industry Code	"
label variable	compnos	"	Case cleared based on number of competitors in market	"
label variable	bte	"	Barriers to Entry	"
label variable	cbp	"	Countervailing Buyer Power	"
label variable	prevcas	"	Previous CCPC decision in relation to same market or firm	"
label variable	smnp	"	Case met simplified merger notification procedure	"
label variable	hhi	"	Reference to HHI in decision	"

label variable	chair_jf	"	CCPc chair at time of decision	"
label variable	chair_bp	"	CCPc chair at time of decision	"
label variable	chair_dp	"	CCPc chair at time of decision	"
label variable	chair_ig	"	CCPc chair at time of decision	"
label variable	chair_jg	"	CCPc chair at time of decision	"
label variable	chair_pk	"	CCPc chair at time of decision	"
label variable	chair_bm	"	CCPc chair at time of decision	"

label variable	mem_tc	"	CCPC Member in charge of mergers division at time of decision	"
label variable	mem_eh	"	CCPC Member in charge of mergers division at time of decision	"
label variable	mem_pg	"	CCPC Member in charge of mergers division at time of decision	"
label variable	mem_sw	"	CCPC Member in charge of mergers division at time of decision	"
label variable	mem_gf	"	CCPC Member in charge of mergers division at time of decision	"
label variable	mem_nm	"	CCPC Member in charge of mergers division at time of decision	"
label variable	mem_sc	"	CCPC Member in charge of mergers division at time of decision	"
label variable	mem_pk	"	CCPC Member in charge of mergers division at time of decision	"
label variable	mem_bm	"	CCPC Member in charge of mergers division at time of decision	"
label variable	mem_ub	"	CCPC Member in charge of mergers division at time of decision	"

label variable	d_dn	"	CCPC Director of mergers division at time of decision	"
label variable	d_ck	"	CCPC Director of mergers division at time of decision	"
label variable	d_ib	"	CCPC Director of mergers division at time of decision	"
label variable	d_as	"	CCPC Director of mergers division at time of decision	"


label variable	chair	"	Cumulative number of cases CCPC Chair	"
label variable	member	"	Cumulative number of cases CCPC member in charge	"
label variable	director	"	Cumulative number of cases CCPC director	"


foreach var of varlist _all {
    local lbl : variable label `var'
    label variable `var' "`=strtrim("`lbl'")'"
}


drop ah as ax

label data "raw data read from $file on $x"



save "./data/coded/raw.dta", replace

display as result "raw.do executed successfully."

exit




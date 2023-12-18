
**standardized

global pos_var x1 x2 x3 x4 x5 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20 x21 x22 x23 x24 x25 x26 x28 x29 x30 x31 x33 x34 x35
foreach i in $pos_var{
egen min_`i'=min(`i')
egen max_`i'=max(`i')
gen s`i'=(`i'-min_`i')/(max_`i'-min_`i')  
replace s`i'=0.0001 if s`i'==0
}

global neg_var x6 x7 x8 x27 x32
foreach i in $neg_var{
egen min_`i'=min(`i')
egen max_`i'=max(`i')
gen s`i'=(max_`i'-`i')/(max_`i'-min_`i')  
replace s`i'=0.0001 if s`i'==0
}
order ID city x* min* max* s*
keep ID city s*

**standard deviation

global S_all_var sx1 sx2 sx3 sx4 sx5 sx6 sx7 sx8 sx9 sx10 sx11 sx12 sx13 sx14 sx15 sx16 sx17 sx18 sx19 sx20 sx21 sx22 sx23 sx24 sx25 sx26 sx27 sx28 sx29 sx30 sx31 sx32 sx33 sx34 sx35
order ID city x* min* max* s* 
foreach i in $S_all_var {
egen sd`i'= sd(`i')
}
order ID city x* min* max* s* sd*
keep ID city s* sd*

**entropy weighting

//p---------------------------------------------------------------------------
forvalue i=1(1)35{ 
egen sums_`i'=sum(sx`i')
gen p`i'=sx`i'/sums_`i'
}
order ID city x* min* max* s* sums* p*

//e和d------------------------------------------------------------------------
forvalue i=1(1)35{
egen l`i'=sum(p`i'*ln(p`i'))
gen e`i'=-l`i'/ln(287)  
gen d`i'=1-e`i'
}
order ID city x* min* max* s* sums* p* l* e* d*

//w1-----------------------------------------------------------------------
forvalue i=1(1)35{
egen f`i'=rowtotal(d*)
gen w`i'=d`i'/f`i'
} 
order ID city x* min* max* s* sums* p* l* e* d* f* w*
keep ID city  w* 


**CRITIC


global S_all_var sx1 sx2 sx3 sx4 sx5 sx6 sx7 sx8 sx9 sx10 sx11 sx12 sx13 sx14 sx15 sx16 sx17 sx18 sx19 sx20 sx21 sx22 sx23 sx24 sx25 sx26 sx27 sx28 sx29 sx30 sx31 sx32 sx33
order ID city x* min* max* s* 
foreach i in $S_all_var {
egen sd`i'= sd(`i')
}
order ID city x* min* max* s* sd*
logout,save(corr) excel replace : pwcorr x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20 x21 x22 x23 x24 x25 x26 x27 x28 x29 x30 x31 x32 x33 x34 x35


**TOPSIS


forvalue i=1(1)35{
gen score`i'=sx`i'*wx`i' 
}

forvalue i=1(1)35{ 
egen max_`i'=max(score`i') 
egen min_`i'=min(score`i')
}

order ID 城市 score* max* min*

forvalue i=1(1)35{ 
gen zheng_`i'=(score`i'-max_`i')^2
gen fu_`i'=(score`i'-min_`i')^2
}

order ID 城市 score* zheng* fu* max* min*

//D+

egen zheng_row = rowtotal(zheng*) 
gen Dzheng = zheng_row^(1/2)

//D-

egen fu_row = rowtotal(fu*)
gen Dfu = fu_row^(1/2)

//C

gen C=Dfu/(Dfu+Dzheng)

keep C

keep ID 城市 score* C


**sensitivity analysis

clear 

forvalue i=1(1)35{
gen score`i'=sx`i'*wx`i' 
}

forvalue i=1(1)35{ 
egen max_`i'=max(score`i') 
egen min_`i'=min(score`i')
}

order ID city score* max* min*

forvalue i=1(1)35{ 
gen zheng_`i'=(score`i'-max_`i')^2
gen fu_`i'=(score`i'-min_`i')^2
}
order ID city score* zheng* fu* max* min*

egen zheng_row = rowtotal(zheng*) 
gen Dzheng = zheng_row^(1/2)
egen fu_row = rowtotal(fu*)
gen Dfu = fu_row^(1/2)
gen C=Dfu/(Dfu+Dzheng)
keep C


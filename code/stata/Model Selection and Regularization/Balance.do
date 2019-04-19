version 14.0
clear
browse
set more off
cap log close


import delim using Credit.csv, clear
gen GenderFemale = (gender == "Female")
gen StudentYes = (student == "Yes")
gen MarriedYes = (married == "Yes")
global x income limit rating cards age GenderFemale StudentYes MarriedYes
reg balance $x

cap ssc install vselect
//The BIC is different from the R code, we can use -6038.7108 to plus the bic from Stata
//then, we can get the bic from the R code. The difference may be from the different 
//random seed.
vselect balance $x, best 

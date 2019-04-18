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
//I don't know why the AIC is different from the Rcode
vselect balance $x, best 

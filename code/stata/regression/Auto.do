version 14.0
clear 
browse
set more off
cap log close
log using Auto.txt, text replace
***********************

** MPG and Horsepower *

***********************

***The origin R code is from 
***https://github.com/jiamingmao/data-analysis/blob/master/codes/Regression/R/auto.R***
***Auto***

import delim using Auto.csv, delim(" ") clear

rename v* (id mpg horsepower)

* Bootstrap standard errors

bootstrap, reps(1000) : reg mpg horsepower

** Homoskedastic standard errors
reg mpg horsepower

** Heteroskedasticity-consistent (HC) standard errors
reg mpg horsepower, vce(hc3)

log close

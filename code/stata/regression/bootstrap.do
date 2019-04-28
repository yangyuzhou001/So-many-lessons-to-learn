version 14.0
clear
browse

set more off
**************
** Bootstrap *
**************
** Code to accompany Lecture on 
** Regression
** Jiaming Mao (jmao@xmu.edu.cn)
** The R code is from 
** https://github.com/jiamingmao/data-analysis/blob/master/codes/Regression/R/bootstrap.R
set seed 123

import delim using Portfolio.csv, clear

** "Portfolio" is a data set in ISLR containing the returns of two assets: X and Y
** alpha is the min variance a portfolio of X and Y can achieve

* function to calcualte alpha
gen bootsample = runiformint(1,100)
gen Xalpha = 0
gen Yalpha = 0
forvalues i = 1/100{
	local j = bootsample[`i']
	qui replace Xalpha = x[`j'] in `i'
	qui replace Yalpha = y[`j'] in `i'
}
corr Xalpha Yalpha, c
dis alpha = (r(Var_2) - r(cov_12))/(r(Var_1) + r(Var_2) - 2*r(cov_12))

* Bootstrap
bootstrap alpha = ((r(Var_2) - r(cov_12))/(r(Var_1) + r(Var_2) - 2*r(cov_12))), ///
	rep(1000) : corr x y, c
* ------ we can do bootstrap in parallel -----
* https://grid.rcs.hbs.org/parallel-stata
* ------ we can also do bootstrap manually -----

clear 
set obs 1000
gen A = 0
forvalues i = 1/1000{
	preserve 
	import delim using Portfolio.csv, clear
	bsample 100
	qui corr x y, c
	restore
	replace A = (r(Var_2) - r(cov_12))/(r(Var_1) + r(Var_2) - 2*r(cov_12)) in `i'
}
sum A

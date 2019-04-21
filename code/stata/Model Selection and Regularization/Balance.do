version 14.0
clear
browse
set more off
cap log close
*******************************************************************************
*	Edited by Yang Yuzhou, mail: yangyuzhou001@foxmail.com, 2019/4/21
*	The code is replicated from the R code for learning ridge and lasso 
*	The R code is sourced from the Jiaming Mao's applied Microeconometrics
*	Attention: results have some difference from the R code, be careful!
*******************************************************************************

************************

** Credit Card Balance *

************************

** Code to accompany Lecture on 

** Model Selection and Regularization

** Jiaming Mao (jmao@xmu.edu.cn)

** https://jiamingmao.github.io

import delim using Credit.csv, clear
gen GenderFemale = (gender == "Female")
gen StudentYes = (student == "Yes")
gen MarriedYes = (married == "Yes")
global x income limit rating cards age GenderFemale StudentYes MarriedYes

* Fit the entire model with all potential predictors
reg balance $x

*************************

* Best Subset Selection * 

*************************

//The following program need additional package vselect, please
// ssc install vselect
//The BIC is different from the R code, we can use -6038.7108 to plus the bic 
//from Stata. Therefore, we can get the bic from the R code. If anyone can 
//understand the difference, please tell me, thanks.
log using balance.log, replace
vselect balance $x, best 
log close

//There is no data format from the vselect report. So we have to generate the 
//data about -vselect- report from the log.
import delim using balance.log, clear

gen id = (strpos(v1,"Preds")!= 0) + ///
		 (strpos(v1,"predictors for each model") != 0) + ///
		 (strpos(v1,"log close")!= 0)
		 
replace id = id + id[_n - 1] in 2/l

***
preserve
keep if id == 1
keep v1
rename v1 v
replace v = subinstr(v,"#","",.)
replace v = stritrim(v)
split v, p(" ")
drop v
export delim using optimalModles.txt, novarname replace
restore
***

* Plot: Cp/BIC of best model vs number of variables
import delim using optimalModles.txt, clear

egen minC = min(c)
replace minC = . if minC != c
twoway line c preds || scatter minC preds, legend(off) 

* Visualze the best model at each Cp/BIC value
egen minBIC = min(bic)
replace minBIC = . if minBIC != bic
twoway line bic preds || scatter minBIC preds, legend(off) 


*********************

* Forward Selection * 

*********************
import delim using Credit.csv, clear
gen GenderFemale = (gender == "Female")
gen StudentYes = (student == "Yes")
gen MarriedYes = (married == "Yes")
global x income limit rating cards age GenderFemale StudentYes MarriedYes

* Forward stepwise selection using AIC
vselect balance $x, forward aic
* Forward stepwise selection using BIC
vselect balance $x, forward bic


********************

* Ridge Regression * 

********************

//  Note: the above lambda differs from the definition used in parts of 
//	the lasso and elastic net literature; see for example the R package 
//	glmnet by Friedman et al. (2010).  We have here adopted an objective
//  function following Belloni et al. (2012).  Specifically, 
//	lambda=2*N*lambda(GN) where lambda(GN) is the penalty level used by 
//	glmnet.

lasso2 balance $x, alpha(0) l(8) // 2*N*0.01
lasso2 balance $x, alpha(0) l(8000000) //2*N*10000
lasso2 balance $x, alpha(0) long lic(aic)

* Coefficient Plot

lasso2 balance $x, alpha(0) long lic(aic) plotpath(lnlambda)

* Cross-validation

cvlasso balance $x, alpha(0) lopt seed(123)
cvlasso balance $x, alpha(0) lse seed(123)

* CV Plot
cvlasso balance $x, alpha(0) lse seed(123) plotcv

* Refit the model using the best lambda according to CV results

lasso2 balance $x, alpha(0) l(`e(lmin)')

*********

* Lasso *

*********

* Coefficient Plot
lasso2 balance $x, alpha(1) long lic(aic) plotpath(lnlambda)

* Cross-validation

cvlasso balance $x, alpha(1) lopt seed(123)

cvlasso balance $x, alpha(1) lse seed(123)

* CV Plot

cvlasso balance $x, alpha(1) lse seed(123) plotcv

* Refit the model using the best lambda according to CV results

lasso2 balance $x, alpha(1) l(`e(lmin)')

version 14.0
clear
browse 
mat drop _all

*******************************************************************************
*	Edited by Yang Yuzhou, mail: yangyuzhou001@foxmail.com, 2019/4/22
*	The code is replicated from the R code for learning cross-validation
*	The R code is sourced from the Jiaming Mao's applied Microeconometrics
*	Attention: results have some difference from the R code, be careful!
*******************************************************************************


*********

** Auto *

*********

** Code to accompany Lecture on 

** Model Selection and Regularization

** Jiaming Mao (jmao@xmu.edu.cn)

** https://jiamingmao.github.io

set seed 1

import delim using auto.csv, delim(",") clear
save auto.dta, replace

***************************

* Validation Set Approach *

***************************

sample 50
gen id = _n

merge 1:1 v1 using auto.dta

forvalues k = 1/5{
	gen validationE`k' = .
	forvalues i = 1/`k'{
		gen horsepower`k'`i' = horsepower^`k'
	}
	reg mpg horsepower`k'* if id != .
	predict xb`k' if id != ., xb
	replace validationE`k' = mpg - xb`k' if id != .
	egen VMSE`k' = mean(validationE`k'^2)
}

sum VMSE*

*********

* LOOCV *

*********
//I don't know how to set the K-fold to give the usual leave-one-out CV
//The program cannot be run when K is greater than 300
//The defaut is 6.

forvalues k = 1/5{
	crossfold glm mpg horsepower`k'*
	matrix m`k' = r(est)
}
matrix m = m1, m2, m3, m4, m5
matrix RMSE = m[5,1..5]
matrix MSE = diag(RMSE)*diag(RMSE)
matrix MSE = vecdiag(MSE)
matrix list MSE

crossfold glm mpg horsepower 

**************

* 10-fold CV *

**************

forvalues k = 1/5{
	crossfold glm mpg horsepower`k'*, k(10)
	matrix m`k' = r(est)
}
matrix m = m1, m2, m3, m4, m5
matrix RMSE = m[10,1..5]
matrix MSE = diag(RMSE)*diag(RMSE)
matrix MSE = vecdiag(MSE)
matrix list MSE

************************

* Information Criteria *

************************
matrix aic = (0, 0, 0, 0, 0)'
matrix bic = aic
forvalues k = 1/5{
	crossfold glm mpg horsepower`k'*
	matrix aic[`k',1] = e(aic)
	matrix bic[`k',1] = e(bic)
}
mat ic = aic, bic
mat list ic

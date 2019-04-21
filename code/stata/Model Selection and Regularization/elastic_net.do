clear
browse

set obs 100
gen z1 = rnormal()
gen z2 = rnormal()

forvalues i = 1/7{
	gen e`i' = rnormal()
}

forvalues i = 2/4{
	gen x1`i' = z1 + e`i'/5
}

forvalues i = 5/7{
	gen x2`i' = z2 + e`i'/5
}

gen x1 = x12
gen x2 = x13
gen x3 = x14
gen x4 = x25
gen x5 = x26
gen x6 = x27

gen y = 3*z1 - 1.5*z2 + 2*e1

keep y x1-x6
*lasso

lasso2 y x*, alpha(1) plotpath(lnlambda) 

*elastic net
lasso2 y x*, alpha(0.3) plotpath(lnlambda)

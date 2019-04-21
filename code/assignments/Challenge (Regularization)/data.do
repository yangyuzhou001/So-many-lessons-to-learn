keep qs3 qa01 qa02 qa04 qa05a qa08a qa10 qa11 qa13 qb01d ///
quc321 quc322 quc323 quc324 quc325 quc326 qc34a qc34b qc492 qd06e qd07h1 ///
qd08h qd13i1 qd13i2 qd13i3 qd13i4 qd13i5 qd13i6 qd14g qd16d1 qd16d2 qd16d3 ///
qd16d4 qd16d5 qd16d6 qd17c qd35a qd35b1 qd35b2 qd35b3 qd36a qd36b qd36c qd4801 ///
 qe02 qe0301 qe0302 qe0303 qe0304 qe0305 qe0306 qe0307 qe0308 qe0309 qe0310 ///
 qe0311 qe0312 qe0401 qe0402 qe0403 qe0404 qe0405 qe0406 qe0407 qe0408 qe0409 ///
 qe0410 qe0411 qe0412 qe101 qe111 
 
drop if qs3 < 0 //城乡
replace qs3 = (qs3 == 1)
replace qa02 = 2006 - year(qa02)
format qa02 %9.0g
drop if qa01 < 0 //性别
replace qa01 = (qa01 == 1)
drop if qa04 < 0 //民族
replace qa04 = (qa04 == 1)
drop if qa08a < 0 //政治面貌
replace qa08a = (qa08a == 1)
drop if qa10 < 0 //官职
replace qa10 = (qa10 >1)
drop if qa11 < 0 //军职
replace qa11 = (qa11 == 3)
drop if qa13 < 0 //信仰
replace qa13 = (qa13 == 7)
drop if qb01d < 0 | qb01d > 996 //周工作时间

global data qs3 qa01 qa02 qa04 qa05a qa08a qa10 qa11 qa13 qb01d ///
quc321 quc322 quc323 quc324 quc325 quc326 qc34a qc34b qc492 qd06e qd07h1 ///
qd08h qd13i1 qd13i2 qd13i3 qd13i4 qd13i5 qd13i6 qd14g qd16d1 qd16d2 qd16d3 ///
qd16d4 qd16d5 qd16d6 qd17c qd35a qd35b1 qd35b2 qd35b3 qd36a qd36b qd36c qd4801 ///
 qe02 qe0301 qe0302 qe0303 qe0304 qe0305 qe0306 qe0307 qe0308 qe0309 qe0310 ///
 qe0311 qe0312 qe0401 qe0402 qe0403 qe0404 qe0405 qe0406 qe0407 qe0408 qe0409 ///
 qe0410 qe0411 qe0412 qe101 qe111 

foreach var of global data {
	drop if `var' < 0
	replace `var' = 0 if `var' == .
}

//收入描述
forvalues i = 1/6{
	replace quc32`i' = (quc32`i' == 1)
}
//上月工资收入
drop if qc34a > 999996
replace qc34b = 0 if qc34b == .
//2005经营纯收入
drop if qc34b > 999996 
//改制后收入变化
drop if qc492 > 3
replace qc492 = (qc492 == 1 | qc492 == 2) //
//配偶2005收入
drop if qd06e > 9999996
replace qd07h1 = (qd07h1 <= 3) //与配偶收入高低
replace qd08h = 0 if qd08h == . //父亲收入
drop if qd08h > 9999996
gen qd13i = 0 //经商务工收入
//识别子问题中都缺失的情况并删除
label list qd13i1
gen qd13id = 0
forvalues k = 1/6{
	replace qd13id = qd13id + (qd13i`k' > r(max) - 3)
}
drop if qd13id == 6 
drop qd13id
//获得经商务工总收入
forvalues k = 1/6{
	replace qd13i`k' = 0 if qd13i`k' == .
	replace qd13i = qd13i + qd13i`k'
	drop qd13i`k'
}
replace qd14g = 0 if qd14g == .
drop if qd14g > 99996
replace qd13i = qd13i + qd14g
drop qd14g

drop qd16d* //删除职业收入分类

//个人总收入
label list qd35a
drop if qd35a > r(max) - 3
drop qd35b* //删除收入比重
//家庭总收入
label list qd36a
drop if qd36a > r(max) - 3
//删除农村问题
tab qd4801, miss
drop qd4801
//收入是否合理
label list qe02
replace qe02 = (qe02 == 1 | qe02 == 2)
//估算收入
//识别子问题中都缺失的情况并删除
label list qe0301
gen qe03id = 0
forvalues k = 1/9{
	replace qe03id = qe03id + (qe030`k' > r(max) - 3)
}
forvalues k = 10/12{
	replace qe03id = qe03id + (qe03`k' > r(max) - 3)
}
drop if qe03id == 12
drop qe03id
//估算总收入
gen qe03 = 0
forvalues i = 1/9{
	replace qe03 = qe030`i' + qe03
}
forvalues i = 10/12{
	replace qe03 = qe03`i' + qe03
}
drop qe0301-qe0312
//应得收入
label list qe0401
gen qe04 = 0
gen qe04id = 0
forvalues i = 1/9{
	replace qe04id = qe04id + (qe040`i' > r(max) - 3)
}
forvalues i = 10/12{
	replace qe04id = qe04id + (qe04`i' > r(max) - 3)
}
drop if qe04id == 12
drop qe04id
forvalues i = 1/9{
	replace qe04 = qe040`i' + qe04
}
forvalues i = 10/12{
	replace qe04 = qe04`i' + qe04
}
drop qe0401-qe0412
//相对3年前
label list qe101
replace qe101 = (qe101 == 1)

//qe111 预计3年后:收入变化
label list qe111 
sum qe111, de
replace qe111 = (qe111 == 1)

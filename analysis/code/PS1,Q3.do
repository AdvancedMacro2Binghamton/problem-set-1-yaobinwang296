*Problem Set 1 Q3
*Yaobin Wang

clear all
cls
cd "C:\Users\Yaobin's PC\Desktop\problem-set-1-yaobinwang296\analysis\output"

*********************************************
*	Import SCF 2007 Summary Extract Data	*
*********************************************
use "C:\Users\Yaobin's PC\Desktop\problem-set-1-yaobinwang296\analysis\input\rscfp2007.dta"



*****************************************************************************
*	Construct earnings, income, and wealth variables according to DGR(2011)	*
*****************************************************************************
*	Earnings
gen Earnings = wageinc+0.863*bussefarminc

*	Income 
gen Income = wageinc+bussefarminc+kginc+intdivinc+ssretinc+transfothinc

*	Wealth
gen Wealth = networth



*****************************************
*	Replicate Table 1 from DGR(2011)	*
*****************************************
*	Quantile of the 2007 Earnings
_pctile Earnings [pweight=wgt], p(1 5 10 20 40 60 80 90 95 99)
matrix E1=(r(r1), r(r2), r(r3), r(r4), r(r5), r(r6), r(r7), r(r8), r(r9), r(r10))
sum Earnings
matrix E=(r(min), E1, r(max))
*	export the Quantile of 2007 Earnings into Excel workbook
putexcel A1=("Quantiles") B1=("0") C1=("1") D1=("5") E1=("10") F1=("20") G1=("40") ///
 H1=("60") I1=("80") J1=("90") K1=("95") L1=("99") M1=("100") using Table1, replace
putexcel A2=("Earnings") B2=matrix (E) using Table1, modify

*	Quantile of the 2007 Income
_pctile Income [pweight=wgt], p(1 5 10 20 40 60 80 90 95 99)
matrix I1=(r(r1), r(r2), r(r3), r(r4), r(r5), r(r6), r(r7), r(r8), r(r9), r(r10))
sum Income
matrix I=(r(min), I1, r(max))
*	export the Quantile of 2007 Income into Excel workbook
putexcel A3=("Income") B3=matrix (I) using Table1, modify

*	Quantile of the 2007 Wealth
_pctile Wealth [pweight=wgt], p(1 5 10 20 40 60 80 90 95 99)
matrix W1=(r(r1), r(r2), r(r3), r(r4), r(r5), r(r6), r(r7), r(r8), r(r9), r(r10))
sum Wealth
matrix W=(r(min), W1, r(max))
*	export the Quantile of 2007 Income into Excel workbook
putexcel A4=("Wealth") B4=matrix (W) using Table1, modify



*********************************************************
* Replicate Table 2 from DGR(2011) and Plot Lorenz Curve*
*********************************************************
*	Coefficient of Variation and Mean/Median
sum Earnings [aw=wgt], detail
scalar CoVar_E=r(sd)/r(mean)
scalar MnMd_E=r(mean)/r(p50)

sum Income [aw=wgt], detail
scalar CoVar_I=r(sd)/r(mean)
scalar MnMd_I=r(mean)/r(p50)

sum Wealth [aw=wgt], detail
scalar CoVar_W=r(sd)/r(mean)
scalar MnMd_W=r(mean)/r(p50)

*	export results into Excel workbook
putexcel B1=("Earnings") C1=("Income") D1=("Wealth") A2=("Coefficient of Vaiation") ///
 A3=("Variance of the logs") A4=("Gini index") A5=("Top 1%/ lowest 40%") ///
 A6=("Location of mean(%)") A7=("Mean/median") B2=(CoVar_E) C2=(CoVar_I) ///
 D2=(CoVar_W) B7=(MnMd_E) C7=(MnMd_I) D7=(MnMd_W) using Table2, replace

 
*	Variance of the logs
gen lnEarnings=log(Earnings)
sum lnEarnings [aw=wgt], detail
scalar lnVar_E=r(Var)

gen lnIncome=log(Income)
sum lnIncome [aw=wgt], detail
scalar lnVar_I=r(Var)

gen lnWealth=log(Wealth)
sum lnWealth [aw=wgt], detail
scalar lnVar_W=r(Var)

*	export results into Excel workbook
putexcel B3=(lnVar_E) C3=(lnVar_I) D3=(lnVar_W) using Table2, modify


*	Gini index and Lorenz curve
lorenz estimate Earnings [pw=wgt], gini
*	export gini index for Earnings into Excel workbook
putexcel B4=matrix(e(G)) using Table2, modify
*	plot Lorenz Curve
lorenz graph, aspectratio(1) xlabel(, grid) legend(off) title(Lorenz Curve for Earnings)
graph save lorenz_Earnings, replace
graph export "C:\Users\Yaobin's PC\Desktop\problem-set-1-yaobinwang296\analysis\output\Lorenz_Earnings.pdf", as(pdf) replace
erase  lorenz_Earnings.gph

lorenz estimate Income [pw=wgt], gini
*	export gini index for Income into Excel workbook
putexcel C4=matrix(e(G)) using Table2, modify
*	plot Lorenz Curve
lorenz graph, aspectratio(1) xlabel(, grid) legend(off) title(Lorenz Curve for Income)
graph save lorenz_Income, replace
graph export "C:\Users\Yaobin's PC\Desktop\problem-set-1-yaobinwang296\analysis\output\Lorenz_Income.pdf", as(pdf) replace
erase  lorenz_Income.gph

lorenz estimate Wealth [pw=wgt], gini
*	export gini index for Wealth into Excel workbook
putexcel D4=matrix(e(G)) using Table2, modify
*	plot Lorenz Curve
lorenz graph, aspectratio(1) xlabel(, grid) legend(off) title(Lorenz Curve for Wealth)
graph save lorenz_Wealth, replace
graph export "C:\Users\Yaobin's PC\Desktop\problem-set-1-yaobinwang296\analysis\output\Lorenz_Wealth.pdf", as(pdf) replace
erase  lorenz_Wealth.gph


*	Location of mean
summ Earnings [aw=wgt]
scalar mean_E=r(mean)
matrix P =J(99,1,0)
forvalues i=1(1)99{
_pctile Earnings [pw=wgt],p(`i')
matrix P[`i',1]=r(r1)-mean_E
if matrix P[`i',1]>0{
scalar location=`i'
}
}
di location




summ Earnings [aw=wgt]
scalar mean_E=r(mean)
local i=1
local j=0
if `i'<100|`j'<=0{
_pctile Earnings [pw=wgt],p(`i')
local j=r(r1)-mean_E
local i=`i'+1
}
else{
scalar location_E=`i'-1
}
di location_E



summ Earnings [aw=wgt]
scalar mean_E=r(mean)
local i=1
local j=0
while `j'<=0{
_pctile Earnings [pw=wgt],p(`i')
local j=r(r1)-mean_E
if `j'<=0{
local i=`i'+1
}
else{
scalar location_E=`i'-1
}
}
di location_E

*	Top 1%/ Lowest 40%

/* 
 The train and test data set has been imported in this point.
*/
/*Add the empty value for the prediction*/

data test;
set test;
SalePrice = .;
;
/* Combine 2 dataset together to do the anaysis*/
data train2;
 set train test;
run;

/* check missing value on the numeric fields*/
proc means data = train2  n nmiss;
run;

/* NA Cleanup get the mean and median for the missing value variables*/
proc univariate data =train2 (where=( GarageYrBlt ne .) and (LotFrontage ne .))  ;
var LotFrontage MasVnrArea GarageYrBlt BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF BsmtFullBath BsmtHalfBath GarageCars GarageArea;
run; 
/* Replace the missing value with median of each variable*/
proc sql;
	update train2
	set LotFrontage=68.00000
	where LotFrontage=.;
	update train2
	set MasVnrArea=0.00000
	where MasVnrArea=.;
	update train2
	set GarageYrBlt=1979.00000
	where GarageYrBlt=.;
	update train2
	set BsmtFinSF1=368.50000
	where BsmtFinSF1=.;
	update train2
	set BsmtFinSF1=368.50000
	where BsmtFinSF1=.;
	update train2
	set BsmtFinSF2=0.00000
	where BsmtFinSF2=.;
	update train2
	set BsmtUnfSF=467.00000
	where BsmtUnfSF=.;
	update train2
	set TotalBsmtSF=989.50000
	where TotalBsmtSF=.;
	update train2
	set BsmtFullBath=0.00000
	where BsmtFullBath=.;
	update train2
	set BsmtHalfBath=0.00000
	where BsmtHalfBath=.;
	update train2
	set GarageCars=2.00000
	where GarageCars=.;
	update train2
	set GarageArea=480.00000
	where GarageArea=.;
run;
/*Custom Model Manually genearted the best model so far*/

proc glm data = train2 plots = all;
	class RoofStyle RoofMatl   MasVnrType Neighborhood	BldgType HouseStyle LotConfig Exterior1st Exterior2nd ExterQual BsmtQual;
	model SalePrice = RoofStyle RoofMatl BldgType HouseStyle MasVnrTYpe LotArea LotFrontage  LotConfig BedroomAbvGr YearBuilt GarageYrBlt
 		Neighborhood  
	 PoolArea  OverallCond  MSSubClass  YearRemodAdd Exterior1st Exterior2nd MasVnrArea ExterQual BsmtQual TotalBsmtSF
	 KitchenAbvGr  TotRmsAbvGrd  FullBath HalfBath BsmtHalfBath  WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch _1stFlrSF _2ndFlrSF
	/ cli Solution;
output out = results p = Predict;
run;
/* Forward variable selection */

proc glmselect data=train2  plots(stepaxis = number) = (criterionpanel ASePlot);
class RoofStyle RoofMatl   MasVnrType Neighborhood	BldgType HouseStyle LotConfig Exterior1st Exterior2nd ExterQual BsmtQual;
	model SalePrice = RoofStyle RoofMatl BldgType HouseStyle MasVnrTYpe LotArea LotFrontage  LotConfig BedroomAbvGr YearBuilt GarageYrBlt
 		Neighborhood  
	 PoolArea  OverallCond  MSSubClass  YearRemodAdd Exterior1st Exterior2nd MasVnrArea ExterQual BsmtQual TotalBsmtSF
	 KitchenAbvGr  TotRmsAbvGrd  FullBath HalfBath BsmtHalfBath  WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch  _1stFlrSF _2ndFlrSF
/selection=Forward(stop=cv select=cv) cvmethod=random(15) stats=adjrsq;;
run;
/* Backward variable selection */
proc glmselect data=train2  plots(stepaxis = number) = (criterionpanel ASePlot);
class RoofStyle RoofMatl   MasVnrType Neighborhood	BldgType HouseStyle LotConfig Exterior1st Exterior2nd ExterQual BsmtQual;
	model SalePrice = RoofStyle RoofMatl BldgType HouseStyle MasVnrTYpe LotArea LotFrontage  LotConfig BedroomAbvGr YearBuilt GarageYrBlt
 		Neighborhood  
	 PoolArea  OverallCond  MSSubClass  YearRemodAdd Exterior1st Exterior2nd MasVnrArea ExterQual BsmtQual TotalBsmtSF
	 KitchenAbvGr  TotRmsAbvGrd  FullBath HalfBath BsmtHalfBath  WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch  _1stFlrSF _2ndFlrSF
/selection=Backward(stop=cv select=cv) cvmethod=random(15) stats=adjrsq;;
run;

/* Stepwise variable selection */
proc glmselect data=train2  plots(stepaxis = number) = (criterionpanel ASePlot);
class RoofStyle RoofMatl   MasVnrType Neighborhood	BldgType HouseStyle LotConfig Exterior1st Exterior2nd ExterQual BsmtQual;
	model SalePrice = RoofStyle RoofMatl BldgType HouseStyle MasVnrTYpe LotArea LotFrontage  LotConfig BedroomAbvGr YearBuilt GarageYrBlt
 		Neighborhood  
	 PoolArea  OverallCond  MSSubClass  YearRemodAdd Exterior1st Exterior2nd MasVnrArea ExterQual BsmtQual TotalBsmtSF
	 KitchenAbvGr  TotRmsAbvGrd  FullBath HalfBath BsmtHalfBath  WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch  _1stFlrSF _2ndFlrSF
/selection=Stepwise(stop=cv select=cv) cvmethod=random(15) stats=adjrsq;;
run;



/*get the residual plot*/

proc glm data = train2 plots = all;
	class RoofStyle RoofMatl   MasVnrType Neighborhood	BldgType HouseStyle LotConfig Exterior1st Exterior2nd ExterQual BsmtQual;
	model SalePrice = RoofStyle RoofMatl BldgType HouseStyle MasVnrTYpe LotArea LotFrontage  LotConfig BedroomAbvGr YearBuilt GarageYrBlt
 		Neighborhood  
	 PoolArea  OverallCond  MSSubClass  YearRemodAdd Exterior1st Exterior2nd MasVnrArea ExterQual BsmtQual TotalBsmtSF
	 KitchenAbvGr  TotRmsAbvGrd  FullBath HalfBath BsmtHalfBath  WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch _1stFlrSF _2ndFlrSF
	/ Solution;
run;

/* Assumption Analysis Matrix scatter plot*/

proc sgscatter data = train2;
title "Sale Price Scatter Plot for Question 2";
matrix saleprice LotArea LotFrontage   BedroomAbvGr YearBuilt GarageYrBlt
 		  
	 PoolArea  OverallCond  MSSubClass  YearRemodAdd  MasVnrArea TotalBsmtSF
	 KitchenAbvGr  TotRmsAbvGrd  FullBath HalfBath BsmtHalfBath  WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch _1stFlrSF _2ndFlrSF ; 
run;
title;

/* cook's D and influencial point anaysis*/

Proc glm data = train2;
	class RoofStyle RoofMatl   MasVnrType Neighborhood	BldgType HouseStyle LotConfig Exterior1st Exterior2nd ExterQual BsmtQual;
	model SalePrice = RoofStyle RoofMatl BldgType HouseStyle MasVnrTYpe LotArea LotFrontage  LotConfig BedroomAbvGr YearBuilt GarageYrBlt
 		Neighborhood  
	 PoolArea  OverallCond  MSSubClass  YearRemodAdd Exterior1st Exterior2nd MasVnrArea ExterQual BsmtQual TotalBsmtSF
	 KitchenAbvGr  TotRmsAbvGrd  FullBath HalfBath BsmtHalfBath  WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch _1stFlrSF _2ndFlrSF /cli solution;
output out = t student = res cookd = cookd h = lev p = yhat;
run;

proc sgplot data =t;
scatter x = yhat y = res / datalabel = id;

proc sgplot data =t;
scatter x = lev y = res / datalabel = id;
run;

/* out put the result for the predicted records for custom model*/

data results2;
set results;
if Predict > 0 then SalePrice = Predict;
if Predict < 0 then SalePrice = 10000;
keep id SalePrice;
where id > 1460;
;
/*
proc print data = results2;
run;
*/
/*export the results into csv file to submit to Kaggle.com*/

proc export data=results2 outfile='C:\Users\yubin\OneDrive\MyWork\SMU\MSDS6371\Project\submit.csv' dbms=csv Replace;
run;

/*Kaggle score testing for Forward*/
proc glm data = train2 plots = all;
	class BldgType LotConfig Neighborhood ExterQual BsmtQual;
	model SalePrice=BldgType LotArea LotConfig YearBuilt Neighborhood OverallCond ExterQual BsmtQual KitchenAbvGr WoodDeckSF _3SsnPorch _1stFlrSF _2ndFlrSF / cli Solution;
output out = resultsForward p = Predict;
run;
/* out put the result for the predicted records for custom model*/

data results2;
set resultsForward;
if Predict > 0 then SalePrice = Predict;
if Predict < 0 then SalePrice = 10000;
keep id SalePrice;
where id > 1460;
;

/*Export the csv file for Forward*/
proc export data=results2 outfile='C:\Users\yubin\OneDrive\MyWork\SMU\MSDS6371\Project\submitForward.csv' dbms=csv Replace;
run;


/*Kaggle score testing for Backward*/
proc glm data = train2 plots = all;
	class BldgType LotConfig Neighborhood ExterQual BsmtQual;
	model SalePrice= BldgType LotArea LotConfig YearBuilt Neighborhood OverallCond YearRemodAdd ExterQual BsmtQual KitchenAbvGr WoodDeckSF _1stFlrSF _2ndFlrSF /cli Solution;
output out = resultsBackward p = Predict;
run;
/* out put the result for the predicted records for Backward model*/

data results2;
set resultsBackward;
if Predict > 0 then SalePrice = Predict;
if Predict < 0 then SalePrice = 10000;
keep id SalePrice;
where id > 1460;
;

/*Export the csv file for Backward*/
proc export data=results2 outfile='C:\Users\yubin\OneDrive\MyWork\SMU\MSDS6371\Project\submitBackward.csv' dbms=csv Replace;
run;

/*Kaggle score testing for Stepwise*/
proc glm data = train2 plots = all;
	class BldgType LotConfig Neighborhood ExterQual BsmtQual;
	model SalePrice= BldgType LotArea LotConfig YearBuilt Neighborhood OverallCond YearRemodAdd ExterQual BsmtQual KitchenAbvGr WoodDeckSF _1stFlrSF _2ndFlrSF /cli Solution;
output out = resultsStepwise p = Predict;
run;
/* out put the result for the predicted records for Backward model*/

data results2;
set resultsStepwise;
if Predict > 0 then SalePrice = Predict;
if Predict < 0 then SalePrice = 10000;
keep id SalePrice;
where id > 1460;
;

/*Export the csv file for Stepwise*/
proc export data=results2 outfile='C:\Users\yubin\OneDrive\MyWork\SMU\MSDS6371\Project\submitStepwise.csv' dbms=csv Replace;
run;


/*Model Averaging */

Proc GLmselect data=train2  seed= 1 ;
Class MSZoning Street LotShape LandContour LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle OverallQual OverallCond
	RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType MasVnrArea ExterQual ExterCond Foundation BsmtQual BsmtCond  BsmtFinType1  BsmtFinType2 BsmtExposure 
	Heating HeatingQC CentralAir GrLivArea GarageFinish GarageQual GarageCond PavedDrive ;
Model SalePrice = MSSubClass MSZoning LotFrontage LotArea Street LotShape LandContour Utilities LotConfig LandSlope Neighborhood 
	Condition1 Condition2 BldgType HouseStyle OverallQual OverallCond YearBuilt YearRemodAdd RoofStyle RoofMatl Exterior1st Exterior2nd 
	MasVnrType MasVnrArea ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinSF1 BsmtFinType2 BsmtFinSF2 
	BsmtUnfSF TotalBsmtSF Heating HeatingQC CentralAir Electrical FrstFlrSF ScndFlrSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath 
	FullBath HalfBath BedroomAbvGr KitcheAbvGr KitchenQual TotRmsAbvGrd Functional Fireplaces FireplaceQu GarageType GarageYrBlt 
	GarageFinish GarageCars GarageArea GarageQual GarageCond PavedDrive WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea 
	MiscVal MoSold YrSold SaleType SaleCondition / selection = Lasso (choose = cv stop = cv ) CVDETAILS;
Modelaverage nsamples= 1000 samplingmethod = URS(percent=100);
output out=testp p=pred r=ress ;
run;

proc print data= testp;


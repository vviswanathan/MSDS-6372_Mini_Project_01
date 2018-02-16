
*Not complex model. Used variables that group other parameters together ;
Proc GLmselect data=train2  seed=2 plots(stepAxis=number)=(criterionPanel ASEPlot) ;
partition fraction (test=.5);
Class  MSZoning Street LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle   
RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 
Heating HeatingQC CentralAir Electrical KitchenQual Functional GarageType GarageFinish GarageQual GarageCond PavedDrive SaleType SaleCondition;

Model SalePriceLog =  MSSubClass LotFrontage LotArea OverallQual OverallCond YearBuilt YearRemodAdd MasVnrArea 
	 LowQualFinSF GrLivArea BsmtFullBath TotalBsmtSF GrLivArea
	BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars 
    WoodDeckSF OpenPorchSF EnclosedPorch tSsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 
	/ selection = Lasso (choose = cv stop = aic ) CVDETAILS  details=all;
Modelaverage nsamples= 1000 samplingmethod = URS(percent=100);

output out= test_lso_ma p= yhat r= ress ;
run;



data Results;
set test_lso_ma;
if  EXP(yhat) > 0 then SalePrice = EXP(yhat);
if  EXP(yhat) < 0 then SalePrice = 10000;
keep id  SalePrice;
where id > 1460;
;
 run;

proc export data=Results outfile='/home/skhayden0/sasuser.v94/Stats 2/Project 1/Results.csv' dbms=csv Replace;
run;


proc sgscatter data = train2;
matrix SalePrice MSSubClass LotArea OverallQual YearBuilt YearRemodAdd;
matrix MasVnrArea BsmtFinSF1 TotalBsmtSF FrstFlrSF GrLivArea FullBath;
matrix KitchenAbvGr Fireplaces GarageCars GarageArea WoodDeckSF ScreenPorch;
run;



*Changed to OLS using the highest selected model from model avg;
proc reg data=train2 outest=TrainResultsLSO_ma plots(label)=(rstudentbyleverage cooksd);
model SalePricelog =  MSSubClass LotArea OverallQual OverallCond YearBuilt YearRemodAdd
		 GrLivArea BsmtFullBath TotalBsmtSF KitchenAbvGr Fireplaces GarageCars WoodDeckSF ScreenPorch
		/ partial AIC VIF clb  ;
		output out= test_lso_ma_OLS  p = yhat;
run;




*proc print data=test_lso_ma_OLS (where=(id>1460));
*run;
/* Save results to CSV*/

data Results;
set test_lso_ma_OLS;
if  EXP(yhat) > 0 then SalePrice = EXP(yhat);
if  EXP(yhat) < 0 then SalePrice = 10000;
keep id  SalePrice;
where id > 1460;
;
 run;

;
 run;
/*That's it! ... From here we will export results2 to a csv file on the desktop and then upload it to Kaggle. */


 
 
proc export data=Results outfile='/home/skhayden0/sasuser.v94/Stats 2/Project 1/Results.csv' dbms=csv Replace;
run;




* other models from the model averging;




proc reg data=train2 outest=TrainResultsLSO_ma plots(label)=(rstudentbyleverage cooksd);
model SalePricelog =   OverallQual YearBuilt YearRemodAdd GrLivArea TotalBsmtSF Fireplaces GarageCars
		/ partial AIC VIF clb  ;
		output out= test_lso_ma_OLS  p = yhat;
run;


proc reg data=train2 outest=TrainResultsLSO_ma plots(label)=(rstudentbyleverage cooksd);
model SalePricelog =   LotArea OverallQual YearBuilt YearRemodAdd GrLivArea BsmtFullBath TotalBsmtSF 
		Fireplaces GarageCars
		/ partial AIC VIF clb  ;
		output out= test_lso_ma_OLS  p = yhat;
run;

proc reg data=train2 outest=TrainResultsLSO_ma plots(label)=(rstudentbyleverage cooksd);
model SalePricelog =   OverallQual GrLivArea TotalBsmtSF GarageCars
		/ partial AIC VIF clb  ;
		output out= test_lso_ma_OLS  p = yhat;
run;


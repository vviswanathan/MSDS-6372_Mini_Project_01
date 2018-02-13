
*Not complex;
Proc GLmselect data=train2  seed=2 plots(stepAxis=number)=(criterionPanel ASEPlot) ;
Class  MSZoning Street LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle   
RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 
Heating HeatingQC CentralAir Electrical KitchenQual Functional GarageType GarageFinish GarageQual GarageCond PavedDrive SaleType SaleCondition;

Model SalePriceLog =  MSSubClass LotFrontage LotArea OverallQual OverallCond YearBuilt YearRemodAdd MasVnrArea 
	 LowQualFinSF GrLivArea BsmtFullBath TotalBsmtSF
	BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars 
    WoodDeckSF OpenPorchSF EnclosedPorch tSsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 
	/ selection = Lasso (choose = cv stop = aic ) CVDETAILS ;
Modelaverage nsamples= 1000 samplingmethod = URS(percent=100);
output out= test_lso_ma p= yhat r= ress ;
run;


*removed cararea  because it is coralated with garage cars

data Results;
set test_lso_ma;
if yhat > 0 then SalePrice = yhat;
if yhat < 0 then SalePrice = 10000;
keep id  SalePrice;
where id > 1460;
;
 run;

proc export data=Results outfile='/home/skhayden0/sasuser.v94/Stats 2/Project 1/Results.csv' dbms=csv Replace;
run;

*Model with log varibles and complex ;


Proc GLmselect data=train2  seed=2 plots(stepAxis=number)=(criterionPanel ASEPlot);
Class MSZoning Street LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle   
RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 
Heating HeatingQC CentralAir Electrical KitchenQual Functional GarageType GarageFinish GarageQual GarageCond PavedDrive SaleType SaleCondition;

Model SalePricelog = MSSubClass LotFrontage LotArea OverallQual OverallCond YearBuilt YearRemodAdd MasVnrArea 
	BsmtFinSF1 BsmtFinSF2 BsmtUnfSF  FrstFlrSF ScndFlrSF LowQualFinSF  BsmtFullBath 
	BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars 
	 WoodDeckSF OpenPorchSF EnclosedPorch tSsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 

	/ selection = Lasso (choose = cv stop = aic ) CVDETAILS;
Modelaverage nsamples= 1000 samplingmethod = URS(percent=100);
output out= test_lso_ma p= pred r= ress ;
run;

*did not return any log varibles 
Model SalePriceLog = Id MSSubClass LotFrontage LotArea OverallQual OverallCond YearBuilt YearRemodAdd MasVnrArea 
	BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF FrstFlrSFLog ScndFlrSFLog LowQualFinSF GrLivAreaLog BsmtFullBath 
	BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars 
	GarageArea WoodDeckSF OpenPorchSFLog EnclosedPorch tSsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold

*proc print data= test_lso_ma;

proc sgscatter data = train2;
matrix MSSubClass LotArea OverallQual YearBuilt YearRemodAdd;
matrix MasVnrArea BsmtFinSF1 TotalBsmtSF FrstFlrSF GrLivArea;
matrix KitchenAbvGr Fireplaces GarageCars GarageArea WoodDeckSF;
run;


*Changed to OLS using the highest selected model from model avg in the more complext model avg;
proc reg data=train2 outest=TrainResultsLSO_ma plots(label)=(rstudentbyleverage cooksd);
model SalePricelog =  MSSubClass LotArea OverallQual OverallCond YearBuilt 
			YearRemodAdd BsmtFinSF1 FrstFlrSF ScndFlrSF BsmtFullBath FullBath 
			HalfBath KitchenAbvGr TotRmsAbvGrd Fireplaces GarageCars WoodDeckSF ScreenPorch
		/ partial AIC VIF CLI;
		output out= test_lso_ma_OLS  p = yhat;
run;



*Changed to OLS using the highest selected model from model avg;
proc reg data=train2 outest=TrainResultsLSO_ma plots(label)=(rstudentbyleverage cooksd);
model SalePricelog =  MSSubClass LotArea OverallQual OverallCond YearBuilt YearRemodAdd
		 GrLivArea BsmtFullBath TotalBsmtSF KitchenAbvGr Fireplaces GarageCars WoodDeckSF ScreenPorch
		/ partial AIC VIF CLI;
		output out= test_lso_ma_OLS  p = yhat;
run;




*proc print data=test_lso_ma_OLS (where=(id>1460));
*run;
/* Save results to CSV*/

data Results;
set test_lso_ma_OLS;
if yhat > 0 then SalePrice = yhat;
if yhat < 0 then SalePrice = 10000;
keep id  SalePrice;
where id > 1460;
;
 run;
/*That's it! ... From here we will export results2 to a csv file on the desktop and then upload it to Kaggle. */


 
 
proc export data=Results outfile='/home/skhayden0/sasuser.v94/Stats 2/Project 1/Results.csv' dbms=csv Replace;
run;

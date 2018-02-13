Proc GLmselect data=train2  seed=2 plots(stepAxis=number)=(criterionPanel ASEPlot) ;
Class  MSZoning Street LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle   
RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 
Heating HeatingQC CentralAir Electrical KitchenQual Functional GarageType GarageFinish GarageQual GarageCond PavedDrive SaleType SaleCondition;

Model SalePriceLog =  MSSubClass LotFrontage LotArea OverallQual OverallCond YearBuilt YearRemodAdd MasVnrArea 
	 LowQualFinSF GrLivArea BsmtFullBath TotalBsmtSF
	BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars 
    WoodDeckSF OpenPorchSF EnclosedPorch tSsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 
	/ selection = Stepwise (choose = cv stop = aic ) CVDETAILS ;
Modelaverage nsamples= 1000 samplingmethod = URS(percent=100);
output out= test_ols_ma p= yhat r= ress ;
run;

proc print data= test_ols_ma;

ods graphics on;
proc glm data=train2 plots=all;
class OverallQual OverallCond Fireplaces GarageCars;
model SalePrice = MSSubClass LotArea OverallQual OverallCond YearBuilt YearRemodAdd GrLivArea BsmtFullBath TotalBsmtSF KitchenAbvGr Fireplaces GarageCars ScreenPorch
					/ CLPARM SOLUTION;
output out = resultsOLS_ma p = Predict;
run;
quit;
ods graphics off;

ods graphics on;
proc glm data=train2 plots=all;
class OverallQual OverallCond Fireplaces GarageCars;
model SalePrice = MSSubClass LotArea OverallQual OverallCond YearBuilt YearRemodAdd GrLivArea BsmtFullBath TotalBsmtSF Fireplaces GarageCars ScreenPorch
					/ CLPARM SOLUTION;
output out = resultsOLS_ma p = Predict;
run;
quit;
ods graphics off;

data results2;
set resultsOLS_ma;
if Predict > 0 then SalePrice = Predict;
if Predict < 0 then SalePrice = 10000;
keep id SalePrice;
where id > 1460;
;

/*Export the csv file for OLS MA*/
proc export data=results2 outfile='C:\Vivek\Data_Science\MSDS-6372-Stats-II\Week-06_Project\submitOLS_ma.csv' dbms=csv Replace;
run;

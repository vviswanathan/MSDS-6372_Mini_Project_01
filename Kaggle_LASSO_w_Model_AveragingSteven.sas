
Proc GLmselect data=train2  seed=2 plots(stepAxis=number)=(criterionPanel ASEPlot);
Class MSSubClass MSZoning Street LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle OverallQual OverallCond 
RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 
Heating HeatingQC CentralAir Electrical KitchenQual Functional GarageType GarageFinish GarageQual GarageCond PavedDrive SaleType SaleCondition;




Model SalePrice = Id MSSubClass LotFrontage LotArea OverallQual OverallCond YearBuilt YearRemodAdd MasVnrArea 
	BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF FrstFlrSF ScndFlrSF LowQualFinSF GrLivArea BsmtFullBath 
	BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars 
	GarageArea WoodDeckSF OpenPorchSF EnclosedPorch tSsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 
	/ selection = Lasso (choose = cv stop = aic ) CVDETAILS;
Modelaverage nsamples= 1000 samplingmethod = URS(percent=100);
output out= test_lso_ma p= pred r= ress ;
run;

*proc print data= test_lso_ma;

proc sgscatter data = train2;
matrix MSSubClass LotArea OverallQual YearBuilt YearRemodAdd;
matrix MasVnrArea BsmtFinSF1 TotalBsmtSF FrstFlrSF GrLivArea;
matrix KitchenAbvGr Fireplaces GarageCars GarageArea WoodDeckSF;
run;

ods graphics on;
proc reg data=train2 outest=TrainResultsLSO_ma plots(label)=(rstudentbyleverage cooksd);
model SalePrice = MSSubClass LotArea OverallQual YearBuilt YearRemodAdd 
					MasVnrArea BsmtFinSF1 TotalBsmtSF FrstFlrSF GrLivArea 
					KitchenAbvGr Fireplaces GarageCars GarageArea WoodDeckSF
					/ partial AIC VIF CLI;
run;
quit;
ods graphics off;

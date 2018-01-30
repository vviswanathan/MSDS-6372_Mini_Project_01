data train;
infile "C:\Vivek\Data_Science\MSDS-6372-Stats-II\Week-06_Project\train1.csv" dlm="," firstobs=2;
input Id MSSubClass MSZoning $ LotFrontage LotArea Street $ /*Alley $ */LotShape $ LandContour $ Utilities $ LotConfig $ LandSlope $ 
	Neighborhood $ Condition1 $ Condition2 $ BldgType $ HouseStyle $ OverallQual OverallCond YearBuilt YearRemodAdd RoofStyle $ RoofMatl $ 
	Exterior1st $ Exterior2nd $ MasVnrType $ MasVnrArea ExterQual $ ExterCond $ Foundation $ BsmtQual $ BsmtCond $ BsmtExposure $ BsmtFinType1 $ 
	BsmtFinSF1 BsmtFinType2 $ BsmtFinSF2 BsmtUnfSF TotalBsmtSF Heating $ HeatingQC $ CentralAir $ Electrical $ FrstFlrSF ScndFlrSF LowQualFinSF 
	GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr KitchenQual $ TotRmsAbvGrd Functional $ Fireplaces FireplaceQu $ 
	GarageType $ GarageYrBlt GarageFinish $ GarageCars GarageArea GarageQual $ GarageCond $ PavedDrive $ WoodDeckSF OpenPorchSF EnclosedPorch 
	tSsnPorch ScreenPorch PoolArea /*PoolQC $ Fence $ MiscFeature $ */MiscVal MoSold YrSold SaleType $ SaleCondition $ SalePrice;
run;
proc print data = train;
run;

data test;
infile "C:\Vivek\Data_Science\MSDS-6372-Stats-II\Week-06_Project\test.csv" dlm="," firstobs=2;
input Id MSSubClass MSZoning $ LotFrontage LotArea Street $ Alley $ LotShape $ LandContour $ Utilities $ LotConfig $ LandSlope $ 
	Neighborhood $ Condition1 $ Condition2 $ BldgType $ HouseStyle $ OverallQual OverallCond YearBuilt YearRemodAdd RoofStyle $ RoofMatl $ 
	Exterior1st $ Exterior2nd $ MasVnrType $ MasVnrArea ExterQual $ ExterCond $ Foundation $ BsmtQual $ BsmtCond $ BsmtExposure $ BsmtFinType1 $ 
	BsmtFinSF1 BsmtFinType2 $ BsmtFinSF2 BsmtUnfSF TotalBsmtSF Heating $ HeatingQC $ CentralAir $ Electrical $ FrstFlrSF ScndFlrSF LowQualFinSF 
	GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr KitchenQual $ TotRmsAbvGrd Functional $ Fireplaces FireplaceQu $ 
	GarageType $ GarageYrBlt GarageFinish $ GarageCars GarageArea GarageQual $ GarageCond $ PavedDrive $ WoodDeckSF OpenPorchSF EnclosedPorch 
	tSsnPorch ScreenPorch PoolArea PoolQC $ Fence $ MiscFeature $ MiscVal MoSold YrSold SaleType $ SaleCondition $ ;
run;
proc print data = test;
run;

/* This code assumes that the training and test sets have been imported.  They have been called “train” and “test” respectively … the final data set we would like you to export and submit to Kaggle is called results2 … Whamo! 
At this point the train and test sets have been preprocessed so that there is no cleaning or manipulation of the data done with SAS code here.  */

data test;
set test;
SalePrice = .;
;

data train2;
 set train test;
run;
proc print data = train2;
run;


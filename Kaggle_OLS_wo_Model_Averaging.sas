Proc GLmselect data=train2  seed=2 plots(stepAxis=number)=(criterionPanel ASEPlot);
Model SalePrice = Id MSSubClass LotFrontage LotArea OverallQual OverallCond YearBuilt YearRemodAdd MasVnrArea 
	BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF FrstFlrSF ScndFlrSF LowQualFinSF GrLivArea BsmtFullBath 
	BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars 
	GarageArea WoodDeckSF OpenPorchSF EnclosedPorch tSsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 
	/ selection = stepwise(choose = cv stop = cv ) CVDETAILS;
output out= test_ols p= pred r= ress ;
run;

proc print data= test_ols;


*Class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 
	Condition2 BldgType HouseStyle RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond 
	Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating HeatingQC CentralAir Electrical 
	KitchenQual Functional FireplaceQu GarageType GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence 
	MiscFeature SaleType SaleCondition;
*Model SalePrice = Id MSSubClass MSZoning LotFrontage LotArea Street Alley LotShape LandContour Utilities 
	LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle OverallQual OverallCond 
	YearBuilt YearRemodAdd RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType MasVnrArea ExterQual 
	ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinSF1 BsmtFinType2 BsmtFinSF2 
	BsmtUnfSF TotalBsmtSF Heating HeatingQC CentralAir Electrical FrstFlrSF ScndFlrSF LowQualFinSF GrLivArea 
	BsmtFullBath BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr KitchenQual TotRmsAbvGrd Functional 
	Fireplaces FireplaceQu GarageType GarageYrBlt GarageFinish GarageCars GarageArea GarageQual GarageCond 
	PavedDrive WoodDeckSF OpenPorchSF EnclosedPorch tSsnPorch ScreenPorch PoolArea PoolQC Fence MiscFeature 
	MiscVal MoSold YrSold SaleType SaleCondition / selection = Lasso (choose = cv stop = cv ) CVDETAILS;

Proc GLmselect data=train2  seed=2 plots(stepAxis=number)=(criterionPanel ASEPlot);
Model SalePrice = Id MSSubClass LotFrontage LotArea OverallQual OverallCond YearBuilt YearRemodAdd MasVnrArea 
	BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF FrstFlrSF ScndFlrSF LowQualFinSF GrLivArea BsmtFullBath 
	BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars 
	GarageArea WoodDeckSF OpenPorchSF EnclosedPorch tSsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 
	/ selection = Lasso (choose = cv stop = aic ) CVDETAILS;
output out= test_lso p= pred r= ress ;
run;

proc print data= test_lso;

proc sgscatter data = train2;
matrix MSSubClass LotFrontage LotArea OverallQual OverallCond; 
matrix YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 TotalBsmtSF; 
matrix GrLivArea BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces; 
matrix GarageYrBlt GarageCars GarageArea WoodDeckSF ScreenPorch PoolArea;
run;

ods graphics on;
proc reg data=train2 outest=TrainResultsLSO plots(label)=(rstudentbyleverage cooksd);
model SalePrice = MSSubClass LotFrontage LotArea OverallQual OverallCond 
					YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 TotalBsmtSF 
					GrLivArea BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces 
					GarageYrBlt GarageCars GarageArea WoodDeckSF ScreenPorch PoolArea
					/ partial AIC VIF CLI;
run;
quit;
ods graphics off;

proc glm data=train2 plots=(DIAGNOSTICS RESIDUALS);
class Fireplaces KitchenAbvGr BedroomAbvGr OverallCond OverallQual;
model SalePrice = MSSubClass LotFrontage LotArea OverallQual OverallCond 
					YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 TotalBsmtSF 
					GrLivArea BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces 
					GarageYrBlt GarageCars GarageArea WoodDeckSF ScreenPorch PoolArea
					Fireplaces*KitchenAbvGr Fireplaces*BedroomAbvGr Fireplaces*OverallCond Fireplaces*OverallQual
					KitchenAbvGr*BedroomAbvGr KitchenAbvGr*OverallCond KitchenAbvGr*OverallQual
					BedroomAbvGr*OverallCond BedroomAbvGr*OverallQual OverallCond*OverallQual;
*lsmeans Fireplaces KitchenAbvGr BedroomAbvGr OverallCond OverallQual / pdiff tdiff cl adjust=bon;
run;

proc glm data=train2 plots=(DIAGNOSTICS RESIDUALS);
class Fireplaces KitchenAbvGr BedroomAbvGr OverallCond OverallQual;
model SalePrice = MSSubClass LotFrontage LotArea OverallQual OverallCond 
					YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 TotalBsmtSF 
					GrLivArea BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces 
					GarageYrBlt GarageCars GarageArea WoodDeckSF ScreenPorch PoolArea
					Fireplaces*KitchenAbvGr KitchenAbvGr*BedroomAbvGr KitchenAbvGr*OverallQual
					BedroomAbvGr*OverallCond;
lsmeans Fireplaces KitchenAbvGr BedroomAbvGr OverallCond OverallQual / pdiff tdiff cl adjust=bon;
run;

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
*Class MSZoning(param=ordinal order=data) Street(param=ordinal order=data) Alley(param=ordinal order=data) LotShape(param=ordinal order=data) LandContour(param=ordinal order=data) 
		Utilities(param=ordinal order=data) LotConfig(param=ordinal order=data) LandSlope(param=ordinal order=data) Neighborhood(param=ordinal order=data) Condition1(param=ordinal order=data) 
		Condition2(param=ordinal order=data) BldgType(param=ordinal order=data) HouseStyle(param=ordinal order=data) RoofStyle(param=ordinal order=data) RoofMatl(param=ordinal order=data) 
		Exterior1st(param=ordinal order=data) Exterior2nd(param=ordinal order=data) MasVnrType(param=ordinal order=data) ExterQual(param=ordinal order=data) ExterCond(param=ordinal order=data) 
		Foundation(param=ordinal order=data) BsmtQual(param=ordinal order=data) BsmtCond(param=ordinal order=data) BsmtExposure(param=ordinal order=data) BsmtFinType1(param=ordinal order=data) 
		BsmtFinType2(param=ordinal order=data) Heating(param=ordinal order=data) HeatingQC(param=ordinal order=data) CentralAir(param=ordinal order=data) Electrical(param=ordinal order=data) 
		KitchenQual(param=ordinal order=data) Functional(param=ordinal order=data) FireplaceQu(param=ordinal order=data) GarageType(param=ordinal order=data) GarageFinish(param=ordinal order=data) 
		GarageQual(param=ordinal order=data) GarageCond(param=ordinal order=data) PavedDrive(param=ordinal order=data) PoolQC(param=ordinal order=data) Fence(param=ordinal order=data) 
		MiscFeature(param=ordinal order=data) SaleType(param=ordinal order=data) SaleCondition(param=ordinal order=data) / showcoding;

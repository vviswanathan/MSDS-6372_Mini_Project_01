Proc GLmselect data=train2  seed=2 plots(stepAxis=number)=(criterionPanel ASEPlot);
Model SalePrice = Id MSSubClass LotFrontage LotArea OverallQual OverallCond YearBuilt YearRemodAdd MasVnrArea 
	BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF FrstFlrSF ScndFlrSF LowQualFinSF GrLivArea BsmtFullBath 
	BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars 
	GarageArea WoodDeckSF OpenPorchSF EnclosedPorch tSsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 
	/ selection = stepwise(choose = cv stop = cv ) CVDETAILS;
output out= test_ols p= pred r= ress ;
run;

proc print data= test_ols;

proc sgscatter data = train2;
matrix MSSubClass LotArea OverallQual OverallCond;
matrix YearBuilt MasVnrArea BsmtFinSF1 GrLivArea;
matrix BsmtFullBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd;
matrix GarageYrBlt GarageCars WoodDeckSF ScreenPorch;
run;

ods graphics on;
proc reg data=train2 outest=TrainResultsOLS plots(label)=(rstudentbyleverage cooksd);
model SalePrice = MSSubClass LotArea OverallQual OverallCond 
					YearBuilt MasVnrArea BsmtFinSF1 GrLivArea 
					BsmtFullBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd 
					GarageYrBlt GarageCars WoodDeckSF ScreenPorch
					/ partial AIC VIF CLI;
run;
quit;
ods graphics off;

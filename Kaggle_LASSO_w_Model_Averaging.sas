Proc GLmselect data=train2  seed=2 plots(stepAxis=number)=(criterionPanel ASEPlot);
Model SalePrice = Id MSSubClass LotFrontage LotArea OverallQual OverallCond YearBuilt YearRemodAdd MasVnrArea 
	BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF FrstFlrSF ScndFlrSF LowQualFinSF GrLivArea BsmtFullBath 
	BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars 
	GarageArea WoodDeckSF OpenPorchSF EnclosedPorch tSsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 
	/ selection = Lasso (choose = cv stop = cv ) CVDETAILS;
Modelaverage nsamples= 1000 samplingmethod = URS(percent=100);
output out= test_lso_ma p= pred r= ress ;
run;

proc print data= test_lso_ma;


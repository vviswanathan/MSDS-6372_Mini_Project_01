Proc GLmselect data=train2  seed=2 plots(stepAxis=number)=(criterionPanel ASEPlot);
Model SalePrice = Id MSSubClass LotFrontage LotArea OverallQual OverallCond YearBuilt YearRemodAdd MasVnrArea 
	BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF FrstFlrSF ScndFlrSF LowQualFinSF GrLivArea BsmtFullBath 
	BsmtHalfBath FullBath HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars 
	GarageArea WoodDeckSF OpenPorchSF EnclosedPorch tSsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 
	/ selection = Stepwise (choose = cv stop = cv ) CVDETAILS;
Modelaverage nsamples= 1000 samplingmethod = URS(percent=100);
output out= test_ols_ma p= pred r= ress ;
run;

proc print data= test_ols_ma;

proc sgscatter data = train2;
matrix MSSubClass LotArea OverallQual OverallCond YearBuilt;
matrix MasVnrArea BsmtFinSF1 TotalBsmtSF GrLivArea BedroomAbvGr;
run;

ods graphics on;
proc reg data=train2 outest=TrainResultsOLS_ma plots(label)=(rstudentbyleverage cooksd);
model SalePrice = MSSubClass LotArea OverallQual OverallCond YearBuilt 
					MasVnrArea BsmtFinSF1 TotalBsmtSF GrLivArea BedroomAbvGr
					/ partial AIC VIF CLI;
run;
quit;
ods graphics off;

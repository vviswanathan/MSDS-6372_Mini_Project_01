*No log
*GrLivArea TotalBsmtSF YearBuilt YearRemodAdd GarageCars OverallQual_9 BsmtFinSF1 Fireplaces KitchenAbvGr LotArea;




proc autoreg data = train2 plots=all;
model SalePricelog =  MSSubClass LotArea OverallQual OverallCond YearBuilt YearRemodAdd BsmtFinSF1 TotalBsmtSF 
		GrLivArea BsmtFullBath KitchenAbvGr Fireplaces GarageCars WoodDeckSF ScreenPorch / dwprob ;
output out = test_auto_reg rm = residualsOLS r = residualsLag1 p= yhat  lcl= LCL ucl= UCL pm= trend;
run;




data Results;
set test_auto_reg;
if  EXP(yhat) > 0 then SalePrice = EXP(yhat);
if  EXP(yhat) < 0 then SalePrice = 10000;
keep id  SalePrice;
where id > 1460;
;
 run;

proc export data=Results outfile='/home/skhayden0/sasuser.v94/Stats 2/Project 1/Results.csv' dbms=csv Replace;
run;



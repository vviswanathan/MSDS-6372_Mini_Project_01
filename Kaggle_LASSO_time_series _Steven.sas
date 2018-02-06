*No log
*GrLivArea TotalBsmtSF YearBuilt YearRemodAdd GarageCars OverallQual_9 BsmtFinSF1 Fireplaces KitchenAbvGr LotArea;

proc autoreg data = train2 plots=all;
class OverallQual;
model  SalePrice = GrLivArea TotalBsmtSF YearBuilt YearRemodAdd GarageCars OverallQual BsmtFinSF1 Fireplaces KitchenAbvGr LotArea / dwprob nlag=1;
output out = Results rm = residualsOLS r = residualsLag1 p= melhat  lcl= LCL ucl= UCL pm= trend;
run;











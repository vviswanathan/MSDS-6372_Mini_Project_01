PROC glm data = train2 plots = all;
CLASS Neighborhood;
MODEL SalePriceLog = GrLivArea Neighborhood GrLivArea*Neighborhood / CLPARM solution;
OUTPUT OUT=TrainOut COOKD=TrainCookD H=Leverage RSTUDENT=RStudent;
RUN;

PROC glm data = train3 plots = all;
CLASS Neighborhood;
MODEL SalePriceLog = GrLivArea Neighborhood GrLivArea*Neighborhood / CLPARM solution;
OUTPUT OUT=TrainOut COOKD=TrainCookD H=Leverage RSTUDENT=RStudent;
RUN;

proc print data=TrainOut;
run;

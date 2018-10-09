*  This is a single line comment ;

/* This is a paragraph

   comment */

%let path = G:\project\project1\sas\sas-prog-for-r-users;


proc import out = student

  datafile = '&path/data/class.csv'

  dbms = csv replace;

  getnames = yes;

run;



proc import out = student_xls

  datafile = '&path/data/class.xls'

  dbms = xls replace;

  getnames = yes;

run;



data student_json;

  INFILE '&path/data/class.json' LRECL  = 3456677  TRUNCOVER SCANOVER

    dsd

    dlm=",}";

  INPUT

    @'"Name":' Name : $12.

    @'"Sex":' Sex : $2.

    @'"Age":' Age :

    @'"Height":' Height :

    @'"Weight":' Weight :

    @@;

run;



proc import out = student

  datafile = '&path/data/class.csv'

  dbms = csv replace;

  getnames = yes;

run;



proc contents data = student;

run;



/* obs= option tells SAS how many observations to print, starting

   with the first observation */

proc print data = student (obs=5);

run;



/* print the last 5 observations */

proc print data = student (firstobs=15);

run; 



proc means data = student mean;

run;



/* SAS uses a different method than Python and R to compute

   quartiles, but the method in each language can be changed */

/* maxdec= option tells SAS to print at most 2 numbers behind

   the decimal point */

proc means data = student min q1 median mean q3 max n maxdec=2;

run;



/* The var statement tells SAS which variable to use for the

   procedure */

proc means data = student stddev sum n max min median maxdec=2;

  var Weight;

run;



proc freq data = student;

  tables Age / nopercent norow nocol;

run;



proc freq data = student;

  tables Sex / nopercent norow nocol;

run;



/* The "*" between two variables on the tables statement

   indicates to produce a two-way table of the two variables */

proc freq data = student;

  tables Age*Sex / nopercent norow nocol;

run;



data females;

  set student;

  where Sex = "F";

run;

proc print data = females(obs=5);

run; 



/* The nosimple option reduces the output of this procedure */

proc corr data = student pearson nosimple;

var Height Weight;

run; 



proc sgplot data = student;

  histogram weight / binwidth=20 binstart=40 scale=count;

  xaxis values=(40 to 160 by 20);

run;



/* SAS automatically prints the mean on the boxplot */

proc sgplot data = student;

  vbox Weight;

run;



/* Notice here you specify the y variable followed by the x variable */

proc sgscatter data = student;

  plot Weight * Height;

run; 



/* Use proc reg to get the parameter estimates for the line of best fit,

   but don't print the graph (ods graphics off) */

ods graphics off;

proc reg data = student;

  /* Syntax indicates Weight as a function of Height */

  model Weight = Height;

  ods output ParameterEstimates=PE;

run;

ods graphics on;



/* data _null_ indicates to not create a data set, but

   run the code within the data step to create macro

   variables to store the parameter estimates */

data _null_;

  set PE;

  if _n_=1 then call symput('Int', put(estimate, BEST6.));

  else call symput('Slope', put(estimate, BEST6.));

run;



/* Use proc sgplot with the reg statement so it prints the line of best fit,

   and use the inset statement to print the equation of the line

   of best fit */

proc sgplot data = student noautolegend;

  reg y = Weight x = Height;

  inset "Line: Y = &Slope x + &Int" / position=topleft;

run; 



/* Notice here you must first sort by Sex and then plot the vertical

  bar chart */

proc sort data = student;

  by Sex;

run;

proc sgplot data = student;

  vbar Sex;

run; 



proc sgplot data = student;

  vbox Weight / group=Sex;

run; 



data student;

  set student;

  BMI = Weight / (Height**2) * 703;

run;

proc print data = student(obs=5);

run;



data student;

  set student;

  if (BMI < 19.0) then BMI_class = "Underweight";

  else BMI_class = "Healthy";

run;

proc print data = student(obs=5);

run;



data student;

  set student;

  LogWeight = log(Weight);

  ExpAge = exp(Age);

  SqrtHeight = sqrt(Height);

  if (BMI < 19.0) then BMI_Neg = -BMI;

  else BMI_Neg = BMI;

  BMI_Pos = abs(BMI_Neg);

  /* Create a Boolean variable, which is handled differently

     in SAS than in Python and R */

  BMI_Check = (BMI_Pos = BMI);

run;

proc print data = student(obs=5);

run; 



data student;

  set student (drop = LogWeight ExpAge SqrtHeight BMI_Neg BMI_Pos BMI_Check);

run;

proc print data = student(obs=5);

run;



proc sort data = student;

  by Age;

run;

proc print data = student(obs=5);

run;



proc sort data = student;

  by Sex;

run;

/* Notice that the data is now sorted first by Sex and

   then within Sex by Age */

proc print data = student(obs=5);

run;



proc means data = student mean;

  by Sex;

  var Age Height Weight BMI;

run;



/* Look at the tail of the data currently */

proc print data = student(firstobs=15);

run; 



data student;

  set student end = eof;

  output;

  if eof then do;

    Name = 'Jane';

    Sex = 'F';

    Age = 14;

    Height = 56.3;

    Weight = 77.0;

    BMI = 17.077695;

    BMI_Class = 'Underweight';

    output;

  end;

run;

proc print data = student(firstobs=16);

run;



proc fcmp outlib=sasuser.userfuncs.myfunc;

  function toKG(lb);

    kg = 0.45359237 * lb;

  return(kg);

endsub;



options cmplib=sasuser.userfuncs;



data studentKG;

  set student;

  Weight_KG = toKG(Weight);

run;



proc print data = studentKG(obs=5);

run;



/* Notice the use of the fish data set because it has some missing

   observations */

proc import out = fish

  datafile ='&path/data/fish.csv'

  dbms = csv replace;

  getnames = yes;

run;



/* First sort by Weight, requesting those with NA for Weight first,

   which SAS does automatically */

proc sort data = fish;

  by Weight;

run;

proc print data = fish(obs=5);

run;



data new_fish;

  set fish;

  /* Notice the not-equal operator (^=) and how SAS denotes

     missing values (.) */

  if (Weight ^= .);

run;

proc print data = new_fish(obs=5);

run;



/* Notice the use of the student data set again, however we want to reload it

   without the changes we've made previously  */

proc import out = student

  datafile = '&path/data/class.csv'

  dbms = csv replace;

  getnames = yes;

run;

data student1;

  set student(keep= Name Sex Age);

run;

proc print data = student1(obs=5);

run; 



data student2;

  set student(keep= Name Height Weight);

run;

proc print data = student2(obs=5);

run;



data new;

  merge student1 student2;

  by Name;

run;

proc print data = new(obs=5);

run;



proc compare base = student compare = new brief;

run;



data newstudent1;

  set student(keep= Name Sex Age);

run;

proc print data = newstudent1(obs=5);

run;



data newstudent2;

  set student(keep= Height Weight);

run;

proc print data = newstudent2(obs=5);

run;



data new2;

  merge newstudent1 newstudent2;

run;

proc print data = new2(obs=5);

run;



proc compare base = student compare = new2 brief;

run;



/* Notice we are using a new data set that needs to be read into the

   environment */

proc import out = price

  datafile = '&path/data/price.csv'

  dbms = csv replace;

  getnames = yes;

run;



/* The following code is used to remove the "," and "$" characters from the

   ACTUAL column so that values can be summed */

data price;

  set price;

  num_actual = input(actual, dollar10.);

run;



proc sql;

  create table categorysales as

    select country, state, prodtype,

    product, sum(num_actual) as REVENUE

    from price

  group by country, state, prodtype, product;

quit;

proc print data = categorysales(obs=5);

run;



proc iml;

  use price;

    read all var {STATE};

  close price;



  unique_states = unique(STATE);

  print(unique_states);

quit;



/* Notice we are using a new data set that needs to be read into the

   environment */

proc import out = iris

  datafile = '&path/data/iris.csv'

  dbms = csv replace;

  getnames = yes;

run;



data features;

  set iris(drop=Target);

run;



proc princomp data = features noprint outstat = feat_princomp;

  var SepalLength SepalWidth PetalLength PetalWidth;

run;



data eigenvectors;

    set feat_princomp;

    where _TYPE_ = "SCORE";

run;

proc print data = eigenvectors;

run;



/* outall option tells SAS to add a flag showing which observations were

   chosen */

/* seed = 29 specifies the seed for random values so the results are

   reproducible */

proc surveyselect data = iris outall out = all method = srs samprate = 0.7

                              seed = 29;

run;



data train (drop = selected) test (drop = selected);

    set all;

    if (selected = 1) then output train;

  else output test;

run;



proc export data = train

   outfile = 'C:\Users\iris_train.csv'

   dbms = csv;

run;

proc export data = test

   outfile = 'C:\Users\iris_test.csv'

   dbms = csv;

run;



/* Notice we are using a new data set that needs to be read into the

   environment */

proc import out = tips

  datafile = '&path/data/tips.csv'

  dbms = csv replace;

  getnames = yes;

run;



/* The following code is used to determine if the individual left more than

   a 15% tip */

data tips;

  set tips;

  if (tip > 0.15*total_bill) then greater15 = 1;

  else greater15 = 0;

run;



/* The descending option tells SAS to model the probability that

  greater15 = 1 */

proc genmod data=tips descending;

  model greater15 = total_bill / dist = bin link = logit lrci;

run; 



/* Fit a linear regression model of tip by total_bill */

proc reg data = tips outest=RegOut;

    tip_hat: model tip = total_bill;

quit;



/* Notice we are using new data sets that need to be read into the

   environment */

proc import out = train

  datafile = '&path/data/tips_train.csv'

  dbms = csv replace;

  getnames = yes;

run;

proc import out = test

  datafile = '&path/data/tips_test.csv'

  dbms = csv replace;

  getnames = yes;

run;



/* The following code is used to determine if the individual left more than

   a 15% tip */

data train;

  set train;

  if (tip > 0.15*total_bill) then greater15 = 1;

  else greater15 = 0;

run;

data test;

  set test;

  if (tip > 0.15*total_bill) then greater15 = 1;

  else greater15 = 0;

run;



/* The descending option tells SAS to model the probability that

  greater15 = 1 */

proc genmod data=train descending;

  model greater15 = total_bill / dist = bin link = logit lrci;

  store out = logmod;

run;



/* Prediction on testing data */

proc plm source = logmod noprint;

    score data = test out = preds pred = pred / ilink;

run;



/* Determine how many were correctly classified */

data preds;

    set preds;

    if (pred < 0.5) then label = 0;

    else label = 1;

    if (label = greater15) then Result = "Correct";

    else Result = "Wrong";

run;



proc freq data = preds;

tables Result / nopercent norow nocol;

run;



/* Notice we are using new data sets that need to be read into the

  environment */

proc import out = train

  datafile = '&path/data/boston_train.csv'

  dbms = csv replace;

  getnames = yes;

run;

proc import out = test

  datafile = '&path/data/boston_test.csv'

  dbms = csv replace;

  getnames = yes;

run;



proc reg data = train outest=RegOut;

  predY: model Target = _0-_12;

quit;



/* Predicton on testing data */

proc score data = test score=RegOut type=parms predict out = Pred;

    var _0-_12;

run;



/* Compute the squared differences between predicted and target */

data Pred;

    set Pred;

    sq_error = (predY - Target)**2;

run;



/* Compute the mean of the squared differences (mean squared error) as an

   assessment of the model */

proc means data = Pred mean;

  var sq_error;

run;



/* Notice we are using new data sets that need to be read into the

   environment */

proc import out = train

    datafile = '&path/data/breastcancer_train.csv'

    dbms = csv replace;

    getnames = yes;

run;

proc import out = test

    datafile = '&path/data/breastcancer_test.csv'

    dbms = csv replace;

    getnames = yes;

run;



/* HPSPLIT procedure is used to fit a decision tree model */

proc hpsplit data = train seed = 29;

    target Target;

    input _0-_29;

    /* Export information about variable importance */

    output importance=import;

    /* Export the model code so this can be used to score testing data */

    code file='hpbreastcancer.sas';

run;



/* Output of this model gives assessment against training data

     and variable importance */



/* Score the test data using the model code */

data scored;

    set test;

    %include 'hpbreastcancer.sas';

run;



/* Use prediction probabilities to generate predictions, and compare these

     to the true responses */

/* If the prediction probability is less than 0.5, classify this as a 0

   and otherwise classify as a 1.  This isn't the best method -- a better

   method would be randomly assigning a 0 or 1 when a probability of 0.5

   occurrs, but this insures that results are consistent */

data scored;

    set scored;

    if (P_Target1 < 0.5) then prediction = 0;

    else prediction = 1;

    if (Target = prediction) then Result = "Correct";

  else Result = "Wrong";

run;



/* Determine how many were correctly classified */

proc freq data = scored;

  tables Result / nopercent norow nocol;

run;



proc import out = train

    datafile = '&path/data/boston_train.csv'

    dbms = csv replace;

    getnames = yes;

run;

proc import out = test

    datafile = '&path/data/boston_test.csv'

    dbms = csv replace;

    getnames = yes;

run;



/* HPSPLIT procedure is used to fit a decision tree model */

proc hpsplit data = train seed = 29;

    target Target / level = int;

    input _0-_12;

    /* Export information about variable importance */

    output importance=import;

    /* Export the model code so this can be used to score testing data */

    code file='hpboston.sas';

run;



/* Output of this model gives assessment against training data

   and variable importance */



/* Score the test data using the model code */

data scored;

    set test;

    %include 'hpboston.sas';

run;



/* Compute the squared differences between predicted and target */

data scored;

    set scored;

    sq_error = (P_Target - Target)**2;

run;



/* Compute the mean of the squared differences (mean squared error) as an

     assessment of the model */

proc means data = scored mean;

  var sq_error;

run;



proc import out = train

    datafile = '&path/data/breastcancer_train.csv'

    dbms = csv replace;

    getnames = yes;

run;

proc import out = test

    datafile = '&path/data/breastcancer_test.csv'

    dbms = csv replace;

    getnames = yes;

run;



/* Output includes information about variable importance */

proc hpforest data = train;

    input _0 - _29 / level = interval;

    target Target / level = nominal;

    save file = 'hpbreastcancer2.bin';

run;



/* Prediction on testing data */

ods select none;

proc hp4score data = test seed = 29;

    score file = 'hpbreastcancer2.bin' out = scored;

run;

ods select all;



/* Determine how many were correctly classified */

data scored;

    set scored;

    if (I_Target = Target) then Result = "Correct";

    else Result = "Wrong";

run;



proc freq data = scored;

  tables Result / nopercent norow nocol;

run;    



proc import out = train

    datafile = '&path/data/boston_train.csv'

    dbms = csv replace;

    getnames = yes;

run;

proc import out = test

    datafile = '&path/data/boston_test.csv'

    dbms = csv replace;

    getnames = yes;

run;



proc hpforest data = train;

    input _0-_12 / level = interval;

    target Target / level = interval;

    save file = 'hpboston2.bin';

run;



/* Prediction on testing data */

ods select none;

proc hp4score data = test seed = 29;

    score file = 'hpboston2.bin' out = scored;

run;

ods select all;



/* Compute the squared differences between predicted and target */

data scored;

    set scored;

    sq_error = (P_Target - Target)**2;

run;



/* Compute the mean of the squared differences (mean squared error) as an

   assessment of the model */

proc means data = scored mean;

  var sq_error;

run;



proc iml;

  submit / R;

    train = read.csv('&path/data/breastcancer_train.csv')

    test = read.csv('&path/data/breastcancer_test.csv')



    library(xgboost)

      set.seed(29)



    xgbMod <- xgboost(data.matrix(subset(train, select = -c(Target))),

                      data.matrix(train$Target), max_depth = 3, nrounds = 2,

                      objective = "binary:logistic", n_estimators = 2500,

                      shrinkage = .01)

    # Prediction on testing data

    predictions <- predict(xgbMod, data.matrix(subset(test, select =

                                                      -c(Target))))

    pred.response <- ifelse(predictions < 0.5, 0, 1)



    # Determine how many were correctly classified

    Results <- ifelse(test$Target == pred.response, "Correct", "Wrong")

    table(Results)

  endsubmit;

quit;



proc iml;

  submit / R;

    train = read.csv('&path/data/boston_train.csv')

    test = read.csv('&path/data/boston_test.csv')



    library(xgboost)

      set.seed(29)



    xgbMod <- xgboost(data.matrix(subset(train, select = -c(Target))),

                      data.matrix(train$Target / 50), max_depth = 3,

                      nrounds = 2, n_estimators = 2500, shrinkage = .01)



    # Predict the target in the testing data, remembering to

    # multiply by 50

    prediction = data.frame(matrix(ncol = 0, nrow = nrow(test)))

    prediction$target_hat <- predict(xgbMod,

                                     data.matrix(subset(test,

                                                 select = - c(Target))))*50



    # Compute the squared difference between predicted tip and actual tip

    prediction$sq_diff <- (prediction$target_hat - test$Target)**2



    # Compute the mean of the squared differences (mean squared error)

    # as an assessment of the model

    mean_sq_error <- mean(prediction$sq_diff)

    print(mean_sq_error)

  endsubmit;

quit;



proc import out = train

    datafile = '&path/data/breastcancer_train.csv'

    dbms = csv replace;

    getnames = yes;

run;

proc import out = test

    datafile = '&path/data/breastcancer_test.csv'

    dbms = csv replace;

    getnames = yes;

run;



/* Fit a support vector classification model */

proc hpsvm data = train noscale;

  input _0-_29 / level = interval;

    target Target / level = nominal;

    code file='hpbreastcancer3.sas';

run;



/* Prediction on testing data */

data scored;

    set test;

    %include 'hpbreastcancer3.sas';

run;



/* Determine how many were correctly classified */

data scored;

    set scored;

    if (I_Target = Target) then Result = "Correct";

    else Result = "Wrong";

run;



proc freq data = scored;

  tables Result / nopercent norow nocol;

run;    



/* Notice we are using new data sets */

  proc import out = train

      datafile = '&path/data/digits_train.csv'

      dbms = csv replace;

      getnames = yes;

  run;

  proc import out = test

      datafile = '&path/data/digits_test.csv'

      dbms = csv replace;

      getnames = yes;

  run;



/* In order to use the NEURAL Procedure we first need to create a data

   mining database (DMDB) that reflects the original data */

proc dmdb batch data = train

    out = dmtrain

    dmdbcat = digits;

  var _0 - _63;

  class Target;

  target Target;

run;

proc dmdb batch data = test

    out = dmtest

    dmdbcat = digits;

  var _0 - _63;

  class Target;

  target Target;

run;



/* Now we can fit the neural network model */

/* Neural network produces a lot of output which is why here

   "nloptions noprint" is specified */

proc neural data = train dmdbcat = digits random = 29;

  nloptions noprint;

  input _0 - _63 / level = interval;

  target Target / level = nominal;

  archi MLP hidden=100;

  train maxiter = 200;

  score out = out outfit = fit;

  score data = test out = gridout;

run;



/* Prediction on testing data */

data scored;

    set gridout;

    rename I_Target = Prediction;

run;



/* This produces a confusion matrix */

proc freq data = scored;

    tables Target*Prediction / nopercent norow nocol;

run;



proc import out = train

    datafile = '&path/data/boston_train.csv'

    dbms = csv replace;

    getnames = yes;

run;

proc import out = test

    datafile = '&path/data/boston_test.csv'

    dbms = csv replace;

    getnames = yes;

run;



/* In order to use the NEURAL Procedure we first need to create a data

   mining database (DMDB) that reflects the original data */

proc dmdb batch data = train

    out = dmtrain

    dmdbcat = boston;

  var _0 - _12 Target;

  target Target;

run;

proc dmdb batch data = test

    out = dmtest

    dmdbcat = boston;

  var _0 - _12 Target;

  target Target;

run;



/* Now we can fit the neural network model */

/* Neural network produces a lot of output which is why here

   "nloptions noprint" is specified */

proc neural data = train dmdbcat = boston random = 29;

  nloptions noprint;

  archi MLP hidden=100;

  input _0 - _12 / level = interval;

  target Target / level = interval;

  train maxiter = 250;

  score data = test outfit = netfit out = gridout;

run;



/* Prediction on testing data */

data scored(keep = sq_error P_Target Target);

    set gridout;

    sq_error = (P_Target - Target)**2;

run;



/* Determine mean squared error */

proc means data = scored mean;

var sq_error;

run;



proc import out = iris

    datafile = '&path/data/iris.csv'

    dbms = csv replace;

    getnames = yes;

run;



data iris;

    length Species $ 20;

    set iris;

    if (Target = 0) then Species = "Setosa";

    if (Target = 1) then Species = "Versicolor";

    if (Target = 2) then Species = "Virginica";

run;



proc fastclus data=iris maxclusters=3 out=kmeans random = 29 noprint;

    var PetalLength PetalWidth SepalLength SepalWidth;

run;



proc freq data = kmeans;

    tables Species*Cluster / nopercent nocol norow;

run;



proc iml;

  submit / R;

    iris = read.csv('&path/data/iris.csv')

      iris$Species = ifelse(iris$Target == 0, "Setosa",

                            ifelse(iris$Target == 1, "Versicolor",

                                   "Virginica"))

      features <- as.matrix(subset(iris, select = c(PetalLength,

                                                    PetalWidth, SepalLength,

                                                    SepalWidth)))

    library(kernlab)

    set.seed(29)

    spectral <- specc(features, centers = 3, iterations = 10,

                      nystrom.red = TRUE)

    labels <- as.data.frame(spectral)

    table(iris$Species, labels$spectral)

  endsubmit;

quit;



proc import out = iris

  datafile = '&path/data/iris.csv'

  dbms = csv replace;

  getnames = yes;

run;



data iris;

  length Species $ 20;

  set iris;

    if (Target = 0) then Species = "Setosa";

    if (Target = 1) then Species = "Versicolor";

    if (Target = 2) then Species = "Virginica";

run;



proc cluster data = iris method = ward print=15 ccc pseudo noprint;

   var petal: sepal:;

   copy species;

run;



proc tree noprint ncl=3 out=out;

   copy petal: sepal: species;

run;



proc freq data = out;

  tables Species*Cluster / nopercent norow nocol;

run;



proc iml;

  submit / R;

    iris = read.csv('&path/data/iris.csv')

      iris$Species = ifelse(iris$Target == 0, "Setosa",

                            ifelse(iris$Target == 1, "Versicolor",

                                   "Virginica"))

      features <- as.matrix(subset(iris, select = c(PetalLength,

                                                    PetalWidth, SepalLength,

                                                    SepalWidth)))

    library(dbscan)

      set.seed(29)

    dbscan <- dbscan(features, eps = 0.5)

    labels <- dbscan$cluster

    table(iris$Species, labels)

  endsubmit;

quit;



/* Read in new data set */

proc import out = air

  datafile = '&path/data/air.csv'

  dbms = csv replace;

  getnames = yes;

run;



proc timeseries data = air plot = series;

    id date interval = month;

    var air;

run;



proc arima data = air;

    identify var = air(1,12) noprint;

    estimate q=(1)(12) noint method=ml noprint;

    forecast id=date interval=month out=forecast;

run;



/* SAS automatically predicts 2 years out and plots the predictions */



proc import out = usecon

  datafile = '&path/data/usecon.csv'

  dbms = csv replace;

  getnames = yes;

run;

proc timeseries data = usecon plot = series;

    id date interval = month;

    var petrol;

run;



proc esm data = usecon out = forecast lead = 24 plot = forecasts;

    id date interval = month;

    forecast petrol / model = simple;

run;



proc timeseries data = usecon plot = series;

    id date interval = month;

    var vehicles;

run;



proc esm data = usecon out = forecast lead = 24 plot = forecasts;

    id date interval = month;

    forecast vehicles / model = addwinters;

run;



proc import out = train

    datafile = '&path/data/boston_train.csv'

    dbms = csv replace;

    getnames = yes;

run;

proc import out = test

    datafile = '&path/data/boston_test.csv'

    dbms = csv replace;

    getnames = yes;

run;



/* Random Forest Regression Model */

ods select none;

proc hpforest data = train ;

    input _0-_12 / level = interval;

    target Target / level = interval;

    save file = 'rfMod.bin';

run;

ods select all;



/* Evaluation on training data  */

ods select none;

proc hp4score data = train;

    score file = 'rfMod.bin' out = scored_train;

run;

ods select all;



/* Determine coefficient of determination score */

proc iml;

  use scored_train;

    read all var _ALL_ into data;

  close scored_train;

  tip = data[,1];

  pred_rf = data[,2];

  r2_rf = 1 - ( (sum((tip - pred_rf)##2)) / (sum((tip - mean(tip))##2)) );

  print(r2_rf);

quit;



/* Random Forest Regression Model (rfMod) */



/* Evaluation on testing data  */

ods select none;

proc hp4score data = test;

    score file = 'rfMod.bin' out = scored_test;

run;

ods select all;



/* Determine coefficient of determination score */

proc iml;

  use scored_test;

    read all var _ALL_ into data;

  close scored_test;

  tip = data[,1];

  pred_rf = data[,2];

  r2_rf = 1 - ( (sum((tip - pred_rf)##2)) / (sum((tip - mean(tip))##2)) );

  print(r2_rf);

quit;



proc import out = train

    datafile = '&path/data/digits_train.csv'

    dbms = csv replace;

    getnames = yes;

run;

proc import out = test

    datafile = '&path/data/digits_test.csv'

    dbms = csv replace;

    getnames = yes;

run;



/* Random Forest Classification Model */

ods select none;

proc hpforest data = train;

    input _0-_63 / level = interval;

    target Target / level = nominal;

    save file = 'rfMod.bin';

run;



/* Evaluation on training data */

proc hp4score data = train;

    score file = 'rfMod.bin' out = scored;

run;

ods select all;



data scored(keep = Target I_Target correct);

    set scored;

    correct = (I_Target = Target);

run;



/* Determine accuracy score */

proc iml;

    use scored;

      read all var _ALL_ into data;

    close scored;



    accuracy_forest = (1/nrow(data)) * sum(data[,2]);



    print(accuracy_forest);

quit;



/* Random Forest Classification Model (rfMod) */



/* Evaluation on testing data */

ods select none;

proc hp4score data = test;

    score file = 'rfMod.bin' out = scored;

run;

ods select all;



data scored(keep = Target I_Target correct);

    set scored;

    correct = (I_Target = Target);

run;



/* Determine accuracy score */

proc iml;

    use scored;

      read all var _ALL_ into data;

    close scored;



    accuracy_forest = (1/nrow(data)) * sum(data[,2]);



    print(accuracy_forest);

quit; 



/* Results will be displayed in the log */

data class_dict;

declare hash mydict();

mydict.defineKey("Name");

mydict.defineData("Age");

mydict.defineDone();

do while (not eof);

  set sashelp.class end = eof;

  rc = mydict.add();

  output;

end;

Name = 'James';

rc = mydict.find();

put rc= Name= Age=;



array my_array{4} a1-a4 (1 3 5 9);




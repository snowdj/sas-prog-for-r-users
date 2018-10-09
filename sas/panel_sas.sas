/*This program creates the SP4R library and connects it to the saved data sets.*/

/*Change this path to the appropriate location*/
%let path = G:\project\project1\sas\sas-prog-for-r-users\data;

/*
This course will use the library name sp4r.
Each data set name will begin with the library name followed by a period.
For example, to save a data set called 'dogs' in the SP4R library
we will use the name sp4r.dogs
*/
libname sp4r "&path";




/*
The following example uses the cost function data from Greene (1990) to estimate the variance components model. The variable OUTPUT is the log of output in millions of kilowatt-hours, and COST is the log of cost in millions of dollars. Refer to Greene (1990) for details.

https://www.sfu.ca/sasdoc/sashtml/ets/chap20/sect7.htm


*/

data sp4r.greene;
      input firm year output cost @@;
   cards;
        1 1955   5.36598   1.14867  1 1960   6.03787   1.45185
        1 1965   6.37673   1.52257  1 1970   6.93245   1.76627
        2 1955   6.54535   1.35041  2 1960   6.69827   1.71109
        2 1965   7.40245   2.09519  2 1970   7.82644   2.39480
        3 1955   8.07153   2.94628  3 1960   8.47679   3.25967
        3 1965   8.66923   3.47952  3 1970   9.13508   3.71795
        4 1955   8.64259   3.56187  4 1960   8.93748   3.93400
        4 1965   9.23073   4.11161  4 1970   9.52530   4.35523
        5 1955   8.69951   3.50116  5 1960   9.01457   3.68998
        5 1965   9.04594   3.76410  5 1970   9.21074   4.05573
        6 1955   9.37552   4.29114  6 1960   9.65188   4.59356
        6 1965  10.21163   4.93361  6 1970  10.34039   5.25520
   ;
run; 
   
proc sort data=sp4r.greene;
  by firm year;
run;


 /*
Usually you cannot explicitly specify all the explanatory variables that affect the dependent variable. The omitted or unobservable variables are summarized in the error disturbances. The TSCSREG procedure used with the Fuller-Battese method adds the individual and time-specific random effects to the error disturbances, and the parameters are efficiently estimated using the GLS method. The variance components model used by the Fuller-Battese method is

 The following statements fit this model. Since the Fuller-Battese is the default method, no options are required.



 */




proc tscsreg data=sp4r.greene;
  model cost = output;
  id firm year;
run;


/*
http://support.sas.com/documentation/cdl/en/etsug/63348/HTML/default/viewer.htm#etsug_panel_sect006.htm

Example 19.1 Analyzing Demand for Liquid Assets
In this example, the demand equations for liquid assets are estimated. The demand function for the demand deposits is estimated under three error structures while demand equations for time deposits and savings and loan (S&L) association shares are calculated using the Parks method. The data for seven states (CA, DC, FL, IL, NY, TX, and WA) are selected out of 49 states. See Feige (1964) for data description. All variables were transformed via natural logarithm. The data set A is shown below.

OUTEST=

*/




data a;
   length state $ 2;
   input state $ year d t s y rd rt rs;
   label d = 'Per Capita Demand Deposits'
        t = 'Per Capita Time Deposits'
        s = 'Per Capita S & L Association Shares'
        y = 'Permanent Per Capita Personal Income'
        rd = 'Service Charge on Demand Deposits'
        rt = 'Interest on Time Deposits'
        rs = 'Interest on S & L Association Shares';
datalines;
CA   1949  6.2785  6.1924  4.4998  7.2056 -1.0700  0.1080  1.0664
CA   1950  6.4019  6.2106  4.6821  7.2889 -1.0106  0.1501  1.0767
CA   1951  6.5058  6.2729  4.8598  7.3827 -1.0024  0.4008  1.1291
CA   1952  6.4785  6.2729  5.0039  7.4000 -0.9970  0.4492  1.1227
CA   1953  6.4118  6.2538  5.1761  7.4200 -0.8916  0.4662  1.2110
CA   1954  6.4520  6.2971  5.3613  7.4478 -0.6951  0.4756  1.1924
CA   1955  6.4998  6.3081  5.5452  7.4838 -0.7012  0.4929  1.2387
CA   1956  6.5162  6.2897  5.7236  7.5380 -0.6292  0.5636  1.2638
CA   1957  6.4646  6.3733  5.8579  7.5822 -0.4620  0.9712  1.3686
CA   1958  6.5191  6.4552  6.0331  7.6178 -0.4050  0.9712  1.3818
CA   1959  6.5709  6.4661  6.2025  7.6797 -0.4095  0.9738  1.3980
DC   1949  6.7499  5.4806  5.8230  7.3796 -1.3432 -0.3916  1.0307
DC   1950  6.9207  5.5413  5.9454  7.4804 -1.3205 -0.4125  1.0567
DC   1951  7.0775  5.6131  6.1420  7.6094 -1.3243 -0.3901  1.1006
DC   1952  6.9810  5.5452  6.2166  7.5606 -1.3205 -0.3161  1.0902
DC   1953  6.9117  5.5530  6.2971  7.5262 -1.2483 -0.1244  1.1102
DC   1954  6.9508  5.7203  6.4394  7.5326 -1.1777  0.4055  1.1259
DC   1955  6.9726  5.7961  6.5820  7.5658 -1.1457  0.4081  1.1559
DC   1956  6.9679  5.7991  6.6670  7.5761 -1.1332  0.4688  1.1787
DC   1957  7.0211  5.9687  6.8002  7.6425 -1.0613  0.8024  1.2143
DC   1958  7.0867  6.0799  6.9197  7.6704 -1.0217  0.7419  1.2404
DC   1959  7.0630  6.0014  7.0291  7.6811 -0.8723  0.8510  1.3156
FL   1949  6.0113  4.8363  4.6347  6.9315 -1.0385 -0.0954  0.8390
FL   1950  6.0707  4.8283  4.7274  6.9147 -1.0729 -0.0440  0.8446
FL   1951  6.1506  4.8903  4.9345  6.9735 -1.0936  0.0020  0.8871
FL   1952  6.1527  4.8828  5.1180  6.9735 -1.1147  0.0507  0.9466
FL   1953  6.1399  4.9273  5.2983  7.0370 -1.0385  0.1115  0.9651
FL   1954  6.1420  4.9416  5.5094  7.0361 -0.9835  0.2374  1.0547
FL   1955  6.3008  5.0814  5.8111  7.1747 -0.9729  0.2919  1.0585
FL   1956  6.3404  5.1120  5.9480  7.1997 -0.9188  0.3961  1.1092
FL   1957  6.2748  5.3660  6.0355  7.2320 -0.8052  0.8838  1.2054
FL   1958  6.2785  5.4806  6.1026  7.2506 -0.6972  0.8973  1.2099
FL   1959  6.2577  5.4596  6.2344  7.2841 -0.6482  0.9119  1.2740
IL   1949  6.7370  5.8749  4.7536  7.2896 -1.9449 -0.1602  0.9179
IL   1950  6.7569  5.8348  4.8363  7.2917 -1.9241 -0.1661  0.8953
IL   1951  6.7878  5.8141  4.9698  7.3492 -1.9173 -0.0661  0.8957
IL   1952  6.8178  5.9402  5.1648  7.4073 -1.9379  0.0573  0.9431
IL   1953  6.8123  5.9814  5.3423  7.4448 -1.8971  0.0871  0.9944
IL   1954  6.8330  6.0259  5.5334  7.4816 -1.8079  0.1222  1.0109
IL   1955  6.8448  6.0259  5.6904  7.5038 -1.7603  0.1319  1.0217
IL   1956  6.8501  6.0568  5.8579  7.5575 -1.6983  0.3031  1.0757
IL   1957  6.8013  6.0913  5.9713  7.5909 -1.5945  0.4874  1.1490
IL   1958  6.8233  6.1399  6.0958  7.6014 -1.5418  0.5522  1.2244
IL   1959  6.7731  6.1633  6.1924  7.6183 -1.4653  0.7198  1.2519
NY   1949  7.2226  5.6021  4.2047  7.3079 -2.1893 -0.3754  0.7415
NY   1950  7.2478  5.5645  4.2627  7.3232 -2.1286 -0.3230  0.7333
NY   1951  7.2506  5.5334  4.4427  7.3563 -2.1286 -0.2294  0.7966
NY   1952  7.2591  5.6058  4.6250  7.4140 -2.1203  0.0488  0.8899
NY   1953  7.2406  5.6904  4.7707  7.4639 -2.0099  0.2159  0.9070
NY   1954  7.2549  5.7621  4.9053  7.4967 -1.9310  0.2971  0.9322
NY   1955  7.2661  5.7462  5.0039  7.5000 -1.9241  0.3407  0.9764
NY   1956  7.2556  5.8260  5.1240  7.5580 -1.7838  0.5619  1.0203
NY   1957  7.2745  5.9915  5.2417  7.6372 -1.6660  0.8024  1.0842
NY   1958  7.2814  6.1137  5.3279  7.6592 -1.6503  0.8587  1.1227
NY   1959  7.2563  6.1181  5.4072  7.6948 -1.5945  0.9247  1.1703
TX   1949  6.3509  4.2341  3.5835  6.9027 -1.9038 -0.1755  1.0134
TX   1950  6.4520  4.2627  3.7377  6.9584 -1.9173 -0.1791  1.0080
TX   1951  6.5206  4.3438  3.8918  7.0510 -1.9105 -0.2083  1.0364
TX   1952  6.5043  4.4308  4.0604  7.0699 -1.9173  0.0677  1.0578
TX   1953  6.5013  4.5951  4.2905  7.1131 -1.8326  0.1570  1.1256
TX   1954  6.5624  4.7622  4.5218  7.1585 -1.7037  0.2837  1.1291
TX   1955  6.5820  4.8442  4.7095  7.1967 -1.6555  0.3133  1.1220
TX   1956  6.5624  4.8828  4.8203  7.2138 -1.5702  0.4344  1.1210
TX   1957  6.5147  5.0689  4.9698  7.2556 -1.3863  0.7519  1.2490
TX   1958  6.5737  5.3033  5.1059  7.2841 -1.2801  0.8069  1.2276
TX   1959  6.5554  5.3519  5.2781  7.3265 -1.1940  0.8899  1.3005
WA   1949  6.0355  5.3033  4.4998  7.0440 -1.0272 -0.0651  0.7266
WA   1950  6.2166  5.3753  4.6913  7.1884 -1.0189 -0.0274  0.8016
WA   1951  6.2634  5.3936  4.8520  7.2675 -1.0079  0.0383  0.8616
WA   1952  6.2519  5.4381  4.9698  7.3005 -0.9650  0.2662  0.9373
WA   1953  6.2146  5.4596  5.1591  7.3337 -0.8819  0.2942  1.0466
WA   1954  6.2860  5.5094  5.3613  7.3790 -0.7319  0.2986  1.0526
WA   1955  6.3008  5.5835  5.5053  7.4079 -0.6368  0.5710  1.0671
WA   1956  6.2634  5.5910  5.5722  7.4122 -0.5327  0.5761  1.1023
WA   1957  6.2025  5.6595  5.6525  7.4448 -0.3842  0.8385  1.1793
WA   1958  6.2558  5.7333  5.7621  7.4697 -0.3341  0.8338  1.1957
WA   1959  6.2442  5.7557  5.8435  7.5005 -0.3147  0.9143  1.2548
;

proc sort data=a;
   by state year;
run;

proc panel data=a  OUTEST= estimated_asset;

model t = y rd rt rs / fixone;
id  state year;
run;


/*

http://pages.stern.nyu.edu/~wgreene/Text/Edition7/tablelist8new.htm



http://support.sas.com/documentation/cdl/en/etsug/66100/HTML/default/viewer.htm#etsug_panel_example02.htm
The data and preliminary SAS statements are:


The following statements fit the model.


   input  Obs I T C Q PF LF;

   label obs = "Observation number";


*/




data airline;
   input  I T C Q PF LF;

   label I  = "Firm Number (CSID)";
   label T  = "Time period (TSID)";
   label Q  = "Output in revenue passenger miles (index)";
   label C  = "Total cost, in thousands";
   label PF = "Fuel price";
   label LF = "Load Factor (utilization index)";
datalines;
  1    1     1140640       .952757    106650       .534487
  1    2     1215690       .986757    110307       .532328
  1    3     1309570      1.091980    110574       .547736
  1    4     1511530      1.175780    121974       .540846
  1    5     1676730      1.160170    196606       .591167
  1    6     1823740      1.173760    265609       .575417
  1    7     2022890      1.290510    263451       .594495
  1    8     2314760      1.390670    316411       .597409
  1    9     2639160      1.612730    384110       .638522
  1   10     3247620      1.825440    569251       .676287
  1   11     3787750      1.546040    871636       .605735
  1   12     3867750      1.527900    997239       .614360
  1   13     3996020      1.660200    938002       .633366
  1   14     4282880      1.822310    859572       .650117
  1   15     4748320      1.936460    823411       .625603
  2    1      569292       .520635    103795       .490851
  2    2      640614       .534627    111477       .473449
  2    3      777655       .655192    118664       .503013
  2    4      999294       .791575    114797       .512501
  2    5     1203970       .842945    215322       .566782
  2    6     1358100       .852892    281704       .558133
  2    7     1501350       .922843    304818       .558799
  2    8     1709270      1.000000    348609       .572070
  2    9     2025400      1.198450    374579       .624763
  2   10     2548370      1.340670    544109       .628706
  2   11     3137740      1.326240    853356       .589150
  2   12     3557700      1.248520   1003200       .532612
  2   13     3717740      1.254320    941977       .526652
  2   14     3962370      1.371770    856533       .540163
  2   15     4209390      1.389740    821361       .528775
  3    1      286298       .262424    118788       .524334
  3    2      309290       .266433    123798       .537185
  3    3      342056       .306043    122882       .582119
  3    4      374595       .325586    131274       .579489
  3    5      450037       .345706    222037       .606592
  3    6      510412       .367517    278721       .607270
  3    7      575347       .409937    306564       .582425
  3    8      669331       .448023    356073       .573972
  3    9      783799       .539595    378311       .654256
  3   10      913883       .539382    555267       .631055
  3   11     1041520       .467967    850322       .569240
  3   12     1125800       .450544   1015610       .589682
  3   13     1096070       .468793    954508       .587953
  3   14     1198930       .494397    886999       .565388
  3   15     1170470       .493317    844079       .577078
  4    1      145167       .086393    114987       .432066
  4    2      170192       .096740    120501       .439669
  4    3      247506       .141500    121908       .488932
  4    4      309391       .169715    127220       .484181
  4    5      354338       .173805    209405       .529925
  4    6      373941       .164272    263148       .532723
  4    7      420915       .170906    316724       .549067
  4    8      474017       .177840    363598       .557140
  4    9      532590       .192248    389436       .611377
  4   10      676771       .242469    547376       .645319
  4   11      880438       .256505    850418       .611734
  4   12     1052020       .249657   1011170       .580884
  4   13     1193680       .273923    951934       .572047
  4   14     1303390       .371131    881323       .594570
  4   15     1436970       .421411    831374       .585525
  5    1       91361       .051028    118222       .442875
  5    2       95428       .052646    116223       .462473
  5    3       98187       .056348    115853       .519118
  5    4      115967       .066953    129372       .529331
  5    5      138382       .070308    243266       .557797
  5    6      156228       .073961    277930       .556181
  5    7      183169       .084946    317273       .569327
  5    8      210212       .095474    358794       .583465
  5    9      274024       .119814    397667       .631818
  5   10      356915       .150046    566672       .604723
  5   11      432344       .144014    848393       .587921
  5   12      524294       .169300   1005740       .616159
  5   13      530924       .172761    958231       .605868
  5   14      581447       .186670    872924       .594688
  5   15      610257       .213279    844622       .635545
  6    1       68978       .037682    117112       .448539
  6    2       74904       .039784    119420       .475889
  6    3       83829       .044331    116087       .500562
  6    4       98148       .050245    122997       .500344
  6    5      118449       .055046    194309       .528897
  6    6      133161       .052462    307923       .495361
  6    7      145062       .056977    323595       .510342
  6    8      170711       .061490    363081       .518296
  6    9      199775       .069027    386422       .546723
  6   10      276797       .092749    564867       .554276
  6   11      381478       .112640    874818       .517766
  6   12      506969       .154154   1013170       .580049
  6   13      633388       .186461    930477       .556024
  6   14      804388       .246847    851676       .537791
  6   15     1009500       .304013    819476       .525775
;
run;

data airline;
   set airline;
   lC = log(C);
   lQ = log(Q);
   lPF = log(PF);
   label lC = "Log transformation of costs";
   label lQ = "Log transformation of quantity";
   label lPF= "Log transformation of price of fuel";
run;


proc panel data=airline printfixed OUTEST= estimated_airline;
   id i t;
   model lC = lQ lPF LF / fixtwo;
run;



/*
Example 20.4 The Airline Cost Data: Random-Effects Models
This example continues to use the Christenson Associates airline data, which measures costs, prices of inputs, and utilization rates for six airlines over the time span 1970–1984. There are six cross sections and fifteen time observations. Here, you examine the different estimates generated from the one-way random-effects and two-way random-effects models, by using four different methods to estimate the variance components: Fuller and Battese, Wansbeek and Kapteyn, Wallace and Hussain, and Nerlove.

The data for this example is created by the PROC PANEL statements shown in Example 20.2. The PROC PANEL statements necessary to generate the estimates are as follows:

*/

proc panel data=airline printfixed outest=estimates;
   id I T;
   RANONE:   model lC = lQ lPF lF / ranone vcomp=fb;
   RANONEwk: model lC = lQ lPF lF / ranone vcomp=wk;
   RANONEwh: model lC = lQ lPF lF / ranone vcomp=wh;
   RANONEnl: model lC = lQ lPF lF / ranone vcomp=nl;
   RANTWO:   model lC = lQ lPF lF / rantwo vcomp=fb;
   RANTWOwk: model lC = lQ lPF lF / rantwo vcomp=wk;
   RANTWOwh: model lC = lQ lPF lF / rantwo vcomp=wh;
   RANTWOnl: model lC = lQ lPF lF / rantwo vcomp=nl;
   POOLED:   model lC = lQ lPF lF / pooled;
   BTWNG:    model lC = lQ lPF lF / btwng;
   BTWNT:    model lC = lQ lPF lF / btwnt;
   FIXONE:   model lC = lQ lPF lF / fixone;
   FIXTWO:   model lC = lQ lPF lF / fixtwo;
run;
data table;
  set estimates;
   VarCS  = round(_VARCS_,.00001);
   VarTS  = round(_VARTS_,.00001);
   VarErr = round(_VARERR_,.00001);
   Int    = round(Intercept,.0001);
   lQ2    = round(lQ,.0001);
   lPF2   = round(lPF,.0001);
   lF2    = round(lF,.0001);
   if _n_ >= 9 then do;
     VarCS = . ;
     VarTS = . ;
   end;
   keep _MODEL_ _METHOD_ VarCS VarTS VarErr Int lQ2 lPF2 lF2;
run;


/*

https://www.aeaweb.org/about-aea/committees/economic-education/econometrics-training-modules/three

*/


proc import out = bachelors

  datafile = 'bachelors.csv'

  dbms = csv replace;

  getnames = yes;

run;



data bachelors2;
      set bachelors;
    if year = 1991 then delete;
    if year = 1992 then delete;
    run;

PROC MEANS DATA=bachelors2;
RUN;


proc contents data=bachelors2;
run;














/*
https://www3.nd.edu/~rwilliam/Taiwan2018/index.html
https://www3.nd.edu/~rwilliam/statafiles/
https://www3.nd.edu/~rwilliam/stats3/panel04-fixedvsrandom.pdf

Here is an example from Allison’s 2009 book Fixed Effects Regression Models. Data are from the National Longitudinal Study of Youth (NLSY). The data set has 1151 teenage girls who were interviewed annually for 5 years beginning in 1979. Here is a listing of the values for the first three cases:

*/


proc import out = teenpov

  datafile = 'teenpovxt.dta'

  dbms = dta replace;

run;



PROC MEANS DATA=teenpov;
RUN;


proc contents data=teenpov;
run;




/*

https://archive.ics.uci.edu/ml/datasets.html?area=&att=&format=&numAtt=&numIns=&sort=nameUp&task=&type=text&view=table
specify your dummy variable with all the levels as a factor (use as.factor) and then entered it into plm as factor(mydummy)

https://vincentarelbundock.github.io/Rdatasets/datasets.html

R dataset plm

baseball

http://support.sas.com/documentation/cdl/en/sqlproc/63043/HTML/default/viewer.htm#n0tf6s2l1rfv5ln1o04ojc4rotu1.htm

*/


proc import out = baseball

  datafile = 'baseball.csv'

  dbms = csv replace;

run;

data baseball2;
      set baseball;
      if ab = 0 then delete;
      ba = h/ab;
run;

PROC MEANS DATA=bachelors2;
RUN;

PROC MEANS DATA=baseball2;
RUN;


proc contents data=baseball2;
run;

proc sort data=baseball2;
  by id year team;
run;

* proc sql ;
* create table work.baseball3 as 
* select 
* a.id,
* a.year,
* mean(a.ba) as ba,
* first_value(a.lg) over (partition by id, year order by id, year) as lg,
* sum(a.g) as g             
* from work.baseball2 a
* group by a.id , a.year
* order by a.id , a.year
* ;
* quit; run;


proc sql ;
create table work.baseball3 as 
WITH cte AS
(
   SELECT *,
         ROW_NUMBER() OVER (PARTITION BY id, year order by id, year) AS rn
   FROM work.baseball2
)
SELECT *
FROM cte
WHERE rn = 1
;
quit; run;


proc panel data=baseball2 printfixed OUTEST= estimated_baseball;
   id id year;
   class lg;
   RANONE:   model ba = lg g r hr cs so / ranone vcomp=fb;
 run;




proc panel data=baseball printfixed OUTEST= estimated_baseball;
   id id year;
   class team lg;
   RANONE:   model ba = g r hr cs so hbp / ranone vcomp=fb;
   RANONEwk: model ba = g r hr cs so hbp / ranone vcomp=wk;
   RANONEwh: model ba = g r hr cs so hbp / ranone vcomp=wh;
   RANONEnl: model ba = g r hr cs so hbp / ranone vcomp=nl;
   RANTWO:   model ba = g r hr cs so hbp / rantwo vcomp=fb;
   RANTWOwk: model ba = g r hr cs so hbp / rantwo vcomp=wk;
   RANTWOwh: model ba = g r hr cs so hbp / rantwo vcomp=wh;
   RANTWOnl: model ba = g r hr cs so hbp / rantwo vcomp=nl;
   POOLED:   model ba = g r hr cs so hbp / pooled;
   BTWNG:    model ba = g r hr cs so hbp / btwng;
   BTWNT:    model ba = g r hr cs so hbp / btwnt;
   FIXONE:   model ba = g r hr cs so hbp / fixone;
   FIXTWO:   model ba = g r hr cs so hbp / fixtwo;
run;


/*
Usage Note 41616: Sample of LIBNAME statement and SQL Pass-Through code to connect to Oracle database using SAS/ACCESS® Interface to Oracle
*/

libname oralib oracle user=scott password=tiger path='DESKTOP-5A8MM7P:1521';


proc sql;
connect to oracle(user=scott password=tiger path='DESKTOP-5A8MM7P:1521');
create table work.baseball5 as
select * from connection to oracle
(select * from baseball2);
quit;
/*--------------------------------------------------*/
/* SAS Programming for R Users - code for exercises */
/* Copyright 2016 SAS Institute Inc.                */
/*--------------------------------------------------*/



/*This program creates the SP4R library and connects it to the saved data sets.*/

/*Change this path to the appropriate location*/
%let path = G:\project\project1\sas\sas-prog-for-r-users;

/*
This course will use the library name sp4r.
Each data set name will begin with the library name followed by a period.
For example, to save a data set called 'dogs' in the SP4R library
we will use the name sp4r.dogs
*/
libname sp4r "&path";


/*SP4R02d01*/

/*Part A*/
data sp4r.example_data;
   length First_Name $ 25 Last_Name $ 25;
   input First_Name $ Last_Name $ age height;
   datalines;
   Jordan Bakerman 27 68
   Bruce Wayne 35 70
   Walter White 51 70
   Henry Hill 65 66
   JeanClaude VanDamme 55 69
;
run;

/*Part B*/
data sp4r.example_data2;
   length First_Name $ 25 Last_Name $ 25;
   input First_Name $ Last_Name $ age height @@;
   datalines;
   Jordan Bakerman 27 68 Bruce Wayne 35 70 Walter White 51 70
   Henry Hill 65 66 JeanClaude VanDamme 55 69
   ;
run;

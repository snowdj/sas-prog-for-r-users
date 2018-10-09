PROC EXPORT DATA= WORK.Estimated_asset 
            OUTFILE= "G:\project\project1\sas\sas-prog-for-r-users\sas\e
st_asset.xls" 
            DBMS=EXCEL REPLACE;
     SHEET="est_assets"; 
RUN;

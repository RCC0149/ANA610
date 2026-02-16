libname Data_610 '/home/u64094997/my_courses/ANA 610/Data_610/Homework 1';

/*-----------------------------------------------------------------------------------------*/

*Importing donor_profile2 data into SAS;

proc import datafile='/home/u64094997/my_courses/ANA 610/Data_610/Homework 1/donor_profile2.csv' out=Data_610.donor_profile2 replace;
run;

*Reassigning donor_profile2 data;

data donor_profile2; 
	set Data_610.donor_profile2;
run;

*Overview of donor_profile2.csv contents;

ods select Variables;			
proc contents data=donor_profile2; run;
ods select default;

*First 25 observations of donor_profile2.csv;

proc print data=donor_profile2 (firstobs = 1 obs = 25); 
run; 

*Checking the numeric DONOR_AGE variable data;

proc means data=donor_profile2 n nmiss min mean max maxdec=2; 
	var DONOR_AGE; 
run; 

proc univariate data=donor_profile2 noprint;
	histogram DONOR_AGE;
run;

proc sql noprint; select count(distinct DONOR_AGE) into: count from donor_profile2; quit; 
proc sql noprint; select count(*) into: obs from donor_profile2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the character categorical URBANICITY variable data;

proc freq data=donor_profile2; 
	tables URBANICITY / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct URBANICITY) into: count from donor_profile2; quit; 
proc sql noprint; select count(*) into: obs from donor_profile2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run; 

*Checking the character categorical SES variable data;

proc freq data=donor_profile2; 
	tables SES / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct SES) into: count from donor_profile2; quit; 
proc sql noprint; select count(*) into: obs from donor_profile2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric categorical CLUSTER_CODE variable data;

proc freq data=donor_profile2; 
	tables CLUSTER_CODE / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct CLUSTER_CODE) into: count from donor_profile2; quit; 
proc sql noprint; select count(*) into: obs from donor_profile2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the character categorical HOME_OWNER variable data;
 
proc freq data=donor_profile2; 
	tables HOME_OWNER / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct HOME_OWNER) into: count from donor_profile2; quit; 
proc sql noprint; select count(*) into: obs from donor_profile2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run; 

*Checking the character categorical DONOR_GENDER variable data;

proc freq data=donor_profile2; 
	tables DONOR_GENDER / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct DONOR_GENDER) into: count from donor_profile2; quit; 
proc sql noprint; select count(*) into: obs from donor_profile2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run; 

*Checking the numeric categorical INCOME_GROUP variable data;

proc freq data=donor_profile2; 
	tables INCOME_GROUP / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct INCOME_GROUP) into: count from donor_profile2; quit; 
proc sql noprint; select count(*) into: obs from donor_profile2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run; 

*Checking the numeric categorical RECENT_STAR_STATUS variable data;

proc freq data=donor_profile2; 
	tables RECENT_STAR_STATUS / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct RECENT_STAR_STATUS) into: count from donor_profile2; quit; 
proc sql noprint; select count(*) into: obs from donor_profile2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run; 

*Checking the numeric ID CONTROL_NUMBER variable data;

data length;
	set Data_610.donor_profile2; 
	len_Control_Number = length(CONTROL_NUMBER); 
run; 

proc means data=length n nmiss min mean median max maxdec=2; 
	var len_Control_Number;
run; 

proc univariate data=length noprint; 
	histogram len_Control_Number; 
run; 

proc sql noprint; select count(distinct CONTROL_NUMBER) into: count from donor_profile2; quit; 
proc sql noprint; select count(*) into: obs from donor_profile2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run; 

/*-----------------------------------------------------------------------------------------*/

*Importing donor_history2 data into SAS;

proc import datafile='/home/u64094997/my_courses/ANA 610/Data_610/Homework 1/donor_history2.csv' out=Data_610.donor_history2 replace;
run;

*Reassigning donor_history2 data;

data donor_history2; 
	set Data_610.donor_history2;
run;

*Overview of donor_history2.csv contents;

ods select Variables;			
proc contents data=donor_history2; run;
ods select default;

*First 25 observations of donor_history2.csv;

proc print data=donor_history2 (firstobs = 1 obs = 25); 
run; 

*Checking the numeric MONTHS_SINCE_ORIGIN variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var MONTHS_SINCE_ORIGIN; 
run; 

proc univariate data=donor_history2 noprint;
	histogram MONTHS_SINCE_ORIGIN;
run;

proc sql noprint; select count(distinct MONTHS_SINCE_ORIGIN) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric FREQUENCY_STATUS_97NK variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var FREQUENCY_STATUS_97NK; 
run;

proc freq data=donor_history2; 
	tables FREQUENCY_STATUS_97NK / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct FREQUENCY_STATUS_97NK) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run; 

*Checking the numeric RECENT_AVG_GIFT_AMT variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var RECENT_AVG_GIFT_AMT; 
run; 

proc univariate data=donor_history2 noprint;
	histogram RECENT_AVG_GIFT_AMT;
run;

proc sql noprint; select count(distinct RECENT_AVG_GIFT_AMT) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric RECENT_RESPONSE_COUNT variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var RECENT_RESPONSE_COUNT; 
run; 

proc freq data=donor_history2; 
	tables RECENT_RESPONSE_COUNT / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct RECENT_RESPONSE_COUNT) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric RECENT_CARD_RESPONSE_COUNT variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var RECENT_CARD_RESPONSE_COUNT; 
run; 

proc freq data=donor_history2; 
	tables RECENT_CARD_RESPONSE_COUNT / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct RECENT_CARD_RESPONSE_COUNT) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric MONTHS_SINCE_LAST_PROM_RESP variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var MONTHS_SINCE_LAST_PROM_RESP; 
run; 

proc univariate data=donor_history2 noprint;
	histogram MONTHS_SINCE_LAST_PROM_RESP;
run;

proc sql noprint; select count(distinct MONTHS_SINCE_LAST_PROM_RESP) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric LIFETIME_CARD_PROM variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var LIFETIME_CARD_PROM; 
run; 

proc univariate data=donor_history2 noprint;
	histogram LIFETIME_CARD_PROM;
run;

proc sql noprint; select count(distinct LIFETIME_CARD_PROM) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric LIFETIME_PROM variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var LIFETIME_PROM; 
run; 

proc univariate data=donor_history2 noprint;
	histogram LIFETIME_PROM;
run;

proc sql noprint; select count(distinct LIFETIME_PROM) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric LIFETIME_GIFT_AMOUNT variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var LIFETIME_GIFT_AMOUNT; 
run; 

proc univariate data=donor_history2 noprint;
	histogram LIFETIME_GIFT_AMOUNT;
run;

proc sql noprint; select count(distinct LIFETIME_GIFT_AMOUNT) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric LIFETIME_GIFT_COUNT variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var LIFETIME_GIFT_COUNT; 
run; 

proc univariate data=donor_history2 noprint;
	histogram LIFETIME_GIFT_COUNT;
run;

proc sql noprint; select count(distinct LIFETIME_GIFT_COUNT) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric LIFETIME_AVG_GIFT_AMT variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var LIFETIME_AVG_GIFT_AMT; 
run; 

proc univariate data=donor_history2 noprint;
	histogram LIFETIME_AVG_GIFT_AMT;
run;

proc sql noprint; select count(distinct LIFETIME_AVG_GIFT_AMT) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric LIFETIME_GIFT_RANGE variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var LIFETIME_GIFT_RANGE; 
run; 

proc univariate data=donor_history2 noprint;
	histogram LIFETIME_GIFT_RANGE;
run;

proc sql noprint; select count(distinct LIFETIME_GIFT_RANGE) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric LAST_GIFT_AMT variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var LAST_GIFT_AMT; 
run; 

proc univariate data=donor_history2 noprint;
	histogram LAST_GIFT_AMT;
run;

proc sql noprint; select count(distinct LAST_GIFT_AMT) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric MONTHS_SINCE_LAST_GIFT variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var MONTHS_SINCE_LAST_GIFT; 
run; 

proc univariate data=donor_history2 noprint;
	histogram MONTHS_SINCE_LAST_GIFT;
run;

proc sql noprint; select count(distinct MONTHS_SINCE_LAST_GIFT) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric MONTHS_SINCE_FIRST_GIFT variable data;

proc means data=donor_history2 n nmiss min mean max maxdec=2; 
	var MONTHS_SINCE_FIRST_GIFT; 
run; 

proc univariate data=donor_history2 noprint;
	histogram MONTHS_SINCE_FIRST_GIFT;
run;

proc sql noprint; select count(distinct MONTHS_SINCE_FIRST_GIFT) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the binary categorical TARGET_B variable data;

proc freq data=donor_history2; 
	tables TARGET_B / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct TARGET_B) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run; 

*Checking the binary categorical IN_HOUSE variable data;

proc freq data=donor_history2; 
	tables IN_HOUSE / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct IN_HOUSE) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the binary categorical PEP_STAR variable data; 
 
proc freq data=donor_history2; 
	tables PEP_STAR / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct PEP_STAR) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run; 

*Checking the character categorical RECENCY_STATUS_96NK variable data;

proc freq data=donor_history2; 
	tables RECENCY_STATUS_96NK / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct RECENCY_STATUS_96NK) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric ID CONTROL_NUMBER variable data;

data length;
	set Data_610.donor_history2; 
	len_Control_Number = length(CONTROL_NUMBER); 
run; 

proc means data=length n nmiss min mean median max maxdec=2; 
	var len_Control_Number;
run; 
 
proc univariate data=length noprint; 
	histogram len_Control_Number; 
run; 

proc sql noprint; select count(distinct CONTROL_NUMBER) into: count from donor_history2; quit; 
proc sql noprint; select count(*) into: obs from donor_history2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run; 

/*-----------------------------------------------------------------------------------------*/

*Reassigning donor_census2 data;

data donor_census2; 
	set Data_610.donor_census2; 
run;

*Overview of donor_census2.sas7bdat contents;

ods select Variables;			
proc contents data=donor_census2; run;
ods select default;

*First 25 observations of donor_census2.sas7bdat;

proc print data=donor_census2 (firstobs = 1 obs = 25); 
run; 

*Checking the numeric MEDIAN_HOME_VALUE variable data;

proc means data=donor_census2 n nmiss min mean max maxdec=2; 
	var MEDIAN_HOME_VALUE; 
run; 

proc univariate data=donor_census2 noprint;
	histogram MEDIAN_HOME_VALUE;
run;

proc sql noprint; select count(distinct MEDIAN_HOME_VALUE) into: count from donor_census2; quit; 
proc sql noprint; select count(*) into: obs from donor_census2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric MEDIAN_HOUSEHOLD_INCOME variable data;

proc means data=donor_census2 n nmiss min mean max maxdec=2; 
	var MEDIAN_HOUSEHOLD_INCOME; 
run;

proc univariate data=donor_census2 noprint;
	histogram MEDIAN_HOUSEHOLD_INCOME;
run;

proc sql noprint; select count(distinct MEDIAN_HOUSEHOLD_INCOME) into: count from donor_census2; quit; 
proc sql noprint; select count(*) into: obs from donor_census2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric PCT_OWNER_OCCUPIED variable data;

proc means data=donor_census2 n nmiss min mean max maxdec=2; 
	var PCT_OWNER_OCCUPIED; 
run; 

proc univariate data=donor_census2 noprint;
	histogram PCT_OWNER_OCCUPIED;
run;

proc sql noprint; select count(distinct PCT_OWNER_OCCUPIED) into: count from donor_census2; quit; 
proc sql noprint; select count(*) into: obs from donor_census2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric PCT_VIETNAM_VETERANS variable data;

proc means data=donor_census2 n nmiss min mean max maxdec=2; 
	var PCT_VIETNAM_VETERANS; 
run; 

proc univariate data=donor_census2 noprint;
	histogram PCT_VIETNAM_VETERANS;
run;

proc sql noprint; select count(distinct PCT_VIETNAM_VETERANS) into: count from donor_census2; quit; 
proc sql noprint; select count(*) into: obs from donor_census2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric PER_CAPITA_INCOME variable data;

proc means data=donor_census2 n nmiss min mean max maxdec=2; 
	var PER_CAPITA_INCOME; 
run; 

proc univariate data=donor_census2 noprint;
	histogram PER_CAPITA_INCOME;
run;

proc sql noprint; select count(distinct PER_CAPITA_INCOME) into: count from donor_census2; quit; 
proc sql noprint; select count(*) into: obs from donor_census2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric categorical WEALTH_RATING variable data;

proc freq data=donor_census2; 
	tables WEALTH_RATING / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct WEALTH_RATING) into: count from donor_census2; quit; 
proc sql noprint; select count(*) into: obs from donor_census2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run; 

*Checking the numeric ID CONTROL_NUMBER variable data;

data length;
	set Data_610.donor_census2; 
	len_Control_Number = length(CONTROL_NUMBER); 
run; 

proc means data=length n nmiss min mean median max maxdec=2; 
	var len_Control_Number;
run; 

proc univariate data=length noprint; 
	histogram len_Control_Number; 
run; 

proc sql noprint; select count(distinct CONTROL_NUMBER) into: count from donor_census2; quit; 
proc sql noprint; select count(*) into: obs from donor_census2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

/*-----------------------------------------------------------------------------------------*/

*Importing donor_survey2 data into SAS;

proc import datafile='/home/u64094997/my_courses/ANA 610/Data_610/Homework 1/donor_survey2.csv' out=Data_610.donor_survey2 replace;
run;

*Reassigning donor_survey2 data;

data donor_survey2; 
	set Data_610.donor_survey2;
run;

*Overview of donor_survey2.csv contents;

ods select Variables;			
proc contents data=donor_survey2; run;
ods select default;

*First 25 observations of donor_survey2.csv;

proc print data=donor_survey2 (firstobs = 1 obs = 25); 
run; 

*Checking the numeric survey_value variable data;

proc means data=donor_survey2 n nmiss min mean max maxdec=2; 
	var survey_value; 
run; 

proc freq data=donor_survey2; 
	tables survey_value / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct survey_value) into: count from donor_survey2; quit; 
proc sql noprint; select count(*) into: obs from donor_survey2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the categorical character survey_question variable data;

proc sql;
    select distinct survey_question
    from donor_survey2;
quit;

proc freq data=donor_survey2; 
	tables survey_question / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct survey_question) into: count from donor_survey2; quit; 
proc sql noprint; select count(*) into: obs from donor_survey2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

*Checking the numeric ID CONTROL_NUMBER variable data;

data length;
	set Data_610.donor_survey2; 
	len_Control_Number = length(CONTROL_NUMBER); 
run; 

proc means data=length n nmiss min mean median max maxdec=2; 
	var len_Control_Number;
run; 
 
proc univariate data=length noprint; 
	histogram len_Control_Number; 
run; 

proc sql noprint; select count(distinct CONTROL_NUMBER) into: count from donor_survey2; quit; 
proc sql noprint; select count(*) into: obs from donor_survey2; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

proc print data=print noobs; run;

/*-----------------------------------------------------------------------------------------*/

*Merging of Donor data files;

	**Load in necessary Donor data files for merger;

data profile; set Data_610.donor_profile2; run;
data history; set Data_610.donor_history2; run;

	**Convert Character CONTROL_NUMBER ID variable to Numeric in Donor Census file;

data census;
    set Data_610.donor_census2;
    conversion = input(CONTROL_NUMBER, comma9.);
    drop CONTROL_NUMBER;
    rename conversion = CONTROL_NUMBER;
run;

    	***Save converted Donor Census file;

data Data_610.donor_censusC; 
	set census; 	
run;

	**Transpose Donor Survey file to allow Survey Questions to be represented in the merged data set;

proc sort data=Data_610.donor_survey2; by CONTROL_NUMBER; run;

proc transpose data=Data_610.donor_survey2 OUT=survey;
    BY CONTROL_NUMBER;
    ID survey_question;
    VAR survey_value;
run;

		***Save transposed Donor Survey file;

data Data_610.donor_surveyT; 
	set survey; 	
run;

	**Sort Donor file data by the numeric CONTROL_NUMBER ID for merging;

proc sort data=profile; by CONTROL_NUMBER; run;
proc sort data=history; by CONTROL_NUMBER; run;
proc sort data=census; by CONTROL_NUMBER; run;
proc sort data=survey; by CONTROL_NUMBER; run;

	**Merge Donor data files;

data donor_master; merge profile history census survey; by CONTROL_NUMBER; 
run;

		***Save merged data file;

data Data_610.donor_master; 
	set donor_master; 	
run;

*Overview of donor_master contents;

proc contents data=donor_master; run;

*Estimated potential modeling sample size of donor_master;

data donor_master_trim;
    set donor_master;
    if cmiss(of _all_) then delete;
run;

	**Note: Obtained by visually assessing the number of records in a temporary file in OUTPUT DATA that was the
	result of removing records with missing data from the merged file;
	
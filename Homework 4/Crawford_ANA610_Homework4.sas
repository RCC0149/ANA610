libname Data_610 '/home/u64094997/my_courses/ANA 610/Data_610/Homework 4';

/*-----------------------------------------------------------------------------------------*/

*Task #1: 	Generate a data audit report (using the audit report template) to be shared with both 
the HR and IT department, include a check of the available modeling sample size. Use SAS to generate 
the tables for the audit report and to assemble all 5 datafiles into a single, modeling datafile 
which retains all available rows of data (i.e., do NOT subset based on the qualified sample).  

*Importing fortune_credit data into SAS;

proc import datafile='/home/u64094997/my_courses/ANA 610/Data_610/Homework 4/fortune_credit.csv' out=Data_610.fortune_credit replace;
run;

*Reassigning fortune_credit data;

data fortune_credit; 
	set Data_610.fortune_credit;
run;

*Overview of fortune_credit.csv contents;

ods select Variables;			
proc contents data=fortune_credit; run;
ods select default;

*First 25 observations of fortune_credit.csv;

proc print data=fortune_credit (firstobs = 1 obs = 25); 
run; 

*Checking the numeric fico_scr variable data;

proc means data=fortune_credit n nmiss min mean max maxdec=2; 
	var fico_scr; 
run; 

proc univariate data=fortune_credit noprint;
	histogram fico_scr;
run;

proc sql noprint; select count(distinct fico_scr) into: count from fortune_credit; quit; 
proc sql noprint; select count(*) into: obs from fortune_credit; quit; 
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

*Checking the numeric categorical ssn variable data;

data length;
	set Data_610.fortune_credit; 
	len_ssn = length(ssn); 
run; 

proc means data=length n nmiss min mean median max maxdec=2; 
	var len_ssn;
run; 

proc univariate data=length noprint; 
	histogram len_ssn; 
run; 

proc sql noprint; select count(distinct ssn) into: count from fortune_credit; quit; 
proc sql noprint; select count(*) into: obs from fortune_credit; quit; 
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

*Reassigning fortune_acct data;

*options sasautos=('/home/u64094997/my_shared_file_links/kevinduffy-deno1/Programs/Macros');

data fortune_acct; 
	set Data_610.fortune_acct; 
run;

*Overview of fortune_acct.sas7bdat contents;

ods select Variables;			
proc contents data=fortune_acct; run;
ods select default;

*First 25 observations of fortune_acct.sas7bdat;

proc print data=fortune_acct (firstobs = 1 obs = 25); 
run; 

*Checking the numeric DailyRate variable data;

proc means data=fortune_acct n nmiss min mean max maxdec=2 nolabels; 
	var DailyRate; 
run; 

proc univariate data=fortune_acct noprint;
	histogram DailyRate;
run;

proc sql noprint; select count(distinct DailyRate) into: count from fortune_acct; quit; 
proc sql noprint; select count(*) into: obs from fortune_acct; quit; 
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

*Checking the numeric HourlyRate variable data;

proc means data=fortune_acct n nmiss min mean max maxdec=2 nolabels; 
	var HourlyRate; 
run; 

proc univariate data=fortune_acct noprint;
	histogram HourlyRate;
run;

proc sql noprint; select count(distinct HourlyRate) into: count from fortune_acct; quit; 
proc sql noprint; select count(*) into: obs from fortune_acct; quit; 
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

*Checking the numeric MonthlyIncome variable data;

proc means data=fortune_acct n nmiss min mean max maxdec=2 nolabels; 
	var MonthlyIncome; 
run; 

proc univariate data=fortune_acct noprint;
	histogram MonthlyIncome;
run;

proc sql noprint; select count(distinct MonthlyIncome) into: count from fortune_acct; quit; 
proc sql noprint; select count(*) into: obs from fortune_acct; quit; 
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

*Checking the numeric PercentSalaryHike variable data;

proc means data=fortune_acct n nmiss min mean max maxdec=2 nolabels; 
	var PercentSalaryHike; 
run; 

proc univariate data=fortune_acct noprint;
	histogram PercentSalaryHike;
run;

proc sql noprint; select count(distinct PercentSalaryHike) into: count from fortune_acct; quit; 
proc sql noprint; select count(*) into: obs from fortune_acct; quit; 
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

*Checking the character categorical Department variable data;

proc freq data=fortune_acct; 
	tables Department / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct Department) into: count from fortune_acct; quit; 
proc sql noprint; select count(*) into: obs from fortune_acct; quit; 
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

*Checking the character categorical OverTime variable data;

proc freq data=fortune_acct; 
	tables OverTime / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct OverTime) into: count from fortune_acct; quit; 
proc sql noprint; select count(*) into: obs from fortune_acct; quit; 
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

*Checking the numeric categorical PerformanceRating variable data;

proc freq data=fortune_acct; 
	tables PerformanceRating / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct PerformanceRating) into: count from fortune_acct; quit; 
proc sql noprint; select count(*) into: obs from fortune_acct; quit; 
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

*Checking the numeric categorical StockOptionLevel variable data;

proc freq data=fortune_acct; 
	tables StockOptionLevel / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct StockOptionLevel) into: count from fortune_acct; quit; 
proc sql noprint; select count(*) into: obs from fortune_acct; quit; 
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

*Checking the numeric categorical employee_no variable data;

data length;
	set Data_610.fortune_acct; 
	len_employee_no = length(employee_no); 
run; 

proc means data=length n nmiss min mean median max maxdec=2; 
	var len_employee_no;
run; 

proc univariate data=length noprint; 
	histogram len_employee_no; 
run; 

proc sql noprint; select count(distinct employee_no) into: count from fortune_acct; quit; 
proc sql noprint; select count(*) into: obs from fortune_acct; quit; 
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

*Checking the character categorical ssn variable data;

data length;
	set Data_610.fortune_acct; 
	len_ssn = length(ssn); 
run; 

proc means data=length n nmiss min mean median max maxdec=2; 
	var len_ssn;
run; 

proc univariate data=length noprint; 
	histogram len_ssn; 
run; 

proc sql noprint; select count(distinct ssn) into: count from fortune_acct; quit; 
proc sql noprint; select count(*) into: obs from fortune_acct; quit; 
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

*Reassigning fortune_attrition data;

data fortune_attrition; 
	set Data_610.fortune_attrition; 
run;

*Overview of fortune_attrition.sas7bdat contents;

ods select Variables;			
proc contents data=fortune_attrition; run;
ods select default;

*First 25 observations of fortune_acct.sas7bdat;

proc print data=fortune_attrition (firstobs = 1 obs = 25); 
run; 

*Checking the date depart_dt variable data;

ods noproctitle;
	
proc tabulate data=fortune_attrition; var depart_dt;
	table depart_dt, n nmiss (min mean median max)*f=mmddyy10.; 
	Title "Descriptive Stats for depart_dt"; run;

title;

proc univariate data=fortune_attrition noprint; histogram depart_dt; run;
	
	proc sql noprint; select count(distinct depart_dt) into: count from fortune_attrition; quit;
	proc sql noprint; select count(*) into: obs from fortune_attrition; quit;
	
	proc delete data=print; run;
	
	data print;
		Records = &obs;
		Distinct = &count;
		DistinctPct = &count/&obs;
		format Records comma9.;
		format Distinct comma9.;
		format DistinctPct percent10.2;
	run;
		proc print data=print noobs; 
			Title "Cardinality of depart_dt"; run;

title;

*Checking the numeric categorical employee_no variable data;

data length;
	set Data_610.fortune_attrition; 
	len_employee_no = length(employee_no); 
run; 

proc means data=length n nmiss min mean median max maxdec=2; 
	var len_employee_no;
run; 

proc univariate data=length noprint; 
	histogram len_employee_no; 
run; 

proc sql noprint; select count(distinct employee_no) into: count from fortune_attrition; quit; 
proc sql noprint; select count(*) into: obs from fortune_attrition; quit; 
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

*Reassigning fortune_hr data;

data fortune_hr; 
	set Data_610.fortune_hr; 
run;

*Overview of fortune_hr.sas7bdat contents;

ods select Variables;			
proc contents data=fortune_hr; run;
ods select default;

*First 25 observations of fortune_hr.sas7bdat;

proc print data=fortune_hr (firstobs = 1 obs = 25); 
run;

*Checking the numeric categorical Education variable data;

proc freq data=fortune_hr; 
	tables Education / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct Education) into: count from fortune_hr; quit; 
proc sql noprint; select count(*) into: obs from fortune_hr; quit; 
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

*Checking the character categorical EducationField variable data;

proc freq data=fortune_hr; 
	tables EducationField / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct EducationField) into: count from fortune_hr; quit; 
proc sql noprint; select count(*) into: obs from fortune_hr; quit; 
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

*Checking the character categorical Gender variable data;

proc freq data=fortune_hr; 
	tables Gender / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct Gender) into: count from fortune_hr; quit; 
proc sql noprint; select count(*) into: obs from fortune_hr; quit; 
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

*Checking the character categorical birth_state variable data;

proc freq data=fortune_hr; 
	tables birth_state / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct birth_state) into: count from fortune_hr; quit; 
proc sql noprint; select count(*) into: obs from fortune_hr; quit; 
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

*Checking the numeric categorical employee_no variable data;

data length;
	set Data_610.fortune_hr; 
	len_employee_no = length(employee_no); 
run; 

proc means data=length n nmiss min mean median max maxdec=2; 
	var len_employee_no;
run; 

proc univariate data=length noprint; 
	histogram len_employee_no; 
run; 

proc sql noprint; select count(distinct employee_no) into: count from fortune_hr; quit; 
proc sql noprint; select count(*) into: obs from fortune_hr; quit; 
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

*Checking the character first_name variable data;

data length;
	set Data_610.fortune_hr; 
	len_first_name = length(first_name); 
run; 

proc means data=length n nmiss min mean median max maxdec=2; 
	var len_first_name;
run; 

proc univariate data=length noprint; 
	histogram len_first_name; 
run; 

proc sql noprint; select count(distinct first_name) into: count from fortune_hr; quit; 
proc sql noprint; select count(*) into: obs from fortune_hr; quit; 
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

*Checking the date birth_dt variable data;

ods noproctitle;
	
proc tabulate data=fortune_hr; var birth_dt;
	table birth_dt, n nmiss (min mean median max)*f=mmddyy10.; 
	Title "Descriptive Stats for birth_dt"; run;

title;

proc univariate data=fortune_hr noprint; histogram birth_dt; run;
	
	proc sql noprint; select count(distinct birth_dt) into: count from fortune_hr; quit;
	proc sql noprint; select count(*) into: obs from fortune_hr; quit;
	
	proc delete data=print; run;
	
	data print;
		Records = &obs;
		Distinct = &count;
		DistinctPct = &count/&obs;
		format Records comma9.;
		format Distinct comma9.;
		format DistinctPct percent10.2;
	run;
		proc print data=print noobs; 
			Title "Cardinality of birth_dt"; run;

title;

*Checking the date hire_dt variable data;

ods noproctitle;
	
proc tabulate data=fortune_hr; var hire_dt;
	table hire_dt, n nmiss (min mean median max)*f=mmddyy10.; 
	Title "Descriptive Stats for hire_dt"; run;

title;

proc univariate data=fortune_hr noprint; histogram hire_dt; run;
	
	proc sql noprint; select count(distinct hire_dt) into: count from fortune_hr; quit;
	proc sql noprint; select count(*) into: obs from fortune_hr; quit;
	
	proc delete data=print; run;
	
	data print;
		Records = &obs;
		Distinct = &count;
		DistinctPct = &count/&obs;
		format Records comma9.;
		format Distinct comma9.;
		format DistinctPct percent10.2;
	run;
		proc print data=print noobs; 
			Title "Cardinality of hire_dt"; run;

title;

/*-----------------------------------------------------------------------------------------*/

*Reassigning fortune_survey data;

data fortune_survey; 
	set Data_610.fortune_survey; 
run;

*Overview of fortune_survey.sas7bdat contents;

ods select Variables;			
proc contents data=fortune_survey; run;
ods select default;

*First 25 observations of fortune_survey.sas7bdat;

proc print data=fortune_survey (firstobs = 1 obs = 25); 
run;

*Checking the numeric DistanceFromHome variable data;

proc means data=fortune_survey n nmiss min mean max maxdec=2 nolabels; 
	var DistanceFromHome; 
run; 

proc univariate data=fortune_survey noprint;
	histogram DistanceFromHome;
run;

proc sql noprint; select count(distinct DistanceFromHome) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the numeric NumCompaniesWorked variable data;

proc means data=fortune_survey n nmiss min mean max maxdec=2 nolabels; 
	var NumCompaniesWorked; 
run; 

proc freq data=fortune_survey; 
	tables NumCompaniesWorked / plots=(freqplot); 
run;

proc sql noprint; select count(distinct NumCompaniesWorked) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the numeric TotalWorkingYears variable data;

proc means data=fortune_survey n nmiss min mean max maxdec=2 nolabels; 
	var TotalWorkingYears; 
run; 

proc univariate data=fortune_survey noprint;
	histogram TotalWorkingYears;
run;

proc sql noprint; select count(distinct TotalWorkingYears) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the numeric TrainingTimesLastYear variable data;

proc means data=fortune_survey n nmiss min mean max maxdec=2 nolabels; 
	var TrainingTimesLastYear; 
run; 

proc freq data=fortune_survey; 
	tables TrainingTimesLastYear / plots=(freqplot); 
run;

proc sql noprint; select count(distinct TrainingTimesLastYear) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the numeric YearsInCurrentRole variable data;

proc means data=fortune_survey n nmiss min mean max maxdec=2 nolabels; 
	var YearsInCurrentRole; 
run; 

proc univariate data=fortune_survey noprint;
	histogram YearsInCurrentRole;
run;

proc sql noprint; select count(distinct YearsInCurrentRole) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the numeric YearsSinceLastPromotion variable data;

proc means data=fortune_survey n nmiss min mean max maxdec=2 nolabels; 
	var YearsSinceLastPromotion; 
run; 

proc univariate data=fortune_survey noprint;
	histogram YearsSinceLastPromotion;
run;

proc sql noprint; select count(distinct YearsSinceLastPromotion) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the numeric YearsWithCurrManager variable data;

proc means data=fortune_survey n nmiss min mean max maxdec=2 nolabels; 
	var YearsWithCurrManager; 
run; 

proc univariate data=fortune_survey noprint;
	histogram YearsWithCurrManager;
run;

proc sql noprint; select count(distinct YearsWithCurrManager) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the character categorical BusinessTravel variable data;

proc freq data=fortune_survey; 
	tables BusinessTravel / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct BusinessTravel) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the numeric categorical EnvironmentSatisfaction variable data;

proc freq data=fortune_survey; 
	tables EnvironmentSatisfaction / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct EnvironmentSatisfaction) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the numeric categorical JobInvolvement variable data;

proc freq data=fortune_survey; 
	tables JobInvolvement / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct JobInvolvement) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the numeric categorical JobLevel variable data;

proc freq data=fortune_survey; 
	tables JobLevel / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct JobLevel) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the numeric categorical JobSatisfaction variable data;

proc freq data=fortune_survey; 
	tables JobSatisfaction / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct JobSatisfaction) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the character categorical MaritalStatus variable data;

proc freq data=fortune_survey; 
	tables MaritalStatus / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct MaritalStatus) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the numeric categorical RelationshipSatisfaction variable data;

proc freq data=fortune_survey; 
	tables RelationshipSatisfaction / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct RelationshipSatisfaction) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the numeric categorical WorkLifeBalance variable data;

proc freq data=fortune_survey; 
	tables WorkLifeBalance / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct WorkLifeBalance) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Checking the numeric categorical employee_no variable data;

data length;
	set Data_610.fortune_survey; 
	len_employee_no = length(employee_no); 
run; 

proc means data=length n nmiss min mean median max maxdec=2; 
	var len_employee_no;
run; 

proc univariate data=length noprint; 
	histogram len_employee_no; 
run; 

proc sql noprint; select count(distinct employee_no) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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

*Merging of Fortune data files;

	**Load in necessary Fortune data files for merger;

data credit; set Data_610.fortune_credit; run;

	**Convert Character ssn variable to Numeric in Fortune acct file;	

data acct; 
	set Data_610.fortune_acct; 
	conversion = input(compress(ssn,'-'), 9.);
	drop ssn;
	rename conversion = ssn;
run;

		***Save converted fortune acct file;

	data Data_610.fortune_acctC; 
		set acct; 	
	run;

data attrition; set Data_610.fortune_attrition; run;

data hr; set Data_610.fortune_hr; run;

data survey; set Data_610.fortune_survey; run;

	**Sort Fortune file data by the numeric ssn for merging;

proc sort data=credit; by ssn; run;
proc sort data=acct; by ssn; run;

	**Merge first round of Fortune data files;

data fortune_ssnm; merge credit acct; by ssn; 
run;

		***Save first merged data file;

	data Data_610.fortune_ssnm; 
		set fortune_ssnm; 	
	run;

	**Sort Fortune file data by the numeric employee_no for merging;

proc sort data=fortune_ssnm; by employee_no; run;
proc sort data=attrition; by employee_no; run;
proc sort data=hr; by employee_no; run;
proc sort data=survey; by employee_no; run;

	**Merge Fortune data files;

data fortune_master; merge fortune_ssnm attrition hr survey; by employee_no; 
run;

		***Save second merged data file;

	data Data_610.fortune_master; 
		set fortune_master; 	
	run;

/*-----------------------------------------------------------------------------------------*/

*Overview of fortune_master contents;

proc contents data=fortune_master; run;
	
/*-----------------------------------------------------------------------------------------*/

*Exporting .csv file from fortune_master;

proc export data=Data_610.fortune_master            
     outfile="/home/u64094997/my_courses/ANA 610/Data_610/Homework 4/fortune_master.csv"  
     dbms=csv                                     
     replace;                                     
run;

*Task #3:	

1.	After merging the 5 files, you should find duplicate rows.  Deduplicate your SAS modeling datafiles.;

proc sort data=fortune_master out=deduplicated nodupkey;
	by employee_no;
run;

*2.	Using your deduplicated datafiles, create two variables, one for AGE, employee age (in years), and one
 for TENURE, the length of time an employee has been with the company (in years).  Create AGE and TENURE for 
 all employees in the datafile. HINT: How should TENURE be defined for those who left the company?  
 What is the analysis date?;

data fortune_master2;
	set deduplicated;
	CURRENT_DATE = mdy(6,1,2018);
	AGE = floor(yrdif(birth_dt, CURRENT_DATE, 'ACT/ACT'));
	if depart_dt = "" then TENURE = floor(yrdif(hire_dt, CURRENT_DATE, 'ACT/ACT'));
	else TENURE = floor(yrdif(hire_dt, depart_dt, 'ACT/ACT'));
	format CURRENT_DATE mmddyy8.;
run;

proc tabulate data=fortune_master2;
	var AGE TENURE;
	table AGE TENURE,
	n nmiss (min mean median max) *f=yyyy.;
run;

	*c.	Using SAS, check AGE and TENURE for integrity issues.  Specifically check for (a) missing values, 
	(b) extreme values, and (c) extreme distribution.  Fully discuss your findings.  Show all relevant code-generated 
	charts and tables.;

*Checking the numeric AGE variable data;

proc means data=fortune_master2 n nmiss min mean max maxdec=2; 
	var AGE; 
run; 

proc univariate data=fortune_master2 noprint;
	histogram AGE;
run;

proc sql noprint; select count(distinct AGE) into: count from fortune_master2; quit; 
proc sql noprint; select count(*) into: obs from fortune_master2; quit; 
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

*Checking the numeric TENURE variable data;

proc means data=fortune_master2 n nmiss min mean max maxdec=2; 
	var TENURE; 
run; 

proc univariate data=fortune_master2 noprint;
	histogram TENURE;
run;

proc sql noprint; select count(distinct TENURE) into: count from fortune_master2; quit; 
proc sql noprint; select count(*) into: obs from fortune_master2; quit; 
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

*3.	Using your deduplicated datafiles, create a target variable, ATT_Q, which takes on a value
 of 1 if an employee took the survey and voluntarily attritioned, or 0 if the employee took the 
 survey and did not attrition.;
 
data fortune_master3;
	set fortune_master2;
 	if BusinessTravel = "" then ATT_Q = "";
	else if depart_dt = "" then ATT_Q = 0;
	else ATT_Q = 1;
run;

**Checking the numeric categorical ATT_Q variable data;

proc freq data=fortune_master3; 
	tables ATT_Q / plots=(freqplot); 
run;

proc sql noprint; select count(distinct MaritalStatus) into: count from fortune_survey; quit; 
proc sql noprint; select count(*) into: obs from fortune_survey; quit; 
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


*4.	You have found that AGE has missing values.  Using SAS and your SAS deduplicated datafile, impute 
these missing values using Predictive Mean Matching (PMM).  Use as control variables EDUCATION and 
HIRE_DT for this conditional imputation approach.  Impute AGE across the entire datafile.

		*Create duplicate of variable to impute;
		
data fortune_master4; set fortune_master3;
	AGE_mi = AGE;
run;

proc print data=fortune_master4 (firstobs=1 obs=25); 
	var AGE AGE_mi; 
run;

 		*Impute missing values using predictive mean matching (PMM) and output imputed data;	
	
proc mi data=fortune_master4 nimpute=1 seed=1234 out=fortune_master4;
	fcs regpmm(AGE_mi = Education hire_dt);
	var AGE_mi Education hire_dt;
run;

		*Conduct comparative analyses;

proc means data=fortune_master4 n nmiss min mean median max std maxdec=3; 
	var  AGE AGE_mi; 
run; 

proc freq data=fortune_master4; 
	tables AGE_mi; 
run;

proc sgplot data=fortune_master4;
	histogram AGE  / binwidth=1 transparency=.5;
	histogram AGE_mi  / binwidth=1 transparency=.5;
run;

proc sgplot data=fortune_master4;
	hbox AGE / transparency=.5;
	hbox AGE_mi / transparency=.5;
run;

proc corr data=fortune_master4; 
	var AGE AGE_mi; 
	with Education hire_dt; 
run;

*Task #4:

Note: For Tasks #4 and #5, use the deduplicated SAS modeling datafile you created in Task #3 
and the imputed version of AGE.

Using PROC HPBIN and target-based enumeration, 

1.	Fill in the following table template to analyze how many bins are appropriate for AGE and 
TENURE.  Start with 10 bins.  Then, using a threshold of 20 for each segment of the target 
variable, determine how many bins should be created (HINT: 10 is too many).  If there are 
missing values, ignore the bin that captures these in your final bin count.;

*AGE Equal Height Binning.;

ods output mapping=mapping;
proc hpbin data=fortune_master4 output=AGE_bin numbin=10 psuedo_quantile; input AGE; run;
proc hpbin data=fortune_master4 woe bins_meta=mapping; target ATT_Q; run;

ods output mapping=mapping;
proc hpbin data=fortune_master4 output=AGE_bin numbin=5 psuedo_quantile; input AGE; run;
proc hpbin data=fortune_master4 woe bins_meta=mapping; target ATT_Q; run;

*AGE Equal Width Binning.;
 
ods output mapping=mapping;
proc hpbin data=fortune_master4 output=AGE_bin numbin=10 bucket; input AGE; run;
proc hpbin data=fortune_master4 woe bins_meta=mapping; target ATT_Q; run;

ods output mapping=mapping;
proc hpbin data=fortune_master4 output=AGE_bin numbin=4 bucket; input AGE; run;
proc hpbin data=fortune_master4 woe bins_meta=mapping; target ATT_Q; run;

*TENURE Equal Height Binning.;

ods output mapping=mapping;
proc hpbin data=fortune_master4 output=TENURE_bin numbin=10 psuedo_quantile; input TENURE; run;
proc hpbin data=fortune_master4 woe bins_meta=mapping; target ATT_Q; run;

ods output mapping=mapping;
proc hpbin data=fortune_master4 output=TENURE_bin numbin=4 psuedo_quantile; input TENURE; run;
proc hpbin data=fortune_master4 woe bins_meta=mapping; target ATT_Q; run;

*TENURE Equal Width Binning.;
 
ods output mapping=mapping;
proc hpbin data=fortune_master4 output=TENURE_bin numbin=10 bucket; input TENURE; run;
proc hpbin data=fortune_master4 woe bins_meta=mapping; target ATT_Q; run;

ods output mapping=mapping;
proc hpbin data=fortune_master4 output=TENURE_bin numbin=2 bucket; input TENURE; run;
proc hpbin data=fortune_master4 woe bins_meta=mapping; target ATT_Q; run;

*4.	For each variable AGE and TENURE, 
a.	Create dummy variables for each bin for your selected binning type.  The dummy variable names 
should show the relevant bin ranges.;

	*For AGE;
	
data dummy; set fortune_master4;
	if AGE = "" then AGE_miss_dum = 1;
	else if AGE < 30.004 then AGE_19_30_dum = 1;
	else if AGE >= 30.004 and AGE < 35.002 then AGE_31_35_dum = 1;
	else if AGE >= 35.002 and AGE < 39.0004 then AGE_36_39_dum = 1;
	else if AGE >= 39.004 and AGE < 46.0018 then AGE_40_46_dum = 1;
	else if AGE >= 46.0018 then AGE_47_61_dum = 1;
run;
	
	*For TENURE;
	
data dummy2; set fortune_master4;	
	if TENURE < 4.0016 then TENURE_0_4_dum = 1;
	else if TENURE >= 4.0016 and TENURE < 6.0024 then TENURE_5_6_dum = 1;
	else if TENURE >= 6.0024 and TENURE < 10.004 then TENURE_7_10_dum = 1;
	else if TENURE >= 10.004 then TENURE_10_41_dum = 1;
run;	

*b.	Using PROC MEANS and PROC TRANSPOSE, produce and show here a “tall and skinny” output table for 
each set of bin dummy variables which shows the bin dummy variables as rows with the sum for each bin 
by target variable segment as columns (so, N rows by 3 columns).;  

	*For AGE;

proc sort data=dummy; by ATT_Q; run;
	
proc means data=dummy sum noprint; var AGE_miss_dum AGE_19_30_dum AGE_31_35_dum AGE_36_39_dum AGE_40_46_dum AGE_47_61_dum; output out=tmp_sum (drop = _TYPE_ _FREQ_)
		 	sum=AGE_miss_dum AGE_19_30_dum AGE_31_35_dum AGE_36_39_dum AGE_40_46_dum AGE_47_61_dum; by ATT_Q; run;
				proc transpose data=tmp_sum out=tmp_sum_t; run;
					proc print data=tmp_sum_t; run;

	*For TENURE;

proc sort data=dummy2; by ATT_Q; run;
	
proc means data=dummy2 sum noprint; var TENURE_0_4_dum TENURE_5_6_dum TENURE_7_10_dum TENURE_10_41_dum; output out=tmp_sum (drop = _TYPE_ _FREQ_)
			sum=TENURE_0_4_dum TENURE_5_6_dum TENURE_7_10_dum TENURE_10_41_dum; by ATT_Q; run;
				proc transpose data=tmp_sum out=tmp_sum_t; run;
					proc print data=tmp_sum_t; run;	
					
*Task #5:

Using PROC CORR and the bin dummy variables your created above for AGE and TENURE:

1.	Identify which employee AGE range is most likely to attrition.  Support your answer by showing output from PROC CORR here.;	

	*Remove non-survey related records from the dataset;

data dummy; 
	modify dummy;
	if ATT_Q="" then remove; 	
run;

	*Convert the target variable ATT_Q from char to num;

data dummy_adj;
	set dummy;
	conversion = input(ATT_Q, 1.);
	drop ATT_Q;
	rename conversion = ATT_Q;
run;

	*Insert 0 values for dummy variable missing values; 

data dummy_adj;
	set dummy_adj;
	if AGE_miss_dum = "" then AGE_miss_dum = 0;
	if AGE_19_30_dum = "" then AGE_19_30_dum = 0;
	if AGE_31_35_dum = "" then AGE_31_35_dum = 0;
	if AGE_36_39_dum = "" then AGE_36_39_dum = 0;
	if AGE_40_46_dum = "" then AGE_40_46_dum = 0;
	if AGE_47_61_dum = "" then AGE_47_61_dum = 0;
run;

	*Use the requested PROC CORR to evaluation.;

proc corr data=dummy_adj out=corr; var ATT_Q;
	with AGE_19_30_dum AGE_31_35_dum AGE_36_39_dum AGE_40_46_dum AGE_47_61_dum;
run; 

data corr; set corr; where _TYPE_ in("CORR"); rename ATT_Q = corr; abs_corr = abs(ATT_Q); run;  

proc sort data=corr; by descending abs_corr; run; proc print data=corr (firstobs = 1 obs = 10); var _name_ abs_corr; run;

*2.	Identify which employee TENURE range is most likely to attrition.  Support your answer by showing output from PROC CORR here.;

	*Remove non-survey related records from the dataset;

data dummy2; 
	modify dummy2;
	if ATT_Q="" then remove; 	
run;

	*Convert the target variable ATT_Q from char to num;

data dummy2_adj;
	set dummy2;
	conversion = input(ATT_Q, 1.);
	drop ATT_Q;
	rename conversion = ATT_Q;
run;

	*Insert 0 values for dummy variable missing values; 

data dummy2_adj;
	set dummy2_adj;
	if TENURE_0_4_dum = "" then TENURE_0_4_dum = 0;
	if TENURE_5_6_dum = "" then TENURE_5_6_dum = 0;
	if TENURE_7_10_dum = "" then TENURE_7_10_dum = 0;
	if TENURE_10_41_dum = "" then TENURE_10_41_dum = 0;
run;

	*Use the requested PROC CORR to evaluation.;

proc corr data=dummy2_adj out=corr; var ATT_Q;
	with TENURE_0_4_dum TENURE_5_6_dum TENURE_7_10_dum TENURE_10_41_dum;
run; 

data corr; set corr; where _TYPE_ in("CORR"); rename ATT_Q = corr; abs_corr = abs(ATT_Q); run;  

proc sort data=corr; by descending abs_corr; run; proc print data=corr (firstobs = 1 obs = 10); var _name_ abs_corr; run;

*Extra Credit

1.	In the full, deduplicated, imputed datafile there are 6 obvious extreme values in the variable HIRE_DT.  
Why are they “obvious”? Explain fully your logic and provide a table showing EMPLOYEE_NUMBER, HIRE_DT and 
TENURE for these 6 “outliers.”;

data hire_out;
	set fortune_master4;
run;
	
data hire_out; 
	modify hire_out;
	if hire_dt >= mdy(6,1,1980) then remove; 	
run;

proc print data=hire_out (firstobs = 1 obs = 10); var employee_no hire_dt TENURE;
run; 		

*2.	Now use the course clustering method (i.e., the one that uses pmin) to try to identify these extreme 
values in the full, deduplicated, imputed datafile.  Show the relevant SAS output.

a.	What does pmin need to be set at to capture these 6 employees?  Explain fully.  Include any relevant 
SAS output and counts of employees in your answer.; 

proc means data=fortune_master4 n range; var hire_dt; run;

%macro clust_ev(dsin,varlist,pmin,dsout);

	/*	macro program parameters the user must set:

	dsin  	= input dataset
	varlist = list of vars used in clustering
	pmin  	= size of cluster, as % of dataset, to label its obs as extremes
	dsout 	= output dataset with extremes identified
	
	Output produced:
	
	(1) cluster membership frequencies, sorted highest to lowest % of dataset
	(2) plot of (1)
	(3) identification of EVs based on PMIN parameter. */

	*Invoke FASTCLUS to group obs into 50 clusters.;
		
proc fastclus data=&dsin maxc=50 maxiter=100 cluster=_clusterindex_ out=work.temp_clus noprint;
	var &varlist; run;
		
	*Analyze resulting clusters;
proc freq data=work.temp_clus noprint;
	tables _clusterindex_ / out=work.temp_freq; run;
		
proc sort data=temp_freq; by descending percent; run;
		
Title 'Clusters and Member %'; 
proc print data=work.temp_freq; run;
proc sgplot data=temp_freq; vbar _clusterindex_ / response=count categoryorder=respasc; run;
			
	*Isolate clusters with a size less than pmin of the dataset size.;
data work.temp_low; set work.temp_freq;
	if percent < &pmin and _clusterindex_ notin(.); _extreme_ = 1;
	keep _clusterindex_ _extreme_; 	run; 
		
	*Merge these isolated clusters back onto the master dataset.;
proc sort data=work.temp_clus; by _clusterindex_; run;
proc sort data=work.temp_low; by _clusterindex_; run;
		
data &dsout; merge work.temp_clus work.temp_low; by _clusterindex_;
	if _extreme_ = . then _extreme_ = 0; run;
		
	*Print the extreme values.;
proc sort data=&dsout; by &varlist; run;
Title 'Extremes (single member clusters)';
proc print data=&dsout; var &varlist _extreme_; where _extreme_ = 1; run;

%mend;
 
%clust_ev(fortune_master4,hire_dt,0.02055, clus_out); 

*3.	Using the full, deduplicated, imputed datafile which contains all variables (35+), including the 
AGE and TENURE dummy variables created in Task #3, check for variable redundancy using PROC VARCLUS.  
Considerations:

•	Restrict your analysis to only “TYPE = 1” variables (machine numeric).
•	Exclude ATT_Q, EMPLOYEE_NO, BIRTH_DT, AGE (observed), and DEPART_DT from consideration.
•	Set MAXEIGEN = 0.7.
•	Restrict your sample to where ATT_Q = 1 or 0 (i.e., the qualified sample);

	**Sort Fortune file data by the numeric employee_no for merging;

data dummy2_trim;
	set dummy2_adj; 
	keep employee_no TENURE TENURE_0_4_dum TENURE_5_6_dum TENURE_7_10_dum TENURE_10_41_dum;
run;

proc sort data=dummy_adj; by employee_no; run;
proc sort data=dummy2_trim; by employee_no; run;

	**Merge Fortune data files;

data fortune_compiled; merge dummy_adj dummy2_trim; by employee_no; 
run;

		***Save second merged data file;

	data Data_610.fortune_compiled; 
		set fortune_compiled; 	
	run;



data fortune_numeric;
	set fortune_compiled;
	drop ATT_Q employee_no birth_dt AGE depart_dt birth_state BusinessTravel CURRENT_DATE Department EducationField first_name Gender hire_dt MaritalStatus Overtime;
run;

*a.	Show the PROC MEANS output for the variables which will be checked for redundancy.;

proc means data=fortune_numeric n nmiss min mean median max skew maxdec=3; run; 

*b.	Show the output reporting the cluster membership (i.e., which variables are assigned to which clusters).;

proc varclus data=fortune_numeric maxeigen=.7 outtree=fortree maxclusters=21 short hi;
run;		
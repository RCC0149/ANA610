libname Data_610 '/home/u64094997/my_courses/ANA 610/Data_610/Homework 2';

*Reassigning s_pml_donor_hw_v3 data;

data donor; 
	set Data_610.s_pml_donor_hw_v3; 
run;

*Overview of s_pml_donor_hw_v3.sas7bdat contents;

ods select Variables;			
proc contents data=donor; run;
ods select default;

*First 25 observations of s_pml_donor_hw_v3.sas7bdat;

proc print data=donor (firstobs = 1 obs = 25); 
run;

*TASK #1;

*1.	Using the fields MONTHS_SINCE_ORIGIN, MONTHS_SINCE_FIRST_GIFT, and MONTHS_SINCE_LAST_GIFT and 
the SAS INTNX() function, create these date fields on the datafile, giving them a format of MM/DD/YYYY.  
Assume you are conducting this analysis on August 1, 1998.;

data donor_dt;
	set donor;
	CURRENT_DATE = mdy(9,1,1998);
	ENTRY_DATE = intnx('month', CURRENT_DATE, -MONTHS_SINCE_ORIGIN);
	FIRST_GIFT_DATE = intnx('month', CURRENT_DATE, -MONTHS_SINCE_FIRST_GIFT);
	LAST_GIFT_DATE = intnx('month', CURRENT_DATE, -MONTHS_SINCE_LAST_GIFT);
	format CURRENT_DATE mmddyy10. ENTRY_DATE mmddyy10. FIRST_GIFT_DATE mmddyy10. LAST_GIFT_DATE mmddyy10.;
run;

	*a.	What is the date of the most recent file entry? 
	
	04/01/1998;
	
	*b.	What is the date of the first gift? 
	
	01/01/1977;
	
	*c.	What is the date of the last gift? 
	
	05/01/1998;
	
proc tabulate data=donor_dt;
	var ENTRY_DATE FIRST_GIFT_DATE LAST_GIFT_DATE;
	table ENTRY_DATE FIRST_GIFT_DATE LAST_GIFT_DATE,
	n nmiss (min mean median max) *f=mmddyy10.;
run;	
	
	*d.	What is the median length of time (in months) between the first and last gift? 
	
	48;

data donor_dt;
	set donor_dt;
	MONTHS_GIFT_RANGE = floor(yrdif(FIRST_GIFT_DATE,LAST_GIFT_DATE, 'actual')*12);
	format MONTHS_GIFT_RANGE 12.;
run;

proc means data=donor_dt n nmiss min mean median max maxdec=1; 
	var MONTHS_GIFT_RANGE; 
run; 		

*2.	Using PROC UNIVARIATE with default settings, 
 	*a.	Show the histograms for ENTRY_DATE and FIRST_GIFT_DATE with the year displayed on the x-axis;
 	
proc univariate data=donor_dt noprint;
	histogram ENTRY_DATE FIRST_GIFT_DATE;
run;

	*b.	Based on these two histograms, what is odd about ENTRY_DATE and FIRST_GIFT_DATE (i.e., considering 
	the definitions of these two dates, is there a data integrity issue we need to address)?  Explain.
	
	One could pretty much suspect that the entry and first gift dates would be the same or close to each 
	other.  There are some first gift dates that proceeded recorded entry dates in the file.  These could
	be errors, and should be verified with the client.  Given the extremely high level of correlation   
	between ENTRY_DATE and FIRST_GIFT_DATE data, imputation could be performed to replace the suspect  
	FIRST_GIFT_DATE data with its corresponding ENTRY_DATE data.  In addition, when an eventual model is 
	generated from the data, only one of these variables would probably be necessary.;
	
proc corr data=donor_dt nosimple;
   var ENTRY_DATE FIRST_GIFT_DATE;
run;	

*3.	Using the SAS YEAR() function, create 3 new fields, showing the YEAR (in YYYY format):  ENTRY_DATE_YEAR, 
FIRST_GIFT_DATE_YEAR, and LAST_GIFT_DATE_YEAR.;

data donor_dt;
    set donor_dt;
    ENTRY_DATE_YEAR = YEAR(ENTRY_DATE);
    FIRST_GIFT_DATE_YEAR = YEAR(FIRST_GIFT_DATE);
    LAST_GIFT_DATE_YEAR = YEAR(LAST_GIFT_DATE); 
run;

	*a.	How many individuals were added to the file in 1998?  Support your answer by showing an SAS output table.
	
	7;
	
proc freq data=donor_dt; 
	tables ENTRY_DATE_YEAR / plots=(freqplot); 
run; 

	*b.	Which year had the lowest mean LAST_GIFT_AMT?  Support your answer by showing an SAS output table using 
	LAST_GIFT_DATE_YEAR. 
	
	1997;
	
proc tabulate data=donor_dt;
   class LAST_GIFT_DATE_YEAR;
   var LAST_GIFT_AMT;
   table LAST_GIFT_DATE_YEAR,
         LAST_GIFT_AMT*mean;
run;

	*c.	In CLUSTER_CODE = 9 and LAST_GIFT_DATE_YEAR = 1997, what was the mean LAST_GIFT_AMT?  Support your answer 
	by showing an SAS output table again using LAST_GIFT_DATE_YEAR.
	
	15.26;
	
proc tabulate data=donor_dt;
   class LAST_GIFT_DATE_YEAR;
   var LAST_GIFT_AMT;
   table LAST_GIFT_DATE_YEAR,
         LAST_GIFT_AMT*mean;
   where CLUSTER_CODE = 9;
run;

*TASK 2;

*1.	The AnyState Veterans of Foreign Wars solicits donations from adults aged 18+ years.  DONOR_AGE may be an 
important variable in explaining whether an individual donated and, if so, how much they donated.

	*a.	Using a table to summarize your findings, perform a quick data integrity check (using R or SAS) on 
	DONOR_AGE and identify issues which may exist with respect to this variable.  Check and report briefly 
	(including a brief note per item if there is any concern) on missing values, odd values, extreme values 
	on the low and high end, distribution skewness, value consistency and anything else you think is important.;

proc means data=donor n nmiss min mean median max std maxdec=3; 
	var DONOR_AGE; 
run; 

proc univariate data=donor noprint;
	histogram DONOR_AGE;
run;

proc sql noprint; select count(distinct DONOR_AGE) into: count from donor; quit; 
proc sql noprint; select count(*) into: obs from donor; quit; 
proc delete data=print; run; 

data print; 
    Records = &obs; 
    Distinct = &count; 
    DistinctPct = &count/&obs; 
    format Records comma9.; 
    format Distinct comma9.; 
    format DistinctPct percent10.2; 
run; 

	*Note: There are 4,795 missing values for DONOR_AGE in the dataset (24.75%).  There are 206 values that are 
	under the age of 18 (1.1%).;  
	
proc sql;
  select count(*) as Young_Age
  from donor
  where DONOR_AGE < 18 
  and DONOR_AGE notin(.);
quit;	

	*b.	One integrity issue you just uncovered is missing values.  Should these records (rows) with missing 
	values for DONOR_AGE be removed from the modeling datafile?  Explain fully why, or why not?
	
	Given this is a fairly large number of records (4,795), the client may not want to remove the records.  
	The originally defined target variable data for TARGET_B and TARGET_D, along with other potentially important 
	explanatory variables could be affected by the removal of records. At this point, there is uncertainty as to 
	what effect DONOR_AGE may have on the estimation of the terget variables, but it definitely seems like a 
	reasonable profile answer to consider. Recommend the exploration of imputation options for the missing values.
	
*2.	Using SAS, impute the missing values of DONOR_AGE using mean unconditional and the conditional approaches 
hot-deck, stochastic regression, and predictive mean matching (PMM).  Your analysis will make use of the following:	

	•	Upon guidance from AnyState, the modeling datafile should be limited to those records with either missing 
		values for DONOR_AGE or values for DONOR_AGE >= 18.;
		
data donor_adj; set donor;
	where DONOR_AGE >= 18
	or DONOR_AGE in(.);
run;

	*•	The control variables for the conditional approaches are MONTHS_SINCE_ORIGIN, IN_HOUSE, PEP_STAR, 
		LIFETIME_CARD_PROM, LIFETIME_PROM, and MONTHS_SINCE_FIRST_GIFT.

	•	MONTHS_SINCE_ORIGIN will be used for the correlation metric.;
	
	*a.	Report the findings of your imputations in the following table (report out to 3 decimal places, right 
	justify numeric cell entries):
	
	*b.	For each imputation, show here the “overlaid histogram” produced by PROC SGPLOT (imputed variable vs. 
	observed variable) and the “overlaid boxplot”.  Make sure that the variable labels used by SGPLOT clearly 
	differentiate between the observed and imputed variables.  Use binwidth = 5 (histogram) and transparency 
	= .5 (histogram and boxplot).;
	
		*Step 1a: Create missing value indicator and duplicate of variable to impute.;
		
data donor_imp; set donor_adj;
	DONOR_AGE_mi = DONOR_AGE;
	DONOR_AGE_mi_dum = missing(DONOR_AGE);
run;

proc print data=donor_imp (firstobs=1 obs=25); 
	var DONOR_AGE DONOR_AGE_mi DONOR_AGE_mi_dum; 
run;

			*Check how many missing values there are now.;
			
proc means data=donor_imp n nmiss min mean median max std maxdec=3; 
	var DONOR_AGE DONOR_AGE_mi DONOR_AGE_mi_dum; 
run; 	

			*Examine the distribution of the "observed" series;
	
proc univariate data=donor_imp;
	var DONOR_AGE;
	histogram DONOR_AGE;
run;	
	
proc sgplot data=donor_imp;
	histogram DONOR_AGE / binwidth=5 transparency=.5; 
run;

proc corr data=donor_imp; 
	var DONOR_AGE DONOR_AGE_mi; 
	with MONTHS_SINCE_ORIGIN; 
run;	
	
		*Step 1b: Impute missing values using unconditional mean and output imputed data;
		
proc stdize data=donor_imp
	method=mean
	reponly
	out=imputed;
	var DONOR_AGE_mi;
run;
	
proc print data=imputed (firstobs=1 obs=25); 
	var DONOR_AGE DONOR_AGE_mi DONOR_AGE_mi_dum; 
run;

		*Step 1c: Conduct comparative analyses;
		
proc means data=imputed n nmiss min mean median max std maxdec=3; 
	var DONOR_AGE DONOR_AGE_mi; 
run; 

proc sgplot data=imputed;
	histogram DONOR_AGE  / binwidth=5 transparency=.5;
	histogram DONOR_AGE_mi  / binwidth=5 transparency=.5;
run;

proc sgplot data=imputed;
	hbox DONOR_AGE / transparency=.5;
	hbox DONOR_AGE_mi / transparency=.5;
run;

proc corr data=imputed; 
	var DONOR_AGE DONOR_AGE_mi; 
	with MONTHS_SINCE_ORIGIN; 
run;

		*Step 2a: Create missing value indicator and duplicate of variable to impute;
		
data donor_imp; set donor_adj;
	DONOR_AGE_mi = DONOR_AGE;
	DONOR_AGE_mi_dum = missing(DONOR_AGE);
run;

proc print data=donor_imp (firstobs=1 obs=25); 
	var DONOR_AGE DONOR_AGE_mi DONOR_AGE_mi_dum; 
run;
	
		*Step 2b: Impute missing values using "hot deck" and output imputed data;
		
proc surveyimpute data=donor_imp seed=12345 method=hotdeck(selection=srswr);
	var DONOR_AGE_mi MONTHS_SINCE_ORIGIN IN_HOUSE PEP_STAR LIFETIME_CARD_PROM LIFETIME_PROM MONTHS_SINCE_FIRST_GIFT;
	output out=imputed;
run;
	
		*Step 2c: Conduct comparative analyses;
		
proc means data=imputed n nmiss min mean median max std maxdec=3; 
	var DONOR_AGE DONOR_AGE_mi; 
run; 

proc sgplot data=imputed;
	histogram DONOR_AGE  / binwidth=5 transparency=.5;
	histogram DONOR_AGE_mi  / binwidth=5 transparency=.5;
run;

proc sgplot data=imputed;
	hbox DONOR_AGE / transparency=.5;
	hbox DONOR_AGE_mi / transparency=.5;
run;

proc corr data=imputed; 
	var DONOR_AGE DONOR_AGE_mi; 
	with MONTHS_SINCE_ORIGIN; 
run;

		*Step 3a: Create missing value indicator and duplicate of variable to impute;
		
data donor_imp; set donor_adj;
	DONOR_AGE_mi = DONOR_AGE;
	DONOR_AGE_mi_dum = missing(DONOR_AGE);
run;

proc print data=donor_imp (firstobs=1 obs=25); 
	var DONOR_AGE DONOR_AGE_mi DONOR_AGE_mi_dum; 
run;

%let segment_var = MONTHS_SINCE_ORIGIN IN_HOUSE PEP_STAR LIFETIME_CARD_PROM LIFETIME_PROM MONTHS_SINCE_FIRST_GIFT;
	
		*Step 3b: Impute missing values using stochastic regression and output imputed data;
		
proc mi data=donor_imp nimpute=1 seed=12345 out=imputed;
	fcs nbiter=1;
	var DONOR_AGE_mi &segment_var;
run;
	
		*Step 3c: Conduct comparative analyses;
		
proc means data=imputed n nmiss min mean median max std maxdec=3; 
	var DONOR_AGE DONOR_AGE_mi; 
run; 

proc sgplot data=imputed;
	histogram DONOR_AGE  / binwidth=5 transparency=.5;
	histogram DONOR_AGE_mi  / binwidth=5 transparency=.5;
run;

proc sgplot data=imputed;
	hbox DONOR_AGE / transparency=.5;
	hbox DONOR_AGE_mi / transparency=.5;
run;

proc corr data=imputed; 
	var DONOR_AGE DONOR_AGE_mi; 
	with MONTHS_SINCE_ORIGIN; 
run;

		*Step 4a: Create missing value indicator and duplicate of variable to impute;
		
data donor_imp; set donor_adj;
	DONOR_AGE_mi = DONOR_AGE;
	DONOR_AGE_mi_dum = missing(DONOR_AGE);
run;

proc print data=donor_imp (firstobs=1 obs=25); 
	var DONOR_AGE DONOR_AGE_mi DONOR_AGE_mi_dum; 
run;
	
		*Step 4b: Impute missing values using predictive mean matching (PMM) and output imputed data;
		
proc mi data=donor_imp nimpute=1 seed=12345 out=imputed;
	fcs regpmm(DONOR_AGE_mi = MONTHS_SINCE_ORIGIN IN_HOUSE PEP_STAR LIFETIME_CARD_PROM LIFETIME_PROM MONTHS_SINCE_FIRST_GIFT);
	var DONOR_AGE_mi MONTHS_SINCE_ORIGIN IN_HOUSE PEP_STAR LIFETIME_CARD_PROM LIFETIME_PROM MONTHS_SINCE_FIRST_GIFT;
run;
	
		*Step 4c: Conduct comparative analyses;
		
proc means data=imputed n nmiss min mean median max std maxdec=3; 
	var DONOR_AGE DONOR_AGE_mi; 
run; 

proc sgplot data=imputed;
	histogram DONOR_AGE  / binwidth=5 transparency=.5;
	histogram DONOR_AGE_mi  / binwidth=5 transparency=.5;
run;

proc sgplot data=imputed;
	hbox DONOR_AGE / transparency=.5;
	hbox DONOR_AGE_mi / transparency=.5;
run;

proc corr data=imputed; 
	var DONOR_AGE DONOR_AGE_mi; 
	with MONTHS_SINCE_ORIGIN; 
run;

	*c.	Based on the 4 imputations, which one do you recommend be used?  Explain fully.
	
	Of the four methods evaluated, Hot-Deck would be chosen, due to having the closest numbers to the mean
	and standard deviation for the observed values, as well as having notably matching histogram and boxplot 
	overlays to the observed values. The only potential drawback was Hot-Deck’s correlation with 
	MONTHS_SINCE_ORIGIN, which all of the other methods were closer to the observed values. A correlation 
	value of 0.276 is on the weaker side, and imagine DONOR_AGE would probably have a stronger correlation 
	to other variables in the dataset. Performing correlation to a numeric outcome variable like Target_D 
	or different numeric explanatory variables better representing the variable population would seem logical.   
	If MONTHS_SINCE_ORIGIN seemed like a potential outcome variable, I might consider using PMM instead, with 
	it having a similar correlation value, a reasonably close standard deviation, and notably matching 
	histogram and boxplot overlays to the observed values.;
	
	*d.	What should you always do when you impute missing values regardless of the technique?  Explain fully.
	
	The first step would be to create a missing value indicator and duplicate of the variable to impute. The 
	second step would be to check how many missing values there are in the observed values. The third step 
	would be to examine the distribution of the variable’s observed series. The fourth step would be to impute 
	missing values and output imputed data. The fifth step would be to conduct comparative analysis between the 
	observed data and the imputed data.
	
*3.	Imputing missing values for categorical variables, such as WEALTH_RATING, is not necessarily as straight 
forward as for continuous variables.;

	*a.	Using a table, perform a quick data integrity check  (using R or SAS) on WEALTH_RATING and identify all 
	issues which may exist with respect to this variable.  Check and report briefly (including a brief note per 
	item if there is any concern) on missing values, odd values, extreme values on the low and high end, 
	distribution skewness, value consistency and anything else you think is important.;
	
proc freq data=donor; 
	tables WEALTH_RATING / plots=(freqplot); 
run; 

proc sql noprint; select count(distinct WEALTH_RATING) into: count from donor; quit; 
proc sql noprint; select count(*) into: obs from donor; quit; 
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

	*Note: There are 8,810 missing values for WEALTH_RATING in the dataset (45.5%).  Ratings are from 0-9, but 
	unsure exactly how they derived.  Need to verify with client. There is a steady frequency increase throughout 
	the range of WEALTH_RATING values in the dataset.;
	
	*b.	Using SAS, impute the missing values of WEALTH_RATING using the mode unconditional and PMM conditional 
	approaches.  

		•	The modeling datafile should include ALL 19,372 records (rows). 

		•	The control variables for the PMM conditional approach are MEDIAN_HOME_VALUE, PEP_STAR, and 
		PER_CAPITA_INCOME.

		•	PER_CAPITA_INCOME will be used for the correlation metric.;
		
*NOTE – WEALTH_RATING is already machine numeric.  So, you do NOT need to create a numeric version as shown in 
the lecture slides and can proceed directly to the mode calculation and imputation stages.;		
		

		*i.	Report the findings of your imputations in the following table (report out to 3 decimal places, 
		right justify numeric cell entries):;
	
		*ii. For each imputation, show here the “overlaid histogram” and “overlaid boxplot” produced by 
		PROC SGPLOT (imputed variable vs. observed variable). Make sure that the variable labels used by 	
		SGPLOT clearly differentiate between the observed and imputed variables. Use binwidth = 1 (histogram) 
		and transparency = .5 (histogram and boxplot).;
		
		*Step 1a: Create duplicate of variable to impute;
		
data donor_cat; set donor;
	WEALTH_RATING_mi = WEALTH_RATING;
run;

proc freq data=donor_cat; 
	tables WEALTH_RATING_mi; 
run;

 		*Step 1b: Impute missing values using unconditional mode and output imputed data;	
	
data imputed; set donor_cat;
	if missing(WEALTH_RATING_mi) then WEALTH_RATING_mi=9;
run;

		*Step 1c: Conduct comparative analyses;

proc means data=imputed n nmiss min mean median max std maxdec=3; 
	var  WEALTH_RATING WEALTH_RATING_mi; 
run; 

proc freq data=imputed; 
	tables WEALTH_RATING_mi; 
run;

proc sgplot data=imputed;
	histogram WEALTH_RATING  / binwidth=1 transparency=.5;
	histogram WEALTH_RATING_mi  / binwidth=1 transparency=.5;
run;

proc sgplot data=imputed;
	hbox WEALTH_RATING / transparency=.5;
	hbox WEALTH_RATING_mi / transparency=.5;
run;

proc corr data=imputed; 
	var WEALTH_RATING WEALTH_RATING_mi; 
	with PER_CAPITA_INCOME; 
run;

		*Step 2a: Create duplicate of variable to impute;
		
data donor_cat; set donor;
	WEALTH_RATING_mi = WEALTH_RATING;
run;

proc print data=donor_cat (firstobs=1 obs=25); 
	var WEALTH_RATING WEALTH_RATING_mi; 
run;

 		*Step 2b: Impute missing values using predictive mean matching (PMM) and output imputed data;	
	
proc mi data=donor_cat nimpute=1 seed=12345 out=imputed;
	fcs regpmm(WEALTH_RATING_mi = MEDIAN_HOME_VALUE PEP_STAR PER_CAPITA_INCOME);
	var WEALTH_RATING_mi MEDIAN_HOME_VALUE PEP_STAR PER_CAPITA_INCOME;
run;

		*Step 2c: Conduct comparative analyses;

proc means data=imputed n nmiss min mean median max std maxdec=3; 
	var  WEALTH_RATING WEALTH_RATING_mi; 
run; 

proc freq data=imputed; 
	tables WEALTH_RATING_mi; 
run;

proc sgplot data=imputed;
	histogram WEALTH_RATING  / binwidth=1 transparency=.5;
	histogram WEALTH_RATING_mi  / binwidth=1 transparency=.5;
run;

proc sgplot data=imputed;
	hbox WEALTH_RATING / transparency=.5;
	hbox WEALTH_RATING_mi / transparency=.5;
run;

proc corr data=imputed; 
	var WEALTH_RATING WEALTH_RATING_mi; 
	with PER_CAPITA_INCOME; 
run;

	*c.	Based on the 2 imputations, which one do you recommend be used?  Explain fully.
	
	The predictive mean matching (PMM) imputation is clearly superior to unconditional mode imputation 
	in this application, and probably most applications. The distribution of missing value imputations 
	made sense, and did not just lump them all into one mode value. This was clearly represented in the 
	histogram overlay.  There were 483 observations allocated to a category slightly below zero in the 
	frequency diagram, but those values would appropriately sit with the 0 category. There is probably 
	a parameter setting to keep that from happening.  Nice to see the use of numerical statistics and 
	correlation in this process.  Much of this was taboo for categorical variables with our ANA600/605 
	professor.;
	
*TASK 3;

*Variables with extreme or non-normal distributions make hypothesis testing difficult and can adversely 
affect model fit, depending on the algorithm employed.;

	*1.	Is the distribution of the variable LIFETIME_GIFT_AMOUNT “extreme”?  Explain fully.  Upon what 
	statistic are you basing your analysis?  Use the entire 19,372 row datafile.;	
	
data donor_ext; set donor;
	LIFETIME_GIFT_AMOUNT_ex = LIFETIME_GIFT_AMOUNT;
run;

proc means data=donor_ext n nmiss min mean median max std skew maxdec=3; 
	var  LIFETIME_GIFT_AMOUNT_ex; 
run; 
	
proc sgplot data=donor_ext;
	histogram LIFETIME_GIFT_AMOUNT_ex  / binwidth=10;
run;

proc univariate data=donor_ext;
	var LIFETIME_GIFT_AMOUNT_ex;
	histogram LIFETIME_GIFT_AMOUNT_ex;
run;	

	*The distribution of the LIFETIME_GIFT_AMOUNT variable is heavily skewed to the right (Skew=6.594).
	Some effort to verify some of the extreme values with the client could made, but there is no obvious
	reason to believe that the data is not accurate.  Given that the skew clearly exceeds the standard 
	of 5, it is possible that a transformation could be used to generate a more normal distribution for 
	eventual use of the variable with a predictive model.

	*2.	If it is extreme, manually using Tukey’s Ladder of Powers, identify the single transformation 
	which yields the most normal distribution.  Show the before and after histogram from PROC UNIVARIATE 
	as well as the before and after skewness statistic.;

data donor_ext; set donor_ext;

	cube_LGA_ex			= LIFETIME_GIFT_AMOUNT_ex**3;
	sq_LGA_ex			= LIFETIME_GIFT_AMOUNT_ex**2;
	id_LGA_ex			= LIFETIME_GIFT_AMOUNT_ex**1;
	sqrt_LGA_ex			= LIFETIME_GIFT_AMOUNT_ex**.5;
	log_LGA_ex			= log(LIFETIME_GIFT_AMOUNT_ex);
	inv_sqrt_LGA_ex		= 1/(LIFETIME_GIFT_AMOUNT_ex**.5);
	inv_id_LGA_ex		= 1/(LIFETIME_GIFT_AMOUNT_ex**1);
	inv_sq_LGA_ex		= 1/(LIFETIME_GIFT_AMOUNT_ex**2);
	inv_cube_LGA_ex		= 1/(LIFETIME_GIFT_AMOUNT_ex**3);
	
run;

proc means data=donor_ext skew;
	var cube_LGA_ex sq_LGA_ex id_LGA_ex sqrt_LGA_ex	log_LGA_ex inv_sqrt_LGA_ex inv_id_LGA_ex inv_sq_LGA_ex inv_cube_LGA_ex;
run;

		*The Tukey logarithmic transformation yielded the best skew result (0.041).;

proc sgplot data=donor_ext;
	histogram log_LGA_ex  / binwidth=.25;
run;

proc univariate data=donor_ext;
	var log_LGA_ex;
	histogram log_LGA_ex;
run;

	*3.	Using a BoxCox transformation, can the skewness be further reduced?  Explain fully, including in your answer:
		a.	The optimal lambda and the new skewness value.
		b.	Output chart produced by PROC TRANSREG.;

data donor_ext; set donor_ext;
	z = 0;
run;

proc transreg data=donor_ext maxiter=0 nozeroconstant details;
	model BoxCox(LIFETIME_GIFT_AMOUNT_ex / par=1 lambda=-3 to 3 by .1) = identity(z);
	output out=LGA_ex_t;
run;

proc means data=LGA_ex_t skew;
	var LIFETIME_GIFT_AMOUNT_ex tLIFETIME_GIFT_AMOUNT_ex;
run;

proc sgplot data=LGA_ex_t;
	histogram tLIFETIME_GIFT_AMOUNT_ex  / binwidth=.25;
run;

proc univariate data=LGA_ex_t;
	var tLIFETIME_GIFT_AMOUNT_ex;
	histogram tLIFETIME_GIFT_AMOUNT_ex;
run;

	*The optimal lambda (0) and skew produced by the BoxCox transformation (0.069) does not improve upon 
	what was obtained through the Tukey log transformation (0.041). The histogram distributions are very 
	similar. The t-statistic and variability parameters were slightly better with the BoxCox transformation.
	Believe one could test each of these transformations in a prospective model to see which performs better.
	
	
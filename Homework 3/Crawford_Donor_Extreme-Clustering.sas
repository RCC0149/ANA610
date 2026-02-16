libname Data_610 '/home/u64094997/my_courses/ANA 610/Data_610/Homework 3';

data donor; 
	set Data_610.s_pml_donor_hw_v3; 
run;

*Task #1 (92 pts):

Check the variable LIFETIME_GIFT_AMOUNT for extreme values using the following 5 techniques: 
“PROC EYEBALL”, top/bottom X%, interquartile range, clustering and statistical.  

	1.	First, in table format, perform a quick data integrity check on LIFETIME_GIFT_AMOUNT 
	(using R or SAS) and identify all issues which may exist with respect to this variable.;
	
proc means data=donor n nmiss min mean median max std skew maxdec=3; 
	var  LIFETIME_GIFT_AMOUNT; 
run; 

data check_table;
	input Issue $15. Finding $60.;
	datalines;
	Missing values			0 = 0.00% of dataset (ok)
	Odd values				None (ok)
	Low values				$15 minimum (potentially ok, but could be an outlier.)
	High values 			$3,775 maximum (potentially ok, but likely an outlier.)
	Skewness      			6.594 > 5, candidate for transformation.
	Consistency				All values are integers. (ok)
	Variable name			Name is descriptively appropriate. (ok)
	;
run;
	
proc print data=check_table;
run;

	*2.	Second, using SAS, summarize your findings from the first 4 extreme value checking 
	methods using the following table template. Use the shown Benchmark Parameters and all 
	records in the datafile. Your answers should be supported by SAS code in your submitted 
	SAS program.;

/* Distribution Examination "PROC EYEBALL" */

proc sgplot data=donor;
  	histogram LIFETIME_GIFT_AMOUNT / binwidth = 38;
run;
	  
proc sgplot data=donor;
	hbox LIFETIME_GIFT_AMOUNT;
run;
	
	/* Invoke PROC UNIVARIATE */

proc univariate data=donor; var LIFETIME_GIFT_AMOUNT;
  	histogram LIFETIME_GIFT_AMOUNT / midpoints = 0 to 3800 by 38;  /* PROC MEANS => min = 15 and max = 3775, so make bin width = 38 */
run; 

proc sql; select count(*) from donor where LIFETIME_GIFT_AMOUNT > 750; quit;
   
  	/* Eyeball approach suggests maybe 750 as a cutoff value for extremes on the high end with
  	  19,372 obs with LIFETIME_GIFT_AMOUNT > 750 = 48/19,372 = 0.25%  */

/* Top/Bottom 1% => e.g., EV if value > 99% value*/

%let anal_var = LIFETIME_GIFT_AMOUNT; 

proc means data=donor p1 p99; var &anal_var; output out = stats p1=bot1 p99=top1; run; 
 
proc print data=stats; run;
 	
	/************************************************************************************************************

                                                      SIDEBAR 

   To automate, need to append BOT1 and TOP1 to the dataset donor.  But we cannot use MERGE because
   there is no common field on the datasets donor and stats.
   
   _n_ is a SAS variable automatically created in a DATA step.  It is a counter for the # of times SAS
   has looped through a dataset. */

data donor_show; set donor; rows = _n_; run;  	proc print data=donor_show (firstobs=1 obs=20); var rows; run;
	
data stats_show; set stats; rows = _n_; run;  	proc print data=stats_show (firstobs=1 obs=20); var rows; run;

	/************************************************************************************************************

	Using _n_ = 1, the cols BOT1 and TOP1 can be appended to every row of the dataset donor, starting with the 
	first row of donor. */

data donor_topbot; set donor; if _n_ = 1 then set stats; run;

proc print data=donor_topbot (firstobs=1 obs=20); var control_number LIFETIME_GIFT_AMOUNT bot1 top1; run;

	/* The execution of the top/bottom technique. */

data donor_topbot; set donor; if _n_ = 1 then set stats; 

	if LIFETIME_GIFT_AMOUNT > top1 then ev_LGA = 1; 
	else if LIFETIME_GIFT_AMOUNT < bot1 then ev_LGA = 1; 
	else ev_LGA = 0;	
run;

proc print data=donor_topbot (firstobs=1 obs=10); var LIFETIME_GIFT_AMOUNT bot1 top1 ev_LGA; run;
	
	/* The number of extreme values. */

proc freq data=donor_topbot; tables ev_LGA; run; 
	
proc sql; select count(*) from donor_topbot where &anal_var > top1; 
proc sql; select count(*) from donor_topbot where &anal_var < bot1; 
	

/* Interquartile Range (IQR) => e.g., EV if value > Q3 + multiplier*IQR  */ 
		
%let iqr_mult = 3; 
 
proc means data=donor q1 q3 qrange; var &anal_var; output out = stats q1=q1 q3=q3 qrange=iqr; run; 
  
proc print data=stats (firstobs=1 obs=10); run;
 	
data donor_iqr; set donor; if _n_ = 1 then set stats;  
	if &anal_var > q3 + &iqr_mult*iqr then ev_&anal_var. = 1; 
	else if &anal_var < q1 - &iqr_mult*iqr then ev_&anal_var. = 1; 
	else ev_&anal_var. = 0; 
	
	upper_cutoff = q3 + &iqr_mult*iqr;
	lower_cutoff = q1 - &iqr_mult*iqr;
run; 

proc print data=donor_iqr (firstobs=1 obs=1); var upper_cutoff lower_cutoff; run;

	/* The number of extreme values. */
 
proc freq data=donor_iqr; tables ev_&anal_var.; run; 

proc sql; select count(*) from donor_iqr where &anal_var > upper_cutoff; 
proc sql; select count(*) from donor_iqr where &anal_var < lower_cutoff; 

/* Clusters => e.g., EV if cluster membership < .006% of dataset size. */
             
	/* EV clustering algorithm contained in a "macro program" called clust_ev */ 
 
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
 
%clust_ev(donor,&anal_var,.006, clus_out);  

proc sql; select count(*) from donor where &anal_var > 945; quit; 

*Task #2 (78 pts):  

1.	To avoid model overfitting issues, threshold coding can result in fewer dummy variables 
than there are levels (categories) of the categorical variable.

	a.	First, in table format, perform a quick data integrity check  on RECENT_STAR_STATUS 
	(using R or SAS) and identify all issues which may exist with respect to this variable.;

Title;
proc freq data=donor; 
	tables RECENT_STAR_STATUS / plots=(freqplot); 
run;
	
data check_table2;
	input Issue $20. Finding $60.;
	datalines;
	Distinct Categories		23
	Missing values       	0 = 0.00% of dataset (ok)
	Odd values           	0 values account for 68.34% of 19,372.
	Low values           	0 (Lowest Star Status on Flag)
	High values          	22 (Highest Star Status on Flag)
	Consistency          	All values are integers. (ok)
	Variable name       	Name is descriptively appropriate. (ok)
	;
run;
	
proc print data=check_table2;
run;

	*b.	Calculate the (1) cardinality and (2) cardinality ratio for RECENT_STAR_STATUS.  What 
	does this value imply for the potential recoding methods which can be used?  Explain fully.;
	
proc sql noprint; select count(distinct RECENT_STAR_STATUS) into: count from donor; quit; 
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

	*c.	Show your neatly formatted SAS code here for how you would recode RECENT_STAR_STATUS into
	dummy variables considering a threshold value of 30.  Use descriptive dummy variable names.;

%let anal_var = RECENT_STAR_STATUS;

data donor_df; set donor; run;

	/* Find freq by RECENT_STAR_STATUS and merge onto master. */

proc freq data=donor_df; table &anal_var / out=freq; run;

	proc print data=freq; run; 

	proc sort data=freq; by &anal_var; run;
	proc sort data=donor_df; by &anal_var; run;
	
data dummy; merge donor_df (in=a) freq (in=b); by &anal_var; if a; run;

	proc print data=dummy (firstobs=1 obs=25); var RECENT_STAR_STATUS count; run;

%let threshold = 30;

	/* Use index variable in a do loop to populate dum_RSS0-dum_RSS22. */

data dummy2; set dummy;
	index = RECENT_STAR_STATUS + 1;
	array red(23) dum_RSS0-dum_RSS22;	
		do i = 1 to 23; 
			if (index = i and COUNT ge &threshold) then red(i) = 1; else red(i) = 0;
		end; 

	/* Create "other" dummy variable. */
		
	if sum(of dum_RSS0-dum_RSS22) = 0 then dum_RSS_other = 1; else dum_RSS_other = 0;
run;

	*e.	Execute your code, and 	
	
		ii.	Show here an SAS-generated output table which reports the MIN, MEAN, MAX 
		and STD for each dummy variable (in one table).;
	
proc means data=dummy2 min mean max std; var dum_RSS0-dum_RSS22 dum_RSS_other; run;

	*f.	Using either R or SAS, check that the sum of each dummy variable is indeed at 
	least 30 for each dummy variable that passes the threshold test. 
	
		i.	Show here a code-generated, neatly formatted output table which reports 
		the SUM for each dummy variable.;
	 	
proc means data=dummy2 sum; var dum_RSS0-dum_RSS22 dum_RSS_other; run;	

	*g.	Using either R or SAS, check whether the SUM for each dummy variable is at least 30 
	for each segment of TARGET_B, the target variable for a predictive model of likelihood 
	to donate.
	
		i.	Show here a code-generated, neatly formatted output table which reports the SUM 
		for each dummy variable by target variable segment.;
		
%let target_var = TARGET_B;

proc means data=donor_df noprint nway;
class &anal_var;
var &target_var;
output out=level mean = prop;
run;
proc sort data=level; by descending prop; run;
proc print data=level; format prop percent10.2; run;

proc sort data=donor_df; by &target_var; run;
proc freq data=donor_df;
	table	&anal_var;
	by	&target_var;	
	run;	
	
*2.	In 1(g) you should have found that the threshold is not met for some of your created dummy
variables at the target variable segment level.

	a.	Using either R or SAS, show your neatly formatted code here for how you would then create
	a new set of dummy variables only if the SUM is at least 30 in both TARGET_B segments.;

	/* Find freq2 by segment level and merge onto master. */

proc sort data=donor_df; by &target_var; run;
proc freq data=donor_df noprint; table &anal_var / out=freq2 (drop = percent); by &target_var; run;

		/* Break apart freq2 into two datasets, one for each target segment. */

	data seg_1 seg_0; set freq2;
		if &target_var = 1 then output seg_1;
		if &target_var = 0 then output seg_0; run;
	
			/* Rename column COUNT in each seg dataset. */
	
		data seg_1; set seg_1; count_seg_1 = count; keep &anal_var count_seg_1; run;
		data seg_0; set seg_0; count_seg_0 = count; keep &anal_var count_seg_0; run;	
	
				/* Sort before merge seg_1 and seg_0 onto master dataset. */

			proc sort data=seg_1; by &anal_var; run;
			proc sort data=seg_0; by &anal_var; run;
			proc sort data=donor_df; by &anal_var; run;
	
data dummy_B; merge donor_df (in=a) seg_1 (in=b) seg_0 (in=c); by &anal_var; if a; run;

	proc print data=dummy_B (firstobs=1 obs=25); var RECENT_STAR_STATUS count_seg_1 count_seg_0; run;

	/* Use index variable in a do loop to populate dum_RSSB0-dum_RSSB22. */
	
data dummy_tar; set dummy_B;
	array red(0:22) dum_RSSB0-dum_RSSB22;
		index=RECENT_STAR_STATUS;
		do i = 0 to 22;
			if (index = i and count_seg_1 >= &threshold and count_seg_0 >= &threshold) then red(i) = 1; else red(i) = 0;
		end;

	/* Create "other" dummy variable. */
		
	if sum(of dum_RSSB0-dum_RSSB22) = 0 then dum_RSSB_other = 1; else dum_RSSB_other = 0; run;

	*b.	Show here a code-generated, neatly formatted output table which shows that the SUM for each
	of your dummies created in 2(a) is indeed at least 30 in each TARGET_B segment.;

proc sort data=dummy_tar; by &target_var; run;
	proc means data =dummy_tar sum; var dum_RSSB0-dum_RSSB22 dum_RSSB_other; by &target_var; run;

*Task #3 (50 pts):

Another remedy for sparseness in the levels of categorical variables is to collapse the levels using 
a statistical approach.  Continue considering TARGET_B as the target variable.

Using SAS’s PROC CLUSTER and the process presented in lecture, determine the optimal number of clusters 
for RECENT_STAR_STATUS and create dummy variables for these clusters. 

	1.	Using PROC FREQ, first calculate the Pearson chi-square statistic.  Use RECENT_STAR_STATUS as the 
	row variable and TARGET_B as the column variable.  Is there a statistical association between 
	RECENT_STAR_STATUS and TARGET_B?  Explain fully.  Display relevant output from PROC FREQ.;
	
proc freq data=donor_df;
	table &anal_var*&target_var / chisq;
 	output out=chi(keep=_pchi_) chisq; 
run;
 	
 	*2.	Show the tree chart (dendrogram) created by PROC CLUSTER and indicate your guess of the number of 
 	clusters based solely on this tree chart.  Circle your guesses on the tree chart.  Explain fully your 
 	guess as it relates to just the information shown by this tree chart, specifically the x-axis.;

proc means data=donor_df nway;
	class &anal_var;
	var &target_var;
	output out=level mean = prop;
run;

proc sort data=level; by descending prop; run;
proc print data=level; format prop; run; 	

ods output clusterhistory=cluster;

proc cluster data=level method=ward outtree=fortree;
	freq _freq_;
	var prop;
	id &anal_var; 
run; 	

	*3.	What is the optimal number of clusters?  Explain fully including the statistical logic behind the 
	optimal number.  Support your answer with the plot of the log p-value.;		

proc freq data=donor_df noprint;
	table &anal_var*&target_var / chisq;
 	output out=chi_sq(keep=_pchi_) chisq; 
run;

data cutoff;
	if _n_=1 then set chi_sq;
	set cluster;
	chisquare=_pchi_*rsquared;
	degfree=numberofclusters-1;
	logpvalue=logsdf('CHISQ',chisquare,degfree);
run;

proc print data=cutoff; var NumberOfClusters SemipartialRsq RSquared chisquare logpvalue; run;

proc sgplot data=cutoff;
	series x = NumberOfClusters y = chisquare / markers datalabel=chisquare;
run;

proc sgplot data=cutoff;
	series x = NumberOfClusters y = logpvalue / markers datalabel=logpvalue;
run;

	*4.	Show a table with the cluster assignments of the levels for RECENT_STAR_STATUS.  Show and discuss 
	why your guess of the number of clusters did or did not differ from the optimal number.;

proc sql;
	select NumberOfClusters into :ncl
	from cutoff
	having logpvalue=min(logpvalue);
quit;

%put &ncl;

proc tree data=fortree nclusters=&ncl out=clus noprint;
	id &anal_var;
run;

	proc sort data=clus;
		by clusname;
	run;
	
		title1 "Levels of Categorical Variable by Cluster";
		proc print data=clus;
			by clusname;
			id clusname;
		run;
		
	*5.	Show your neatly formatted SAS code for how you would create dummy variables (with descriptive names)
	for these cluster assignments.;	
	
data clus2; set clus; drop clusname; run;
	proc sort data=clus2; by &anal_var; run;
	proc sort data=donor_df; by &anal_var; run;
		data scored; merge donor_df (in=a) clus2 (in=b); by &anal_var; if a;
			dum_RSS_clus1=(cluster=1);
			dum_RSS_clus2=(cluster=2);
			dum_RSS_clus3=(cluster=3);
		run;	
		
		
		proc means data=scored sum; var dum_RSS_clus1-dum_RSS_clus3; run;
		
	*6.	Show a SAS output table with the frequencies of the new cluster dummy variables.;

		proc sort data=scored; by &target_var; run;
			proc means data=scored sum; var dum_RSS_clus1-dum_RSS_clus3; by &target_var; run;
		
	*7.	Check and show here, using the relevant SAS output table, that for each cluster dummy variable, SUM is 
	at least 30 in each TARGET_B segment.;
	
		proc means data=scored sum noprint; var dum_RSS_clus1-dum_RSS_clus3; output out=tmp_sum (drop = _TYPE_ _FREQ_)
			sum = dum_RSS_clus1-dum_RSS_clus3; by &target_var; run;
				proc transpose data=tmp_sum out=tmp_sum_t; run;
					proc print data=tmp_sum_t; run;
					
*Extra Credit (45 pts):

Task #1

As we have seen, variable transformation can make a distribution “more normal” and, thus, can reduce, if not 
eliminate, any model leverage resulting from extreme values.

1.	Using SAS, transform LIFETIME_GIFT_AMOUNT by applying the log() function.  Show, side by side, the before 
and after histograms along with the before and after skewness values.

	Perform assessment of LIFETIME_GIFT_AMOUNT.;

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

	*Perform requested logarithmic transformation of LIFETIME_GIFT_AMOUNT distribution.;

data donor_ext; set donor_ext;
	log_LGA_ex			= log(LIFETIME_GIFT_AMOUNT_ex);	
run;

proc means data=donor_ext n nmiss min mean median max std skew maxdec=3; 
	var  log_LGA_ex; 
run; 

proc sgplot data=donor_ext;
	histogram log_LGA_ex  / binwidth=.25;
run;

proc univariate data=donor_ext;
	var log_LGA_ex;
	histogram log_LGA_ex;
run;

*2.	Test for extreme values using the log version of LIFETIME_GIFT_AMOUNT.  Use the clustering method with pmin=.006.;
					
/* Clusters => e.g., EV if cluster membership < .006% of dataset size. */
             
	/* EV clustering algorithm contained in a "macro program" called clust_ev */ 
 
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
 
%clust_ev(donor_ext,log_LGA_ex,.006, clus_out);  

proc sql; select count(*) from donor_ext where log_LGA_ex > 7.47590; quit; 

*Task #2

After this reduction (see Task #3 above) in the spareness of the levels of RECENT_STAR_STATUS, using SAS’s 
PROC FREQ, calculate the new Pearson chi-square statistic.  Is there still a statistical association between 
RECENT_STAR_STAUS and TARGET_B?  Explain fully and show relevant output from PROC FREQ.;

proc freq data=scored;
	table dum_RSS_clus1-dum_RSS_clus3*&target_var / chisq;
 	output out=chi(keep=_pchi_) chisq; 
run; 

*Task #4

Using either SAS or R, create a supervised ratio variable for RECENT_STAR_STATUS which applies an overall threshold of 30.

1.	Show here a code-generated, neatly formatted output table which has the following columns: (i) RECENT_STAR_STATUS 
Category, (ii) total frequency(count), (iii) frequency TARGET_B = 1, (iv) frequency TARGET_B = 0, and (v)the supervised ratio;

/* calculates WOE from odds POV */

%macro WOEOdds(dsin,dsout,var,target);

proc sort data=&dsin; by &var; run;

/* calculate # events and odds for each level */
proc means data=&dsin sum noprint; var &target; by &var; output out=level_sum (drop= _TYPE_) sum = events; run;

	data level_sum; set level_sum; 
		non_events = _freq_ - events;
		odds_event = events/non_events;
	run;
		
/* calculate # events and odds for entire sample */
proc means data=&dsin sum noprint; var &target;  output out=total_sum (drop= _TYPE_) sum = tot_events; run;

	data total_sum; set total_sum; 
		tot_non_events 	=	_FREQ_ - tot_events;
		tot_odds_event  = 	tot_events/tot_non_events;
		tot_obs			= 	_FREQ_;
		drop _FREQ_;
	run;
	
/* merge level with total data and compute stats */	
data level_sum; 
	if _n_ = 1 then set work.total_sum;
	set level_sum; 
	odds_ratio		=	odds_event / tot_odds_event;
	woe 			=	log(odds_ratio);
	pct_events		=	(events/tot_events);	
	pct_non_events 	= 	(non_events/tot_non_events);
	iv				=	((pct_events)-(pct_non_events))*woe;
run;	

/* print out results */	
	proc print data=level_sum; var &var _freq_ events non_events odds_event odds_ratio woe iv; run;
/* get the variable-level IV */	
	proc sql; select sum(iv) into: IV from level_sum; quit;	
	
/* append WOE to dataset */
data level_sum2; set level_sum; keep &var woe ; run;
	proc sort data=level_sum2; by &var; run;
	proc sort data=&dsin; by &var; run;
		data &dsout; merge &dsin(in=a) level_sum2(in=b); by &var; if a; run;
%mend;

%WOEOdds(donor_df,donor_woe,&anal_var,&target_var);



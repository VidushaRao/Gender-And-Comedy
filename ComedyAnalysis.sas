libname c "C:\Users\Vidusha\Documents\MSA\SideProjectIdeas\comedy";

/* import csv data */
proc import datafile='C:\Users\Vidusha\Documents\MSA\SideProjectIdeas\comedy\ccp_updated.csv'
			out=c.ccp
			dbms=csv
			replace;
run;

/* overview of data */
proc contents data=c.ccp order=varnum;
run;

/* keep only necessary vars */
/* create new vars for other analysis */
data c.ccp;
	set c.ccp;
	drop imdb_id id appearance_number;
	year = year(original_air_date);
	if original_air_date < '31dec2005'd then timezone = 1;
	else  timezone = 2;
run;

proc export data=c.ccp
			outfile = 'C:\Users\Vidusha\Documents\MSA\SideProjectIdeas\comedy\SasComedy.csv'
			dbms = csv
			replace;
run;

/* order and output series data */
proc sort data=c.ccp;
	by episode_number_overall;
run;

proc means data=c.ccp n mean median min max std;
	class timezone gender;
	var user_rating;
run;

proc sgplot data=c.ccp;
	scatter x=episode_number_overall y=user_rating;
	series x=episode_number_overall y=user_rating;
run;

/* very slight downward trend of user ratings */

/* comparisons by gender */
/* difference in ratings based on gender present. potentially significant difference */

proc means data=c.ccp n mean median min max std;
	class gender;
	var user_rating;
run;

/* ASSUMPTIONS */

* 1) assume independence for data points;
* 2) Insignificant evidence for difference in variance;
* 3) slight kurtosis and skewness present in distributions,
	but M sample size is large enough;

proc glm data=c.ccp plots=diagnostics;
	class gender;
	model user_rating = gender;
	means gender / hovtest = levene;
run;

proc univariate data=c.ccp;
	class gender;
	var user_rating;
	histogram user_rating;
run;

*Gender and timezone interaction;

proc glm data=c.ccp plots=diagnostics;
	class gender timezone;
	model user_rating = gender|timezone;
	means gender / hovtest = levene;
	lsmeans gender timezone / pdiff=all adjust=tukey;
run;

proc univariate data=c.ccp;
	class gender timezone;
	var user_rating;
	histogram user_rating;
run;
/* comparison by time zones (cut offs at 9/11 and 2008 recession) */
proc means data=c.ccp n mean median min max std;
	class timezone;
	var user_rating;
run;

/* ASSUMPTIONS */

* 1) assume independence for data points;
* 2) Insignificant evidence for difference in variance;
* 3) TZ 2 is more normal than the TZ 0 and 1. 
	TZ 0 and 1 have slight negative skew;

*timezone;
proc means data=c.ccp n mean median min max std;
	class timezone;
	var user_rating;
run;

proc glm data=c.ccp;
	class timezone;
	model user_rating = timezone;
	means timezone / hovtest = levene;
	lsmeans timezone / pdiff=all adjust=tukey;
run;

proc univariate data=c.ccp;
	class timezone;
	var user_rating;
	histogram user_rating;
run;

/* try NPAR1WAY */
*gender;
proc npar1way data=c.ccp;
	class gender;
	var user_rating;
	output out=test anova median;
run;

*time period;
proc npar1way data=c.ccp;
	class timezone;
	var user_rating;
	output out=test anova median;
run;


/* by season 
proc means data=c.ccp n mean median min max std;
	class season;
	var user_rating;
run;

proc glm data=c.ccp;
	class season;
	model user_rating = season;
run;

/* comparing ratings to vote numbers 
proc reg data=c.ccp;
	where user_votes < 100;
	model user_rating = user_votes;
run;
quit;

/*seeing what the deal is with timeseries and comedy (lots of missing dates) 
proc sort data=c.ccp;
	by original_air_date;
run;
proc timeseries data=c.ccp plots=(series) seasonality=2;
	id original_air_date interval=year accumulate=average;
	var user_rating;
run;
*/

/* comparisons by year 
proc means data=c.ccp n mean median min max std;
	class year;
	var user_rating;
run;

proc glm data=c.ccp;
	class year;
	model user_rating = year;
run;

*/

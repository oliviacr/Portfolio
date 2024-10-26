ods graphics off;
OPTIONS NOFMTERR;

libname Midus 'C:\Users\olivi\Box\Midus MZ\Analysis';

data MZtwin; set Midus.midus_mztwins_discordance_2;
data MZWITHtwin; set Midus.midus_mzwithtwins_2;

/*inital data checks*/

* Check frequencies of discordance;
proc freq data=MZtwin; table MMB1wt_Dis MMB2wt_Dis MMB3wt_Dis; run;

* Check distribution of differences in # of chronic conditions across twins in families;
proc univariate; var  MMB1wt_Diff; 
histogram; run;

* Check changes over time;
proc freq; table 
MMB1wt_Dis*MMB2wt_Dis MMB2wt_Dis*MMB3wt_Dis MMB1wt_Dis*MMB3wt_Dis;
run;

/* Additional data prep */
data outcomeprep; set MZtwin;

* Create identifier variables that note which twin has the higher levels;
if MMB1wt_1 gt MMB1wt_2 then MMB1wt_greater=1;
else if MMB1wt_1 lt MMB1wt_2 then MMB1wt_greater=2;

if m1adl_1 gt m1adl_2 then m1adl_greater=1;
else if m1adl_1 lt m1adl_2 then m1adl_greater=2;

if m2adl_1 gt m2adl_2 then m2adl_greater=1;
else if m2adl_1 lt m2adl_2 then m2adl_greater=2;

if m1pwb_1 gt m1pwb_2 then m1pwb_greater=1;
else if m1pwb_1 lt m1pwb_2 then m1pwb_greater=2;

if m2pwb_1 gt m2pwb_2 then m2pwb_greater=1;
else if m2pwb_1 lt m2pwb_2 then m2pwb_greater=2;
RUN;
/* data checks */

* Test whether the outcome is greater in the twin with more chronic conditions;
proc freq; table MMB1_greater*m1adl_greater MMB1wt_greater*m1adl_greater
				 MMB1_greater*m2adl_greater MMB1wt_greater*m2adl_greater

 				 MMB1_greater*m1pwb_greater MMB1wt_greater*m1pwb_greater
				 MMB1_greater*m2pwb_greater MMB1wt_greater*m2pwb_greater
/chisq;
run;
* Cross-tabs generally suggest that the MZ twin with the higher chronic conditions has the higher ADLs
but, the twin with the higher chronic conditions does not have higher/lower wellbeing than his/her co-twin;

proc freq data=mztwin; table m1age_1*m1age_2 m1female_1*m1female_2 m1nonwhite_1*m1nonwhite_2 m1educcats_1*m1educcats_2; run;

* Sort data for merging;
proc sort data= OutcomePrep; by M2FAMNUM; run;
proc sort data= MZwithtwin; by M2FAMNUM; run;

/* Create within-family and between-family variables for MLMs */

* Merge this dataset back into the long dataset for use in MLM;
data Multilevel; merge OutcomePrep MZwithtwin; by M2FAMNUM; 

* Create family average variables (between-family covariates);
MMB1wt_famave=mean(MMB1wt_1, MMB1wt_2);
m1adl_famave=mean(m1adl_1, m1adl_2);
m1pwb_famave=mean(m1pwb_1, m1pwb_2);
m1smoke_famave=mean(m1smoke_1,m1smoke_2);
m1female_famave=mean(m1female_1,m1female_2);
m1age_famave=mean(m1age_1,m1age_2);
m1educcats_famave=mean(m1educcats_1,m1educcats_2);

*Create family average variables M2 for discordance %;
MMB2wt_famave=mean(MMB2wt_1, MMB2wt_2);
m2adl_famave=mean(m2adl_1, m2adl_2);
m2pwb_famave=mean(m2pwb_1, m2pwb_2);

* Create twin-specific variables (within-family centered variables);
if twin=1 then do;
MMB1wt_twspec=MMB1wt_1-MMB1wt_famave;
m1adl_twspec=m1adl_1-m1adl_famave;
m1pwb_twspec=m1pwb_1-m1pwb_famave;
m1smoke_twspec=m1smoke_1-m1smoke_famave;
m1educcats_twspec=m1educcats_1-m1educcats_famave;
end;

if twin=2 then do;
MMB1wt_twspec=MMB1wt_2-MMB1wt_famave;
m1adl_twspec=m1adl_2-m1adl_famave;
m1pwb_twspec=m1pwb_2-m1pwb_famave;
m1smoke_twspec=m1smoke_2-m1smoke_famave;
m1educcats_twspec=m1educcats_2-m1educcats_famave;
end;

* Create twin-specific variables for discordance % at m2 (within-family centered variables);
if twin=1 then do;
MMB2wt_twspec=MMB2wt_1-MMB2wt_famave;
m2adl_twspec=m2adl_1-m2adl_famave;
m2pwb_twspec=m2pwb_1-m2pwb_famave;
end;

if twin=2 then do;
MMB2wt_twspec=MMB2wt_2-MMB2wt_famave;
m2adl_twspec=m2adl_2-m2adl_famave;
m2pwb_twspec=m2pwb_2-m2pwb_famave;
end;

run;
/* Data Check4; set multilevel; keep twin m2adl_twspec m2adl_2 m2adl_famave; run; */

proc means data=multilevel;
var MMB1wt MMB1wt_famave m1adl  m1adl_famave m1pwb_famave
m1smoke_famave m1female_famave m1age_famave m1educcats_famave
MMB1wt_twspec m1adl_twspec m1pwb_twspec m1smoke_twspec m1educcats_twspec;
run;

/* Means and frequencies for descriptives table*/
proc freq data=multilevel; table m1smoke m1educcats m1female; RUN;
proc means data=multilevel;
var m1age m1pwb m2pwb MMB1wt MMB2wt m1adl m2adl;
run;

Proc corr data= multilevel; var MMB1wt_famave
m1adl_famave
m1pwb_famave
m1smoke_famave
m1female_famave
m1age_famave
m1educcats_famave; Run;

data centered; set Multilevel;
MMB1wt				=	MMB1wt				-	1.0442805	;
MMB1wt_famave		=	MMB1wt_famave		-	1.0442805	;
m1adl				=	m1adl				-	1.272966	;
m1adl_famave		=	m1adl_famave		-	1.2699259	;
m1pwb_famave		=	m1pwb_famave		-	16.8961095	;
m1smoke_famave		=	m1smoke_famave		-	1.6657061	;
m1female_famave		=	m1female_famave		-	0.4596542	;
m1age_famave		=	m1age_famave		-	44.0778098	;
m1educcats_famave	=	m1educcats_famave	-	1.9221902	;

m1smoke_1 = m1smoke_1-1;
m1smoke_2 = m1smoke_2-1;

if m2famnum=120892 then delete;

File 'C:\Users\olivi\Box\Midus MZ\Analysis\Mplus Version\MidusMZ_Mplus.dat';
put m2famnum MMB1wt MMB2wt m1adl m2adl m1adl_famave m1adl_twspec
MMB1wt_famave MMB1wt_twspec
m1pwb_famave m1pwb_twspec 
m1educcats_twspec m1educcats_famave
m1smoke_famave m1smoke_twspec m1age_famave m1female_famave;
run;

* Mixed Method;

/* Model build for paper */

/* Number of Conditions */

/* 1. ICC */

PROC MIXED DATA=centered NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL MMB2wt =  
				  /SOLUTION DDFM=BW NOTEST; 
 RANDOM intercept /SUBJECT=M2FAMNUM TYPE=VC GCORR; 
RUN;

/* 2. Covariates-only baseline */

PROC MIXED DATA=centered NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL MMB2wt = 
m1smoke_famave m1smoke_twspec
m1female_famave m1age_famave m1educcats_famave m1educcats_twspec MMB1wt/SOLUTION DDFM=BW NOTEST; 
 RANDOM intercept /SUBJECT=M2FAMNUM TYPE=VC GCORR; 
RUN;

/* 3. Test of ADLS */

PROC MIXED DATA=Multilevel NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL MMB2wt = m1adl_famave m1adl_twspec
m1smoke_famave m1smoke_twspec
m1smoke_famave m1smoke_twspec
m1female_famave m1age_famave m1educcats_famave m1educcats_twspec MMB1wt/SOLUTION DDFM=BW NOTEST; 
 RANDOM intercept /SUBJECT=M2FAMNUM TYPE=VC GCORR; 
RUN;

/* 4. Test of moderation by Well-being */
PROC MIXED DATA=Multilevel NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL MMB2wt = m1adl_famave m1adl_twspec
				m1pwb_famave m1pwb_twspec 
				m1adl_twspec*m1pwb_twspec 
m1smoke_famave m1smoke_twspec
m1female_famave m1age_famave m1educcats_famave m1educcats_twspec MMB1wt/SOLUTION DDFM=BW NOTEST; 
 RANDOM intercept /SUBJECT=M2FAMNUM TYPE=VC GCORR; 
RUN;

/* Functional Limitations */

/* 1. ICC */


PROC MIXED DATA=Multilevel NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL m2adl =  
				  /SOLUTION DDFM=BW NOTEST; 
 RANDOM intercept /SUBJECT=M2FAMNUM TYPE=VC GCORR; 
RUN;

/* 2. Covariates-only baseline */

PROC MIXED DATA=Multilevel NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL m2adl = 
m1smoke_famave m1smoke_twspec
m1female_famave m1age_famave m1educcats_famave m1educcats_twspec m1adl/SOLUTION DDFM=BW NOTEST; 
 RANDOM intercept /SUBJECT=M2FAMNUM TYPE=VC GCORR; 
RUN;

/* 3. Test of Chronic Conditions */

PROC MIXED DATA=Multilevel NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL m2adl = MMB1wt_famave MMB1wt_twspec
m1smoke_famave m1smoke_twspec
m1female_famave m1age_famave m1educcats_famave m1educcats_twspec m1adl/SOLUTION DDFM=BW NOTEST; 
 RANDOM intercept /SUBJECT=M2FAMNUM TYPE=VC GCORR; 
RUN;

/* 4. Test of moderation by Well-being */
PROC MIXED DATA=Multilevel NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL m2adl = MMB1wt_famave MMB1wt_twspec
				m1pwb_famave m1pwb_twspec 
				MMB1wt_twspec*m1pwb_twspec 
m1smoke_famave m1smoke_twspec
m1female_famave   m1educcats_famave m1educcats_twspec m1adl/SOLUTION DDFM=BW NOTEST; 
 RANDOM intercept /SUBJECT=M2FAMNUM TYPE=VC GCORR; 
RUN;

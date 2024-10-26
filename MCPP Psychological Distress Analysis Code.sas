
/* Data Prep and Analysis Code for Hair Hormones & Subjective Stress Paper*/
libname MCPP 'C:\Users\olivi\Box\MCPP (L2 Sensitive)\Data (except methylation)\Cleaned & Scaled Data';
libname birth 'C:\Users\olivi\Box\MCPP (L2 Sensitive)\Data (except methylation)\Cleaned & Scaled Data';
libname hair 'C:\Users\olivi\Box\MCPP (L2 Sensitive)\Data (except methylation)\Hair Hormones';
libname pri_lib 'C:\Users\olivi\Box\MCPP (L2 Sensitive)\Data Prep\Working PRI Scripts'; 
options nofmterr;

data hh; set hair.cleanedhairhormones_wide; id1=id*1; drop ID; run;
data t1; set mcpp.cleanedscaledt1_2020_09_29; id1=id*1; drop ID; keep id1 DE51T1r DE52T1r stait1 psst1 PRAT1 LECT1_NEG BMIT1 BDIT1 BAIT1 PSC26T1 DE03T1; run;
data t2; set mcpp.cleanedscaledt2_2020_09_29; id1=id*1; drop ID; keep id1 stait2 psst2 PRAT2 BDIT2 BAIT2 PSC26T2 DE03T2; run;
data t3; set mcpp.cleanedscaledt3_2020_09_29; id1=id*1; drop ID; keep id1 stait3 psst3 PRAT3 LECT3_NEG BDIT3 BAIT3 PSC26T3 DE03T3; run;
data t1_np; set mcpp.cleanscaledt1_np; id1=id*1; drop ID; keep id1 DE51T1r DE52T1r stait1 psst1 LECT1_NEG BMIT1 BDIT1 BAIT1 PSC26T1 DE03T1; run;
data t2_np; set mcpp.cleanscaledt2_np; id1=id*1; drop ID; keep id1 stait2 psst2 BDIT2 BAIT2 PSC26T2 DE03T2; run;
data t3_np; set mcpp.cleanscaledt3_np; id1=id*1; drop ID; keep id1 stait3 psst3 LECT3_NEG BDIT3 BAIT3 PSC26T3 DE03T3; run;

proc sort data=hh; by id1; run;
proc sort data=T1; by id1; run;
proc sort data=T2; by id1; run;
proc sort data=T3; by id1; run;
proc sort data=T1_np; by id1; run;
proc sort data=T2_np; by id1; run;
proc sort data=T3_np; by id1; run;

proc import 
datafile="C:\Users\olivi\Box\MCPP (L2 Sensitive)\Data (except methylation)\Genetic Data\Combined_MCPP_Data_02012021_OR_twindeleted.xlsx"
	out=sex
	DBMS=xlsx 
    replace;
    getnames=yes; 
run;

Data sex; set sex; id1=id*1; drop ID; keep id1 sex; run;
proc sort data=sex; by id1; run;

Data merged; merge t1 t2 t3 t1_np t2_np t3_np hh sex; by id1; id=id1; drop id1; if ID=. then delete; run;

/* Bring in Covariates */
proc import 
		datafile="C:\Users\olivi\Box\MCPP (L2 Sensitive)\Data (except methylation)\Cleaned & Scaled Data\All demographics.csv"
		out=demog
		DBMS=csv 
        replace;
     getnames=yes;
run;

proc import 
		datafile="C:\Users\olivi\Box\MCPP (L2 Sensitive)\Data (except methylation)\Cleaned & Scaled Data\all visit ages.csv" 
		out=Vdatesages
		DBMS=csv 
        replace;
     getnames=yes;  
run;

proc contents data=Vdatesages; run;

proc import
		datafile="C:\Users\olivi\Box\MCPP (L2 Sensitive)\Data (except methylation)\contraception.csv"
		out=OCuse
		DBMS=csv 
        replace;
     getnames=yes;
run;

data ethnicity_raw; set MCPP.ethnicity; if ID=19 and raceth=. then delete;  run;
data ethnicity;
    set ethnicity_raw;
    format _all_;
RUN;

data pri; set pri_lib.pri_eprfinal; run; 

proc sort data=merged; by id;
proc sort data=OCuse; by id;
proc sort data=Vdatesages; by id;
proc sort data=demog; by id;
proc sort data=ethnicity; by id; run;

Data merged2; set merged;
zstait1=stait1;
zpsst1=psst1;
zPRAT1=PRAT1;
zBDIT1=BDIT1;
zBAIT1=BAIT1; 
zstait2=stait2;
zpsst2=psst2; 
zPRAT2=PRAT2;
zBDIT2=BDIT2;
zBAIT2=BAIT2;
zstait3=stait3;
zpsst3=psst3;
zPRAT3=PRAT3;
zBDIT3=BDIT3;
zBAIT3=BAIT3;run;

PROC STANDARD DATA=merged2 MEAN=0 STD=1 OUT=zstress; 
  VAR zstait1 zpsst1 zPRAT1 zBDIT1 zBAIT1 
zstait2 zpsst2 zPRAT2 zBDIT2 zBAIT2
zstait3 zpsst3 zPRAT3 zBDIT3 zBAIT3; 
RUN;

PROC MEANS data=merged2 n mean stddev min max skew kurt; 
var cort_BatchRmv_T1 cort_BatchRmv_T2 cort_BatchRmv_T3 
DHEA_BatchRmv_T1 DHEA_BatchRmv_T2 DHEA_BatchRmv_T3 
TESTO_BatchRmv_T1 TESTO_BatchRmv_T2 TESTO_BatchRmv_T3;
RUN; 
/* Medication check: data mcheck; set merged; keep ID PSC26T1 PSC26T2 PSC26T3; run; */

data All; 
merge zstress OCuse Vdatesages demog ethnicity pri; by ID; 

if hormonal ne 1 and missing ne 1 and pregnant = 0 then hormonal =0; 

mo_of_visit1 = put( visit1, month.); 
mo_of_visit2 = put( visit2, month.);
mo_of_visit3 = put( visit3, month.);
mo_of_visit4 = SUBSTR( visit4, 6, 2);

array months mo_of_visit1 mo_of_visit2 mo_of_visit3 mo_of_visit4;
array season $6 seasont1 seasont2 seasont3 season6mo;

do over months;
if months in ("12", "01", "02") then season="winter";
if months in (12, 1, 2) then season="winter";
if months in ("03", "04", "05") then season="spring";
if months in (3, 4, 5) then season="spring";
if months in ("06", "07", "08") then season="summer";
if months in (6, 7, 8) then season="summer";
if months in ("09","10","11") then season="fall";
if months in (9, 10, 11) then season="fall";
end;

yrsV4=age6m-ageT3; 

wksT1_T1=0;
IF (wksT2_T1 NE . AND wksT3_T2 NE .) then wksT3_T1 = wksT2_T1+wksT3_T2;

stai=mean(stait1, stait2, stait3);
pss=mean(psst1, psst2, psst3);
BDI=mean(BDIT1, BDIT2, BDIT3);
BAI=mean(BAIT1, BAIT2, BAIT3);

cort_dhea1=cort_BatchRmv_T1/dhea_BatchRmv_T1;
cort_dhea2=cort_BatchRmv_T2/dhea_BatchRmv_T2;
cort_dhea3=cort_BatchRmv_T3/dhea_BatchRmv_T3;

logcort_BatchRmv_T1 = LOG(cort_BatchRmv_T1+15.0510551);
logcort_BatchRmv_T2 = LOG(cort_BatchRmv_T2+14.6010551); 
logcort_BatchRmv_T3 = LOG(cort_BatchRmv_T3+9.5000000); 

logDHEA_BatchRmv_T1 = LOG(DHEA_BatchRmv_T1+19.1621219);
logDHEA_BatchRmv_T2 = LOG(DHEA_BatchRmv_T2+17.2106019); 
logDHEA_BatchRmv_T3 = LOG(DHEA_BatchRmv_T3+16.5862950); 

logcort_dhea1= LOG((cort_BatchRmv_T1+15.0510551)/(dhea_BatchRmv_T1+19.1621219));
logcort_dhea2=LOG((cort_BatchRmv_T2+14.6010551)/(dhea_BatchRmv_T2+17.2106019));
logcort_dhea3=LOG((cort_BatchRmv_T3+9.5000000)/(dhea_BatchRmv_T3+16.5862950));

cort_testo1=cort_BatchRmv_T1/testo_BatchRmv_T1;
cort_testo2=cort_BatchRmv_T2/testo_BatchRmv_T2;
cort_testo3=cort_BatchRmv_T3/testo_BatchRmv_T3;

logtesto_BatchRmv_T1 = LOG(testo_BatchRmv_T1+2.3527454);
logtesto_BatchRmv_T2 = LOG(testo_BatchRmv_T2+2.8108254); 
logtesto_BatchRmv_T3 = LOG(testo_BatchRmv_T3+2.2087854);

logcort_testo1=LOG((cort_BatchRmv_T1+15.0510551)/(testo_BatchRmv_T1+2.3527454));
logcort_testo2=LOG((cort_BatchRmv_T2+14.6010551)/(testo_BatchRmv_T2+2.8108254));
logcort_testo3=LOG((cort_BatchRmv_T3+9.5000000)/(testo_BatchRmv_T3+2.2087854)); 

cstress_both1=mean(zstait1, zpsst1, zBDIT1, zBAIT1);
cstress_both2=mean(zstait2, zpsst2, zBDIT2, zBAIT2);
cstress_both3=mean(zstait3, zpsst3, zBDIT3, zBAIT3);

cstress_preg1=mean(zstait1, zpsst1, zPRAT1, zBDIT1, zBAIT1);
cstress_preg2=mean(zstait2, zpsst2, zPRAT2, zBDIT2, zBAIT2);
cstress_preg3=mean(zstait3, zpsst3, zPRAT3);

/* Medication variable */

Med1=0;
Med2=0;
Med3=0;

if DE03T1 = . then Med1 = .;
if DE03T2 = . then Med2 = .;
if DE03T3 = . then Med3 = .;

if ID = 28 then Med1 = 1;

if ID = 40 then Med1 = 1;
if ID = 40 then Med2 = 1;
if ID = 40 then Med3 = 1;

if ID = 42 then Med1 = 1;
if ID = 42 then Med2 = 1;
if ID = 42 then Med3 = 1;

if ID = 43 then Med1 = 1;
if ID = 43 then Med2 = 1;
if ID = 43 then Med3 = 0;

if ID = 1015 then Med1 = 1;
if ID = 1015 then Med2 = 1;
if ID = 1015 then Med3 = 0;

if ID = 1017 then Med1 = 1;
if ID = 1017 then Med2 = 1;
if ID = 1017 then Med3 = 1;

if ID = 1020 then Med1 = 1;
if ID = 1020 then Med2 = 1;
if ID = 1020 then Med3 = 1;

if ID = 1022 then Med1 = 1;
if ID = 1022 then Med2 = 1;
if ID = 1022 then Med3 = 1;

if ID = 1030 then Med1 = 0;
if ID = 1030 then Med2 = 1;
if ID = 1030 then Med3 = 1;

run;
/* data check; set all; keep ID Med1 Med2 Med3; run; */
/* data check; set all; keep ID cort_BatchRmv_T2 logcort_BatchRmv_T2 cort_dhea2 logcort_dhea2 DHEA_BatchRmv_T2 logDHEA_BatchRmv_T2 logcort_dhea1; run; */

/* Histograms of unlogged/logged hormones */
proc univariate data=all;
  var cort_BatchRmv_T1 logcort_BatchRmv_T1 cort_BatchRmv_T2 logcort_BatchRmv_T2 cort_BatchRmv_T3 logcort_BatchRmv_T3
DHEA_BatchRmv_T1 logDHEA_BatchRmv_T1 DHEA_BatchRmv_T2 logDHEA_BatchRmv_T2 DHEA_BatchRmv_T3 logDHEA_BatchRmv_T3
cort_dhea1 cort_dhea2 cort_dhea3 logcort_dhea1 logcort_dhea2 logcort_dhea3
testo_BatchRmv_T1 logtesto_BatchRmv_T1 testo_BatchRmv_T2 logtesto_BatchRmv_T2 testo_BatchRmv_T3 logtesto_BatchRmv_T3
cort_testo1 cort_testo2 cort_testo3 logcort_testo1 logcort_testo2 logcort_testo3;
histogram;
run;

/* Descriptives unlogged/logged hormones */
PROC MEANS data=all n mean stddev min max skew kurt; 
var cort_BatchRmv_T1 logcort_BatchRmv_T1 cort_BatchRmv_T2 logcort_BatchRmv_T2 cort_BatchRmv_T3 logcort_BatchRmv_T3
DHEA_BatchRmv_T1 logDHEA_BatchRmv_T1 DHEA_BatchRmv_T2 logDHEA_BatchRmv_T2 DHEA_BatchRmv_T3 logDHEA_BatchRmv_T3
cort_dhea1 cort_dhea2 cort_dhea3 logcort_dhea1 logcort_dhea2 logcort_dhea3
testo_BatchRmv_T1 logtesto_BatchRmv_T1 testo_BatchRmv_T2 logtesto_BatchRmv_T2 testo_BatchRmv_T3 logtesto_BatchRmv_T3
cort_testo1 cort_testo2 cort_testo3 logcort_testo1 logcort_testo2 logcort_testo3;
RUN; 

/* Correlations */ 
proc sort data=all; by pregnant; run;
/* alphas for cstress_preg vars*/
proc corr alpha; where pregnant=1;
var stait1 psst1 PRAT1 BDIT1 BAIT1; 
run;
*PRA drags alpha down, not highly correlated with other scores;

proc corr alpha; where pregnant=1;
var stait2 psst2 PRAT2 BDIT2 BAIT2;
run;
*PRA drags alpha down, not highly correlated with other scores;

proc corr alpha; where pregnant=1;
var stait3 psst3 PRAT3 BDIT3 BAIT3;
run;
*PRA is somewhat more correlated, removing BAI helps the alpha the most;

/* alphas for cstress_both vars within and across groups*/
proc corr alpha; by pregnant;
var stait1 psst1 BDIT1 BAIT1; 
run;
*alpha is lower for pregnant group, BAI is lowest corr with other scores;

proc corr alpha; by pregnant;
var stait2 psst2 BDIT2 BAIT2;
run;
*alphas are more even, BAI score are slighty more highly correlated with other scales;

proc corr alpha; by pregnant;
var stait3 psst3 BDIT3 BAIT3;
run;
*.91/.86;

proc corr alpha; 
var stait1 psst1 BDIT1 BAIT1; 
run;
*.86;

proc corr alpha; 
var stait2 psst2 BDIT2 BAIT2;
run;
*.82;

proc corr alpha;
var stait3 psst3 BDIT3 BAIT3;
run;
*.90;

proc sort data=all; by pregnant; run;

/**************************** For Descriptive Part of Results ************************************************/

proc sort data=all; by pregnant; run;
proc corr data=all; by pregnant;
var stait1 psst1 PRAT1 BDIT1 BAIT1 cstress_both1
stait2 psst2 PRAT2 BDIT2 BAIT2 cstress_both2
stait3 psst3 PRAT3 BDIT3 BAIT3 cstress_both3;
run;

proc corr data=all; by pregnant;
var cort_BatchRmv_T1 dhea_BatchRmv_T1 testo_BatchRmv_T1 cort_dhea1 cort_testo1
cort_BatchRmv_T2 dhea_BatchRmv_T2 testo_BatchRmv_T2 cort_dhea2 cort_testo2
cort_BatchRmv_T3 dhea_BatchRmv_T3 testo_BatchRmv_T3 cort_dhea3 cort_testo3;
run;

/* logged variables */
proc corr data=all; by pregnant;
var logcort_BatchRmv_T1 logdhea_BatchRmv_T1 logtesto_BatchRmv_T1 logcort_dhea1 logcort_testo1
logcort_BatchRmv_T2 logdhea_BatchRmv_T2 logtesto_BatchRmv_T2 logcort_dhea2 logcort_testo2
logcort_BatchRmv_T3 logdhea_BatchRmv_T3 logtesto_BatchRmv_T3 logcort_dhea3 logcort_testo3;
run;

proc corr data=all; by pregnant;
var stait1 psst1 PRAT1 BDIT1 BAIT1 cstress_both1
stait2 psst2 PRAT2 BDIT2 BAIT2 cstress_both2
stait3 psst3 PRAT3 BDIT3 BAIT3 cstress_both3;
with cort_BatchRmv_T1 dhea_BatchRmv_T1 testo_BatchRmv_T1 cort_dhea1 cort_testo1
cort_BatchRmv_T2 dhea_BatchRmv_T2 testo_BatchRmv_T2 cort_dhea2 cort_testo2
cort_BatchRmv_T3 dhea_BatchRmv_T3 testo_BatchRmv_T3 cort_dhea3 cort_testo3;
run;


proc corr; by pregnant; var stait1 psst1 BDIT1 BAIT1; 
with cort_BatchRmv_T1 dhea_BatchRmv_T1 testo_BatchRmv_T1 est_BatchRmv_T1 pro_BatchRmv_T1; run;
*NP: PSST1 - Cort = .34, p=.047, no other corrs;

proc corr; by pregnant; var stait2 psst2 BDIT2 BAIT2; 
with cort_BatchRmv_T2 dhea_BatchRmv_T2 testo_BatchRmv_T2 est_BatchRmv_T2 pro_BatchRmv_T2; run;
*No corrs;

proc corr; by pregnant; var stait3 psst3 BDIT3 BAIT3;
with cort_BatchRmv_T3 dhea_BatchRmv_T3 testo_BatchRmv_T3  est_BatchRmv_T3 pro_BatchRmv_T3; run;
*No corrs;

proc means data=all; var cort_BatchRmv_T1 cort_BatchRmv_T2 cort_BatchRmv_T3
testo_BatchRmv_T1 testo_BatchRmv_T2 testo_BatchRmv_T3
dhea_BatchRmv_T1 dhea_BatchRmv_T2 dhea_BatchRmv_T3
est_BatchRmv_T1 est_BatchRmv_T2 est_BatchRmv_T3
pro_BatchRmv_T1 pro_BatchRmv_T2 pro_BatchRmv_T3;  run;

proc corr; by pregnant; var cort_BatchRmv_T1 cort_BatchRmv_T2 cort_BatchRmv_T3
testo_BatchRmv_T1 testo_BatchRmv_T2 testo_BatchRmv_T3
dhea_BatchRmv_T1 dhea_BatchRmv_T2 dhea_BatchRmv_T3
est_BatchRmv_T1 est_BatchRmv_T2 est_BatchRmv_T3
pro_BatchRmv_T1 pro_BatchRmv_T2 pro_BatchRmv_T3
stait1 psst1 stait2 psst2 stait3 psst3
BDIT1 BDIT2 BDIT3 BAIT1 BAIT2 BAIT3; run;

/* SES Correlations */
proc corr data=all; var SES DE10T1 DE25T1 Fneed deprive occupation poverty; by pregnant; run;

/* Flip to long data */
data long; set all;
	id = id; pregnant=pregnant; assess=1; 
	/*hormones*/ DHEA=dhea_BatchRmv_T1; Cort=cort_BatchRmv_T1; testo=testo_BatchRmv_T1; est=est_BatchRmv_T1; pro=pro_BatchRmv_T1;  cort_dhea=cort_dhea1; cort_testo=cort_testo1;
	/*psych distress */ stai=stait1; pss=psst1; PRA=PRAT1; BDI=BDIT1; BAI=BAIT1; cstress_both=cstress_both1; cstress_preg=cstress_preg1; 
    /*covariates */ season=seasont1; age=aget1; wksSinceT1=wksT1_T1; age_pa=mean(aget1,aget2,aget3); age_wp=aget1-aget1; SES=SES; 
	/*more covariates*/ BMI=BMIT1; raceth=raceth; NEG=LECT1_NEG; Hormonal=Hormonal; Pregtot=Pregtot; OCtot=OCtot; sex=sex; Med=Med1; 
	/*logged hormones*/ logDHEA=logdhea_BatchRmv_T1; logCort=logcort_BatchRmv_T1; logtesto=logtesto_BatchRmv_T1; logcort_dhea=logcort_dhea1; logcort_testo=logcort_testo1; OUTPUT;
	id = id; pregnant=pregnant; assess=2; 
	/*hormones*/ DHEA=dhea_BatchRmv_T2; Cort=cort_BatchRmv_T2; testo=testo_BatchRmv_T2; est=est_BatchRmv_T2; pro=pro_BatchRmv_T2;  cort_dhea=cort_dhea2; cort_testo=cort_testo2;
	/*psych distress */ stai=stait2; pss=psst2; PRA=PRAT2; BDI=BDIT2; BAI=BAIT2; cstress_both=cstress_both2; cstress_preg=cstress_preg2; 
    /*covariates */ season=seasont2; age=aget1; wksSinceT1=wksT2_T1; age_pa=mean(aget1,aget2,aget3); age_wp=aget2-aget1; SES=SES; 
	/*more covariates*/ BMI=BMIT1; raceth=raceth; NEG=LECT1_NEG; Hormonal=Hormonal; Pregtot=Pregtot; OCtot=OCtot; sex=sex; Med=Med1; 
	/*logged hormones*/logDHEA=logdhea_BatchRmv_T2; logCort=logcort_BatchRmv_T2; logtesto=logtesto_BatchRmv_T2; logcort_dhea=logcort_dhea2; logcort_testo=logcort_testo2; OUTPUT;
	id = id; pregnant=pregnant; assess=3; 
	/*hormones*/ DHEA=dhea_BatchRmv_T3; Cort=cort_BatchRmv_T3; testo=testo_BatchRmv_T3; est=est_BatchRmv_T3; pro=pro_BatchRmv_T3;  cort_dhea=cort_dhea3; cort_testo=cort_testo3;
	/*psych distress */  stai=stait3; pss=psst3; PRA=PRAT3; BDI=BDIT3; BAI=BAIT3; cstress_both=cstress_both3; cstress_preg=cstress_preg3; 
	/*covariates */  season=seasont3; age=aget1; wksSinceT1=wksT3_T1; age_pa=mean(aget1,aget2,aget3); age_wp=aget3-aget1; SES=SES;
	/*more covariates*/ BMI=BMIT1; raceth=raceth; NEG=LECT1_NEG; Hormonal=Hormonal; Pregtot=Pregtot; OCtot=OCtot; sex=sex; Med=Med1;
	/*logged hormones*/ logDHEA=logdhea_BatchRmv_T3; logCort=logcort_BatchRmv_T3; logtesto=logtesto_BatchRmv_T3; logcort_dhea=logcort_dhea3; logcort_testo=logcort_testo3; OUTPUT;
KEEP id pregnant assess 
		 dhea cort testo est pro 
		 stai pss PRA BDI BAI cort_dhea cort_testo cstress_both cstress_preg
		 season age age_wp age_pa ses BMI raceth wksSinceT1 NEG hormonal Pregtot OCtot sex Med
		 logDHEA logCort logtesto logcort_dhea logcort_testo;
	RUN;
* note that LEC_T1 is used as a time-invariant covariate, T3 is excluded from this code;

/* center hormone data */
PROC SQL; 
	CREATE TABLE persmeanctr AS
	SELECT *, mean(Cort) AS PersonAveCort,  
	Cort - mean(Cort) AS CortWPcentered, mean(DHEA) AS PersonAveDHEA,  
	DHEA - mean(DHEA) AS DHEAWPcentered, mean(testo) AS PersonAvetesto,  
	testo - mean(testo) AS testoWPcentered, mean(est) AS PersonAveest,  
	est - mean(est) AS estWPcentered, mean(pro) AS PersonAvepro,  
	pro - mean(pro) AS protWPcentered,
	mean(cort_dhea) AS PersonAvecort_dhea, 
	cort_dhea - mean(cort_dhea) AS cort_dheaWPcentered, 
	mean(cort_testo) AS PersonAvecort_testo, 
	cort_testo - mean(cort_testo) AS cort_testoWPcentered,
	mean(STAI) AS PersonAveSTAI,  
	STAI - mean(STAI) AS STAIWPcentered,
	mean(PSS) AS PersonAvePSS,  
	PSS - mean(PSS) AS PSSWPcentered,
	mean(PRA) AS PersonAvePRA,  
	PRA - mean(PRA) AS PRAWPcentered,
	mean(cstress_both) AS PersonAvecstress_both,  
	cstress_both - mean(cstress_both) AS cstress_bothWPcentered,
	mean(cstress_preg) AS PersonAvecstress_preg,  
	cstress_preg - mean(cstress_preg) AS cstress_pregWPcentered,    
	mean(BDI) AS PersonAveBDI,  
	BDI - mean(BDI) AS BDIWPcentered,    
	mean(BAI) AS PersonAveBAI,  
	BAI - mean(BAI) AS BAIWPcentered,
	mean(logCort) AS logPersonAveCort, 
	logCort - mean(logCort) AS logCortWPcentered, 
	mean(logDHEA) AS logPersonAveDHEA,  
	logDHEA - mean(logDHEA) AS logDHEAWPcentered, 
	mean(logtesto) AS logPersonAvetesto,  
	logtesto - mean(logtesto) AS logtestoWPcentered,
	mean(logcort_dhea) AS logPersonAvecort_dhea, 
	logcort_dhea - mean(logcort_dhea) AS logcort_dheaWPcentered, 
	mean(logcort_testo) AS logPersonAvecort_testo, 
	logcort_testo - mean(logcort_testo) AS logcort_testoWPcentered
	FROM long
	GROUP BY id;
QUIT;

Data center; set persmeanctr;
assessc=assess-1;
run;

proc means mean var; var PersonAveCort PersonAveDHEA PersonAveTesto 
CortWPcentered DHEAWPcentered TestoWPcentered 
logPersonAveCort logPersonAveDHEA logPersonAveTesto 
logCortWPcentered logDHEAWPcentered logTestoWPcentered cstress_preg cstress_pregWPcentered PersonAvecstress_preg; run;

/* create group-specific datasets */
Data Pregnant; set center; if pregnant = 0 then delete; run;
Data Non_pregnant; set center; if pregnant = 1 then delete; run;

/* initial correlations for full data */
proc sort data=all; by pregnant; run;
proc corr data=all; var SES DE10T1 DE25T1 Fneed deprive occupation poverty; with PSS STAI BDI BAI cort_BatchRmv_T1 cort_BatchRmv_T2 cort_BatchRmv_T3; by pregnant; run;
*BIG correlations of lower SES and more stress;
*and T1 stress in pregnant women (lower SES higher cort), but not NP or other assessments;

/* these correlations include all timepoints so people are "triple-counted" */
proc sort data=center; by pregnant;
proc corr data=center; var PSS STAI Cort BAI BDI; with SES age bmi NEG PersonAveCort CortWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered; by pregnant; run;
* ses-cort correlation in Preg but not nonpreg;

/* group-specific corrleations, again includin all time-points */
proc corr data=pregnant; var SES age bmi NEG Pregtot OCtot PersonAveCort CortWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered; with PSS STAI PRA cstress_preg Cort BAI BDI; run; 
proc corr data=pregnant; var PSS STAI PRA BAI BDI Cort cstress_preg Pregtot OCtot; run; 

proc corr data=non_pregnant; var SES age bmi NEG hormonal PersonAveCort CortWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered; with PSS STAI cstress_both Cort BAI BDI; run; 
proc corr data=non_pregnant; var PSS STAI BAI BDI Cort cstress_both; run; 

/* checking differences for season and race/eth */
proc glm data=center; 
CLASS season;
model STAI = season; run;
*no differences;

proc glm data=center; 
CLASS raceth;
model STAI = raceth; run;
*no differences;

proc glm data=center; 
CLASS season;
model PSS = season; run;
*no differences;

proc glm data=center; 
CLASS raceth;
model PSS = raceth; run;
*no differences;

proc glm data=center; 
CLASS season;
model CortWPcentered = season; run;
*no differences;

proc glm data=center; 
CLASS raceth;
model CortWPcentered = raceth; run;
*no differences;

proc glm data=center; 
CLASS season;
model Cort = season; run;
*no differences;

proc glm data=center; 
CLASS raceth;
model Cort = raceth; run;

/*** Longitudinal plots ***/

PROC GPLOT DATA=pregnant;
	TITLE ' ';
	SYMBOL1 REPEAT=600 INTERPOL=JOIN VALUE=DOT HEIGHT=.5 WIDTH=.5 COLOR=blue;
	AXIS1
		LABEL = (A=90 F=SWISSX h=1.3 'WP Cortisol')
		MINOR = none
		OFFSET = (2);
	AXIS2
		LABEL = (F=SWISSX H=1.3 'Psych Distress')
		MINOR = none
		OFFSET = (2); 
	PLOT CortWPcentered * cstress_preg = id /NOLEGEND VAXIS=AXIS1 HAXIS=AXIS2 noframe;
RUN;
QUIT;

PROC GPLOT DATA=pregnant;
	TITLE ' ';
	SYMBOL1 REPEAT=600 INTERPOL=JOIN VALUE=DOT HEIGHT=.5 WIDTH=.5 COLOR=blue;
	AXIS1
		LABEL = (A=90 F=SWISSX h=1.3 'WP Cortisol')
		MINOR = none
		OFFSET = (2);
	AXIS2
		LABEL = (F=SWISSX H=1.3 'Anxiety')
		MINOR = none
		OFFSET = (2); 
	PLOT CortWPcentered * BAI = id /NOLEGEND VAXIS=AXIS1 HAXIS=AXIS2 noframe;
RUN;
QUIT;

PROC GPLOT DATA=pregnant;
	TITLE ' ';
	SYMBOL1 REPEAT=600 INTERPOL=JOIN VALUE=DOT HEIGHT=.5 WIDTH=.5 COLOR=blue;
	AXIS1
		LABEL = (A=90 F=SWISSX h=1.3 'WP Cortisol')
		MINOR = none
		OFFSET = (2);
	AXIS2
		LABEL = (F=SWISSX H=1.3 'Pregnancy Related Anxiety')
		MINOR = none
		OFFSET = (2); 
	PLOT CortWPcentered * PRA = id /NOLEGEND VAXIS=AXIS1 HAXIS=AXIS2 noframe;
RUN;
QUIT;

/* Coupling plots of pregnant women */
PROC SORT DATA=pregnant; BY ID TIME;
PROC GPLOT DATA=pregnant;
by ID;
	TITLE ' ';
	SYMBOL1 REPEAT=3 INTERPOL=JOIN VALUE=dot HEIGHT=.75 WIDTH=.5 COLOR=BLACK;
	SYMBOL2 REPEAT=3 INTERPOL=JOIN VALUE=dot HEIGHT=.75 WIDTH=.5 COLOR=BLUE;
	AXIS1
		/*ORDER = (-8 to 4 by 2)*/
		LABEL = (A=90 F=SWISSX h=1.3 'Within Person Cortisol')
		MINOR = none
		OFFSET = (2)
		COLOR = BLACK;
	AXIS2
		/*ORDER = (-8 to 4 by 2)*/
		LABEL = (A = 270 F=SWISSX H=1.3 'Psych Distress')
		MINOR = none
		OFFSET = (2)
 		COLOR = BLUE;
	AXIS3
		ORDER = (1 to 3 by 1)
		LABEL = (F=SWISSX H=1.3 'Assessment')
		MINOR = none
		OFFSET = (2)
		COLOR = black;
	PLOT CortWPcentered * assess = id /NOLEGEND VAXIS=AXIS1 HAXIS=AXIS3 CAXIS=black NOFRAME;
	PLOT2 cstress_preg * assess = id /NOLEGEND VAXIS=AXIS2 HAXIS=AXIS3 CAXIS=BLACK NOFRAME;
RUN;

/* Multilevel Models */

/* Baseline + Covariates */
proc sort data=center; by pregnant id assess; run;
PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 BY PREGNANT;
 MODEL stai = assessc age bmi ses NEG /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 BY PREGNANT;
 MODEL PSS = assessc age bmi ses NEG/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 BY PREGNANT;
 MODEL Cort = assessc age bmi ses NEG/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

/***********************************************************************************/

/* Adding in hormonal milieu */
PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL STAI = pregnant assessc age bmi ses NEG
			  PersonAveCort CortWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL PSS = pregnant assessc age bmi ses NEG
			  PersonAveCort CortWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL Cort = pregnant assessc age bmi ses NEG
			  PersonAveSTAI STAIWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

/***********************************************************************************/

/* Adding in pregnancy*CORT interaction */
PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 CLASS pregnant;
 MODEL stai = pregnant assessc age bmi ses NEG
			  PersonAveCort CortWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered 
			  pregnant*CortWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 class pregnant;
 MODEL Cort = pregnant assessc age bmi ses NEG
			  PersonAveSTAI STAIWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered
			  pregnant*STAIWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 CLASS pregnant;
 MODEL PSS = pregnant assessc age bmi ses NEG
			 PersonAveCort CortWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered
		     pregnant*CortWPcentered /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept CortWPcentered /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
class pregnant;
 MODEL Cort = pregnant assessc age bmi ses NEG
			  PersonAvePSS PSSWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered
			  pregnant*psswpcentered /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 BY PREGNANT;
 MODEL STAI = assessc age bmi ses NEG
			  PersonAveCort CortWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 BY PREGNANT;
 MODEL PSS = assessc age bmi ses NEG 
			  PersonAveCort CortWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 by pregnant;
 MODEL Cort = assessc age bmi ses NEG
			  PersonAveSTAI STAIWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
by pregnant;
MODEL Cort = assessc age bmi ses NEG
			  PersonAvePSS PSSWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;
 
/***********************************************************************************/

/* Ratio Models */

/******** Cort_DHEA Ratio ********/

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 CLASS pregnant;
 MODEL stai = pregnant assessc age bmi ses NEG
			  cort_dheaWPcentered PersonAvecort_dhea PersonAvetesto testoWPcentered 
			  pregnant*cort_dheaWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 CLASS PREGNANT;
 MODEL PSS = pregnant assessc age bmi ses NEG
			 cort_dheaWPcentered PersonAvecort_dhea PersonAvetesto testoWPcentered 
			 pregnant*cort_dheaWPcentered /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept  /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 BY pregnant;
 MODEL stai = assessc age bmi ses NEG
			  cort_dheaWPcentered PersonAvecort_dhea PersonAvetesto testoWPcentered 
			  /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept  /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 BY pregnant;
 MODEL PSS = assessc age bmi ses NEG
			  cort_dheaWPcentered PersonAvecort_dhea PersonAvetesto testoWPcentered 
			  /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept  /SUBJECT=id TYPE=VC GCORR;
RUN;

/***********************************************************************************/

/******** Cort_Testo Ratio ********/

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 CLASS pregnant;
 MODEL stai = pregnant assessc age bmi ses NEG 
			  cort_testoWPcentered PersonAvecort_testo PersonAveDHEA DHEAWPcentered 
			  pregnant*cort_testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 CLASS pregnant;
 MODEL PSS = pregnant assessc age bmi ses NEG
			  cort_testoWPcentered PersonAvecort_testo PersonAveDHEA DHEAWPcentered 
			  pregnant*cort_testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept  /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
BY pregnant;
 MODEL stai =  assessc age bmi ses NEG 
			  cort_testoWPcentered PersonAvecort_testo PersonAveDHEA DHEAWPcentered 
			  cort_testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 BY pregnant;
 MODEL PSS = assessc age bmi ses NEG
			  cort_testoWPcentered PersonAvecort_testo PersonAveDHEA DHEAWPcentered 
			  cort_testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept  /SUBJECT=id TYPE=VC GCORR;

/***********************************************************************************/

/******** Cort_DHEA Ratio and Cort_Testo Ratio ********/

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 CLASS pregnant;
MODEL stai = pregnant assessc age bmi ses NEG cort_dheaWPcentered PersonAvecort_dhea pregnant*cort_dheaWPcentered 
			  cort_testoWPcentered PersonAvecort_testo pregnant*cort_testoWPcentered /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN; 

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
CLASS pregnant;
MODEL pss = pregnant assessc age bmi ses NEG cort_dheaWPcentered PersonAvecort_dhea pregnant*cort_dheaWPcentered 
			  cort_testoWPcentered PersonAvecort_testo pregnant*cort_testoWPcentered /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
BY pregnant;
MODEL stai = assessc age bmi ses NEG cort_dheaWPcentered PersonAvecort_dhea cort_dheaWPcentered 
			  cort_testoWPcentered PersonAvecort_testo cort_testoWPcentered /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;

PROC MIXED DATA=center NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
BY pregnant;
MODEL pss = assessc age bmi ses NEG cort_dheaWPcentered PersonAvecort_dhea pregnant*cort_dheaWPcentered 
			  cort_testoWPcentered PersonAvecort_testo pregnant*cort_testoWPcentered /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

/*********************** Modeling pregnancy sample seperately ****************************************/

proc sort data=Pregnant; by id assessc; run;
/*** Baseline + Covariates ***/ 
PROC MIXED DATA=Pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL STAI = assessc age bmi ses NEG Pregtot sex
			  /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=Pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL PSS = assessc age bmi ses NEG Pregtot sex
			  /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=Pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL PRA = assessc age bmi ses NEG Pregtot sex
			  /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=Pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL cstress_preg = assessc age bmi ses NEG Pregtot sex
			  /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

/******************************************************************/

/*** Hormonal Milieu ***/
PROC MIXED DATA=Pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL STAI = assessc age bmi ses NEG Pregtot sex
			  PersonAveCort CortWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=Pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL PSS = assessc age bmi ses NEG Pregtot sex
			  PersonAveCort CortWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=Pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL PRA = assessc age bmi ses NEG Pregtot sex
			  PersonAveCort CortWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=Pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL cstress_preg = assessc age bmi ses NEG Pregtot sex
			  PersonAveCort CortWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=Pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL cort = assessc age bmi ses NEG Pregtot sex
			  PersonAveSTAI STAIWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=Pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL cort = assessc age bmi ses NEG Pregtot sex
			  PersonAvePSS PSSWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered/SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN;

/* Ratio Models */

/******** Cort_DHEA Ratio ********/

PROC MIXED DATA=pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL stai =  assessc age bmi ses NEG Pregtot sex
			  cort_dheaWPcentered PersonAvecort_dhea PersonAvetesto testoWPcentered 
			  /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept  /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL PSS =  assessc age bmi ses NEG Pregtot sex
			  cort_dheaWPcentered PersonAvecort_dhea PersonAvetesto testoWPcentered 
			  /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept  /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL PRA =  assessc age bmi ses NEG Pregtot sex
			  cort_dheaWPcentered PersonAvecort_dhea PersonAvetesto testoWPcentered 
			  /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept  /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL cstress_preg =  assessc age bmi ses NEG Pregtot sex
			  cort_dheaWPcentered PersonAvecort_dhea PersonAvetesto testoWPcentered 
			  /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept  /SUBJECT=id TYPE=VC GCORR;
RUN;

/******** Cort_Testo Ratio ********/

PROC MIXED DATA=pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL stai =  assessc age bmi ses NEG Pregtot sex
			  cort_testoWPcentered PersonAvecort_testo PersonAveDHEA DHEAWPcentered 
			  /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept  /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL PSS =  assessc age bmi ses NEG Pregtot sex
			  cort_testoWPcentered PersonAvecort_testo PersonAveDHEA DHEAWPcentered 
			  /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept  /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL PRA =  assessc age bmi ses NEG Pregtot sex
			  cort_testoWPcentered PersonAvecort_testo PersonAveDHEA DHEAWPcentered 
			  /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept  /SUBJECT=id TYPE=VC GCORR;
RUN;

PROC MIXED DATA=pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
 MODEL cstress_preg =  assessc age bmi ses NEG Pregtot sex
			  cort_testoWPcentered PersonAvecort_testo PersonAveDHEA DHEAWPcentered 
			  /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept  /SUBJECT=id TYPE=VC GCORR;
RUN;

/******** Cort_DHEA Ratio and Cort_Testo Ratio ********/

PROC MIXED DATA=pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
MODEL stai = assessc age bmi ses NEG Pregtot sex cort_dheaWPcentered PersonAvecort_dhea cort_dheaWPcentered 
			  cort_testoWPcentered PersonAvecort_testo cort_testoWPcentered /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN; 

PROC MIXED DATA=pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
MODEL PSS = assessc age bmi ses NEG Pregtot sex cort_dheaWPcentered PersonAvecort_dhea cort_dheaWPcentered 
			  cort_testoWPcentered PersonAvecort_testo cort_testoWPcentered /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN; 

PROC MIXED DATA=pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
MODEL PRA = assessc age bmi ses NEG Pregtot sex cort_dheaWPcentered PersonAvecort_dhea cort_dheaWPcentered 
			  cort_testoWPcentered PersonAvecort_testo cort_testoWPcentered /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN; 

PROC MIXED DATA=pregnant NOCLPRINT COVTEST METHOD=REML EMPIRICAL;
MODEL cstress_preg = assessc age bmi ses NEG Pregtot sex cort_dheaWPcentered PersonAvecort_dhea cort_dheaWPcentered 
			  cort_testoWPcentered PersonAvecort_testo cort_testoWPcentered /SOLUTION DDFM=BW NOTEST ; 
 RANDOM intercept /SUBJECT=id TYPE=VC GCORR;
RUN; 

proc corr data=pregnant; var assess age BMI SES Neg sex Pregtot STAI PSS CORT PRA cstress_preg cstress_both BAI BDI ; run;
proc corr data=Non_pregnant; var assess age BMI SES Neg hormonal STAI PSS CORT cstress_preg cstress_both BAI BDI ; run;

/* DATA out for MPLUS */

proc means data=center; var age BMI NEG PSS STAI BDI BAI cstress_both cstress_preg; run;

data mplus; set center;
agec = age - 28.1198933;
BMIc = BMI - 27.7555627;
NEGc = Neg - 16.7457627;
Medc = Med - 0.1176471; 

File 'C:\Users\olivi\Box\MCPP (L2 Sensitive)\Projects and Analyses\Longitudinal Hair Hormones & Subjective Stress Paper\Mplus\R&R 01012023\R&R01012023.dat';
put ID pregnant assessc agec BMIc SES Negc STAI PSS PersonAveCort CortWPcentered PersonAveDHEA 
    DHEAWPcentered PersonAvetesto testoWPcentered cort_dheaWPcentered PersonAvecort_dhea cort_testoWPcentered PersonAvecort_testo
	CORT PRA cstress_preg cstress_both BAI BDI sex Pregtot hormonal	PersonAveSTAI STAIWPcentered PersonAvePSS PSSWPcentered PersonAveBDI BDIWPcentered PersonAveBAI BAIWPcentered med
	logPersonAveCort logCortWPcentered logPersonAveDHEA logDHEAWPcentered logPersonAvetesto logtestoWPcentered logcort_dheaWPcentered logPersonAvecort_dhea logcort_testoWPcentered logPersonAvecort_testo;
run;

proc means n mean var stddev min max skew kurt; var Med logPersonAveCort logCortWPcentered logPersonAveDHEA 
    logDHEAWPcentered logPersonAvetesto logtestoWPcentered logcort_dheaWPcentered logPersonAvecort_dhea logcort_testoWPcentered logPersonAvecort_testo; run;

/* Data out; set mplus; keep ID pregnant assessc agec BMIc SES Negc STAI PSS logPersonAveCort logCortWPcentered logPersonAveDHEA 
    logDHEAWPcentered logPersonAvetesto logtestoWPcentered logcort_dheaWPcentered logPersonAvecort_dhea logcort_testoWPcentered logPersonAvecort_testo
	CORT PRA cstress_preg cstress_both BAI BDI sex Pregtot hormonal	PersonAveSTAI STAIWPcentered PersonAvePSS PSSWPcentered PersonAveBDI BDIWPcentered PersonAveBAI BAIWPcentered; run; */

/* Data check; set center; keep ID logPersonAveCort logCortWPcentered PersonAveCort CortWPcentered ; run; */

/* Export for R */

data csv; set center;
agec = age - 28.4439809;
BMIc = BMI - 27.7555627;
NEGc = Neg - 16.7457627; 

keep ID pregnant assessc agec BMIc SES Neg STAI PSS PersonAveCort CortWPcentered PersonAveDHEA DHEAWPcentered PersonAvetesto testoWPcentered
	cort_dheaWPcentered PersonAvecort_dhea cort_testoWPcentered PersonAvecort_testo; run;

proc export data=csv
outfile='C:\Users\olivi\Box\MCPP (L2 Sensitive)\Projects and Analyses\Conference Proposals\olivia ISPNE 2020\ISPNE2020.csv' 
dbms=csv
replace;
run;








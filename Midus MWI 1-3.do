clear
clear matrix
clear mata
set maxvar 20000

** Open MIDUS 1 file with missing data already coded

use "C:\Users\olivi\Dropbox\MIDUS\MIDUS 1\m1dataclean.dta"


** Merge MIDUS 2 P1 file with missing data already coded

merge 1:1 M2ID using "C:\Users\olivi\Dropbox\MIDUS\MIDUS 2\m2p1dataclean.dta"

drop _merge

** Merge MIDUS 2 P4 Biomarkers
merge 1:1 M2ID using "C:\Users\olivi\Dropbox\MIDUS\MIDUS 2\m2p4dataclean.dta"

drop _merge

** Merge MIDUS 3 P1 file with missing data already coded
merge 1:1 M2ID using "C:\Users\olivi\Dropbox\MIDUS\MIDUS 3\m3p1dataclean.dta"

drop _merge

** Define value labels
label define yesno 0 "No" 1 "Yes" 
** Rename and recode variables (0=No and 1=Yes)

** M1 MULTIMORBIDITY VARIABLES PHONE CONDITION
* Lead in # A1PA11

recode A1PA11 (2=0) 
recode A1PA11BA (2=0)
gen m1pha=.
recode m1pha(.=1) if A1PA11==1 & A1PA11BA==1
recode m1pha(.=0) if A1PA11==0
recode m1pha (.=0) if A1PA11BA==0
gen m1phawt=m1pha*1.73 
label variable m1phawt "MIDUS 1 - Heart Attack Weight"
label variable m1pha "MIDUS 1 - Heart Attack"
label values m1pha yesno

recode A1PA11 (2=0) 
recode A1PA11BB (2=0)
gen m1pangina=.
recode m1pangina(.=1) if A1PA11==1 & A1PA11BB==1
recode m1pangina(.=0) if A1PA11==0
gen m1panginawt=m1pangina*2.2 
label variable m1panginawt "MIDUS 1 - Angina Weight"
label variable m1pangina "MIDUS 1 - Angina Attack"
label values m1pangina yesno

recode A1PA11 (2=0) 
recode A1PA11BC (2=0)
gen m1phblood=.
recode m1phblood(.=1) if A1PA11==1 & A1PA11BC==1
recode m1phblood(.=0) if A1PA11==0
gen m1phbloodwt=m1phblood*1.53 
label variable m1phbloodwt "MIDUS 1 - High Blood Pressure Weight"
label variable m1phblood "MIDUS 1 - High Blood Pressure"
label values m1phblood yesno

recode A1PA11 (2=0) 
recode A1PA11BD (2=0)
gen m1pvalve=.
recode m1pvalve(.=1) if A1PA11==1 & A1PA11BD==1
recode m1pvalve(.=0) if A1PA11==0
gen m1pvalvewt=m1pvalve*0.033 
label variable m1pvalvewt "MIDUS 1 - Mitrovalve Prolapse Weight"
label variable m1pvalve "MIDUS 1 - Mitrovalve Prolapse Pressure"
label values m1pvalve yesno

recode A1PA11 (2=0) 
recode A1PA11BI (2=0)
gen m1pfailure=.
recode m1pfailure(.=1) if A1PA11==1 & A1PA11BI==1
recode m1pfailure(.=0) if A1PA11==0
gen m1pfailurewt=m1pfailure*4.77 
label variable m1pfailurewt "MIDUS 1 - Heart Failure Weight"
label variable m1pfailure "MIDUS 1 - Heart Failure"
label values m1pfailure yesno

recode A1PA36 (2=0) 
recode A1PA39A (2=0)
gen m1pbreast=.
recode m1pbreast(.=1) if A1PA36==1 & A1PA39A==1
recode m1pbreast(.=0) if A1PA36==0
gen m1pbreastwt=m1pbreast*0.886 
label variable m1pbreastwt "MIDUS 1 - Breast Cancer Weight"
label variable m1pbreast "MIDUS 1 - Breast Cancer"
label values m1pbreast yesno

recode A1PA36 (2=0) 
recode A1PA39B (2=0)
gen m1pcervical=.
recode m1pcervical(.=1) if A1PA36==1 & A1PA39B==1
recode m1pcervical(.=0) if A1PA36==0
gen m1pcervicalwt=m1pcervical*0.723 
label variable m1pcervicalwt "MIDUS 1 - Cervical Cancer Weight"
label variable m1pcervical "MIDUS 1 - Cervical Cancer"
label values m1pcervical yesno

recode A1PA36 (2=0) 
recode A1PA39C (2=0)
gen m1pcolon=.
recode m1pcolon(.=1) if A1PA36==1 & A1PA39C==1
recode m1pcolon(.=0) if A1PA36==0
gen m1pcolonwt=m1pcolon*0.723 
label variable m1pcolonwt "MIDUS 1 - Colon Cancer Weight"
label variable m1pcolon "MIDUS 1 - Colon Cancer"
label values m1pcolon yesno

recode A1PA36 (2=0) 
recode A1PA39D (2=0)
gen m1plung=.
recode m1plung(.=1) if A1PA36==1 & A1PA39D==1
recode m1plung(.=0) if A1PA36==0
gen m1plungwt=m1plung*6.25 
label variable m1plungwt "MIDUS 1 - Lung Cancer Weight"
label variable m1plung "MIDUS 1 - Lung Cancer"
label values m1plung yesno

recode A1PA36 (2=0) 
recode A1PA39E (2=0)
gen m1pleuk=.
recode m1pleuk(.=1) if A1PA36==1 & A1PA39E==1
recode m1pleuk(.=0) if A1PA36==0
gen m1pleukwt=m1pleuk*1.32 
label variable m1pleukwt "MIDUS 1 - Lymphoma/Leukemia Weight"
label variable m1pleuk "MIDUS 1 - Lymphoma/Leukemia"
label values m1pleuk yesno

recode A1PA36 (2=0) 
recode A1PA39F (2=0)
gen m1pova=.
recode m1pova(.=1) if A1PA36==1 & A1PA39F==1
recode m1pova(.=0) if A1PA36==0
gen m1povawt=m1pova*1.87 
label variable m1povawt "MIDUS 1 - Ovarian Cancer Weight"
label variable m1pova "MIDUS 1 - Ovarian Cancer"
label values m1pova yesno

recode A1PA36 (2=0) 
recode A1PA39G (2=0)
gen m1ppro=.
recode m1ppro(.=1) if A1PA36==1 & A1PA39G==1
recode m1ppro(.=0) if A1PA36==0
gen m1pprowt=m1ppro*0.402 
label variable m1pprowt "MIDUS 1 - Prostate Cancer Weight"
label variable m1ppro "MIDUS 1 - Prostate Cancer"
label values m1ppro yesno

recode A1PA36 (2=0) 
recode A1PA39H (2=0)
gen m1pskin=.
recode m1pskin(.=1) if A1PA36==1 & A1PA39H==1
recode m1pskin(.=0) if A1PA36==0
gen m1pskinwt=m1pskin*-0.068 
label variable m1pskinwt "MIDUS 1 - Skin Cancer Weight"
label variable m1pskin "MIDUS 1 - Skin Cancer"
label values m1pskin yesno

recode A1PA36 (2=0) 
recode A1PA39I (2=0)
gen m1pute=.
recode m1pute(.=1) if A1PA36==1 & A1PA39I==1
recode m1pute(.=0) if A1PA36==0
gen m1putewt=m1pute*0.753 
label variable m1putewt "MIDUS 1 - Uterine Cancer Weight"
label variable m1pute "MIDUS 1 - Uterine Cancer"
label values m1pute yesno

** M1 MULTIMORBIDITY VARIABLES SAQ CONDITION

recode A1SA9A (2=0), gen(m1scopd)
gen m1scopdwt=m1scopd*4.32
label variable m1scopdwt "MIDUS 1 - COPD Weight"
label variable m1scopd "MIDUS 1 - COPD Cancer"
label values m1scopd yesno

recode A1SA9B (2=0), gen(m1sarth)
gen m1sarthwt=m1sarth*3.79
label variable m1scopdwt "MIDUS 1 - Arthritis Weight"
label variable m1scopd "MIDUS 1 - Arthritis"
label values m1scopd yesno

recode A1SA9G (2=0), gen(m1sthyroid)
gen m1sthyroidwt=m1sthyroid*0.479
label variable m1sthyroidwt "MIDUS 1 - Thyroid Disease Weight"
label variable m1sthyroid "MIDUS 1 - Thyroid Disesase"
label values m1sthyroid yesno

recode A1SA9L (2=0), gen(m1sgall)
gen m1sgallwt=m1sgall*0.929
label variable m1sgallwt "MIDUS 1 - Gallbladder Weight"
label variable m1sgall "MIDUS 1 - Gallbladder"
label values m1sgall yesno

recode A1SA9O (2=0), gen(m1saids)
gen m1saidswt=m1saids*2.91
label variable m1saidswt "MIDUS 1 - Aids Weight"
label variable m1saids "MIDUS 1 - Aids"
label values m1saids yesno

*Depression from SAQ
*recode A1SA9T (2=0), gen(m1sdep)
*gen m1sdepwt=m1sdep*1.29
*label variable m1sdepwt "MIDUS 1 - Depression Weight"
*label variable m1sdep "MIDUS 1 - Depression"
*label values m1sdep yesno

*Depression (Dichotomous Diagnosis)
gen m1sdep = A1PDEPDX
gen m1sdepwt=m1sdep*1.29
label variable m1sdepwt "MIDUS 1 - Depression Weight"
label variable m1sdep "MIDUS 1 - Depression"
label values m1sdep yesno

*Code Dichotomous V for alcohol abuse
recode A1SA44B (2=0), gen(alc1)
recode A1SA44C (2=0), gen(alc2)
recode A1SA44D (2=0), gen(alc3)
recode A1SA44E (2=0), gen(alc4)
gen m1salc=.
recode m1salc (.=0) if alc1==0 & alc2==0 & alc3==0 & alc4==0
recode m1salc (.=1) if alc1==1 | alc2==1 | alc3==1 | alc4==1
gen m1salcwt=m1salc*1.37
label variable m1salcwt "MIDUS 1 - Alcohol Weight"
label variable m1salc "MIDUS 1 - Alcohol"
label values m1salc yesno

*Alcoholism from SAQ
*recode A1SA9U (2=0), gen(m1salc)
*gen m1salcwt=m1salc*1.37
*label variable m1salcwt "MIDUS 1 - Alcohol Weight"
*label variable m1salc "MIDUS 1 - Alcohol"
*label values m1salc yesno

recode A1SA9V (2=0), gen(m1smig)
gen m1smigwt=m1smig*0.614
label variable m1smigwt "MIDUS 1 - Migraine Weight"
label variable m1smig "MIDUS 1 - Migraine"
label values m1smig yesno

recode A1SA9X (2=0), gen(m1sdia)
gen m1sdiawt=m1sdia*2.67
label variable m1sdiawt "MIDUS 1 - Diabetes Weight"
label variable m1sdia "MIDUS 1 - Diabetes"
label values m1sdia yesno

recode A1SA9Y (2=0), gen(m1sms)
gen m1smswt=m1sms*10.6
label variable m1smswt "MIDUS 1 - MS Weight"
label variable m1sms "MIDUS 1 - MS"
label values m1sms yesno

recode A1SA9Z (2=0), gen(m1sstroke)
gen m1sstrokewt=m1sstroke*3.79
label variable m1sstrokewt "MIDUS 1 - Stroke Weight"
label variable m1sstroke "MIDUS 1 - Stroke Cancer"
label values m1sstroke yesno

recode A1SA9AA (2=0), gen(m1sulcer)
gen m1sulcerwt=m1sulcer*1.08
label variable m1sulcerwt "MIDUS 1 - Ulcer Weight"
label variable m1sulcer "MIDUS 1 - Ulcer Cancer"
label values m1sulcer yesno

recode A1SA10C (2=0), gen(m1scholrx)
gen m1scholrxwt=m1scholrx*0.343
label variable m1scholrxwt "MIDUS 1 - Cholesterol Rx Weight"
label variable m1scholrx "MIDUS 1 - Cholesterol Rx Cancer"
label values m1scholrx yesno

*Create multimorbidity Count Variable
gen MMB1=m1pha+m1pangina+m1phblood+m1pvalve+m1pfailure+m1pbreast+m1pcervical+m1pcolon+m1plung+m1pleuk+m1pova+m1ppro+m1pskin+m1pute+m1scopd+m1sarth+m1sthyroid+m1sgall+m1saids+m1sdep+m1smig+m1sdia+m1sms+m1sstroke+m1sulcer+m1scholrx
gen MMB1wt=m1phawt+m1panginawt+m1phbloodwt+m1pvalvewt+m1pfailurewt+m1pbreastwt+m1pcervicalwt+m1pcolonwt+m1plungwt+m1pleukwt+m1povawt+m1pprowt+m1pskinwt+m1putewt+m1scopdwt+m1sarthwt+m1sthyroidwt+m1sgallwt+m1saidswt+m1sdepwt+m1smigwt+m1sdiawt+m1smswt+m1sstrokewt+m1sulcerwt+m1scholrxwt
** M2 MULTIMORBIDITY VARIABLES PHONE CONDITION

recode B1PA6A (2=0), gen(m2pstroke)
gen m2pstrokewt=m2pstroke*3.79 
label variable m2pstrokewt "MIDUS 2 - Stroke Weight"
label variable m2pstroke "MIDUS 2 - Stroke"
label values m2pstroke yesno

recode B1PA6C (2=0), gen(m2ppark)
gen m2pparkwt=m2ppark*8.82
label variable m2pparkwt "MIDUS 2 - Parkinson's Weight"
label variable m2ppark "MIDUS 2 - Parkinson's"
label values m2ppark yesno

recode B1PA7 (2=0) 
recode B1PA7BA (2=0)
gen m2pha=.
recode m2pha(.=1) if B1PA7==1 & B1PA7BA==1
recode m2pha(.=0) if B1PA7==0
gen m2phawt=m2pha*1.73 
label variable m2phawt "MIDUS 2 - Heart Attack Weight"
label variable m2pha "MIDUS 2 - Heart Attack"
label values m2pha yesno

recode B1PA7 (2=0) 
recode B1PA7BB (2=0)
gen m2pangina=.
recode m2pangina(.=1) if B1PA7==1 & B1PA7BB==1
recode m2pangina(.=0) if B1PA7==0
gen m2panginawt=m2pangina*2.2 
label variable m2panginawt "MIDUS 2 - Angina Weight"
label variable m2pangina "MIDUS 2 - Angina"
label values m2pangina yesno

recode B1PA7 (2=0) 
recode B1PA7BC (2=0)
gen m2phblood=.
recode m2phblood(.=1) if B1PA7==1 & B1PA7BC==1
recode m2phblood(.=0) if B1PA7==0
gen m2phbloodwt=m2phblood*1.53 
label variable m2phbloodwt "MIDUS 2 - High Blood Pressure Weight"
label variable m2phblood "MIDUS 2 - High Blood Pressure"
label values m2phblood yesno

recode B1PA7 (2=0) 
recode B1PA7BD (2=0)
gen m2pvalve=.
recode m2pvalve(.=1) if B1PA7==1 & B1PA7BD==1
recode m2pvalve(.=0) if B1PA7==0
gen m2pvalvewt=m2pvalve*0.033 
label variable m2pvalvewt "MIDUS 2 - Mitrovalve Prolapse Weight"
label variable m2pvalve "MIDUS 2 - Mitrovalve Prolapse"
label values m2pvalve yesno

recode B1PA7 (2=0) 
recode B1PA7BI (2=0)
gen m2pfailure=.
recode m2pfailure(.=1) if B1PA7==1 & B1PA7BI==1
recode m2pfailure(.=0) if B1PA7==0
gen m2pfailurewt=m2pfailure*4.77 
label variable m2pfailurewt "MIDUS 2 - Heart Failure Weight"
label variable m2pfailure "MIDUS 2 - Heart Failure"
label values m2pfailure yesno

recode B1PA26 (2=0) 
recode B1PA7BA (2=0)
gen m2pbreast=.
recode m2pbreast(.=1) if B1PA26==1 & B1PA28A==1
recode m2pbreast(.=0) if B1PA26==0
gen m2pbreastwt=m2pbreast*0.886 
label variable m2pbreastwt "MIDUS 2 - Breast Cancer Weight"
label variable m2pbreast "MIDUS 2 - Breast Cancer"
label values m2pbreast yesno

recode B1PA26 (2=0) 
recode B1PA7BB (2=0)
gen m2pcervical=.
recode m2pcervical(.=1) if B1PA26==1 & B1PA28B==1
recode m2pcervical(.=0) if B1PA26==0
gen m2pcervicalwt=m2pcervical*0.723 
label variable m2pcervicalwt "MIDUS 2 - Cervical Cancer Weight"
label variable m2pcervical "MIDUS 2 - Cervical Cancer"
label values m2pcervical yesno

recode B1PA26 (2=0) 
recode B1PA7BC (2=0)
gen m2pcolon=.
recode m2pcolon(.=1) if B1PA26==1 & B1PA28C==1
recode m2pcolon(.=0) if B1PA26==0
gen m2pcolonwt=m2pcolon*1.18 
label variable m2pcolonwt "MIDUS 2 - Colon Cancer Weight"
label variable m2pcolon "MIDUS 2 - Colon Cancer"
label values m2pcolon yesno

recode B1PA26 (2=0) 
recode B1PA7BD (2=0)
gen m2plung=.
recode m2plung(.=1) if B1PA26==1 & B1PA28D==1
recode m2plung(.=0) if B1PA26==0
gen m2plungwt=m2plung*6.25 
label variable m2plungwt "MIDUS 2 - Lung Cancer Weight"
label variable m2plung "MIDUS 2 - Lung Cancer"
label values m2plung yesno

recode B1PA26 (2=0) 
recode B1PA7BA (2=0)
gen m2pleuk=.
recode m2pleuk(.=1) if B1PA26==1 & B1PA28E==1
recode m2pleuk(.=0) if B1PA26==0
gen m2pleukwt=m2pleuk*1.32 
label variable m2pleukwt "MIDUS 2 - Lymphoma/Leukemia Weight"
label variable m2pleuk "MIDUS 2 - Lymphoma/Leukemia"
label values m2pleuk yesno

recode B1PA26 (2=0) 
recode B1PA7BF (2=0)
gen m2pova=.
recode m2pova(.=1) if B1PA26==1 & B1PA28F==1
recode m2pova(.=0) if B1PA26==0
gen m2povawt=m2pova*1.87 
label variable m2povawt "MIDUS 2 - Ovarian Cancer Weight"
label variable m2pova "MIDUS 2 - Ovarian Cancer"
label values m2pova yesno

recode B1PA26 (2=0) 
recode B1PA7BG (2=0)
gen m2ppro=.
recode m2ppro(.=1) if B1PA26==1 & B1PA28G==1
recode m2ppro(.=0) if B1PA26==0
gen m2pprowt=m2ppro*0.402 
label variable m2pprowt "MIDUS 2 - Prostate Cancer Weight"
label variable m2ppro "MIDUS 2 - Prostate Cancer"
label values m2ppro yesno

recode B1PA26 (2=0) 
recode B1PA7BH (2=0)
gen m2pskin=.
recode m2pskin(.=1) if B1PA26==1 & B1PA28H==1
recode m2pskin(.=0) if B1PA26==0
gen m2pskinwt=m2pskin*-0.068 
label variable m2pskinwt "MIDUS 2 - Skin Cancer Weight"
label variable m2pskin "MIDUS 2 - Skin Cancer"
label values m2pskin yesno

recode B1PA26 (2=0) 
recode B1PA7BI (2=0)
gen m2pute=.
recode m2pute(.=1) if B1PA26==1 & B1PA28I==1
recode m2pute(.=0) if B1PA26==0
gen m2putewt=m2pute*0.753 
label variable m2putewt "MIDUS 2 - Uterine Cancer Weight"
label variable m2pute "MIDUS 2 - Uterine Cancer"
label values m2pute yesno

** M2 MULTIMORBIDITY VARIABLES SAQ CONDITION

recode B1SA11A (2=0), gen(m2scopd)
gen m2scopdwt=m2scopd*4.32
label variable m2scopdwt "MIDUS 2 - COPD Weight"
label variable m2scopd "MIDUS 2 - COPD Cancer"
label values m2scopd yesno

recode B1SA11D (2=0), gen(m2sarth)
gen m2sarthwt=m2sarth*3.79
label variable m2scopdwt "MIDUS 2 - Arthritis Weight"
label variable m2scopd "MIDUS 2 - Arthritis"
label values m2scopd yesno

recode B1SA11G (2=0), gen(m2sthyroid)
gen m2sthyroidwt=m2sthyroid*0.479
label variable m2sthyroidwt "MIDUS 2 - Thyroid Diesease Weight"
label variable m2sthyroid "MIDUS 2 - Thyroid Diesease"
label values m2sthyroid yesno

recode B1SA11L (2=0), gen(m2sgall)
gen m2sgallwt=m2sgall*0.929
label variable m2sgallwt "MIDUS 2 - Gallbladder Weight"
label variable m2sgall "MIDUS 2 - Gallbladder"
label values m2sgall yesno

recode B1SA11O (2=0), gen(m2saids)
gen m2saidswt=m2saids*2.91
label variable m2saidswt "MIDUS 2 - Aids Weight"
label variable m2saids "MIDUS 2 - Aids"
label values m2saids yesno

*Depression
gen m2sdep = B1PDEPDX
gen m2sdepwt=m2sdep*1.29
label variable m2sdepwt "MIDUS 2 - Depression Weight"
label variable m2sdep "MIDUS 2 - Depression"
label values m2sdep yesno

*Alcohol Problem
gen m2salc = B1SALCOH
gen m2salcwt=m2salc*1.37
label variable m2salcwt "MIDUS 2 - Alcohol Weight"
label variable m2salc "MIDUS 2 - Alcohol"
label values m2salc yesno

recode B1SA11V (2=0), gen(m2smig)
gen m2smigwt=m2smig*0.614
label variable m2smigwt "MIDUS 2 - Migraine Weight"
label variable m2smig "MIDUS 2 - Migraine"
label values m2smig yesno

recode B1SA11X (2=0), gen(m2sdia)
gen m2sdiawt=m2sdia*2.67
label variable m2sdiawt "MIDUS 2 - Diabetes Weight"
label variable m2sdia "MIDUS 2 - Diabetes"
label values m2sdia yesno

recode B1SA11Y (2=0), gen(m2sms)
gen m2smswt=m2sms*10.6
label variable m2smswt "MIDUS 2 - MS Weight"
label variable m2sms "MIDUS 2 - MS"
label values m2sms yesno

recode B1SA11Z (2=0), gen(m2sstroke)
gen m2sstrokewt=m2sstroke*3.79
label variable m2sstrokewt "MIDUS 2 - Stroke Weight"
label variable m2sstroke "MIDUS 2 - Stroke Cancer"
label values m2sstroke yesno

recode B1SA11AA (2=0), gen(m2sulcer)
gen m2sulcerwt=m2sulcer*1.08
label variable m2sulcerwt "MIDUS 2 - Ulcer Weight"
label variable m2sulcer "MIDUS 2 - Ulcer Cancer"
label values m2sulcer yesno

recode B1SA12C (2=0), gen(m2scholrx)
gen m2scholrxwt=m2scholrx*0.343
label variable m2scholrxwt "MIDUS 1 - Cholesterol Rx Weight"
label variable m2scholrx "MIDUS 1 - Cholesterol Rx Cancer"
label values m2scholrx yesno

*Create Multimorbidity Count Variable
gen MMB2=m2pha+m2pangina+m2phblood+m2pvalve+m2pfailure+m2pbreast+m2pcervical+m2pcolon+m2plung+m2pleuk+m2pova+m2ppro+m2pskin+m2pute+m2scopd+m2sarth+m2sthyroid+m2sgall+m2saids+m2sdep+m2smig+m2sdia+m2sms+m2sstroke+m2sulcer+m2scholrx
gen MMB2wt=m2phawt+m2panginawt+m2phbloodwt+m2pvalvewt+m2pfailurewt+m2pbreastwt+m2pcervicalwt+m2pcolonwt+m2plungwt+m2pleukwt+m2povawt+m2pprowt+m2pskinwt+m2putewt+m2scopdwt+m2sarthwt+m2sthyroidwt+m2sgallwt+m2saidswt+m2sdepwt+m2smigwt+m2sdiawt+m2smswt+m2sstrokewt+m2sulcerwt+m2scholrxwt

egen MMB2a=rowtotal(m2pha m2pangina m2phblood m2pvalve m2pfailure m2pbreast m2pcervical m2pcolon m2plung m2pleuk m2pova m2ppro m2pskin m2pute m2scopd m2sarth m2sthyroid m2sgall m2saids m2sdep m2smig m2sdia m2sms m2sstroke m2sulcer m2scholrx)
replace MMB2a=. if B1STATUS<2

** M2 MULTIMORBIDITY VARIABLES PROJECT 4 BIOMARKERS

*High Blood Pressure
recode B4H1B (2=0), gen(m2bhb)
gen m2bhbwt=m2bhb*1.53
label variable m2bhbwt "MIDUS 2 - BIO - High Blood Pressure Weight"
label variable m2bhb "MIDUS 2 - BIO - High Blood Pressure Disease"
label values m2bhb yesno

*High Blood Pressure Physician Diagnosed
recode B4H1B (2=0)
recode B4H1BD (2=0)
gen m2bhbD=.
recode m2bhbD (.=1) if B4H1BD==1
recode m2bhbD (.=0) if B4H1B==0 
gen m2bhbDwt=m2bhbD*1.53
label variable m2bhbD "MIDUS 2 - BIO - High Blood Pressure P Diagnosed"
label variable m2bhbD "MIDUS 2 - BIO - High Blood Pressure P Diagnosed Weight"

*Stroke
recode B4H1F (2=0), gen(m2bstroke)
gen m2bstrokewt=m2bstroke*3.79
label variable m2bstrokewt "MIDUS 2 - BIO - Stroke Weight"
label variable m2bstroke "MIDUS 2 - BIO - Stroke"
label values m2bstroke yesno

*Stroke Physician Diagnosed
recode B4H1F (2=0)
recode B4H1FD (2=0)
gen m2bstrokeD=.
recode m2bstrokeD (.=1) if B4H1FD==1
recode m2bstrokeD (.=0) if B4H1F==0
gen m2bstrokeDwt=m2bstrokeD*3.79
label variable m2bstrokeD "MIDUS 2 - BIO - Stroke P Diagnosed"
label variable m2bstrokeDwt "MIDUS 2 - BIO - Stroke P Diagnosed Weight"

*Cholesterol
recode B4H1H (2=0), gen(m2bchol)
gen m2bcholwt=m2bchol*0.343
label variable m2bcholwt "MIDUS 2 - BIO - High Cholesterol Weight"
label variable m2bchol "MIDUS 2 - BIO High Cholesterol"
label values m2bchol yesno

*Cholesterol Physician Diagnosed
recode B4H1H (2=0)
recode B4H1HD (2=0)
gen m2bcholD=.
recode m2bcholD (.=1) if B4H1HD==1
recode m2bcholD (.=0) if B4H1H==0 
gen m2bcholDwt=m2bcholD*0.343
label variable m2bcholD "MIDUS 2 - BIO - High Cholesterol P Diagnosed"
label variable m2bcholDwt "MIDUS 2 - BIO - High Cholesterol P Diagnosed Weight"
label values m2bcholD yesno

*Diabetes
recode B4H1I (2=0), gen(m2bdia)
gen m2bdiawt=m2bdia*2.67
label variable m2bdiawt "MIDUS 2 - BIO - Diabetes"
label variable m2bdia "MIDUS 2 - BIO - Diabetes"
label values m2bdia yesno

*Diabetes Physician Diagnosed
recode B4H1I (2=0)
recode B4H1ID (2=0) 
gen m2bdiaD=.
recode m2bdiaD (.=1) if B4H1ID==1
recode m2bdiaD (.=0) if B4H1I==0
gen m2bdiaDwt=m2bdiaD*0.343
label variable m2bdiaDwt "MIDUS 2 - BIO - Diabetes"
label variable m2bdiaD "MIDUS 2 - BIO - Diabetes"
label values m2bdiaD yesno

*Asthma
recode B4H1J (2=0), gen(m2basth)
gen m2basthwt=m2basth*1.62
label variable m2basthwt "MIDUS 2 - BIO - Asthma Weight"
label variable m2basth "MIDUS 2 - BIO - Asthma"
label values m2basth yesno

*Asthma Physician Diagnosed 
recode B4H1J (2=0)
recode B4H1JD (2=0)
gen m2basthD=.
recode m2basthD (.=1) if B4H1JD==1
recode m2basthD (.=0) if B4H1J==0
gen m2basthDwt=m2basthD*1.62
label variable m2basthDwt "MIDUS 2 - BIO - Asthma P Diagnosed Weight"
label variable m2basthD "MIDUS 2 - BIO - Asthma P Diganosed"
label values m2basthD yesno

*Thyroid Disease
recode B4H1N (2=0), gen(m2bthyroid)
gen m2bthyroidwt=m2bthyroid*0.479
label variable m2bthyroidwt "MIDUS 2 - BIO - Thyroid Disease Weight"
label variable m2bthyroid "MIDUS 2 - BIO Thyroid Disease"
label values m2bthyroid yesno

*Thyroid Disease Physician Diagnosed
recode B4H1N (2=0)
recode B4H1ND (2=0)
gen m2bthyroidD=.
recode m2bthyroidD (.=1) if B4H1ND==1
recode m2bthyroidD (.=0) if B4H1N==0
gen m2bthyroidDwt=m2bthyroidD*0.479
label variable m2bthyroidDwt "MIDUS 2 - BIO - Thyroid Disease P Diagnosed Weight"
label variable m2bthyroidD "MIDUS 2 - BIO - Thyroid Disease P Diganosed"
label values m2bthyroidD yesno

*Ulcer
recode B4H1O (2=0), gen(m2bulcer)
gen m2bulcerwt=m2bulcer*1.08
label variable m2bulcerwt "MIDUS 2 - Ulcer Weight"
label variable m2bulcer "MIDUS 2 - BIO - Ulcer"
label values m2bulcer yesno

*Ulcer Physician Diagnosed
recode B4H1O (2=0)
recode B4H1OD (2=0)
gen m2bulcerD=.
recode m2bulcerD (.=1) if B4H1OD==1
recode m2bulcerD (.=0) if B4H1O==0
gen m2bulcerDwt=m2bulcer*1.08
label variable m2bulcerDwt "MIDUS 2 - BIO - Ulcer P Diagnosed Weight"
label variable m2bulcerD "MIDUS 2 - BIO - Ulcer Diganosed"
label values m2bulcerD yesno

*Colon Polyp
recode B4H1Q (2=0), gen(m2bpolyp)
gen m2bpolypwt=m2bpolyp*0.01
label variable m2bpolypwt "MIDUS 2 - Colon Polyp Weight"
label variable m2bpolyp "MIDUS 2 - BIO - Colon Polyp"
label values m2bpolyp yesno

*Colon Polyp Physician Diagnosed 
recode B4H1Q (2=0)
recode B4H1QD (2=0)
gen m2bpolypD=.
recode m2bpolypD (.=1) if B4H1QD==1
recode m2bpolypD (.=0) if B4H1Q==0
gen m2bpolypDwt=m2bpolyp*0.01
label variable m2bpolypDwt "MIDUS 2 - BIO - Colon Polyp P Diagnosed Weight"
label variable m2bpolypD "MIDUS 2 - BIO - Colon Polyp Diganosed"
label values m2bpolypD yesno

*Arthritis 
recode B4H1R (2=0), gen(m2barth)
gen m2barthwt=m2barth*3.79
label variable m2barthwt "MIDUS 2 - Arthritis Weight"
label variable m2barth "MIDUS 2 - BIO - Arthritis"
label values m2barth yesno

*Arthritis Physician Diagnosed 
recode B4H1R (2=0)
recode B4H1RD (2=0)
gen m2barthD=.
recode m2barthD (.=1) if B4H1RD==1
recode m2barthD (.=0) if B4H1R==0
gen m2barthDwt=m2barth*3.79
label variable m2barthDwt "MIDUS 2 - Arthritis Weight P Diagnosed"
label variable m2barthD "MIDUS 2 - BIO - Arthritis P Diagnosed"
label values m2barthD yesno

*Glaucoma
recode B4H1S (2=0), gen(m2bglau)
gen m2bglauwt=m2bglau*0.427
label variable m2bglauwt "MIDUS 2 - Glaucoma Weight"
label variable m2bglau "MIDUS 2 - BIO - Glaucoma"
label values m2bglau yesno

*Glaucoma Physician Diagnosed
recode B4H1S (2=0)
recode B4H1SD (2=0)
gen m2bglauD=.
recode m2bglauD (.=1) if B4H1SD==1
recode m2bglauD (.=0) if B4H1S==0
gen m2bglauDwt=m2bglau*0.427
label variable m2bglauDwt "MIDUS 2 - Glaucoma P Diagnosed Weight"
label variable m2bglauD "MIDUS 2 - BIO - Glaucoma P Diagnosed"
label values m2bglauD yesno

*Cirrhosis 
recode B4H1T (2=0), gen(m2bcirr)
gen m2bcirrwt=m2bcirr*0.199
label variable m2bcirrwt "MIDUS 2 - Cirrhosis Weight"
label variable m2bcirr "MIDUS 2 - BIO - Cirrhosis "
label values m2bcirr yesno

*Cirrhosis Physician Diagnosed 
recode B4H1T (2=0)
recode B4H1TD (2=0)
gen m2bcirrD=.
recode m2bcirrD (.=1) if B4H1TD==1
recode m2bcirrD (.=0) if B4H1T==0
gen m2bcirrDwt=m2bcirr*0.199
label variable m2bcirrDwt "MIDUS 2 - Cirrhosis P Diganosed Weight"
label variable m2bcirrD "MIDUS 2 - BIO - Cirrhosis P Diagnosed"
label values m2bcirrD yesno

*Alcoholism
recode B4H1U (2=0), gen(m2balc)
gen m2balcwt=m2balc*1.37
label variable m2balcwt "MIDUS 2 - BIO - Alcoholism Weight"
label variable m2balc "MIDUS 2 - BIO - Alcoholism"
label values m2balc yesno

*Alcoholism Physician Diganosed 
recode B4H1U (2=0)
recode B4H1UD (2=0)
gen m2balcD=.
recode m2balcD (.=1) if B4H1UD==1
recode m2balcD (.=0) if B4H1U==0
gen m2balcDwt=m2balc*1.37
label variable m2balcDwt "MIDUS 2 - BIO - Alcoholism Weight P Diagnosed"
label variable m2balcD "MIDUS 2 - BIO - Alcoholism P Diagnosed"
label values m2balcD yesno

*Depression
recode B4H1V (2=0), gen(m2bdep)
gen m2bdepwt=m2bdep*1.29
label variable m2bdepwt "MIDUS 2 - Depression Weight"
label variable m2bdep "MIDUS 2 - BIO - Depression"
label values m2bdep yesno

*Depression Physician Diagnosed 
recode B4H1V (2=0)
recode B4H1VD (2=0)
gen m2bdepD=.
recode m2bdepD (.=1) if B4H1VD==1
recode m2bdepD (.=0) if B4H1V==0 | B4H1VD==0
gen m2bdepDwt=m2bdep*1.29
label variable m2bdepDwt "MIDUS 2 - Depression Weight P Diagnosed"
label variable m2bdepD "MIDUS 2 - BIO - Depression P Diagnosed"
label values m2bdepD yesno

*Create Multimorbidity Variable 
gen MMBio2=m2bhb+m2bstroke+m2bchol+m2bdia+m2basth+m2bthyroid+m2bulcer+m2bpolyp+m2barth+m2bglau+m2bcirr+m2balc+m2bdep
*Physician Diagnosed
gen MMBioD=m2bhbD+m2bstrokeD+m2bcholD+m2bdiaD+m2basthD+m2bthyroidD+m2bulcerD+m2bpolypD+m2barthD+m2bglauD+m2bcirrD+m2balcD+m2bdepD
*Weighted
gen MMBiowt=m2bhbwt+m2bstrokewt+m2bcholwt+m2bdiawt+m2basthwt+m2bthyroidwt+m2bulcerwt+m2bpolypwt+m2barthwt+m2bglauwt+m2bcirrwt+m2balcwt+m2bdepwt
*Weighted Physician diagnosed 
gen MMBioDwt=m2bhbDwt+m2bstrokeDwt+m2bcholDwt+m2bdiaDwt+m2basthDwt+m2bthyroidDwt+m2bulcerDwt+m2bpolypDwt+m2barthDwt+m2bglauDwt+m2bcirrDwt+m2balcDwt+m2bdepDwt

** M2 MULTIMORBIDITY VARIABLES PROJECT 4 BIOMARKERS Major Life Events

*recode B4H2AF (2=0), gen(m2bhip)
*gen m2bhipwt=m2bhip*3.56
*label variable m2bhipwt "MIDUS 2 - Broken Hip Weight"
*label variable m2bhip "MIDUS 2 - BIO - Broken Hip"
*label values m2bhip yesno

*recode B4H2KY (2=0), gen(m2bvert)
*gen m2bvertwt=m2bvert*2.07
*label variable m2bvertwt "MIDUS 2 - Broken Vertabra Weight"
*label variable m2bvert "MIDUS 2 - BIO - Broken Vertabra"
*label values m2bvert yesno

** M3 MULTIMORBIDITY VARIABLES PHONE CONDITION

recode C1PA7 (2=0) 
recode C1PA7BA (2=0)
gen m3pha=.
recode m3pha(.=1) if C1PA7==1 & C1PA7BA==1
recode m3pha(.=0) if C1PA7==0
gen m3phawt=m3pha*1.73 
label variable m3phawt "MIDUS 3 - Heart Attack Weight"
label variable m3pha "MIDUS 3 - Heart Attack"
label values m3pha yesno

recode C1PA7 (2=0) 
recode C1PA7BB (2=0)
gen m3pangina=.
recode m3pangina(.=1) if C1PA7==1 & C1PA7BB==1
recode m3pangina(.=0) if C1PA7==0
gen m3panginawt=m3pangina*1.73 
label variable m3panginawt "MIDUS 3 - Angina Weight"
label variable m3pangina "MIDUS 3 - Angina Attack"
label values m3pangina yesno

recode C1PA7 (2=0) 
recode C1PA7BC (2=0)
gen m3phblood=.
recode m3phblood(.=1) if C1PA7==1 & C1PA7BC==1
recode m3phblood(.=0) if C1PA7==0
gen m3phbloodwt=m3phblood*1.53 
label variable m3phbloodwt "MIDUS 3 - High Blood Pressure Weight"
label variable m3phblood "MIDUS 3 - High Blood Pressure"
label values m3phblood yesno

recode C1PA7 (2=0) 
recode C1PA7BD (2=0)
gen m3pvalve=.
recode m3pvalve(.=1) if C1PA7==1 & C1PA7BD==1
recode m3pvalve(.=0) if C1PA7==0
gen m3pvalvewt=m3pvalve*0.033 
label variable m3pvalvewt "MIDUS 3 - Mitrovalve Prolapse Weight"
label variable m3pvalve "MIDUS 3 - Mitrovalve Prolapse"
label values m3pvalve yesno

recode C1PA7 (2=0) 
recode C1PA7BI (2=0)
gen m3pfailure=.
recode m3pfailure(.=1) if C1PA7==1 & C1PA7BI==1
recode m3pfailure(.=0) if C1PA7==0
gen m3pfailurewt=m3pfailure*4.77
label variable m3pfailurewt "MIDUS 3 - Heart Failure Weight"
label variable m3pfailure "MIDUS 3 - Heart Failure"
label values m3pfailure yesno

recode C1PA26 (2=0) 
recode C1PA28A (2=0)
gen m3pbreast=.
recode m3pbreast(.=1) if C1PA26==1 & C1PA28A==1
recode m3pbreast(.=0) if C1PA26==0
gen m3pbreastwt=m3pbreast*0.886 
label variable m3pbreastwt "MIDUS 3 - Breast Cancer Weight"
label variable m3pbreast "MIDUS 3 - Breast Cancer"
label values m3pbreast yesno

recode C1PA26 (2=0) 
recode C1PA28B (2=0)
gen m3pcervical=.
recode m3pcervical(.=1) if C1PA26==1 & C1PA28B==1
recode m3pcervical(.=0) if C1PA26==0
gen m3pcervicalwt=m3pcervical*0.723 
label variable m3pcervicalwt "MIDUS 3 - Cervical Cancer Weight"
label variable m3pcervical "MIDUS 3 - Cervical Cancer"
label values m3pcervical yesno

recode C1PA26 (2=0) 
recode C1PA28C (2=0)
gen m3pcolon=.
recode m3pcolon(.=1) if C1PA26==1 & C1PA28C==1
recode m3pcolon(.=0) if C1PA26==0
gen m3pcolonwt=m3pcolon*0.723 
label variable m3pcolonwt "MIDUS 3 - Colon Cancer Weight"
label variable m3pcolon "MIDUS 3 - Colon Cancer"
label values m3pcolon yesno

recode C1PA26 (2=0) 
recode C1PA28D (2=0)
gen m3plung=.
recode m3plung(.=1) if C1PA26==1 & C1PA28D==1
recode m3plung(.=0) if C1PA26==0
gen m3plungwt=m3plung*6.25 
label variable m3plungwt "MIDUS 3 - Lung Cancer Weight"
label variable m3plung "MIDUS 3 - Lung Cancer"
label values m3plung yesno

recode C1PA26 (2=0) 
recode C1PA28E (2=0)
gen m3pleuk=.
recode m3pleuk(.=1) if C1PA26==1 & C1PA28E==1
recode m3pleuk(.=0) if C1PA26==0
gen m3pleukwt=m3pleuk*1.32 
label variable m3pleukwt "MIDUS 3 - Lymphoma/Leukemia Weight"
label variable m3pleuk "MIDUS 3 - Lymphoma/Leukemia"
label values m3pleuk yesno

recode C1PA26 (2=0) 
recode C1PA28F (2=0)
gen m3pova=.
recode m3pova(.=1) if C1PA26==1 & C1PA28F==1
recode m3pova(.=0) if C1PA26==0
gen m3povawt=m3pova*1.87 
label variable m3povawt "MIDUS 3 - Ovarian Cancer Weight"
label variable m3pova "MIDUS 3 - Ovarian Cancer"
label values m3pova yesno

recode C1PA26 (2=0) 
recode C1PA28G (2=0)
gen m3ppro=.
recode m3ppro(.=1) if C1PA26==1 & C1PA28G==1
recode m3ppro(.=0) if C1PA26==0
gen m3pprowt=m3ppro*0.402 
label variable m3pprowt "MIDUS 3 - Prostate Cancer Weight"
label variable m3ppro "MIDUS 3 - Prostate Cancer"
label values m3ppro yesno

recode C1PA26 (2=0) 
recode C1PA28H (2=0)
gen m3pskin=.
recode m3pskin(.=1) if C1PA26==1 & C1PA28H==1
recode m3pskin(.=0) if C1PA26==0
gen m3pskinwt=m3pskin*-0.068 
label variable m3pskinwt "MIDUS 3 - Skin Cancer Weight"
label variable m3pskin "MIDUS 3 - Skin Cancer"
label values m3pskin yesno

recode C1PA26 (2=0) 
recode C1PA28I (2=0)
gen m3pute=.
recode m3pute(.=1) if C1PA26==1 & C1PA28I==1
recode m3pute(.=0) if C1PA26==0
gen m3putewt=m3pute*0.753 
label variable m3putewt "MIDUS 3 - Uterine Cancer Weight"
label variable m3pute "MIDUS 3 - Uterine Cancer"
label values m3pute yesno

** M3 MULTIMORBIDITY VARIABLES SAQ CONDITION

recode C1SA11A (2=0), gen(m3scopd)
gen m3scopdwt=m3scopd*4.32
label variable m3scopdwt "MIDUS 1 - COPD Weight"
label variable m3scopd "MIDUS 1 - COPD"
label values m3scopd yesno

recode C1SA11B (2=0), gen(m3sarth)
gen m3sarthwt=m3sarth*3.79
label variable m3sarthwt "MIDUS 3 - Arthritis Weight"
label variable m3sarth "MIDUS 3 - Arthritis"
label values m3sarth yesno

recode C1SA11G (2=0), gen(m3sthyroid)
gen m3sthyroidwt=m3sthyroid*0.479
label variable m3sthyroidwt "MIDUS 3 - Thyroid Disease Weight"
label variable m3sthyroid "MIDUS 3 - Thyroid Disease"
label values m3sthyroid yesno

recode C1SA11L (2=0), gen(m3sgall)
gen m3sgallwt=m3sgall*0.929
label variable m3sgallwt "MIDUS 3 - Gallbladder Weight"
label variable m3sgall "MIDUS 3 - Gallbladder"
label values m3sgall yesno

recode C1SA11O (2=0), gen(m3saids)
gen m3saidswt=m3saids*2.91
label variable m3saidswt "MIDUS 3 - Aids Weight"
label variable m3saids "MIDUS 3 - Aids"
label values m3saids yesno

*Depression
gen m3sdep = C1PDEPDX
gen m3sdepwt=m3sdep*1.29
label variable m3sdepwt "MIDUS 3 - Depression Weight"
label variable m3sdep "MIDUS 3 - Depression"
label values m3sdep yesno

*Alcohol Problem
gen m3salc = C1SALCOH
gen m3salcwt=m3salc*1.37
label variable m3salcwt "MIDUS 3 - Alcohol Weight"
label variable m3salc "MIDUS 3 - Alcohol"
label values m3salc yesno

recode C1SA11V (2=0), gen(m3smig)
gen m3smigwt=m3smig*0.614
label variable m3smigwt "MIDUS 3 - Migraine Weight"
label variable m3smig "MIDUS 3 - Migraine"
label values m3smig yesno

recode C1SA11X (2=0), gen(m3sdia)
gen m3sdiawt=m3sdia*2.67
label variable m3sdiawt "MIDUS 3 - Diabetes Weight"
label variable m3sdia "MIDUS 3 - Diabetes"
label values m3sdia yesno

recode C1SA11Y (2=0), gen(m3sms)
gen m3smswt=m3sms*10.6
label variable m3smswt "MIDUS 3 - MS Weight"
label variable m3sms "MIDUS 3 - MS"
label values m3sms yesno

recode C1SA11Z (2=0), gen(m3sstroke)
gen m3sstrokewt=m3sstroke*3.79
label variable m3sstrokewt "MIDUS 3 - Stroke Weight"
label variable m3sstroke "MIDUS 3 - Stroke Cancer"
label values m3sstroke yesno

recode C1SA11AA (2=0), gen(m3sulcer)
gen m3sulcerwt=m3sulcer*1.08
label variable m3sulcerwt "MIDUS 3 - Ulcer Weight"
label variable m3sulcer "MIDUS 3 - Ulcer Cancer"
label values m3sulcer yesno

recode C1SA12C (6=0)(1=1)(2=1)(3=1)(4=1)(5=1), gen(m3scholrx)
gen m3scholrxwt=m3scholrx*0.343
label variable m3scholrxwt "MIDUS 3 - Cholesterol Rx Weight"
label variable m3scholrx "MIDUS 3 - Cholesterol Rx Cancer"
label values m3scholrx yesno

*Create Multimorbidity Count Variable 
gen MMB3=m3pha+m3pangina+m3phblood+m3pvalve+m3pfailure+m3pbreast+m3pcervical+m3pcolon+m3plung+m3pleuk+m3pova+m3ppro+m3pskin+m3pute+m3scopd+m3sarth+m3sthyroid+m3sgall+m3saids+m3sdep+m3smig+m3sdia+m3sms+m3sstroke+m3sulcer+m3scholrx
gen MMB3wt=m3phawt+m3panginawt+m3phbloodwt+m3pvalvewt+m3pfailurewt+m3pbreastwt+m3pcervicalwt+m3pcolonwt+m3plungwt+m3pleukwt+m3povawt+m3pprowt+m3pskinwt+m3putewt+m3scopdwt+m3sarthwt+m3sthyroidwt+m3sgallwt+m3saidswt+m3sdepwt+m3smigwt+m3sdiawt+m3smswt+m3sstrokewt+m3sulcerwt+m3scholrxwt


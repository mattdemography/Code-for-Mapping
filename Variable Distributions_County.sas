options nofmterr;
ods results=off;

/*
libname home "/home/s4-data/LatestCities/1880/SIS"; run;

data work; set home.all_1880;
KEEP 
serial sex raced relate related age bpld fbpld mbpld nativity sei marst
nchild county statefip;
run;

proc export data=work
outfile= "/home/mmarti24/all_1880_county.csv"
dbms=csv replace;
putnames=YES;
run;

*/

*Now Do "Variable Distributions_County.R";

libname home "/home/mmarti24/"; run;

PROC IMPORT OUT= work.work
            DATAFILE= "/home/mmarti24/all_1880_county_n.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES; 
RUN;

data work2; set work;
c_a=statefip||county;
run;

proc sort data=work2; by c_a;
data home.allcities (rename=count=County_ID); set work2;
by c_a;
if first.c_a then count +1;
else count=count;
drop c_a;
run;

data home.hh; set home.allcities;
if hh=1;
run;

data home.a1564_m; set home.allcities;
if a_15_64=1;
if male=1;
run;

data home.a1564_f; set home.allcities;
if a_15_64=1;
if female=1;
run;

data home.a1564; set home.allcities;
if a_15_64=1;
run;

data home.sei; set home.allcities;
if sei>0;
run;

data home.m_18; set home.allcities;
if a_18=1;
run;

data home.m_sex; set home.allcities;
if a_18_44=1;
run;


data home.allcities; set home.allcities; 
m5=0; if age<5 & male=1 then m5=1;
m5_9=0; if 5<=age<=9 & male=1 then m5_9=1;
m10_14=0; if 10<=age<=14 & male=1 then m10_14=1;
m15_17=0; if 15<=age<=17 & male=1 then m15_17=1;
m18_19=0; if 18<=age<=19 & male=1 then m18_19=1;
m20=0; if age=20 & male=1 then m20=1;
m21=0; if age=21 & male=1 then m21=1;
m22_24=0; if 22<=age<=24 & male=1 then m22_24=1;
m25_29=0; if 25<=age<=29 & male=1 then m25_29=1;
m30_34=0; if 30<=age<=34 & male=1 then m30_34=1;
m35_39=0; if 35<=age<=39 & male=1 then m35_39=1;
m40_44=0; if 40<=age<=44 & male=1 then m40_44=1;
m45_49=0; if 45<=age<=49 & male=1 then m45_49=1;
m50_54=0; if 50<=age<=54 & male=1 then m50_54=1;
m55_59=0; if 55<=age<=59 & male=1 then m55_59=1;
m60_61=0; if 60<=age<=61 & male=1 then m60_61=1;
m62_64=0; if 62<=age<=64 & male=1 then m62_64=1;
m65_66=0; if 65<=age<=66 & male=1 then m65_66=1;
m67_69=0; if 67<=age<=69 & male=1 then m67_69=1;
m70_74=0; if 70<=age<=74 & male=1 then m70_74=1;
m75_79=0; if 75<=age<=79 & male=1 then m75_79=1;
m80_84=0; if 80<=age<=84 & male=1 then m80_84=1;
m85=0; if age>=85 & male=1 then m85=1;

f5=0; if age<5 & female=1 then f5=1;
f5_9=0; if 5<=age<=9 & female=1 then f5_9=1;
f10_14=0; if 10<=age<=14 & female=1 then f10_14=1;
f15_17=0; if 15<=age<=17 & female=1 then f15_17=1;
f18_19=0; if 18<=age<=19 & female=1 then f18_19=1;
f20=0; if age=20 & female=1 then f20=1;
f21=0; if age=21 & female=1 then f21=1;
f22_24=0; if 22<=age<=24 & female=1 then f22_24=1;
f25_29=0; if 25<=age<=29 & female=1 then f25_29=1;
f30_34=0; if 30<=age<=34 & female=1 then f30_34=1;
f35_39=0; if 35<=age<=39 & female=1 then f35_39=1;
f40_44=0; if 40<=age<=44 & female=1 then f40_44=1;
f45_49=0; if 45<=age<=49 & female=1 then f45_49=1;
f50_54=0; if 50<=age<=54 & female=1 then f50_54=1;
f55_59=0; if 55<=age<=59 & female=1 then f55_59=1;
f60_61=0; if 60<=age<=61 & female=1 then f60_61=1;
f62_64=0; if 62<=age<=64 & female=1 then f62_64=1;
f65_66=0; if 65<=age<=66 & female=1 then f65_66=1;
f67_69=0; if 67<=age<=69 & female=1 then f67_69=1;
f70_74=0; if 70<=age<=74 & female=1 then f70_74=1;
f75_79=0; if 75<=age<=79 & female=1 then f75_79=1;
f80_84=0; if 80<=age<=84 & female=1 then f80_84=1;
f85=0; if age>=85 & female=1 then f85=1;

run;


*USE MAIN DATA SET;

proc sort data=home.allcities; by County_ID; run;
proc summary data=home.allcities; by County_ID; 
output out=calc_cnt(rename=(person=poptotC
black=blkCn blk_nm=blk_nmCn british=britCn canadian=canadaCn chinese=chinaCn danish=danishCn 
french=frenchCn german=germanCn irish=irishCn japanese=japanCn mulatto=mulattoCn
native_am=nat_amCn norwegian=norwayCn swedish=swedeCn yankee=nwnpCn
british_f=brit1Cn canadian_f=canada1Cn chinese_f=china1Cn danish_f=danish1Cn 
french_f=french1Cn german_f=german1Cn irish_f=irish1Cn japanese_f=japan1Cn 
norwegian_f=norway1Cn swedish_f=swede1Cn
british_s=brit2Cn canadian_s=canada2Cn chinese_s=china2Cn danish_s=danish2Cn 
french_s=french2Cn german_s=german2Cn irish_s=irish2Cn japanese_s=japan2Cn 
norwegian_s=norway2Cn swedish_s=swede2Cn
foreign=fbCn a_60=t60Cn a_16=t0_16Cn
m5=m0_4Cn m5_9=m5_9Cn m10_14=m10_14Cn m15_17=m15_17Cn m18_19=m18_19Cn m20=m20Cn m21=m21Cn 
m22_24=m22_24Cn m25_29=m25_29Cn m30_34=m30_34Cn m35_39=m35_39Cn
m40_44=m40_44Cn m45_49=m45_49Cn m50_54=m50_54Cn m55_59=m55_59Cn 
m60_61=m60_61Cn m62_64=m62_64Cn m65_66=m65_66Cn m67_69=m67_69Cn 
m70_74=m70_74Cn m75_79=m75_79Cn m80_84=m80_84Cn m85=m85Cn
f5=f0_4Cn f5_9=f5_9Cn f10_14=f10_14Cn f15_17=f15_17Cn f18_19=f18_19Cn f20=f20Cn f21=f21Cn 
f22_24=f22_24Cn f25_29=f25_29Cn f30_34=f30_34Cn f35_39=f35_39Cn
f40_44=f40_44Cn f45_49=f45_49Cn f50_54=f50_54Cn f55_59=f55_59Cn 
f60_61=f60_61Cn f62_64=f62_64Cn f65_66=f65_66Cn f67_69=f67_69Cn 
f70_74=f70_74Cn f75_79=f75_79Cn f80_84=f80_84Cn f85=f85Cn) drop=_TYPE_ _FREQ_) sum=;
var black blk_nm british canadian chinese danish french german irish japanese mulatto
native_am norwegian swedish yankee british_f canadian_f chinese_f danish_f french_f 
german_f irish_f japanese_f norwegian_f swedish_f
british_s canadian_s chinese_s danish_s french_s german_s irish_s japanese_s
norwegian_s swedish_s foreign a_60 a_16 
m5 m5_9 m10_14 m15_17 m18_19 m20 m21 m22_24 m25_29 m30_34 m35_39
m40_44 m45_49 m50_54 m55_59 m60_61 m62_64 m65_66 m67_69 m70_74 m75_79 m80_84 m85 
f5 f5_9 f10_14 f15_17 f18_19 f20 f21 f22_24 f25_29 f30_34 f35_39 
f40_44 f45_49 f50_54 f55_59 f60_61 f62_64 f65_66 f67_69 f70_74 f75_79 f80_84 f85
person; run;

data calc_cnt; set calc_cnt; 
blkCp=(blkCn/poptotC)*100;
blk_nmCp=(blk_nmCn/poptotC)*100;
britCp=(britCn/poptotC)*100;
canadaCp=(canadaCn/poptotC)*100;
chinaCp=(chinaCn/poptotC)*100;
danishCp=(danishCn/poptotC)*100;
frenchCp=(frenchCn/poptotC)*100;
germanCp=(germanCn/poptotC)*100;
irishCp=(irishCn/poptotC)*100;
japanCp=(japanCn/poptotC)*100;
mulattoCp=(mulattoCn/poptotC)*100;
nat_amCp=(nat_amCn/poptotC)*100;
norwayCp=(norwayCn/poptotC)*100;
swedeCp=(swedeCn/poptotC)*100;
nwnpCp=(nwnpCn/poptotC)*100;

brit1Cp=(brit1Cn/poptotC)*100;
canada1Cp=(canada1Cn/poptotC)*100;
china1Cp=(china1Cn/poptotC)*100;
danish1Cp=(danish1Cn/poptotC)*100;
french1Cp=(french1Cn/poptotC)*100;
german1Cp=(german1Cn/poptotC)*100;
irish1Cp=(irish1Cn/poptotC)*100;
japan1Cp=(japan1Cn/poptotC)*100;
norway1Cp=(norway1Cn/poptotC)*100;
swede1Cp=(swede1Cn/poptotC)*100;

brit2Cp=(brit2Cn/poptotC)*100;
canada2Cp=(canada2Cn/poptotC)*100;
china2Cp=(china2Cn/poptotC)*100;
danish2Cp=(danish2Cn/poptotC)*100;
french2Cp=(french2Cn/poptotC)*100;
german2Cp=(german2Cn/poptotC)*100;
irish2Cp=(irish2Cn/poptotC)*100;
japan2Cp=(japan2Cn/poptotC)*100;
norway2Cp=(norway2Cn/poptotC)*100;
swede2Cp=(swede2Cn/poptotC)*100;

fbCp=(fbCn/poptotC)*100;
t60Cp=(t60Cn/poptotC)*100;
t0_16Cp=(t0_16Cn/poptotC)*100;

if city ne 0;

run;

*USE SEI SUBSET;
proc sort data=home.a1564_m; by County_ID; run;
proc summary data=home.a1564_m; by County_ID; 
output out=calc_sei_m(rename=(person=m15_64Cn m_sei_1564=mlf15_64Cn) drop=_TYPE_ _FREQ_) sum=;
var m_sei_1564 person; run;

data calc_sei_m; set calc_sei_m;
mlf15_64Cp=(mlf15_64Cn/m15_64Cn)*100;
run;

proc sort data=calc_cnt; by County_ID;
proc sort data=calc_sei_m; by County_ID;
data calc_cnt; merge calc_cnt calc_sei_m; by County_ID; run;

proc sort data=home.a1564_f; by County_ID; run;
proc summary data=home.a1564_f; by County_ID; 
output out=calc_sei_f(rename=(person=f15_64Cn w_sei_1564=flf15_64Cn) drop=_TYPE_ _FREQ_) sum=;
var w_sei_1564 person; run;

data calc_sei_f; set calc_sei_f;
flf15_64Cp=(flf15_64Cn/f15_64Cn)*100;
run;

proc sort data=calc_cnt; by County_ID;
proc sort data=calc_sei_f; by County_ID;
data calc_cnt; merge calc_cnt calc_sei_f; by County_ID; run;

proc sort data=home.a1564; by County_ID; run;
proc summary data=home.a1564; by County_ID; 
output out=calc_sei(rename=(person=t15_64Cn sei_1564=tlf15_64Cn) drop=_TYPE_ _FREQ_) sum=;
var sei_1564 person; run;

data calc_sei; set calc_sei;
tlf15_64Cp=(tlf15_64Cn/t15_64Cn)*100;
run;

proc sort data=calc_cnt; by County_ID;
proc sort data=calc_sei; by County_ID;
data calc_cnt; merge calc_cnt calc_sei; by County_ID; run;

*USE 18+ SUBSET;
proc sort data=home.m_18; by County_ID; run;
proc summary data=home.m_18; by County_ID; 
output out=calc_m_18(rename=(person=t18Cn married_18=marriedCn) drop=_TYPE_ _FREQ_) sum=;
var married_18 person; run;

data calc_m_18; set calc_m_18;
marriedCp=(marriedCn/t18Cn)*100;
run;

proc sort data=calc_m_18; by County_ID;
proc sort data=calc_cnt; by County_ID;
data calc_cnt; merge calc_cnt calc_m_18; by County_ID; run;

*USE 18-44 SUBSET;
proc sort data=home.m_sex; by County_ID; run;
proc summary data=home.m_sex; by County_ID; 
output out=calc_sex(rename=(person=t18_44Cn male=m18_44Cn female=f18_44Cn) drop=_TYPE_ _FREQ_) sum=;
var male female person; run;

data calc_sex; set calc_sex;
m18_44Cp=(m18_44Cn/t18_44Cn)*100;
f18_44Cp=(f18_44Cn/t18_44Cn)*100;
run;

proc sort data=calc_sex; by County_ID;
proc sort data=calc_cnt; by County_ID;
data calc_cnt; merge calc_cnt calc_sex; by County_ID; run;

*USE HOUSEHOLD SUBSET;
proc sort data=home.hh; by County_ID; run;
proc summary data=home.hh; by County_ID; 
output out=calc_hh(rename=(person=hhCn hh_married_children=hh_kidsCn) drop=_TYPE_ _FREQ_) sum=;
var hh_married_children person; run;

data calc_hh; set calc_hh;
hh_kidsCp=(hh_kidsCn/hhCn)*100;
run;

proc sort data=calc_hh; by County_ID;
proc sort data=calc_cnt; by County_ID;
data calc_cnt; merge calc_cnt calc_hh; by County_ID; run;

proc sort data=home.sei; by County_ID; run;
proc summary data=home.sei; by County_ID;
output out=sei_mean(rename=(sei=meanseiC) drop=_TYPE_ _FREQ_) mean=;
var sei; run;

proc sort data=calc_cnt; by County_ID;
proc sort data=sei_mean; by County_ID;
data calc_cnt; merge calc_cnt sei_mean; by County_ID; drop male female city; year=1880; run;

data all; set home.allcities;
keep statefip county county_id;
run;

data calc_cnt; merge calc_cnt all; by county_id; run;
data home.calculations_all_county; set calc_cnt;
run;

PROC EXPORT DATA= home.calculations_all_county
            OUTFILE= "/home/mmarti24/Calculation_All_County.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;



/*
ods pdf file="/home/mmarti24/County_Distributions.pdf";
title "Percent Black - County";
proc freq data=calc_all; tables blk_p; run;
title "Percent Black Not Mulatto - County";
proc freq data=calc_all; tables blk_nm_p; run;
title "Percent British - County";
proc freq data=calc_all  ; tables british_p; run;
title "Percent Canadian - County";
proc freq data=calc_all  ; tables canadian_p; run;
title "Percent Chinese - County";
proc freq data=calc_all  ; tables chinese_p; run;
title "Percent Danish - County";
proc freq data=calc_all  ; tables danish_p; run;
title "Percent French - County";
proc freq data=calc_all  ; tables french_p; run;
title "Percent German - County";
proc freq data=calc_all  ; tables german_p; run;
title "Percent Irish - County";
proc freq data=calc_all  ; tables irish_p; run;
title "Percent Japanese - County";
proc freq data=calc_all  ; tables japanese_p; run;
title "Percent Mulatto - County";
proc freq data=calc_all  ; tables mulatto_p; run;
title "Percent Native American - County";
proc freq data=calc_all  ; tables native_am_p; run;
title "Percent Norwegian - County";
proc freq data=calc_all  ; tables norwegian_p; run;
title "Percent Swedish - County";
proc freq data=calc_all  ; tables swedish_p; run;
title "Percent Yankee - County";
proc freq data=calc_all  ; tables yankee_p; run;
title "Percent Foreign Born - County";
proc freq data=calc_all  ; tables foreign_p; run;
title "Percent 60 and Older - County";
proc freq data=calc_all  ; tables a_60_p; run;
title "Percent 16 and Younger - County";
proc freq data=calc_all  ; tables a_16_p; run;
title "Percent Women with SEI among women age 15-64 - County";
proc freq data=calc_all  ; tables w_sei_p; run;
title "Percent Men with SEI among men age 15-64 - County";
proc freq data=calc_all  ; tables m_sei_p; run;
title "Percent Men and women with SEI among persons age 15-64 - County";
proc freq data=calc_all  ; tables sei_p;  run;
title "Percent Married among age 18+ - County";
proc freq data=calc_all  ; tables married_p; run;
title "Percent Male 18-44 - County";
proc freq data=calc_all  ; tables male_p; run;
title "Percent Female 18-44 - County";
proc freq data=calc_all  ; tables female_p; run;
title "Percent Households Married Couples With Children - County";
proc freq data=calc_all  ; tables marry_child_p; run;
title "Mean SEI of Persons with SEI - County";
proc freq data=calc_all  ; tables sei_mean; run;

ods pdf close;


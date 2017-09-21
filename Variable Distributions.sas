
libname home "S:\Projects\Preparing 1880 Files\Online Maps\Data"; run;

PROC IMPORT OUT= All_1
            DATAFILE= "S:\Projects\Preparing 1880 Files\Online Maps\Data\AllCities_1.csv" 
            DBMS=CSV REPLACE; 
RUN;

PROC IMPORT OUT= All_2
            DATAFILE= "S:\Projects\Preparing 1880 Files\Online Maps\Data\AllCities_2.csv" 
            DBMS=CSV REPLACE;
RUN;

PROC IMPORT OUT= Chi_3
            DATAFILE= "S:\Projects\Preparing 1880 Files\Online Maps\Data\Chicago_3.csv" 
            DBMS=CSV REPLACE;
RUN;

data all_2b; set all_2;
has_sein=has_sei*1;
sei_num=sei*1;
sei_1564n=sei_1564 * 1;
w_sei_1564n=w_sei_1564 *1;
Drop sei sei_1564 w_sei_1564 has_sei;
run;

proc datasets lib=work nolist;
delete all_2; quit; run;

data all_2c; set all_2b;
has_sei=has_sein;
sei=sei_num;
sei_1564=sei_1564n;
w_sei_1564=w_sei_1564n;
Drop sei_num sei_1564n w_sei_1564n has_sein;
run;

proc datasets lib=work nolist;
delete all_2b; quit; run;

data home.allcities;  set all_1 all_2c chi_3;  
run;

proc datasets lib=work nolist;
delete all_1 all_2c chi_3; quit; run;

data work; set home.allcities;
c_a=city||address;
c_s=city||Segment_id;
c_e=city||enumdist;
if street ne "NA"; run;

proc sort data=work; by c_a;
data work2 (rename=count=Address_ID); set work;
by c_a;
if first.c_a then count +1;
else count=count;
drop c_a;
run;

proc datasets lib=work nolist;
delete work; quit; run;

proc sort data=work2; by c_s;
data work3 (rename=count=City_Seg_ID); set work2;
by c_s;
if first.c_s then count +1;
else count=count;
drop c_s;
run;

proc datasets lib=work nolist;
delete work2; quit; run;

proc sort data=work3; by c_e;
data home.allcities (rename=count=ED_ID); set work3;
by c_e;
if first.c_e then count +1;
else count=count;
drop c_e;
run;

proc datasets lib=work nolist;
delete work3; quit; run;

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


****** BUILDING LEVEL ******;

proc sort data=home.allcities; by Address_ID; run;
proc summary data=home.allcities; by Address_ID; 
output out=calc_build(rename=(person=poptotB
black=blkBn blk_nm=blk_nmBn british=britBn canadian=canadaBn chinese=chinaBn danish=danishBn 
french=frenchBn german=germanBn irish=irishBn japanese=japanBn mulatto=mulattoBn
native_am=nat_amBn norwegian=norwayBn swedish=swedeBn yankee=nwnpBn
british_f=brit1Bn canadian_f=canada1Bn chinese_f=china1Bn danish_f=danish1Bn 
french_f=french1Bn german_f=german1Bn irish_f=irish1Bn japanese_f=japan1Bn 
norwegian_f=norway1Bn swedish_f=swede1Bn
british_s=brit2Bn canadian_s=canada2Bn chinese_s=china2Bn danish_s=danish2Bn 
french_s=french2Bn german_s=german2Bn irish_s=irish2Bn japanese_s=japan2Bn 
norwegian_s=norway2Bn swedish_s=swede2Bn
foreign=fbBn a_60=t60Bn a_16=t0_16Bn
m5=m0_4Bn m5_9=m5_9Bn m10_14=m10_14Bn m15_17=m15_17Bn m18_19=m18_19Bn m20=m20Bn m21=m21Bn 
m22_24=m22_24Bn m25_29=m25_29Bn m30_34=m30_34Bn m35_39=m35_39Bn
m40_44=m40_44Bn m45_49=m45_49Bn m50_54=m50_54Bn m55_59=m55_59Bn 
m60_61=m60_61Bn m62_64=m62_64Bn m65_66=m65_66Bn m67_69=m67_69Bn 
m70_74=m70_74Bn m75_79=m75_79Bn m80_84=m80_84Bn m85=m85Bn
f5=f0_4Bn f5_9=f5_9Bn f10_14=f10_14Bn f15_17=f15_17Bn f18_19=f18_19Bn f20=f20Bn f21=f21Bn 
f22_24=f22_24Bn f25_29=f25_29Bn f30_34=f30_34Bn f35_39=f35_39Bn
f40_44=f40_44Bn f45_49=f45_49Bn f50_54=f50_54Bn f55_59=f55_59Bn 
f60_61=f60_61Bn f62_64=f62_64Bn f65_66=f65_66Bn f67_69=f67_69Bn 
f70_74=f70_74Bn f75_79=f75_79Bn f80_84=f80_84Bn f85=f85Bn) drop=_TYPE_ _FREQ_) sum=;
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

data calc_build; set calc_build; 
blkBp=(blkBn/poptotB)*100;
blk_nmBp=(blk_nmBn/poptotB)*100;
britBp=(britBn/poptotB)*100;
canadaBp=(canadaBn/poptotB)*100;
chinaBp=(chinaBn/poptotB)*100;
danishBp=(danishBn/poptotB)*100;
frenchBp=(frenchBn/poptotB)*100;
germanBp=(germanBn/poptotB)*100;
irishBp=(irishBn/poptotB)*100;
japanBp=(japanBn/poptotB)*100;
mulattoBp=(mulattoBn/poptotB)*100;
nat_amBp=(nat_amBn/poptotB)*100;
norwayBp=(norwayBn/poptotB)*100;
swedeBp=(swedeBn/poptotB)*100;
nwnpBp=(nwnpBn/poptotB)*100;

brit1Bp=(brit1Bn/poptotB)*100;
canada1Bp=(canada1Bn/poptotB)*100;
china1Bp=(china1Bn/poptotB)*100;
danish1Bp=(danish1Bn/poptotB)*100;
french1Bp=(french1Bn/poptotB)*100;
german1Bp=(german1Bn/poptotB)*100;
irish1Bp=(irish1Bn/poptotB)*100;
japan1Bp=(japan1Bn/poptotB)*100;
norway1Bp=(norway1Bn/poptotB)*100;
swede1Bp=(swede1Bn/poptotB)*100;

brit2Bp=(brit2Bn/poptotB)*100;
canada2Bp=(canada2Bn/poptotB)*100;
china2Bp=(china2Bn/poptotB)*100;
danish2Bp=(danish2Bn/poptotB)*100;
french2Bp=(french2Bn/poptotB)*100;
german2Bp=(german2Bn/poptotB)*100;
irish2Bp=(irish2Bn/poptotB)*100;
japan2Bp=(japan2Bn/poptotB)*100;
norway2Bp=(norway2Bn/poptotB)*100;
swede2Bp=(swede2Bn/poptotB)*100;

fbBp=(fbBn/poptotB)*100;
t60Bp=(t60Bn/poptotB)*100;
t0_16Bp=(t0_16Bn/poptotB)*100;

if city ne 0;

run;

*USE SEI SUBSET;
proc sort data=home.a1564_m; by Address_ID; run;
proc summary data=home.a1564_m; by Address_ID; 
output out=calc_sei_m(rename=(person=m15_64Bn m_sei_1564=mlf15_64Bn) drop=_TYPE_ _FREQ_) sum=;
var m_sei_1564 person; run;

data calc_sei_m; set calc_sei_m;
mlf15_64Bp=(mlf15_64Bn/m15_64Bn)*100;
run;

proc sort data=calc_build; by Address_ID;
proc sort data=calc_sei_m; by Address_ID;
data calc_build; merge calc_build calc_sei_m; by Address_ID; run;

proc sort data=home.a1564_f; by Address_ID; run;
proc summary data=home.a1564_f; by Address_ID; 
output out=calc_sei_f(rename=(person=f15_64Bn w_sei_1564=flf15_64Bn) drop=_TYPE_ _FREQ_) sum=;
var w_sei_1564 person; run;

data calc_sei_f; set calc_sei_f;
flf15_64Bp=(flf15_64Bn/f15_64Bn)*100;
run;

proc sort data=calc_build; by Address_ID;
proc sort data=calc_sei_f; by Address_ID;
data calc_build; merge calc_build calc_sei_f; by Address_ID; run;

proc sort data=home.a1564; by Address_ID; run;
proc summary data=home.a1564; by Address_ID; 
output out=calc_sei(rename=(person=t15_64Bn sei_1564=tlf15_64Bn) drop=_TYPE_ _FREQ_) sum=;
var sei_1564 person; run;

data calc_sei; set calc_sei;
tlf15_64Bp=(tlf15_64Bn/t15_64Bn)*100;
run;

proc sort data=calc_build; by Address_ID;
proc sort data=calc_sei; by Address_ID;
data calc_build; merge calc_build calc_sei; by Address_ID; run;

*USE 18+ SUBSET;
proc sort data=home.m_18; by Address_ID; run;
proc summary data=home.m_18; by Address_ID; 
output out=calc_m_18(rename=(person=t18Bn married_18=marriedBn) drop=_TYPE_ _FREQ_) sum=;
var married_18 person; run;

data calc_m_18; set calc_m_18;
marriedBp=(marriedBn/t18Bn)*100;
run;

proc sort data=calc_m_18; by Address_ID;
proc sort data=calc_build; by Address_ID;
data calc_build; merge calc_build calc_m_18; by Address_ID; run;

*USE 18-44 SUBSET;
proc sort data=home.m_sex; by Address_ID; run;
proc summary data=home.m_sex; by Address_ID; 
output out=calc_sex(rename=(person=t18_44Bn male=m18_44Bn female=f18_44Bn) drop=_TYPE_ _FREQ_) sum=;
var male female person; run;

data calc_sex; set calc_sex;
m18_44Bp=(m18_44Bn/t18_44Bn)*100;
f18_44Bp=(f18_44Bn/t18_44Bn)*100;
run;

proc sort data=calc_sex; by Address_ID;
proc sort data=calc_build; by Address_ID;
data calc_build; merge calc_build calc_sex; by Address_ID; run;

*USE HOUSEHOLD SUBSET;
proc sort data=home.hh; by Address_ID; run;
proc summary data=home.hh; by Address_ID; 
output out=calc_hh(rename=(person=hhBn hh_married_children=hh_kidsBn) drop=_TYPE_ _FREQ_) sum=;
var hh_married_children person; run;

data calc_hh; set calc_hh;
hh_kidsBp=(hh_kidsBn/hhBn)*100;
run;

proc sort data=calc_hh; by Address_ID;
proc sort data=calc_build; by Address_ID;
data calc_build; merge calc_build calc_hh; by Address_ID; run;

proc sort data=home.sei; by Address_ID; run;
proc summary data=home.sei; by Address_ID;
output out=sei_mean(rename=(sei=meanseiB) drop=_TYPE_ _FREQ_) mean=;
var sei; run;

proc sort data=calc_build; by Address_ID;
proc sort data=sei_mean; by Address_ID;
data calc_build; merge calc_build sei_mean; by Address_ID; drop male female city; year=1880; run;

PROC EXPORT DATA= WORK.CALC_BUILD
            OUTFILE= "S:\Projects\Preparing 1880 Files\Online Maps\Data\Calculation_All_Building.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;

****** SEGMENT LEVEL *******;
proc sort data=home.allcities; by City_Seg_ID; run;
proc summary data=home.allcities; by City_Seg_ID; 
output out=calc_segment(rename=(person=poptotS
black=blkSn blk_nm=blk_nmSn british=britSn canadian=canadaSn chinese=chinaSn danish=danishSn 
french=frenchSn german=germanSn irish=irishSn japanese=japanSn mulatto=mulattoSn
native_am=nat_amSn norwegian=norwaySn swedish=swedeSn yankee=nwnpSn
british_f=brit1Sn canadian_f=canada1Sn chinese_f=china1Sn danish_f=danish1Sn 
french_f=french1Sn german_f=german1Sn irish_f=irish1Sn japanese_f=japan1Sn 
norwegian_f=norway1Sn swedish_f=swede1Sn
british_s=brit2Sn canadian_s=canada2Sn chinese_s=china2Sn danish_s=danish2Sn 
french_s=french2Sn german_s=german2Sn irish_s=irish2Sn japanese_s=japan2Sn 
norwegian_s=norway2Sn swedish_s=swede2Sn
foreign=fbSn a_60=t60Sn a_16=t0_16Sn
m5=m0_4Sn m5_9=m5_9Sn m10_14=m10_14Sn m15_17=m15_17Sn m18_19=m18_19Sn m20=m20Sn m21=m21Sn 
m22_24=m22_24Sn m25_29=m25_29Sn m30_34=m30_34Sn m35_39=m35_39Sn
m40_44=m40_44Sn m45_49=m45_49Sn m50_54=m50_54Sn m55_59=m55_59Sn 
m60_61=m60_61Sn m62_64=m62_64Sn m65_66=m65_66Sn m67_69=m67_69Sn 
m70_74=m70_74Sn m75_79=m75_79Sn m80_84=m80_84Sn m85=m85Sn
f5=f0_4Sn f5_9=f5_9Sn f10_14=f10_14Sn f15_17=f15_17Sn f18_19=f18_19Sn f20=f20Sn f21=f21Sn 
f22_24=f22_24Sn f25_29=f25_29Sn f30_34=f30_34Sn f35_39=f35_39Sn
f40_44=f40_44Sn f45_49=f45_49Sn f50_54=f50_54Sn f55_59=f55_59Sn 
f60_61=f60_61Sn f62_64=f62_64Sn f65_66=f65_66Sn f67_69=f67_69Sn 
f70_74=f70_74Sn f75_79=f75_79Sn f80_84=f80_84Sn f85=f85Sn) drop=_TYPE_ _FREQ_) sum=;
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


data calc_segment; set calc_segment; 
blkSp=(blkSn/poptotS)*100;
blk_nmSp=(blk_nmSn/poptotS)*100;
britSp=(britSn/poptotS)*100;
canadaSp=(canadaSn/poptotS)*100;
chinaSp=(chinaSn/poptotS)*100;
danishSp=(danishSn/poptotS)*100;
frenchSp=(frenchSn/poptotS)*100;
germanSp=(germanSn/poptotS)*100;
irishSp=(irishSn/poptotS)*100;
japanSp=(japanSn/poptotS)*100;
mulattoSp=(mulattoSn/poptotS)*100;
nat_amSp=(nat_amSn/poptotS)*100;
norwaySp=(norwaySn/poptotS)*100;
swedeSp=(swedeSn/poptotS)*100;
nwnpSp=(nwnpSn/poptotS)*100;

brit1Sp=(brit1Sn/poptotS)*100;
canada1Sp=(canada1Sn/poptotS)*100;
china1Sp=(china1Sn/poptotS)*100;
danish1Sp=(danish1Sn/poptotS)*100;
french1Sp=(french1Sn/poptotS)*100;
german1Sp=(german1Sn/poptotS)*100;
irish1Sp=(irish1Sn/poptotS)*100;
japan1Sp=(japan1Sn/poptotS)*100;
norway1Sp=(norway1Sn/poptotS)*100;
swede1Sp=(swede1Sn/poptotS)*100;

brit2Sp=(brit2Sn/poptotS)*100;
canada2Sp=(canada2Sn/poptotS)*100;
china2Sp=(china2Sn/poptotS)*100;
danish2Sp=(danish2Sn/poptotS)*100;
french2Sp=(french2Sn/poptotS)*100;
german2Sp=(german2Sn/poptotS)*100;
irish2Sp=(irish2Sn/poptotS)*100;
japan2Sp=(japan2Sn/poptotS)*100;
norway2Sp=(norway2Sn/poptotS)*100;
swede2Sp=(swede2Sn/poptotS)*100;

fbSp=(fbSn/poptotS)*100;
t60Sp=(t60Sn/poptotS)*100;
t0_16Sp=(t0_16Sn/poptotS)*100;

if city ne 0;

run;


*USE SEI SUBSET;
proc sort data=home.a1564_m; by City_Seg_ID; run;
proc summary data=home.a1564_m; by City_Seg_ID; 
output out=calc_sei_m(rename=(person=m15_64Sn m_sei_1564=mlf15_64Sn) drop=_TYPE_ _FREQ_) sum=;
var m_sei_1564 person; run;

data calc_sei_m; set calc_sei_m;
mlf15_64Sp=(mlf15_64Sn/m15_64Sn)*100;
run;

proc sort data=calc_segment; by City_Seg_ID;
proc sort data=calc_sei_m; by City_Seg_ID;
data calc_segment; merge calc_segment calc_sei_m; by City_Seg_ID; run;

proc sort data=home.a1564_f; by City_Seg_ID; run;
proc summary data=home.a1564_f; by City_Seg_ID; 
output out=calc_sei_f(rename=(person=f15_64Sn w_sei_1564=flf15_64Sn) drop=_TYPE_ _FREQ_) sum=;
var w_sei_1564 person; run;

data calc_sei_f; set calc_sei_f;
flf15_64Sp=(flf15_64Sn/f15_64Sn)*100;
run;

proc sort data=calc_segment; by City_Seg_ID;
proc sort data=calc_sei_f; by City_Seg_ID;
data calc_segment; merge calc_segment calc_sei_f; by City_Seg_ID; run;

proc sort data=home.a1564; by City_Seg_ID; run;
proc summary data=home.a1564; by City_Seg_ID; 
output out=calc_sei(rename=(person=t15_64Sn sei_1564=tlf15_64Sn) drop=_TYPE_ _FREQ_) sum=;
var sei_1564 person; run;

data calc_sei; set calc_sei;
tlf15_64Sp=(tlf15_64Sn/t15_64Sn)*100;
run;

proc sort data=calc_segment; by City_Seg_ID;
proc sort data=calc_sei; by City_Seg_ID;
data calc_segment; merge calc_segment calc_sei; by City_Seg_ID; run;

*USE 18+ SUBSET;
proc sort data=home.m_18; by City_Seg_ID; run;
proc summary data=home.m_18; by City_Seg_ID; 
output out=calc_m_18(rename=(person=t18Sn married_18=marriedSn) drop=_TYPE_ _FREQ_) sum=;
var married_18 person; run;

data calc_m_18; set calc_m_18;
marriedSp=(marriedSn/t18Sn)*100;
run;

proc sort data=calc_m_18; by City_Seg_ID;
proc sort data=calc_segment; by City_Seg_ID;
data calc_segment; merge calc_segment calc_m_18; by City_Seg_ID; run;

*USE 18-44 SUBSET;
proc sort data=home.m_sex; by City_Seg_ID; run;
proc summary data=home.m_sex; by City_Seg_ID; 
output out=calc_sex(rename=(person=t18_44Sn male=m18_44Sn female=f18_44Sn) drop=_TYPE_ _FREQ_) sum=;
var male female person; run;

data calc_sex; set calc_sex;
m18_44Sp=(m18_44Sn/t18_44Sn)*100;
f18_44Sp=(f18_44Sn/t18_44Sn)*100;
run;

proc sort data=calc_sex; by City_Seg_ID;
proc sort data=calc_segment; by City_Seg_ID;
data calc_segment; merge calc_segment calc_sex; by City_Seg_ID; run;

*USE HOUSEHOLD SUBSET;
proc sort data=home.hh; by City_Seg_ID; run;
proc summary data=home.hh; by City_Seg_ID; 
output out=calc_hh(rename=(person=hhSn hh_married_children=hh_kidsSn) drop=_TYPE_ _FREQ_) sum=;
var hh_married_children person; run;

data calc_hh; set calc_hh;
hh_kidsSp=(hh_kidsSn/hhSn)*100;
run;

proc sort data=calc_hh; by City_Seg_ID;
proc sort data=calc_segment; by City_Seg_ID;
data calc_segment; merge calc_segment calc_hh; by City_Seg_ID; run;

proc sort data=home.sei; by City_Seg_ID; run;
proc summary data=home.sei; by City_Seg_ID;
output out=sei_mean(rename=(sei=meanseiS) drop=_TYPE_ _FREQ_) mean=;
var sei; run;

proc sort data=calc_segment; by City_Seg_ID;
proc sort data=sei_mean; by City_Seg_ID;
data calc_segment; merge calc_segment sei_mean; by City_Seg_ID; drop male female city; year=1880; run;

PROC EXPORT DATA= WORK.CALC_SEGMENT 
            OUTFILE= "S:\Projects\Preparing 1880 Files\Online Maps\Data\Calculation_All_Segment.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;


***** ED LEVEL *****;
proc sort data=home.allcities; by ED_ID; run;
proc summary data=home.allcities; by ED_ID; 
output out=calc_ed(rename=(person=poptotE
black=blkEn blk_nm=blk_nmEn british=britEn canadian=canadaEn chinese=chinaEn danish=danishEn 
french=frenchEn german=germanEn irish=irishEn japanese=japanEn mulatto=mulattoEn
native_am=nat_amEn norwegian=norwayEn swedish=swedeEn yankee=nwnpEn
british_f=brit1En canadian_f=canada1En chinese_f=china1En danish_f=danish1En 
french_f=french1En german_f=german1En irish_f=irish1En japanese_f=japan1En 
norwegian_f=norway1En swedish_f=swede1En
british_s=brit2En canadian_s=canada2En chinese_s=china2En danish_s=danish2En 
french_s=french2En german_s=german2En irish_s=irish2En japanese_s=japan2En 
norwegian_s=norway2En swedish_s=swede2En
foreign=fbEn a_60=t60En a_16=t0_16En
m5=m0_4En m5_9=m5_9En m10_14=m10_14En m15_17=m15_17En m18_19=m18_19En m20=m20En m21=m21En 
m22_24=m22_24En m25_29=m25_29En m30_34=m30_34En m35_39=m35_39En
m40_44=m40_44En m45_49=m45_49En m50_54=m50_54En m55_59=m55_59En 
m60_61=m60_61En m62_64=m62_64En m65_66=m65_66En m67_69=m67_69En 
m70_74=m70_74En m75_79=m75_79En m80_84=m80_84En m85=m85En
f5=f0_4En f5_9=f5_9En f10_14=f10_14En f15_17=f15_17En f18_19=f18_19En f20=f20En f21=f21En 
f22_24=f22_24En f25_29=f25_29En f30_34=f30_34En f35_39=f35_39En
f40_44=f40_44En f45_49=f45_49En f50_54=f50_54En f55_59=f55_59En 
f60_61=f60_61En f62_64=f62_64En f65_66=f65_66En f67_69=f67_69En 
f70_74=f70_74En f75_79=f75_79En f80_84=f80_84En f85=f85En) drop=_TYPE_ _FREQ_) sum=;
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

data calc_ed; set calc_ed; 
blkEp=(blkEn/poptotE)*100;
blk_nmEp=(blk_nmEn/poptotE)*100;
britEp=(britEn/poptotE)*100;
canadaEp=(canadaEn/poptotE)*100;
chinaEp=(chinaEn/poptotE)*100;
danishEp=(danishEn/poptotE)*100;
frenchEp=(frenchEn/poptotE)*100;
germanEp=(germanEn/poptotE)*100;
irishEp=(irishEn/poptotE)*100;
japanEp=(japanEn/poptotE)*100;
mulattoEp=(mulattoEn/poptotE)*100;
nat_amEp=(nat_amEn/poptotE)*100;
norwayEp=(norwayEn/poptotE)*100;
swedeEp=(swedeEn/poptotE)*100;
nwnpEp=(nwnpEn/poptotE)*100;

brit1Ep=(brit1En/poptotE)*100;
canada1Ep=(canada1En/poptotE)*100;
china1Ep=(china1En/poptotE)*100;
danish1Ep=(danish1En/poptotE)*100;
french1Ep=(french1En/poptotE)*100;
german1Ep=(german1En/poptotE)*100;
irish1Ep=(irish1En/poptotE)*100;
japan1Ep=(japan1En/poptotE)*100;
norway1Ep=(norway1En/poptotE)*100;
swede1Ep=(swede1En/poptotE)*100;

brit2Ep=(brit2En/poptotE)*100;
canada2Ep=(canada2En/poptotE)*100;
china2Ep=(china2En/poptotE)*100;
danish2Ep=(danish2En/poptotE)*100;
french2Ep=(french2En/poptotE)*100;
german2Ep=(german2En/poptotE)*100;
irish2Ep=(irish2En/poptotE)*100;
japan2Ep=(japan2En/poptotE)*100;
norway2Ep=(norway2En/poptotE)*100;
swede2Ep=(swede2En/poptotE)*100;

fbEp=(fbEn/poptotE)*100;
t60Ep=(t60En/poptotE)*100;
t0_16Ep=(t0_16En/poptotE)*100;

if city ne 0;

run;


*USE SEI SUBSET;
proc sort data=home.a1564_m; by ED_ID; run;
proc summary data=home.a1564_m; by ED_ID; 
output out=calc_sei_m(rename=(person=m15_64En m_sei_1564=mlf15_64En) drop=_TYPE_ _FREQ_) sum=;
var m_sei_1564 person; run;

data calc_sei_m; set calc_sei_m;
mlf15_64Ep=(mlf15_64En/m15_64En)*100;
run;

proc sort data=calc_ed; by ED_ID;
proc sort data=calc_sei_m; by ED_ID;
data calc_ed; merge calc_ed calc_sei_m; by ED_ID; run;

proc sort data=home.a1564_f; by ED_ID; run;
proc summary data=home.a1564_f; by ED_ID; 
output out=calc_sei_f(rename=(person=f15_64En w_sei_1564=flf15_64En) drop=_TYPE_ _FREQ_) sum=;
var w_sei_1564 person; run;

data calc_sei_f; set calc_sei_f;
flf15_64Ep=(flf15_64En/f15_64En)*100;
run;

proc sort data=calc_ed; by ED_ID;
proc sort data=calc_sei_f; by ED_ID;
data calc_ed; merge calc_ed calc_sei_f; by ED_ID; run;

proc sort data=home.a1564; by ED_ID; run;
proc summary data=home.a1564; by ED_ID; 
output out=calc_sei(rename=(person=t15_64En sei_1564=tlf15_64En) drop=_TYPE_ _FREQ_) sum=;
var sei_1564 person; run;

data calc_sei; set calc_sei;
tlf15_64Ep=(tlf15_64En/t15_64En)*100;
run;

proc sort data=calc_ed; by ED_ID;
proc sort data=calc_sei; by ED_ID;
data calc_ed; merge calc_ed calc_sei; by ED_ID; run;

*USE 18+ SUBSET;
proc sort data=home.m_18; by ED_ID; run;
proc summary data=home.m_18; by ED_ID; 
output out=calc_m_18(rename=(person=t18En married_18=marriedEn) drop=_TYPE_ _FREQ_) sum=;
var married_18 person; run;

data calc_m_18; set calc_m_18;
marriedEp=(marriedEn/t18En)*100;
run;

proc sort data=calc_m_18; by ED_ID;
proc sort data=calc_ed; by ED_ID;
data calc_ed; merge calc_ed calc_m_18; by ED_ID; run;

*USE 18-44 SUBSET;
proc sort data=home.m_sex; by ED_ID; run;
proc summary data=home.m_sex; by ED_ID; 
output out=calc_sex(rename=(person=t18_44En male=m18_44En female=f18_44En) drop=_TYPE_ _FREQ_) sum=;
var male female person; run;

data calc_sex; set calc_sex;
m18_44Ep=(m18_44En/t18_44En)*100;
f18_44Ep=(f18_44En/t18_44En)*100;
run;

proc sort data=calc_sex; by ED_ID;
proc sort data=calc_ed; by ED_ID;
data calc_ed; merge calc_ed calc_sex; by ED_ID; run;

*USE HOUSEHOLD SUBSET;
proc sort data=home.hh; by ED_ID; run;
proc summary data=home.hh; by ED_ID; 
output out=calc_hh(rename=(person=hhEn hh_married_children=hh_kidsEn) drop=_TYPE_ _FREQ_) sum=;
var hh_married_children person; run;

data calc_hh; set calc_hh;
hh_kidsEp=(hh_kidsEn/hhEn)*100;
run;

proc sort data=calc_hh; by ED_ID;
proc sort data=calc_ed; by ED_ID;
data calc_ed; merge calc_ed calc_hh; by ED_ID; run;

proc sort data=home.sei; by ED_ID; run;
proc summary data=home.sei; by ED_ID;
output out=sei_mean(rename=(sei=meanseiE) drop=_TYPE_ _FREQ_) mean=;
var sei; run;

proc sort data=calc_ed; by ED_ID;
proc sort data=sei_mean; by ED_ID;
data calc_ed; merge calc_ed sei_mean; by ED_ID; drop male female city; year=1880; run;

PROC EXPORT DATA= WORK.CALC_ED 
            OUTFILE= "S:\Projects\Preparing 1880 Files\Online Maps\Data\Calculation_All_ED.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;

data home.calculations_all_building; set calc_build; run;
data home.calculations_all_segment; set calc_segment; run;
data home.calculations_all_ed; set calc_ed; run;

/*
ods pdf file="Z:\Projects\Preparing 1880 Files\Online Maps\Distributions.pdf";
title "Percent Black - Building";
proc freq data=calc_all; tables blk_p; run;
title "Percent Black Not Mulatto - Building";
proc freq data=calc_all; tables blk_nm_p; run;
title "Percent British - Building";
proc freq data=calc_all  ; tables british_p; run;
title "Percent Canadian - Building";
proc freq data=calc_all  ; tables canadian_p; run;
title "Percent Chinese - Building";
proc freq data=calc_all  ; tables chinese_p; run;
title "Percent Danish - Building";
proc freq data=calc_all  ; tables danish_p; run;
title "Percent French - Building";
proc freq data=calc_all  ; tables french_p; run;
title "Percent German - Building";
proc freq data=calc_all  ; tables german_p; run;
title "Percent Irish - Building";
proc freq data=calc_all  ; tables irish_p; run;
title "Percent Japanese - Building";
proc freq data=calc_all  ; tables japanese_p; run;
title "Percent Mulatto - Building";
proc freq data=calc_all  ; tables mulatto_p; run;
title "Percent Native American - Building";
proc freq data=calc_all  ; tables native_am_p; run;
title "Percent Norwegian - Building";
proc freq data=calc_all  ; tables norwegian_p; run;
title "Percent Swedish - Building";
proc freq data=calc_all  ; tables swedish_p; run;
title "Percent Yankee - Building";
proc freq data=calc_all  ; tables yankee_p; run;
title "Percent Foreign Born - Building";
proc freq data=calc_all  ; tables foreign_p; run;
title "Percent 60 and Older - Building";
proc freq data=calc_all  ; tables a_60_p; run;
title "Percent 16 and Younger - Building";
proc freq data=calc_all  ; tables a_16_p; run;
title "Percent Women with SEI among women age 15-64 - Building";
proc freq data=calc_all  ; tables w_sei_p; run;
title "Percent Men with SEI among men age 15-64 - Building";
proc freq data=calc_all  ; tables m_sei_p; run;
title "Percent Men and women with SEI among persons age 15-64 - Building";
proc freq data=calc_all  ; tables sei_p;  run;
title "Percent Married among age 18+ - Building";
proc freq data=calc_all  ; tables married_p; run;
title "Percent Male 18-44 - Building";
proc freq data=calc_all  ; tables male_p; run;
title "Percent Female 18-44 - Building";
proc freq data=calc_all  ; tables female_p; run;
title "Percent Households Married Couples With Children - Building";
proc freq data=calc_all  ; tables marry_child_p; run;
title "Mean SEI of Persons with SEI - Building";
proc freq data=calc_all  ; tables sei_mean; run;

title "Percent Black - Segment";
proc freq data=calc_segment  ; tables blk_p; run;
title "Percent Black Not Mulatto - Segment";
proc freq data=calc_segment; tables blk_nm_p; run;
title "Percent British - Segment";
proc freq data=calc_segment  ; tables british_p; run;
title "Percent Canadian - Segment";
proc freq data=calc_segment  ; tables canadian_p; run;
title "Percent Chinese - Segment";
proc freq data=calc_segment  ; tables chinese_p; run;
title "Percent Danish - Segment";
proc freq data=calc_segment  ; tables danish_p; run;
title "Percent French - Segment";
proc freq data=calc_segment  ; tables french_p; run;
title "Percent German - Segment";
proc freq data=calc_segment  ; tables german_p; run;
title "Percent Irish - Segment";
proc freq data=calc_segment  ; tables irish_p; run;
title "Percent Japanese - Segment";
proc freq data=calc_segment  ; tables japanese_p; run;
title "Percent Mulatto - Segment";
proc freq data=calc_segment  ; tables mulatto_p; run;
title "Percent Native American - Segment";
proc freq data=calc_segment  ; tables native_am_p; run;
title "Percent Norwegian - Segment";
proc freq data=calc_segment  ; tables norwegian_p; run;
title "Percent Swedish - Segment";
proc freq data=calc_segment  ; tables swedish_p; run;
title "Percent Yankee - Segment";
proc freq data=calc_segment  ; tables yankee_p; run;
title "Percent Foreign Born - Segment";
proc freq data=calc_segment  ; tables foreign_p; run;
title "Percent 60 and Older - Segment";
proc freq data=calc_segment  ; tables a_60_p; run;
title "Percent 16 and Younger - Segment";
proc freq data=calc_segment  ; tables a_16_p; run;
title "Percent Women with SEI among women age 15-64 - Segment";
proc freq data=calc_segment  ; tables w_sei_p; run;
title "Percent Men with SEI among men age 15-64 - Segment";
proc freq data=calc_segment  ; tables m_sei_p; run;
title "Percent Men and women with SEI among persons age 15-64 - Segment";
proc freq data=calc_segment  ; tables sei_p; run;
title "Percent Married among age 18+ - Segment";
proc freq data=calc_segment  ; tables married_p; run;
title "Percent Male 18-44 - Segment";
proc freq data=calc_segment  ; tables male_p; run;
title "Percent Female 18-44 - Segment";
proc freq data=calc_segment  ; tables female_p; run;
title "Percent Households Married Couples With Children - Segment";
proc freq data=calc_segment  ; tables marry_child_p; run;
title "Mean SEI of Persons with SEI - Segment";
proc freq data=calc_segment  ; tables sei_mean; run;

ods pdf close;

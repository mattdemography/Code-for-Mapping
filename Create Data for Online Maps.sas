libname home "Z:\Projects\Preparing 1880 Files\Online Maps\Data"; run;


data city_seg_id; set home.allcities;
keep
NonOver_SegG_id NonOver_ExtG_id
Segment_id city street
city_seg_id;
run;

proc sort data=city_seg_id
nodupkey;
by city_seg_id;
run;

data Address_id; set home.allcities;
keep
NonOver_SegG_id NonOver_ExtG_id serial
Segment_id city street house_number address 
address_id;
run;

proc sort data=Address_id
nodupkey;
by address_id;
run;

data ED_id; set home.allcities;
keep
city enumdist ed_id;
run;

proc sort data=ED_id
nodupkey;
by ED_id;
run;

proc sort data=home.calculations_all_segment; by city_seg_id; run;
data home.calculations_all_segment; merge home.calculations_all_segment city_seg_id; by city_seg_id; run;
proc datasets library=home;
modify calculations_all_segment;
format city $char15.;
run;
quit;
data home.calculations_all_segment; length city $15; set home.calculations_all_segment;
if city="Alleghen" then city="Allegheny";
if city="Baltimor" then city="Baltimore";
if city="Charlest" then city="Charleston";
if city="Cincinna" then city="Cincinnati";
if city="Clevelan" then city="Cleveland";
if city="Indianap" then city="Indianapolis";
if city="JerseyCi" then city="JerseyCity";
if city="KansasCi" then city="KansasCity";
if city="Louisvil" then city="Louisville";
if city="Minneapo" then city="Minneapolis";
if city="Nashvill" then city="Nashville";
if city="NYC_Bron" then city="NYC_Bronx";
if city="NYC_Manh" then city="NYC_Manhattan";
if city="NewOrlea" then city="NewOrleans";
if city="Philadel" then city="Philadelphia";
if city="Pittsbur" then city="Pittsburgh";
if city="Providen" then city="Providence";
if city="Rocheste" then city="Rochester";
if city="San Fran" then city="San_Francisco";
if city="Washingt" then city="Washington";
if city ne "0";
run;

proc sort data=home.calculations_all_building; by address_id; run;
data home.calculations_all_building; merge home.calculations_all_building address_id; by address_id; run;
proc datasets library=home;
modify calculations_all_building;
format city $char15.;
run;
quit;
data home.calculations_all_building; length city $15; set home.calculations_all_building;
if city="Alleghen" then city="Allegheny";
if city="Baltimor" then city="Baltimore";
if city="Charlest" then city="Charleston";
if city="Cincinna" then city="Cincinnati";
if city="Clevelan" then city="Cleveland";
if city="Indianap" then city="Indianapolis";
if city="JerseyCi" then city="JerseyCity";
if city="KansasCi" then city="KansasCity";
if city="Louisvil" then city="Louisville";
if city="Minneapo" then city="Minneapolis";
if city="Nashvill" then city="Nashville";
if city="NYC_Bron" then city="NYC_Bronx";
if city="NYC_Manh" then city="NYC_Manhattan";
if city="NewOrlea" then city="NewOrleans";
if city="Philadel" then city="Philadelphia";
if city="Pittsbur" then city="Pittsburgh";
if city="Providen" then city="Providence";
if city="Rocheste" then city="Rochester";
if city="San Fran" then city="San_Francisco";
if city="Washingt" then city="Washington";
if city ne "0";
run;
proc freq data=home.calculations_all_building; tables city; run;

proc sort data=home.calculations_all_ed; by ed_id; run;
data home.calculations_all_ed; merge home.calculations_all_ed ed_id; by ed_id; run;
proc datasets library=home;
modify calculations_all_ed;
format city $char15.;
run;
quit;
data home.calculations_all_ed; length city $15; set home.calculations_all_ed;
if city="Alleghen" then city="Allegheny";
if city="Baltimor" then city="Baltimore";
if city="Charlest" then city="Charleston";
if city="Cincinna" then city="Cincinnati";
if city="Clevelan" then city="Cleveland";
if city="Indianap" then city="Indianapolis";
if city="JerseyCi" then city="JerseyCity";
if city="KansasCi" then city="KansasCity";
if city="Louisvil" then city="Louisville";
if city="Minneapo" then city="Minneapolis";
if city="Nashvill" then city="Nashville";
if city="NYC_Bron" then city="NYC_Bronx";
if city="NYC_Manh" then city="NYC_Manhattan";
if city="NewOrlea" then city="NewOrleans";
if city="Philadel" then city="Philadelphia";
if city="Pittsbur" then city="Pittsburgh";
if city="Providen" then city="Providence";
if city="Rocheste" then city="Rochester";
if city="San Fran" then city="San_Francisco";
if city="Washingt" then city="Washington";
if city ne "0";
run;
proc freq data=home.calculations_all_ed; tables city; run;


**** Export by City ****;
data num_city; set home.calculations_all_segment; run;
proc sort data=num_city
nodupkey;
by city;
run;

data _null_;
  set num_city end=last;
  i+1;
  call symputx('city'||trim(left(put(i,8.))),city);
  if last then call symput('total', trim(left(put(i,8.))));
run;

%macro exportit;
   %do i=1 %to &total;
      data c_&&city&i;
	set home.calculations_all_segment;
	where city="&&city&i";
      run;
      
      proc export data=c_&&city&i outfile="S:\Projects\Preparing 1880 Files\Online Maps\Data\City_Summary - Segment\Segment_sum_&&city&i...csv" dbms=csv replace;
	  run;
   %end;
%mend exportit;

%exportit;


*By Address;
data num_city; set home.calculations_all_building; run;
proc sort data=num_city
nodupkey;
by city;
run;

data _null_;
  set num_city end=last;
  i+1;
  call symputx('city'||trim(left(put(i,8.))),city);
  if last then call symput('total', trim(left(put(i,8.))));
run;

%macro exportit;
   %do i=1 %to &total;
      data c_&&city&i;
	set home.calculations_all_building;
	where city="&&city&i";
      run;
      
      proc export data=c_&&city&i outfile="S:\Projects\Preparing 1880 Files\Online Maps\Data\City_Summary - Building\Building_sum_&&city&i...csv" dbms=csv replace;
	  run;
   %end;
%mend exportit;

%exportit;

*By ED;
data num_city; set home.calculations_all_ed; run;
proc sort data=num_city
nodupkey;
by city;
run;

data _null_;
  set num_city end=last;
  i+1;
  call symputx('city'||trim(left(put(i,8.))),city);
  if last then call symput('total', trim(left(put(i,8.))));
run;

%macro exportit;
   %do i=1 %to &total;
      data c_&&city&i;
	set home.calculations_all_ed;
	where city="&&city&i";
      run;
      
      proc export data=c_&&city&i outfile="S:\Projects\Preparing 1880 Files\Online Maps\Data\City_Summary - Enumeration District\ED_sum_&&city&i...csv" dbms=csv replace;
	  run;
   %end;
%mend exportit;

%exportit;

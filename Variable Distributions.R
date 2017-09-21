#Bring In Libraries
#Library List
library(foreign)
library(car)
library(plyr)
library(reshape2)
library(rgdal)
library(haven)
library(data.table)

sumby<- function(x,y){
  y1<-deparse(substitute(y))
  y2<-unlist((strsplit(as.character(y1), "[$]")))[2]
  myvars<-"y"
  nrows<-length(x)
  df<-data.frame(x=numeric(), y=numeric())
  df<-rename(df, c(x=y2, y=y))
  for(i in 1:nrows){
    x2<-(colnames(x[i]))
    t<-(tapply(x[,i], INDEX=list(y), FUN=sum, na.rm=T))
    df2<-data.frame(x=names(t), y=t)
    df2<-rename(df2, c(x=y2, y=x2))
    df<-merge(df, df2, by=y2, all=T, accumulate=T)
    df<-df[!names(df) %in% myvars]
  }
  df
}

#Bring in all data to build one file with all cities
  citylist<-read.csv(("S:/Projects/Preparing 1880 Files/City Lists.csv"))
  citylist <- data.frame(lapply(citylist, as.character), stringsAsFactors=FALSE)
  Cityname<-citylist$Cityname
  rows<-nrow(citylist)

#Separate Loop into 1-25 and 26-40;

for(i in 9){
}
#Bring in DBF Files
  #g<-read.dbf(paste("Z:/Projects/Preparing 1880 Files/", Cityname[i],"/Match Address/", Cityname[i],"_OnStreet_BenResult.dbf", sep=""))
  m<-read.csv(paste("S:/Projects/Preparing 1880 Files/", Cityname[i],"/Match Address/",Cityname[i], "_BenResult.csv", sep=""))

  #Change variable names in files that do not have these standard names
  m<-rename(m, c("bp"="bpldet"))
  m<-rename(m, c("mbp"="fbpldtus"))
  m<-rename(m, c("fbp"="mbpldtus"))
  
  vars<-c("X", "serial", "sex", "race", "relate", "age", "bpldet", "fbpldtus", "mbpldtus", "nativity", "seius", "marst", "nchild",
          "enumdist", "NonOver_SegG_id", "NonOver_ExtG_id", "Segment_id", "House_Number", "Street")
  m<-m[vars]
  m$city<-Cityname[i]
  
  #Rename SEIUS to SEI  #Rename bpldet to bpl
    m<-rename(m, c("seius"="sei"))
  #Create Person Counter for Aggregation  
    m$person<-recode(m$serial,"\" \"=0; else=1")
  #Create Address Variable
    m$address<-paste(m$House_Number, " ", m$Street, sep="")
  #Create Head of Household Variable
    m$hh<-recode(m$relate,"c(101)=1; else=0")
  #Race
    m$race<-car::recode(m$race, "100='white';200='black'; 210='mulatto';300='American Indian/Alaska Native';
                          400='Chinese';500='Japanese'")
  #Birthplace
    bpl<-read.csv("S:/Projects/Preparing 1880 Files/BPL_Codes.csv", stringsAsFactors = F)
    m<-merge(m, bpl[,c("Code", "Label")], by.x="bpldet", by.y="Code", m.x=T)
    m<-rename(m, c("Label"="BPL"))
  #Father's Birthplace
    fbpl<-read.csv("S:/Projects/Preparing 1880 Files/FBPL_Codes.csv", stringsAsFactors = F)
    m<-merge(m, fbpl[,c("Code", "Label")], by.x="fbpldtus", by.y="Code", m.x=T)
    m<-rename(m, c("Label"="FBPL"))
  #Mother's Birthplace
    mbpl<-read.csv("S:/Projects/Preparing 1880 Files/MBPL_Codes.csv", stringsAsFactors = F)
    m<-merge(m, mbpl[,c("Code", "Label")], by.x="mbpldtus", by.y="Code", m.x=T)
    m<-rename(m, c("Label"="MBPL"))
  #Native Born
    m$bpldet<-as.numeric(m$bpldet)
    m$native_b<-ifelse(m$bpldet<=5610 | m$bpldet==9900 | m$bpldet==90011 | m$bpldet==90021 | m$bpldet==90022, 1, 0) #Abroad (Sea or Land)
  #Foreign Born - And NOT Native Born because 'At Sea (US Born)' is considered foreign born by nativity
    m$foreign<-ifelse((m$nativity==5 & m$native_b!=1), 1, 0)                #Foreign-Born
  #Native Parents
    m$mbpldtus<-as.numeric((m$mbpldtus))
    m$fbpldtus<-as.numeric((m$fbpldtus))
    m$native_p<-ifelse(((m$mbpldtus<=5610 | m$mbpldtus==9900 | m$mbpldtus==90011 | m$mbpldtus==90021 | m$mbpldtus==90022) & 
                         (m$fbpldtus<=5610 | m$fbpldtus==9900 | m$fbpldtus==90011 | m$fbpldtus==90021 | m$fbpldtus==90022)) |
                         ((m$mbpldtus<=5610 | m$mbpldtus==9900 | m$mbpldtus==90011 | m$mbpldtus==90021 | m$mbpldtus==90022) & (m$fbpldtus==99900 | m$fbpldtus==99700))|
                         ((m$fbpldtus<=5610 | m$fbpldtus==9900 | m$fbpldtus==90011 | m$fbpldtus==90021 | m$fbpldtus==90022) & (m$mbpldtus==99900 | m$mbpldtus==99700)), 1, 0)
  #Native Born and Native Born Parents
    m$native_bp<-ifelse(m$native_b==1 & m$native_p==1, 1,0)
  #Native Born, Native Parents, White
    m$yankee<-ifelse(m$native_bp==1 & m$race=="white", 1, 0)
  #Ethnicity Categories (_f=first generation; _s=second generation) 
    #Black
      m$blk_nm<-ifelse(m$race=="black", 1, 0)
    #Black - All
      m$black<-ifelse(m$race=="black" | m$race=="mulatto", 1, 0)
    #British
      m$british_f<-ifelse((m$bpldet>=41000 & m$bpldet<=41200),1,0)
      m$british_s<-ifelse(m$native_b==1 & ((m$mbpldtus>=41000 & m$mbpldtus<=41200) | 
                                            ((m$fbpldtus>=41000 & m$fbpldtus<=41200) & (m$mbpldtus==99900 | m$mbpldtus==99700))) ,1,0)
      m$british<-ifelse(m$british_f==1 | m$british_s==1, 1, 0)
    #Canadian
      m$canadian_f<-ifelse((m$bpldet>=15000 & m$bpldet<=15083), 1,0)
      m$canadian_s<-ifelse(m$native_b==1 & ((m$mbpldtus>=15000 & m$mbpldtus<=15083) |
                                           ((m$fbpldtus>=15000 & m$fbpldtus<=15083) & (m$mbpldtus==99900 | m$mbpldtus==99700))), 1, 0)
      m$canadian<-ifelse(m$canadian_f==1 | m$canadian_s==1, 1, 0)
    #Chinese
      m$chinese_f<-ifelse((m$bpldet>=50000 & m$bpldet<=50040), 1,0)
      m$chinese_s<-ifelse(m$native_b==1 & ((m$mbpldtus>=50000 & m$mbpldtus<=50040) |
                                              ((m$fbpldtus>=50000 & m$fbpldtus<=50040) & (m$mbpldtus==99900 | m$mbpldtus==99700))), 1, 0)
      m$chinese<-ifelse(m$chinese_f==1 | m$chinese_s==1, 1, 0)
    #Danish
      m$danish_f<-ifelse((m$bpldet==40000 | m$bpldet==40010),1,0)
      m$danish_s<-ifelse(m$native_b==1 & ((m$mbpldtus==40000 | m$mbpldtus==40010) |
                                            ((m$fbpldtus==40000 | m$fbpldtus==40010) & (m$mbpldtus==99900 | m$mbpldtus==99700))), 1, 0)
      m$danish<-ifelse(m$danish_f==1 | m$danish_s==1, 1, 0)    
    #French
      m$french_f<-ifelse((m$bpldet>=42100 & m$bpldet<=42112), 1,0)
      m$french_s<-ifelse(m$native_b==1 & ((m$mbpldtus>=42100 & m$mbpldtus<=42112) | 
                                          ((m$fbpldtus>=42100 & m$fbpldtus<=42112) & (m$mbpldtus==99900 | m$mbpldtus==99700))) ,1,0)
      m$french<-ifelse(m$french_f==1 | m$french_s==1, 1, 0)    
    #Germany 
      m$german_f<-ifelse((m$bpldet>=45300 & m$bpldet<=45362), 1,0)
      m$german_s<-ifelse(m$native_b==1 & ((m$mbpldtus>=45300 & m$mbpldtus<=45362) | 
                                              ((m$fbpldtus>=45300 & m$fbpldtus<=45362) & (m$mbpldtus==99900 | m$mbpldtus==99700))) ,1,0)
      m$german<-ifelse(m$german_f==1 | m$german_s==1, 1, 0)
    #Irish
      m$irish_f<-ifelse((m$bpldet==41400 | m$bpldet==41410),1,0)
      m$irish_s<-ifelse(m$native_b==1 & ((m$mbpldtus==41400 | m$mbpldtus==41410) |
                                             ((m$fbpldtus==41400 | m$fbpldtus==41410) & (m$mbpldtus==99900 | m$mbpldtus==99700))), 1, 0)
      m$irish<-ifelse(m$irish_f==1 | m$irish_s==1, 1, 0)
    #Japanese
      m$japanese_f<-ifelse(m$bpldet==50100, 1, 0)
      m$japanese_s<-ifelse(m$native_b==1 & ((m$mbpldtus==50100) | 
                                               ((m$fbpldtus==50100) & (m$mbpldtus==99900 | m$mbpldtus==99700))) ,1,0)
      m$japanese<-ifelse(m$japanese_f==1 | m$japanese_s==1, 1, 0)
    #Mulatto
      m$mulatto<-ifelse(m$race=="mulatto", 1, 0)
    #Native American
      m$native_am<-ifelse(m$race=="American Indian/Alaska Native", 1, 0)
    #Norwegian
      m$norwegian_f<-ifelse(m$bpldet==40400, 1, 0)
      m$norwegian_s<-ifelse(m$native_b==1 & ((m$mbpldtus==40400) | 
                                             ((m$fbpldtus==40400) & (m$mbpldtus==99900 | m$mbpldtus==99700))) ,1,0)
      m$norwegian<-ifelse(m$norwegian_f==1 | m$norwegian_s==1, 1, 0)
    #Swedish
      m$swedish_f<-ifelse(m$bpldet==40500, 1, 0)
      m$swedish_s<-ifelse(m$native_b==1 & ((m$mbpldtus==40500) | 
                                            ((m$fbpldtus==40500) & (m$mbpldtus==99900 | m$mbpldtus==99700))) ,1,0)
      m$swedish<-ifelse(m$swedish_f==1 | m$swedish_s==1, 1, 0)
    #Sex Variables
      m$male<-ifelse(m$sex==1, 1, 0)
      m$female<-ifelse(m$sex==2, 1, 0)
    #Create Age Dummy Variables
      m$age<-ifelse(m$age==999, NA, m$age)
      m$a_15_64<-ifelse(m$age>=15 & m$age<=64, 1, 0)
      m$a_18<-ifelse(m$age>=18, 1,0)
      m$a_18_44<-ifelse(m$age>=18 & m$age<=44, 1,0)
      m$a_60<-ifelse(m$age>=60, 1, 0)                                       #Anyone 60 and Older
      m$a_16<-ifelse(m$age<=16, 1,0)                                        #Anyone 16 and Younger 
    #Calculate Married Couples with Children
      m$married<-ifelse(m$marst==1, 1, 0)
      m$has_children<-ifelse(m$nchild>=1, 1, 0)
      m$married_children<-ifelse((m$married==1 & m$has_children==1), 1, 0)
      m$hh_married_children<-ave(m$married_children, m$serial, FUN=sum)
      m$hh_married_children<-ifelse(m$hh_married_children>=1, 1, 0)
    #Calculate Combination Variables
      m$has_sei<-ifelse(m$sei>0, 1, 0) # If Individual has an SEI
      m$w_sei_1564<-ifelse(m$female==1 & m$has_sei==1 & m$a_15_64==1, 1, 0 )# Women with SEI between Ages 15-64
      m$m_sei_1564<-ifelse(m$male==1 & m$has_sei==1 & m$a_15_64==1, 1, 0 )  # Men with SEI between Ages 15-64
      m$sei_1564<-ifelse(m$has_sei==1 & m$a_15_64==1, 1, 0 )                # Any Person with SEI between Ages 15-64
      m$married_18<-ifelse((m$marst==1 | m$marst==2) & m$a_18==1, 1, 0)     # Any Person married 18 and over
    
    #Remove missing addresses
      m<-subset(m, !is.na(m$Street))
      
    #This File Combines all Cities
      m1<-rbind(m1, m)
      
      #This file will allow me to see what cities have made it into the calculations
      cities<-data.table(unique(m1$city))
}
    ??#Write CSV for Part One and Part Two (21-40)
    write.csv(m1, "S:/Projects/Preparing 1880 Files/Online Maps/AllCities_1.csv")
    write.csv(m1, "S:/Projects/Preparing 1880 Files/Online Maps/AllCities_2.csv")
    write.csv(m, "S:/Projects/Preparing 1880 Files/Online Maps/Chicago_3.csv")
      
    ???#Create New Table from M on First Run
    m1<-m[0,1:81]
      
      
    
    
    
    
    
    
    
      #Keep Only Head of Households for Household Computations like %HH of Married Couples w/Children
      m_hh<-subset(m1, m1$hh==1)
      #Keep Only those 15-64 for SEI Calculations
      m_sei<-subset(m1, m1$a_15_64==1)
      #Keep Only those Over 18 for % Married Calculations
      m_18<-subset(m1, m1$a_18==1)
      #Keep Only those Over 18-64 for % Sex Ratio Calculations
      m_sex<-subset(m1, m1$a_18_44==1)
 
##### Calculate Building Percents for Ethnicity, Foreign, and Other Variables ####
      bld<-sumby(m[,c("black", "british", "canadian", "chinese", "danish", "french", "german", "irish", "japanese", "mulatto",
                      "native_am", "norwegian", "swedish", "yankee", "foreign",
                      "male", "female", "a_60", "a_16", "sei", "married_18",
                      "person")], m$address)
      bld<-rename(bld, c("person"="bld_tot"))
      bld$blk_per<-round((bld$black/bld$bld_tot)*100, digits = 2)
      bld$b_per<-round((bld$british/bld$bld_tot)*100, digits = 2)
      bld$can_per<-round((bld$canadian/bld$bld_tot)*100, digits = 2)
      bld$chi_per<-round((bld$chinese/bld$bld_tot)*100, digits = 2)
      bld$d_per<-round((bld$danish/bld$bld_tot)*100, digits = 2)
      bld$f_per<-round((bld$french/bld$bld_tot)*100, digits = 2)        #French
      bld$g_per<-round((bld$german/bld$bld_tot)*100, digits = 2)
      bld$i_per<-round((bld$irish/bld$bld_tot)*100, digits = 2)
      bld$j_per<-round((bld$japanese/bld$bld_tot)*100, digits = 2)
      bld$m_per<-round((bld$mulatto/bld$bld_tot)*100, digits = 2)
      bld$nam_per<-round((bld$native_am/bld$bld_tot)*100, digits = 2)   #American Indian
      bld$n_per<-round((bld$norwegian/bld$bld_tot)*100, digits = 2)
      bld$s_per<-round((bld$swedish/bld$bld_tot)*100, digits = 2)
      bld$y_per<-round((bld$yankee/bld$bld_tot)*100, digits = 2)
      bld$fb_per<-round((bld$foreign/bld$bld_tot)*100, digits = 2)      #Foreign-Born
      bld$chi_per<-round((bld$chinese/bld$bld_tot)*100, digits = 2)
      bld$a60_per<-round((bld$a_60/bld$bld_tot)*100, digits = 2)
      bld$a16_per<-round((bld$a_16/bld$bld_tot)*100, digits = 2)


    #Create Table  
      All<-data.table(Cityname[i])
      All<-rename(All, c("V1"="City"))
      #Use SEI Subset
        sei<-sumby(m_sei[,c("w_sei_1564", "m_sei_1564", "sei_1564", "person")], m_sei$address)
        sei<-rename(sei, c("person"="bld_tot"))
        sei$wsei_per<-round((sei$w_sei_1564/sei$bld_tot)*100, digits = 2)
        sei$msei_per<-round((sei$m_sei_1564/sei$bld_tot)*100, digits = 2)
        sei$sei_per<-round((sei$sei_1564/sei$bld_tot)*100, digits = 2)
      All$w_sei_mean_bld<-mean(sei$wsei_per, na.rm=T)
      All$w_sei_median_bld<-median(sei$wsei_per, na.rm=T)
      All$m_sei_mean_bld<-mean(sei$msei_per, na.rm=T)
      All$m_sei_median_bld<-median(sei$msei_per, na.rm=T)
      All$sei_mean_bld<-mean(sei$sei_per, na.rm=T)
      All$sei_median_bld<-median(sei$sei_per, na.rm=T)
      #Use Plus 18 Subset
        marry<-sumby(m_18[, c("married_18", "person")], m_18$address)
        marry<-rename(marry, c("person"="bld_tot"))
        marry$married_per<-round((marry$married_18/marry$bld_tot)*100, digits = 2)
      All$married_mean_bld<-mean(marry$married_per, na.rm=T)
      All$married_median_bld<-median(marry$married_per, na.rm=T)
      #Use 18-44 Subset
        sex<-sumby(m_sex[,c("male", "female")], m_sex$address)
        sex<-rename(sex, c("person"="bld_tot"))
        sex$male_per<-round((sex$male/sex$bld_tot)*100, digits = 2)
        sex$female_per<-round((sex$female/sex$bld_tot)*100, digits = 2)
      All$male_mean_bld<-mean(sex$male_per, na.rm=T)
      All$male_median_bld<-median(sex$male_per, na.rm=T)
      All$female_mean_bld<-mean(sex$female_per, na.rm=T)
      All$female_median_bld<-median(sex$female_per, na.rm=T)
      All$a60_mean_bld<-mean(bld$a60_per, na.rm=T)
      All$a60_median_bld<-median(bld$a60_per, na.rm=T)
      All$a16_mean_bld<-mean(bld$a16_per, na.rm=T)
      All$a16_median_bld<-median(bld$a16_per, na.rm=T)
      All$fb_mean_bld<-mean(bld$fb_per, na.rm=T)
      All$fb_median_bld<-median(bld$fb_per, na.rm=T)
      All$nam_mean_bld<-mean(bld$nam_per, na.rm=T)
      All$nam_median_bld<-median(bld$nam_per, na.rm=T)
      All$mulatto_mean_bld<-mean(bld$m_per, na.rm=T)
      All$mulatto_median_bld<-median(bld$m_per, na.rm=T)
      All$blk_mean_bld<-mean(bld$blk_per, na.rm=T)
      All$blk_median_bld<-median(bld$blk_per, na.rm=T)
      All$chi_mean_bld<-mean(bld$chi_per, na.rm=T)
      All$chi_median_bld<-median(bld$chi_per, na.rm=T)
      All$f_mean_bld<-mean(bld$f_per, na.rm=T)
      All$f_median_bld<-median(bld$f_per, na.rm=T)
      All$d_mean_bld<-mean(bld$d_per, na.rm=T)
      All$d_median_bld<-median(bld$d_per, na.rm=T)
      All$n_mean_bld<-mean(bld$n_per, na.rm=T)
      All$n_median_bld<-median(bld$n_per, na.rm=T)
      All$s_mean_bld<-mean(bld$s_per, na.rm=T)
      All$s_median_bld<-median(bld$s_per, na.rm=T)
      All$g_mean_bld<-mean(bld$g_per, na.rm=T)
      All$g_median_bld<-median(bld$g_per, na.rm=T)
      All$i_mean_bld<-mean(bld$i_per, na.rm=T)
      All$i_median_bld<-median(bld$i_per, na.rm=T)
      All$b_mean_bld<-mean(bld$b_per, na.rm=T)
      All$b_median_bld<-median(bld$b_per, na.rm=T)
      All$can_mean_bld<-mean(bld$can_per, na.rm=T)
      All$can_median_bld<-median(bld$can_per, na.rm=T)
      All$y_mean_bld<-mean(bld$y_per, na.rm=T)
      All$y_median_bld<-median(bld$y_per, na.rm=T)
      #From hh dataset
        hh<-sumby(m_hh[,c("hh_married_children", "person")], m_hh$address)
        hh<-rename(hh, c("person"="bld_tot"))
        hh$hh_marry_child_per<-round((hh$hh_married_children/hh$bld_tot)*100, digits=2)
        All$married_child_mean_bld<-mean(hh$hh_marry_child_per, na.rm=T)
        All$married_child_median_bld<-median(hh$hh_marry_child_per, na.rm=T)
      All$mean_sei_bld<-mean(bld$sei, na.rm=T)

      
   
      
      
      
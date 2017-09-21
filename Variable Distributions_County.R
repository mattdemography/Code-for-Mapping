#Bring In Libraries
#Library List
library(car)
library(plyr)

#Bring in DBF Files
  #m<-read.csv(paste("Z:/Projects/Preparing 1880 Files/", Cityname[i],"/Match Address/",Cityname[i], "_BenResult.csv", sep=""))
  m<-read.csv("/home/mmarti24/all_1880_county.csv")
  names(m)<-tolower(names(m))
  
  #Change variable names in files that do not have these standard names
  m<-rename(m, c("bpld"="bpldet"))
  m<-rename(m, c("mbpld"="fbpldtus"))
  m<-rename(m, c("fbpld"="mbpldtus"))
  
  #Create Person Counter for Aggregation  
    m$person<-recode(m$serial,"\" \"=0; else=1")
  #Create Head of Household Variable
    m$hh<-recode(m$relate,"c(1)=1; else=0")
  #race
    m$raced<-car::recode(m$raced, "100='white';200='black'; 210='mulatto';300='American Indian/Alaska Native';
                          400='Chinese';500='Japanese'")
  #Birthplace
    bpl<-read.csv("/home/mmarti24/BPL_Codes.csv", stringsAsFactors = F)
    m<-merge(m, bpl[,c("Code", "Label")], by.x="bpldet", by.y="Code", m.x=T)
    m<-rename(m, c("Label"="BPL"))
  #Father's Birthplace
    fbpl<-read.csv("/home/mmarti24/FBPL_Codes.csv", stringsAsFactors = F)
    m<-merge(m, fbpl[,c("Code", "Label")], by.x="fbpldtus", by.y="Code", m.x=T)
    m<-rename(m, c("Label"="FBPL"))
  #Mother's Birthplace
    mbpl<-read.csv("/home/mmarti24/MBPL_Codes.csv", stringsAsFactors = F)
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
    m$yankee<-ifelse(m$native_bp==1 & m$raced=="white", 1, 0)
  #Ethnicity Categories (_f=first generation; _s=second generation) 
    #Black
      m$blk_nm<-ifelse(m$raced=="black", 1, 0)
    #Black - All
      m$black<-ifelse(m$raced=="black" | m$raced=="mulatto", 1, 0)
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
      m$mulatto<-ifelse(m$raced=="mulatto", 1, 0)
    #Native American
      m$native_am<-ifelse(m$raced=="American Indian/Alaska Native", 1, 0)
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

  #Write Out CSV
      write.csv(m, "/home/mmarti24/all_1880_county_n.csv")
   
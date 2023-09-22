library("dplyr")


setwd("C:/Users/rocpa/OneDrive/Desktop/ROME_CNR/WP5")
# https://esploradati.istat.it/databrowser/#/it/dw/categories/IT1,POP,1.0/POP_POPULATION/DCIS_POPRES1/IT1,22_289_DF_DCIS_POPRES1_2,1.0
df <- read.csv("gen_eta_definedRM2023.csv",sep = ";")
df <- df[-306,]
colnames(df)[1] <- "gender" 
colnames(df)[2] <- "age"
colnames(df)[3] <- "number"
df[df$gender == "Femmine",]$gender <- "female"
df[df$gender == "Maschi",]$gender <- "male"

df <- df %>% filter(age != "Totale")
df <- df %>% filter(gender != "Totale")

#  for testing table(df)

df$age <- as.numeric(gsub(" anni| anni e più","",df$age))

df$age <- case_when(
  df$age <= 50 ~ "under50",
  df$age >= 51 &  df$age <= 80  ~ "50to80",
  df$age >= 81 ~ "over80"
)

# df <- df[,-2]
write.csv(df,file="dftest.csv",row.names = F) # will not work: NetLogo or else language would not read strings, better have numbers ready


# df <- df[,c(1,3,2)]

dfcrossed <- df %>% group_by(gender,age) %>% summarise_all(sum)

write.csv(dfcrossed,file="dfcrossed_istat.csv",row.names = F)

# test by individual variable
dfage <- df[,-c(1)]
dfage <- dfage %>% group_by(age) %>% summarise_all(sum)
write.csv(dfage,file="dfage_istat.csv",row.names = F)

dfgen <- df[,-c(2)]
dfgen <- dfgen %>% group_by(gender) %>% summarise_all(sum)
write.csv(dfgen,file="dfgen_istat.csv",row.names= F)


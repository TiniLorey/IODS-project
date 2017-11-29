hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")
str(hd)
dim(hd)
str(gii)
dim(gii)
summary(hd)
summary(gii)

colnames(hd)
colnames(hd)[3] <- "HDI"
colnames(hd)[2] <- "Country"
colnames(hd)[5] <- "EYE"
colnames(hd)[7] <- "GNI"
colnames(hd)[4] <- "LEB"
colnames(hd)[6] <- "MYE"
colnames(hd)[8] <- "GNI_HDI.Rank"
colnames(hd)

colnames(gii)[3] <- "GII"
colnames(gii)[4] <- "MMR"
colnames(gii)[5] <- "ABR"
colnames(gii)[6] <- "PercRepParl"
colnames(gii)[7] <- "edu2F"
colnames(gii)[8] <- "edu2M"
colnames(gii)[9] <- "LabF"
colnames(gii)[10] <- "LabM"
colnames(gii)

#Mutate the "Gender inequality" data and create two new variables. The first one should be the ratio of Female and Male populations with secondary education in each country. (i.e. edu2F / edu2M). The second new variable should be the ratio of labour force participation of females and males in each country (i.e. labF / labM). 
#utate(iris, sepal = Sepal.Length + Sepal. Width)
library(dplyr)
RFtoMP2E <- c(gii$Population.with.Secondary.Education..Female./gii$Population.with.Secondary.Education..Male.)
FtoMLFPR <- c(gii$Labour.Force.Participation.Rate..Female./gii$Labour.Force.Participation.Rate..Male.)
gii <- mutate(gii, RFtoMP2E = (edu2F / edu2M))
gii <- mutate(gii, FtoMLFPR = (LabF / LabM))
str(hd)



help("inner_join")
hd_gii <- inner_join(hd, gii, by = c("Country" = "Country"), suffix = c(".hd", ".gii"))
str(hd_gii)
write.csv(hd_gii, "human.csv")




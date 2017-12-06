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
colnames(hd)[5] <- "Edu.Exp"
colnames(hd)[7] <- "GNI"
colnames(hd)[4] <- "Life.Exp"
colnames(hd)[6] <- "MYE"
colnames(hd)[8] <- "GNI_HDI.Rank"
colnames(hd)

colnames(gii)[3] <- "GII"
colnames(gii)[4] <- "Mat.Mor"
colnames(gii)[5] <- "Ado.Birth"
colnames(gii)[6] <- "Parli.F"
colnames(gii)[7] <- "edu2F"
colnames(gii)[8] <- "edu2M"
colnames(gii)[9] <- "LabF"
colnames(gii)[10] <- "LabM"
colnames(gii)

#Mutate the "Gender inequality" data and create two new variables. The first one should be the ratio of Female and Male populations with secondary education in each country. (i.e. edu2F / edu2M). The second new variable should be the ratio of labour force participation of females and males in each country (i.e. labF / labM). 
#utate(iris, sepal = Sepal.Length + Sepal. Width)
library(dplyr)
Edu2.FM <- c(gii$Population.with.Secondary.Education..Female./gii$Population.with.Secondary.Education..Male.)
Labo.FM <- c(gii$Labour.Force.Participation.Rate..Female./gii$Labour.Force.Participation.Rate..Male.)
gii <- mutate(gii, Edu2.FM = (edu2F / edu2M))
gii <- mutate(gii, Labo.FM = (LabF / LabM))
str(hd)



help("inner_join")
hd_gii <- inner_join(hd, gii, by = c("Country" = "Country"), suffix = c(".hd", ".gii"))
str(hd_gii)


#Mutate the data: transform the Gross National Income (GNI) variable to numeric (Using string manipulation. Note that the mutation of 'human' was not done on DataCamp). (1 point)

transform(hd_gii, GNI = as.numeric(GNI))
str(hd_gii)

#"Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F" 

keep_columns <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# select the 'keep_columns' to create a new dataset
hd_gii <- dplyr::select(hd_gii, one_of(keep_columns))
dim(hd_gii)

hd_gii[complete.cases(hd_gii), ]

#This was supposed to only keep complete rows, but it didnt work. Hence, I googled and found the na.omit function
hd_gii <- na.omit(hd_gii)
dim(hd_gii)

#Then I try to remove the last 7 lines as those are regions:
hd_gii <- hd_gii[-c(189, 190, 191, 192, 193, 194, 195), ]
# That didnt work either, so I went back to datacamp and found this: I define the last indices we want to keep in last
last <- nrow(hd_gii) - 7
last
# Then I choose everything until the last 7 observations and keep it
human <- hd_gii[1:last, ]

# To add countries as rownames I mutate:
rownames(human) <- human$Country


#Then I need to remove the column "country" and write the table including rownames. I am unsusre if I need to define row.names = TRUE, but just to be sure. 
human <- dplyr::select(human, -Country)

write.csv(human, file = "human.csv", row.names = TRUE)




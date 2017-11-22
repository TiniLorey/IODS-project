#Martina Lorey, 22.11.2017, R Studio exercise 3. The source of the datase is <https://archive.ics.uci.edu/ml/datasets/Student+Performance>

#This data approach student achievement in secondary education of two Portuguese schools. The data attributes include student grades, demographic, social and school related features) and it was collected by using school reports and questionnaires. Two datasets are provided regarding the performance in two distinct subjects: Mathematics (mat) and Portuguese language (por). In [Cortez and Silva, 2008], the two datasets were modeled under binary/five-level classification and regression tasks. Important note: the target attribute G3 has a strong correlation with attributes G2 and G1. This occurs because G3 is the final year grade (issued at the 3rd period), while G1 and G2 correspond to the 1st and 2nd period grades. It is more difficult to predict G3 without G2 and G1, but such prediction is much more useful.

#Step 3: Read both student-mat.csv and student-por.csv into R (from the data folder) and explore the structure and dimensions of the data. 

str(student.mat)
dim(student.mat)
#[1] 650  33
glimpse(student.mat)

str(student.por)
dim(student.por)
#[1] 650  33
glimpse(student.por)

#Step 4: Join the two data sets using the variables "school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet" as (student) identifiers. Keep only the students present in both data sets. Explore the structure and dimensions of the joined data. 

# access the dplyr library
library(dplyr)

colnames(student.mat)
colnames(student.por)
rownames(student.mat)
variable.names(student.mat)
#First I had imported the csv without headings, thus some issues

# common variables to use as identifiers: "school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet"
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")


# join the two datasets by the selected identifiers
math_por <- inner_join(student.mat, student.por, by = join_by)
str(math_por)
dim(math_por)
glimpse(math_por)
#650/33

#Step 5a: 
# print out the column names of 'math_por'
colnames(math_por)

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))
colnames(alc)

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math_por)[!colnames(math_por) %in% join_by]

# print out the columns not used for joining
colnames(notjoined_columns)
notjoined_columns

# for every column name not used for joining...select two columns from 'math_por' with the same original name...select the first column vector of those two columns

for(column_name in notjoined_columns) {
  two_columns <- select(alc, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]
if(is.numeric(first_column)) {
alc[column_name] <- round(rowMeans(two_columns))
  } else {
  alc[column_name] <- first_column
  }
}

  
glimpse(alc)

#Step 6: Take the average of the answers related to weekday and weekend alcohol consumption to create a new column 'alc_use' to the joined data. Then use 'alc_use' to create a new logical column 'high_use' which is TRUE for students for which 'alc_use' is greater than 2 (and FALSE otherwise)

alc_use <- (math_por$Dalc.x + math_por$Walc.x)

# define a new column alc_use by combining weekday and weekend alcohol use

alc <- mutate(alc, alc_use = (math_por$Dalc.x + math_por$Walc.x) / 2)

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)
glimpse(alc)
#Observations: 382
#Variables: 15
#Its the wrong output, I have to go back and check my code

setwd("~/GitHub/IODS-project")
write.csv(alc, file = "alc.csv")


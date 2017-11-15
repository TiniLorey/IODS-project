#Martina Lorey 15.11.2017 R Studio Exercuise 2 from Chapter 2

students2014 <- read.table("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/learning2014.txt", sep=",", header = TRUE)
str(students2014)
dim(students2014)
head(students2014) 
#The data seems the same like my data wrangling exercise sheet the head() command gives the table in the format we know from excel
# The table includes the heraders gender, age, attitude (Global attitude toward statistics), deep (deep-learning), stra (strategic), surf (Surface), and points (exam points), its a learning exercise from 2014. More information about the data can be found in the meta data file: <http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-meta.txt> . But be aware that we have combined all Strategic learning columns to one, same with surface learning and deep learning, resulting in deep, stra, surf-columns.

#To visualize the data a bit I want to use the ggplot package, so I install and select it:
install.packages("ggplot2")
library("ggplot2", lib.loc="C:/Program Files/R/R-3.4.2/library")
library(ggplot2)

#As in the datacamp exercise I make a scatter plot. First: I initialize the plot with dataset and aesthetic mapping
p1 <- ggplot(students2014, aes(x = attitude, y = points, col = gender))
#Then I define the visualization type (points) and print the plot
p2 <- p1 + geom_point(aes(col = gender))
p2

#I want to add a trendline a.k.a. regression line, so I use the formula from datacamp: 
p3 <- p2 + geom_smooth(method = "lm")
p3
#It seems that for females higher attitude leads to slower increasing exam points, the regression line is steeper for men, who start lower but with higher attitude gain higher exam points

#Next I want to plot the age-to-point relation the same way:
p4 <- ggplot(students2014, aes(x = age, y = points, col = gender))
p5 <- p4 + geom_point(aes(col = gender))
p5
p6 <- p5 + geom_smooth(method = "lm")
p6
 #There it seems that for females, age has no influence on exam points, the regression line is just very slightly reducing points for growing age, while for men it looks that the exam points go more drastically down with higher age. 


#Next I explore the relationship of the variables with the pairs function in ggplot. 
# First I draw a scatter plot matrix of the variables in students2014 while excluding Gender as a column
pairs(students2014[-1], col = students2014$gender)
#The resulting plot matix looks a bit messy

# The next steps are a bit unclear, but in the datacamp we did it like this: install and select /access the GGally and ggplot2 libraries
install.packages("GGally")
library(GGally)
library(ggplot2)

# create a more advanced plot matrix with ggpairs()
p7 <- ggpairs(students2014, mapping = aes(col = gender, alpha = 0.3), lower = list(combo = wrap("facethist", bins = 20)))
p7
#What I take away from these plots is: There were more females than males in the course. The age of the males was slightly higher, their attitude was better and there exam points as well, even though they did just as well as the women in deep learning, but the strategic learning and surface questions they did worse.
#The correlations between the genders is given. 

#As the Attitude differs most between male and female participants I still make a linear regression and fit a linear model where points is the target variable and attitude the explanatory
qplot(attitude, points, data = students2014) + geom_smooth(method = "lm")
my_model <- lm(points ~ attitude, data = students2014)
summary(my_model)
#It is good news, the better your attitude towards statistics the better exam points you can score, so I guess if I just keep the sisu up I will succeed!


#Next I do the multiple variant verion by creating a plot matrix with ggpairs()
ggpairs(students2014, lower = list(combo = wrap("facethist", bins = 20)))

# And then I create a regression model with multiple explanatory variables and call it
my_model2 <- lm(points ~ attitude + stra + surf, data = students2014)
summary(my_model2)
#This gives me Residuals, Coefficients and their Errors, and shows that the p-value for attitude was 0,001.GÍn line with earlier results, it seems the attitude matters most.


#If I understood everything correct then the last task is to produce the following diagnostic plots: Residuals vs Fitted values, Normal QQ-plot and Residuals vs Leverage. Explain the assumptions of the model and interpret the validity of those assumptions based on the diagnostic plots. (0-3 points)
#For this I use the way we learned in datacamps graphical model validation, with the which argument  In the plot function you can use the argument "which" to choose which plots you want, "which# must be an integer vector corresponding to the following list of plots 1	Residuals vs Fitted values 2	Normal QQ-plot 3	Standardized residuals vs Fitted values 4	Cook's distances 5	Residuals vs Leverage 6	Cook's distance vs Leverage
plot(my_model2, which = c(1, 2, 5), par(mfrow = c(2,2)))
#The residuals over theroretical quantiles loos good for the most part, the others look a bit odd. I am unsure if the which list changed?


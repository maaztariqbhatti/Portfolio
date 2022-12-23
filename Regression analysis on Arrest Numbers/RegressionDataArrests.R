#Load all modules needed
library(ggplot2)
library(dplyr)
library(corrplot)
library(caTools)
library(tsoutliers)

install.packages("caTools")    # For Linear regression 
library(caTools)

install.packages('car')
library(car)

#Load the data
dataArrests = read.csv("dataArrests_Mac.csv", header = TRUE, sep = ";")
str(dataArrests)

#Check for missing values
any(is.na(dataArrests))
data[rowSums(is.na(data)) > 0, ]   
#Prints rows with missing values
dataArrests[rowSums(is.na(dataArrests)) > 0,]

#Since there are 5 rows with missing values we remove them
dataArrests = dataArrests[complete.cases(dataArrests),]

#Exploratory analysis

#Lets look at the distribution of each explantory variable through histogram
par(mfrow = c(2, 2))
hist(dataArrests$Assault, xlab = "Assault", main = NULL)
hist(dataArrests$UrbanPop, xlab = "Urban population", main = NULL)
hist(dataArrests$Traffic, xlab = "Traffic", main = NULL)
hist(dataArrests$CarAccidents, xlab = "Car accidents", main = NULL)

#Urban pop seems normally distrubuted
#We can confirming by plotting another graph with bounds for standard deviation
par(mfrow = c(1, 1))
plot(dataArrests$UrbanPop,type = "p", ylim = c(0,120), col = "blue", pch = 16,
     ylab = "UrbanPop", main = "Urban population distribution analysis")
abline(a=3*sd(dataArrests$UrbanPop) + mean(dataArrests$UrbanPop), b = 0, col = "red")
abline(a=mean(dataArrests$UrbanPop) - 3*sd(dataArrests$UrbanPop), b = 0, col = "red")
abline(a=mean(dataArrests$UrbanPop), b = 0, col = "black", lty = 2)
legend("bottomright",legend = c("+-3 Standard Deviation", "Mean"),
       col=c( "red", "black"), lty=1:2, cex=0.8,
       text.font=4, bg='lightblue')

#Confirmed Traffic is normally distributed no need to run further tests

#Lets look at the murder variable
hist(dataArrests$Murder, main = "Murder distribution", xlab = "Murder")
boxplot(dataArrests$Murder, main = "Boxplot for Murder")
#The box plot shows some potential outliers

#Lets look at summary stats of the dependent variable
summary(dataArrests$Murder)

#Lets plot murder against explanatory variables 
#Lets look at the distribution of each explantory variable through histogram
par(mfrow = c(3, 3), oma = c(5,4,0,0) + 0.1,
    mar = c(0,0,1.7,1.7) + 0.1)

plot(dataArrests$Assault, dataArrests$Murder,xlab = "Assault", ylab = "Murder", main = NULL)
plot(dataArrests$UrbanPop, dataArrests$Murder,xlab = "UrbanPop", ylab = "Murder", main = NULL)
plot(dataArrests$Drug, dataArrests$Murder,xlab = "Drug", ylab = "Murder", main = NULL)
plot(dataArrests$Traffic, dataArrests$Murder,xlab = "Traffic", ylab = "Murder", main = NULL)
plot(dataArrests$Cyber, dataArrests$Murder,xlab = "Cyber", ylab = "Murder", main = NULL)
plot(dataArrests$Kidnapping, dataArrests$Murder,xlab = "Kidnapping", ylab = "Murder", main = NULL)
plot(dataArrests$Domestic, dataArrests$Murder,xlab = "Domestic", ylab = "Murder", main = NULL)
plot(dataArrests$Alcohol, dataArrests$Murder,xlab = "Alcohol", ylab = "Murder", main = NULL)
plot(dataArrests$CarAccidents, dataArrests$Murder,xlab = "CarAccidents", ylab = "Murder")
title(xlab = "Explanatory variables",
      ylab = "Murder",
      outer = TRUE)
#Lets find correlation between the explanatory variables
cor(dataArrests)
corrplot(cor(dataArrests), "number")
#Traffic and and car accidents are highly corelated
#Variables that have highest coorelation with murder:
#Assault = 0.64, Drug = 0.39

cormat = abs(cor(dataArrests))
diag(cormat) = 0
#Remove highly correlated variables
while (max(cormat)>0.8) {
  #Find explanitory variables with highest absolute correlation
  maxvar = which(cormat == max(cormat), arr.ind = TRUE)
  
  #Select variable with highest average correlation
  maxavg = which.max(rowMeans(cormat[maxvar[,1],]))
  
  #FYI
  print(rownames(maxvar)[maxvar[,1] == maxvar[maxavg,1]])
  
  
  #Removal
  dataArrests = dataArrests[,-maxvar[maxavg,1]]
  cormat = cormat[-maxvar[maxavg,1], -maxvar[maxavg,1]]
}

#Car accidents has been removed since its correlation was highest

#Lets implement linear regression
lineRegModel = lm(Murder~Assault+UrbanPop+Drug+Traffic+Cyber+Kidnapping+Domestic+Alcohol, data = dataArrests)
summary(lineRegModel)

#Remove kidnapping from the model
lineRegModel = lm(Murder~Assault+UrbanPop+Drug+Traffic+Cyber+Domestic+Alcohol, data = dataArrests)
summary(lineRegModel)

#Remove Alcohol from the model
lineRegModel = lm(Murder~Assault+UrbanPop+Drug+Traffic+Cyber+Domestic, data = dataArrests)
summary(lineRegModel)

#Remove Domestic from the model
lineRegModel = lm(Murder~Assault+UrbanPop+Drug+Traffic+Cyber, data = dataArrests)
summary(lineRegModel)

#Remove Drug from the model
lineRegModel = lm(Murder~Assault+UrbanPop+Traffic+Cyber, data = dataArrests)
summary(lineRegModel)

#Remove traffic from the model
lineRegModel = lm(Murder~Assault+UrbanPop+Cyber, data = dataArrests)
summary(lineRegModel)

#Remove Cyber from the model
lineRegModel = lm(Murder~Assault+UrbanPop, data = dataArrests)
summary(lineRegModel)

#Remove UrbanPop from the model
lineRegModel = lm(Murder~Assault, data = dataArrests)
summary(lineRegModel)

#Plot the actual data and predicted values
ggplot(dataArrests,aes(x=Assault, y=Murder)) + geom_point() +
  geom_line((aes(x = Assault, y = fitted.values(lineRegModel), col = "red")))

#Lets take a look at the residuals

#1 Mean of the residuals should be close to zero
mean(residuals(lineRegModel))

#2 Variance of residuals 
var(residuals(lineRegModel))

#3 Residuals are linearly indepenent of each other
plot(residuals(lineRegModel), ylab = "Residuals", main = "Scatter plot of residuals",type = "p", 
     ylim = c(-25,30), col = "blue", pch = 16,)
abline(a=3*sd(residuals(lineRegModel)) + mean(residuals(lineRegModel)), b = 0, col = "red")
abline(a=mean(residuals(lineRegModel)) - 3*sd(residuals(lineRegModel)), b = 0, col = "red")
abline(a=mean(residuals(lineRegModel)), b = 0, col = "black", lty = 2)
legend("bottomright",legend = c("+-3 Standard Deviation", "Mean"),
       col=c( "red", "black"), lty=1:2, cex=0.8,
       text.font=4, bg='lightblue')

#Durbin watson test to test for auto correlation
durbinWatsonTest(lineRegModel)

#Check for relationship between the residuals and each of the explanatory variables
corrplot(cor(residuals(lineRegModel),dataArrests[,2:9]), "number")

#Check for normality
JarqueBera.test(residuals(lineRegModel))

#histogram of residuals
hist(residuals(lineRegModel), main = "Histogram of residuals", xlab = "Residuals")




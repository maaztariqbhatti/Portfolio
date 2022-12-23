rm(list=ls())

#Load all useful libraries
library(scales)
library(NbClust)
library(purrr)
library(ggplot2)
library(dplyr)
library(corrplot)

#Data
initdata = read.csv("wholesale_Mac.csv", header = TRUE, sep= ";")
str(initdata)

#Check for missing values
any(is.na(initdata))

#Exploratory data analysis
#Lets look at the distribution of each explantory variable through histogram
par(mfrow = c(1, 1))

#Take a look at the each variable
#Region
summary(initdata$Region)
ggplot(data= initdata, aes(x = Region)) + geom_bar()

#Channel
summary(initdata$Channel)
ggplot(data= initdata, aes(x = Channel)) + geom_bar()

#Fresh
summary(initdata$Fresh)
hist(initdata$Fresh, xlab = "Fresh", main = NULL)
boxplot(initdata$Fresh, xlab = "Fresh", main = "Boxplot for Fresh")
sum(initdata$Fresh)

#Milk
summary(initdata$Milk)
hist(initdata$Milk, xlab = "Milk", main = NULL)
boxplot(initdata$Milk, xlab = "Milk", main = "Boxplot for Milk")

#Grocery
summary(initdata$Grocery)
hist(initdata$Milk, xlab = "Grocery", main = NULL)
boxplot(initdata$Milk, xlab = "Grocery", main = "Boxplot for Grocery")

#Frozen
summary(initdata$Frozen)
hist(initdata$Frozen, xlab = "Frozen", main = NULL)
boxplot(initdata$Frozen, xlab = "Frozen", main = "Boxplot for Frozen")

#Detergents Paper
summary(initdata$Detergents_Paper)
hist(initdata$Detergents_Paper, xlab = "Detergents_Paper", main = NULL)
boxplot(initdata$Detergents_Paper, xlab = "Detergents_Paper", main = "Boxplot for Detergents_Paper")

#Detergents Delicassen      
summary(initdata$Delicassen)
hist(initdata$Delicassen, xlab = "Delicassen", main = NULL)
boxplot(initdata$Delicassen, xlab = "Delicassen", main = "Boxplot for Delicassen")

totalSpent = c(sum(initdata$Fresh), sum(initdata$Milk),  sum(initdata$Grocery),sum(initdata$Frozen), sum(initdata$Detergents_Paper),
sum(initdata$Delicassen))
min(totalSpent)

#Correlation analysis
cor(initdata)
corrplot(cor(initdata), "number")

plot(initdata$Grocery, initdata$Detergents_Paper, xlab = "Grocery", ylab = "Detergents_Paper")

plot(initdata$Grocery, initdata$Milk, xlab = "Grocery", ylab = "Milk")

#Scaling - min max maximaization to second dimension(each column)
normalizedData = apply(initdata[,c(3,4,5,6,7,8)],2, rescale, to =c(0,1))
str(normalizedData)

#Finding out the number of clusters
#run this as a function of k from 1 to 10
tot_within_ss = map_dbl(1:10, function(k){
  model = kmeans(normalizedData, centers = k, nstart = 25)
  model$tot.withinss
})

#Elbow plot
plot(1:10,tot_within_ss, type = 'o', xlab = "number of clusters",
     ylab = "Total WSS", main = "Elbow method", panel.first = grid())

#Other methods to determine number of clusters
silClust = NbClust(normalizedData, distance='euclidean', min.nc = 2, max.nc = 10,
                   method = "kmeans", index = "silhouette")

gapClust = NbClust(normalizedData, distance='euclidean', min.nc = 2, max.nc = 10,
                   method = "kmeans", index = "gap")

chClust = NbClust(normalizedData, distance='euclidean', min.nc = 2, max.nc = 10,
                  method = "kmeans", index = "ch")

#plot these methods
par(mfrow = c(1,3))
plot(2:10, silClust$All.index, type = 'o', xlab = "No of clusters",
     ylab = "Silhouette Score", panel.first = grid(), main = "Silhouette method")

plot(2:10, gapClust$All.index, type = 'o', xlab = "No of clusters",
     ylab = "Gap statistic", panel.first = grid(), main = "Gap statistics")

plot(2:10, chClust$All.index, type = 'o', xlab = "No of clusters",
     ylab = "Calinksi Harabasz", panel.first = grid(),main = "Calinski-Harabasz Index method")

#k means
kmeansmdl = kmeans(normalizedData, centers = 2, nstart = 25)
par(mfrow = c(1,1))
kmeansmdl$size

#Lets add cluster memberhips to the data
datanew = as.data.frame(normalizedData) %>%mutate(member = factor(kmeansmdl$cluster))
str(datanew)
datanew %>% group_by(member) %>%
  summarise_all(list(average = mean))


#Lets visualize the normalized dataset
ggplot(datanew, aes(x=Detergents_Paper, y=Grocery, col=member))+
  geom_point()+
  ggtitle("Clusters in the data set")

#Lets visualize
ggplot(datanew, aes(x = Detergents_Paper, y=Milk, col=member))+
  geom_point()

ggplot(datanew, aes(x = Frozen, y=Fresh, col=member))+
  geom_point()

#Put membership degrees in non normalized 
dataold = as.data.frame(initdata) %>%mutate(member = factor(kmeansmdl$cluster))

ggplot(dataold, aes(x=Detergents_Paper, y=Grocery, col=member))+
  geom_point()+
  ggtitle("Clusters in the data set")

#Lets visualize the old dataset
ggplot(dataold, aes(x = Detergents_Paper, y=Grocery, col=member))+
  geom_point()

#Barplot to show segrigation of clusters in categorical variables
ggplot(dataold,
       aes(x=Region, col = member, fill = member)) + 
  geom_bar()

#Investigate variable
ggplot(dataold, aes(x = member, y=Grocery, fill=member))+
  geom_boxplot()+
  ggtitle("Distribution of Grocery by Cluster")+
  xlab("Cluster")+
  ylab("Grocery")

#Amount of values in each cluster
dataold %>% group_by(member) %>%
  summarize(n())







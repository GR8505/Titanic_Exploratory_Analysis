#Data Preparation and Exploratory Analysis
#The following packages were installed and loaded

install.packages("ggplot2")
install.packages("ggthemes")
install.packages("scales")
install.packages("dplyr")
install.packages("mice")
install.packages("randomForest")
install.packages("ResourceSelection")
install.packages("viridis")
install.packages("RColorBrewer")
install.packages("wesanderson")
install.packages("magrittr")
install.packages("ggpubr")
install.packages("viridisLite")
install.packages("corrplot")
install.packages("Rcpp")
install.packages("Amelia")
install.packages("dummies")
install.packages("naniar")
install.packages("plotly")
install.packages("WriteXLS")
install.packages("plyr")

#Loading of packages
library("ggplot2")
library("ggthemes")
library("scales")
library("dplyr")
library("mice")
library("randomForest")
library("ResourceSelection")
library("viridisLite")
library("viridis")
library("RColorBrewer")
library("wesanderson")
library("magrittr")
library("ggpubr")
library("corrplot")
library("Rcpp")
library("Amelia")
library("dummies")
library("naniar")
library("plotly")
library("WriteXLS")
library("plyr")

#Proceeded to load both train and test titanic datasets
titanic.train <- read.csv ('C:/Users/Greg/Desktop/CSV/CSV/train.csv', stringsAsFactors = F)
titanic.test <- read.csv ('C:/Users/Greg/Desktop/CSV/CSV/test.csv', stringsAsFactors = F)
titanic.train$IsTrainSet <- TRUE
titanic.test$IsTrainSet <- FALSE
titanic.test$Survived <- NA

#Both train and test datasets were merged to search for anomalies and missingness
titanic.full <- rbind(titanic.train, titanic.test)

#An initial glance of the data
str(titanic.full)
summary(titanic.full)


#Proceeded to convert any possible blank/empty cells to NA for simplicity in dealing with 
#missingness
titanic.full[titanic.full==""] <- NA
colSums(is.na(titanic.full))

#From this analysis we see that there are 2 NA's in Embarked
#We will decipher which Passenger ID's have NA under Embarked
which(is.na(titanic.full$Embarked))

#We will decipher which Passenger ID has NA under Fare
which(is.na(titanic.full$Fare))

#Creating Title variable from Name
titanic.full$Title <- gsub('(.*, )|(\\..*)', '', titanic.full$Name)
special_title <- c('Dona', 'Lady', 'the Countess','Capt', 'Col', 'Don',                 'Dr', 'Major', 'Rev', 'Sir', 'Jonkheer')
titanic.full$Title[titanic.full$Title %in% special_title] <- 'Special Title'
titanic.full$Title[titanic.full$Title == 'Mlle']        <- 'Miss' 
titanic.full$Title[titanic.full$Title == 'Ms']          <- 'Miss'
titanic.full$Title[titanic.full$Title == 'Mme']         <- 'Mrs' 

#Creating Family Size variable from SibSp and Parch
titanic.full$Fsize <- titanic.full$SibSp + titanic.full$Parch + 1
titanic.full$FsizeC[titanic.full$Fsize == 1] <- 'loner'
titanic.full$FsizeC[titanic.full$Fsize < 5 & titanic.full$Fsize > 1] <- 'small'
titanic.full$FsizeC[titanic.full$Fsize > 4] <- 'large'

#Looking at the missing Embarked for passenger 62 and 830
#Both of them were Pclass = 1 and Fare = $80
# Performing a box plot shows that the median Fare for a Pclass 1 passenger that boarded at Cherbourg was $80, therefore we will set their Embarked = C

embark_fare <- titanic.full %>%
  filter(PassengerId != 62 & PassengerId != 830)

#Making box plot to illustrate the median Fare for the three Classes and three Embarkments
ggplot(embark_fare, aes(x = Embarked, y = Fare, fill = factor(Pclass))) +
  geom_boxplot() +
  geom_hline(aes(yintercept=80), 
             colour='red', linetype='dashed', lwd=2) +
  scale_y_continuous(labels=dollar_format()) +
  theme_few()

#From the boxplot we can see that the median Fare for a first class passenger that boarded at
#Cherbourg was around $80 (the dashed red line indicates this)
#Therefore, it is highly likely that these two passengers embarked at Cherbourg
titanic.full$Embarked[c(62, 830)] <- 'C'


#Missing Fare passenger 1044
#This passenger most likely boarded at Southampton and was Third Class.

ggplot(titanic.full[titanic.full$Pclass == '3' & titanic.full$Embarked == 'S', ], 
       aes(x = Fare)) +
  geom_density(fill = "#FB9A99", alpha=0.4) + 
  geom_vline(aes(xintercept=median(Fare, na.rm=T)),
             colour='black', linetype='dashed', lwd=1) +
  scale_x_continuous(labels=dollar_format()) +
  theme_cleveland()

#The median Fare for all passengers Embarked = S and Pclass = 3 was $8.05
titanic.full$Fare[1044] <- median(titanic.full[titanic.full$Pclass == '3' & titanic.full$Embarked == 'S', ]$Fare, na.rm = TRUE)


#I then proceeded to use the Multivariate Imputation by Chained Equations (MICE) method to predict missing ages.
factor_vars <- c('PassengerId','Pclass','Sex','Embarked',
                 'Title','FsizeC')
titanic.full[factor_vars] <- lapply(titanic.full[factor_vars], function(x) as.factor(x))
set.seed(129)
mice_mod <- mice(titanic.full[, !names(titanic.full) %in% c('PassengerId','Name','Ticket','Survived')], method='rf') 

mice_output <- complete(mice_mod)

titanic.full$Age <- mice_output$Age

par(mfrow=c(1,2))
h1<-hist(titanic.full$Age, freq=F, main='Age: Original Data', 
         col="#7FCDBB", ylim=c(0,0.04))
h2<-hist(mice_output$Age, freq=F, main='Age: MICE Output', 
         col="#225EA8", ylim=c(0,0.04))
par(mfrow=c(1,1))

#Created Child and Mother variables
titanic.full$Child[titanic.full$Age < 18] <- 'Child'
titanic.full$Child[titanic.full$Age >= 18] <- 'Adult'
titanic.full$Mother <- 'Not Mother'
titanic.full$Mother[titanic.full$Sex == 'female' & titanic.full$Parch > 0 & titanic.full$Age > 18 & titanic.full$Title != 'Miss'] <- 'Mother'

#Checking data and seeing what we need to convert as factors
str(titanic.full)

titanic.full$Child  <- factor(titanic.full$Child)
titanic.full$Mother <- factor(titanic.full$Mother)

#Checking for any missing values for variables that we want to use(Cabin is useless) 
md.pattern(titanic.full)


#Splitting full dataset to test and train
#Proceed to make predictive model
titanic.train <- titanic.full[titanic.full$IsTrainSet==T,]
titanic.test <- titanic.full[titanic.full$IsTrainSet==F,]
titanic.train$Survived <- as.factor(titanic.train$Survived)


set.seed(653)
#Performing Backward Selection for Logistic Regression Model
log_rm1 <- glm(Survived ~ Pclass + Sex + Age + SibSp + Parch +  Fare + Embarked + Title + FsizeC + Child + Mother, family = binomial, data = titanic.train)
summary(log_rm1)
hoslem.test(titanic.train$Survived, fitted(log_rm1))

#AIC = 751.55
#Removed Variable Sex as it has the highest p-value
#Title, FsizeC and Pclass are all significant
log_rm2 <- glm(Survived ~ Pclass + Age + SibSp + Parch +  Fare + Embarked + Title + FsizeC + Child + Mother, family = binomial, data = titanic.train)
summary(log_rm2)

#AIC increased to 755.45
#p-value for Embarked is high.  Seeking to remove and test
log_rm3 <- glm(Survived ~ Pclass + Age + SibSp + Parch +  Fare + Title + FsizeC + Child + Mother, family = binomial, data = titanic.train)
summary(log_rm3)

#AIC lowered to 753.27
#p-value for Fare reduced 
#Removed Variable Mother and retesting
log_rm4 <- glm(Survived ~ Pclass + Age + SibSp + Parch +  Fare + Title + FsizeC + Child, family = binomial, data = titanic.train)
summary(log_rm4)

#AIC reduced to 751.35 which is lower than the 751.55 in the first model
#Removed Variable Parch
log_rm5 <- glm(Survived ~ Pclass + Age + SibSp +  Fare + Title + FsizeC + Child, family = binomial, data = titanic.train)
summary(log_rm5)

#AIC = 749.44
#It seems that Pclass, Title and Fsize are the most significant variables in this model
#Removed Variable SibSp
log_rm6 <- glm(Survived ~ Pclass + Age + Fare + Title + FsizeC + Child, family = binomial, data = titanic.train)
summary(log_rm6)

#AIC = 747.84
#p-value for Fare continues to fall
#Removed Variable Child
log_rm7 <- glm(Survived ~ Pclass + Age + Fare + Title + FsizeC, family = binomial, data = titanic.train)
summary(log_rm7)

#AIC = 746.58
#p-value for Age has dropped as well
#Experimenting with removal of Fare and Age
#Removing Fare first
log_rm8 <- glm(Survived ~ Pclass + Age + Title + FsizeC, family = binomial, data = titanic.train)
summary(log_rm8)

#AIC increased to 748.04
#Replacing Age with Fare and retesting model
log_rm9 <- glm(Survived ~ Pclass + Fare + Title + FsizeC, family = binomial, data = titanic.train)
summary(log_rm9)

#AIC (747.39) is still higher than AIC for log_rm7 model
#Most variables in log_rm7 are significant
#Proceeded to use log_rm7

prediction_glm <- predict(log_rm7, titanic.test)
solution <- data.frame(PassengerID = titanic.test$PassengerId, Survived = prediction_glm)

head(prediction_glm)
prediction_glm = ifelse(prediction_glm > 0.5, 1, 0)
head(prediction_glm)
solution <- data.frame(PassengerID = titanic.test$PassengerId, Survived = prediction_glm)
write.csv(solution, file = 'log_rm7_Solution.csv', row.names = F)
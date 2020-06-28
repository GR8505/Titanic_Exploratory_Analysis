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
titanic.train <- read.csv ('C:/Users/Greg/Documents/Analysis Projects/Titanic_Challenge/Titanic_Exploratory_Analysis/Resources/train.csv', stringsAsFactors = F)
titanic.test <- read.csv ('C:/Users/Greg/Documents/Analysis Projects/Titanic_Challenge/Titanic_Exploratory_Analysis/Resources/test.csv', stringsAsFactors = F)
titanic.train$IsTrainSet <- TRUE
titanic.test$IsTrainSet <- FALSE
titanic.test$Survived <- NA

#Both train and test datasets were merged to search for anomalies and missingness
titanic.full <- rbind(titanic.train, titanic.test)

#An initial glance of the data
str(titanic.full)
summary(titanic.full)

#First of all, from glancing at the data we can see that Cabin is poorly populated. 
#Let us deal with this variable one time.
#Cabin is poorly populated,but let us separate the Deck from the Cabin
titanic.full$Cabin[titanic.full$Cabin==""] <- "U"
strsplit(titanic.full$Cabin[2], NULL)[[1]]
titanic.full$Deck<-factor(sapply(titanic.full$Cabin, function(x) strsplit(x, NULL)[[1]][1]))
levels(titanic.full$Deck)

#Assigning Values to the Deck (Doing this now so that we can perform a correlation matrix later)

titanic.full$DeckD <- revalue(titanic.full$Deck,
                              c("A"="1", "B"="2", "C"="3", "D"="4", "E"="5", "F"="6", 
                                "G"="7", "T"="8", "U"="9"))

table(titanic.full$Survived, titanic.full$Deck)

DeckB<-ggplot(titanic.full[1:891,], aes(x = Deck, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  labs(x = 'Deck')
pl2<-c("#F16913", "#5E4FA2")
DeckB+scale_fill_manual(values = pl2) + scale_color_grey()+theme(legend.position="bottom") + coord_flip()


#Not sure if this variable provides any meaningful insights as there a lot of unknown Decks
#for the passengers

#Proceeded to convert any possible blank/empty cells to NA for simplicity in dealing with 
#missingness
titanic.full[titanic.full==""] <- NA
colSums(is.na(titanic.full))

#Getting an idea of how many missing items we have to deal with
vis_miss(titanic.full) + coord_flip()

#Provides us with a visual of how many age values are missing
ggplot(titanic.full, aes(x=PassengerId, y = Age)) + geom_miss_point() + theme_dark()


#Recognising that there are NA's in the dataset, let us proceed to count them
sum(is.na(titanic.full))

#We performed further analysis of which columns had NA values
colSums(is.na(titanic.full))

#From this analysis we see that there are 2 NA's in Embarked
#We will decipher which Passenger ID's have NA under Embarked
which(is.na(titanic.full$Embarked))

#We will decipher which Passenger ID has NA under Fare
which(is.na(titanic.full$Fare))

#Looking at each variable and how it relates to Survival
#Let's look at Pclass
table(titanic.full$Survived, titanic.full$Pclass)
display.brewer.all()
display.brewer.pal(n = 11, name = 'Spectral')
brewer.pal(n = 11, name = "Spectral")

b1<-c("#66C2A5", "#3288BD", "#5E4FA2")
bA<-ggplot(titanic.full[1:891,], aes(x = Pclass, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(1:11)) +
  labs(x = 'Pclass')

bA+scale_fill_manual(values = b1) + scale_color_grey()+theme(legend.position="bottom")

#Let's look at Gender
table(titanic.full$Survived, titanic.full$Sex)
display.brewer.pal(n = 9, name = 'Oranges')
brewer.pal(n = 9, name = "Oranges")

b2<-c("#FDD0A2", "#F16913")
bB<-ggplot(titanic.full[1:891,], aes(x = Sex, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  labs(x = 'Gender')

bB+scale_fill_manual(values = b2) + scale_color_grey()+theme(legend.position="bottom")

#Looking at the age distribution for the passengers who did not survive
Age1<-ggplot(titanic.full[titanic.full$Survived == '0',], 
             aes(x = Age)) +
  geom_density(fill = 'lightblue', na.rm = TRUE, alpha=0.4,)  +
  scale_x_continuous() +
  theme_few()


#Looking at the age distribution for the passengers who did survive
Age2<-ggplot(titanic.full[titanic.full$Survived == '1',], 
             aes(x = Age)) +
  geom_density(fill = 'lightgreen',na.rm = TRUE, alpha=0.4)  +
  scale_x_continuous() +
  theme_few()

ggarrange(Age1, Age2, 
          labels = c(" Not Survived", "   Survived"),
          ncol = 1, nrow = 2)


#We can see that the distributions look more or less the same but younger age groups had a slightly better chance at
#survival

#Looking at the mean ages for both Survival Groups

Age1Mean<-ggplot(titanic.full[titanic.full$Survived == '0',], 
                 aes(x = Age)) +
  geom_density(fill = 'lightblue', na.rm = TRUE, alpha=0.4,)  +
  geom_vline(aes(xintercept=mean(Age, na.rm=T)),
             colour='red', linetype='dashed', lwd=1)+
  scale_x_continuous() +
  theme_few()

Age2Mean<-ggplot(titanic.full[titanic.full$Survived == '1',], 
                 aes(x = Age)) +
  geom_density(fill = 'lightgreen',na.rm = TRUE, alpha=0.4)  +
  geom_vline(aes(xintercept=mean(Age, na.rm=T)),
             colour='red', linetype='dashed', lwd=1)+
  scale_x_continuous() +
  theme_few()
ggarrange(Age1Mean, Age2Mean, 
          labels = c(" Not Survived", "   Survived"),
          ncol = 1, nrow = 2)
#We can see that the mean age for those who did not survive is higher than those who did survive
#But we will not proceed of further analysis of this variable as we will have to deal with missingness later

#Looking at SibSp and Parch
#We suspect that these two variables will be correlated
#Will investigate later

table(titanic.full$Survived, titanic.full$SibSp)
table(titanic.full$Survived, titanic.full$Parch)

brewer.pal(n = 9, name = "Greens")
brewer.pal(n = 9, name = "Blues")

b3<-c("#A1D99B", "#41AB5D")
bSp<-ggplot(titanic.full[1:891,], aes(x = SibSp, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(0:11)) +
  labs(x = 'SibSp')
BSpFinal <- bSp+scale_fill_manual(values = b3) + scale_color_grey()+theme(legend.position="right")

b4<-c("#9ECAE1", "#4292C6")
bParch<-ggplot(titanic.full[1:891,], aes(x = Parch, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(0:11)) +
  labs(x = 'Parch')
BParchFinal <- bParch+scale_fill_manual(values = b4) + scale_color_grey()+theme(legend.position="right")

ggarrange(BSpFinal, BParchFinal, 
          labels = c("                 SibSp", "                Parch"),
          ncol = 1, nrow = 2)

#From the illustration of theses two charts, it appears that being a loner does not help
#one's chances of survival on the Titanic.
#However, a large number of loners did also survive but we will look at this further.
brewer.pal(n = 9, name = "Purples")
SibSp0<-ggplot(titanic.full[titanic.full$Survived == '0',], 
               aes(x = SibSp)) +
  geom_density(fill = "red", na.rm = TRUE, alpha=0.4,)  +
  scale_x_continuous(breaks=c(0:8)) 

brewer.pal(n = 9, name = "Blues")
SibSp1<-ggplot(titanic.full[titanic.full$Survived == '1',], 
               aes(x = SibSp)) +
  geom_density(fill = "darkblue", na.rm = TRUE, alpha=0.4,)  +
  scale_x_continuous(breaks=c(0:8))

ggarrange(SibSp0, SibSp1, 
          labels = c("                 Perished", "                Survived"),
          ncol = 1, nrow = 2)

#From this analysis, we can see that being a loner has a very minor impact on survival, although
#a higher density of loners did perish (density of 1.5 (Perished) compared to 1.2(Survived)).  Another insight is that
#persons with exactly one SibSp had a higher chance of survival (density of just around 0.7(Survived) compared 
#to 0.4(Perished)).
#Also it is worth noting that anybody with SibSp > 4 did not survive.
#Not sure if this variable will impact the model.
#Proceeding to do the same with Parch

brewer.pal(n = 11, name = "RdGy")
Parch0<-ggplot(titanic.full[titanic.full$Survived == '0',], 
               aes(x = Parch)) +
  geom_density(fill = "#B2182B", na.rm = TRUE, alpha=0.4,)  +
  scale_x_continuous() 
Parch1<-ggplot(titanic.full[titanic.full$Survived == '1',], 
               aes(x = Parch)) +
  geom_density(fill = "#F4A582", na.rm = TRUE, alpha=0.4,)  +
  scale_x_continuous() 

ggarrange(Parch0, Parch1, 
          labels = c("                 Perished", "                Survived"),
          ncol = 1, nrow = 2)

#From the diagram both Survived and Perished have a similar Parch distribution.  
#There is just a higher proportion of loners who perished.  
#In addition, anyone with a Parch of 1 or 2 had a higher survival rate.
#Number of survived declines with Parch>=3
#Let's look at the correlation between SibSp and Parch

CorSibParch <- cor(titanic.full$SibSp, titanic.full$Parch)
#With a correlation of <0.5, we can safely say that there is a weak correlation
#between SibSp and Parch



#Looking at Fare
brewer.pal(n = 9, name = "GnBu")
FareDist0<-ggplot(titanic.full[titanic.full$Survived == '0',], 
                  aes(x = Fare)) +
  geom_density(fill = "#A8DDB5", na.rm = TRUE, alpha=0.4,)  +
  geom_vline(aes(xintercept=mean(Age, na.rm=T)),
             colour='red', linetype='dashed', lwd=1)+
  scale_x_continuous(labels=dollar_format())

FareDist1<-ggplot(titanic.full[titanic.full$Survived == '1',], 
                  aes(x = Fare)) +
  geom_density(fill = "#7BCCC4", na.rm = TRUE, alpha=0.4,)  +
  geom_vline(aes(xintercept=mean(Age, na.rm=T)),
             colour='red', linetype='dashed', lwd=1)+
  scale_x_continuous(labels=dollar_format())

ggarrange(FareDist0, FareDist1, 
          labels = c("                 Perished", "                Survived"),
          ncol = 1, nrow = 2)

p1 <- ggplot(titanic.full[titanic.full$Survived == '0',], aes(x=Fare)) + 
  geom_histogram(aes(y = ..density..), alpha = 0.7, fill = "#333333") + 
  geom_density(fill = "#ff4d4d", alpha = 0.5) + 
  ggtitle("Deceased (Average Fare = $22.12)")

fig1 <- ggplotly(p1)

p2 <- ggplot(titanic.full[titanic.full$Survived == '1',], aes(x=Fare)) + 
  geom_histogram(aes(y = ..density..), alpha = 0.7, fill = "#084081") + 
  geom_density(fill = "#7BCCC4", alpha = 0.5) + 
  ggtitle("Survived (Average Fare = $48.40)")

fig2 <- ggplotly(p2)

fig1
fig2

AvgFareDeceased <- mean(titanic.full[titanic.full$Survived == '0',]$Fare, na.rm = TRUE)
AvgFareSurvived <- mean(titanic.full[titanic.full$Survived == '1',]$Fare, na.rm = TRUE)

#Not sure if this shows that Fare is a mjor determinant for Survival but the average fare for
#persons that survived ($48.40) is more than double the average fare for persons who did not survive ($22.12)
#We suspect that Fare and Pclass could also be correlated..

CorClassFare <- cor(titanic.full$Pclass, titanic.full$Fare, use="complete.obs")

#There is a negative correlation between these two variables.  At around -0.6
#we will say it is not a strong negative correlation ( < -0.8), but it is neither a weak negative
#correlation ( > -0.5).  

#Looking at Embarked
table(titanic.full$Survived, titanic.full$Embarked)

brewer.pal(n = 12, name = "Set3")
b5<-c("#8DD3C7", "#BC80BD")

embark_clean <- titanic.full %>%
  filter(PassengerId != 62 & PassengerId != 830)

plotEmbarked <- ggplot(embark_clean[1:891,], aes(x = Embarked, fill = factor(Survived))) +
  geom_bar(stat='count', position = position_dodge2(width = 2.5, preserve = "single")) +
  labs(x = 'Embarked')

plotEmbarked+scale_fill_manual(values = b5) + scale_color_grey()+theme(legend.position="bottom")+ coord_flip()

#From this diagram we can see that Cherbourg was the only port that had a higher proportion of 
#survived compared to not survived.  Queenstown had a higher number of passengers who died compared to
#survived while passengers who boarded in Southampton had the highest number of casualties.


#Creating Title variable from Name
titanic.full$Title <- gsub('(.*, )|(\\..*)', '', titanic.full$Name)
special_title <- c('Dona', 'Lady', 'the Countess','Capt', 'Col', 'Don',                 'Dr', 'Major', 'Rev', 'Sir', 'Jonkheer')
titanic.full$Title[titanic.full$Title %in% special_title] <- 'Special Title'
titanic.full$Title[titanic.full$Title == 'Mlle']        <- 'Miss' 
titanic.full$Title[titanic.full$Title == 'Ms']          <- 'Miss'
titanic.full$Title[titanic.full$Title == 'Mme']         <- 'Mrs' 

str(titanic.full)
titanic.full$Title  <- factor(titanic.full$Title)
#Let's see how Title impacts survival
mosaicplot(table(titanic.full$Title, titanic.full$Survived), main='Title by Survival', shade=TRUE)

table(titanic.full$Survived, titanic.full$Title)
ggplot(titanic.full[1:891,], aes(Age, fill = factor(Survived))) + 
  geom_histogram() + facet_grid(.~Title)

p<-ggplot(titanic.full[1:891,], aes(x = Title, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  labs(x = 'Title')

pl1<-c("#7FCDBB", "#225EA8")

p+scale_fill_manual(values = pl1) + scale_color_grey()+theme(legend.position="bottom")

#Creating Family Size variable from SibSp and Parch
titanic.full$Fsize <- titanic.full$SibSp + titanic.full$Parch + 1
titanic.full$FsizeC[titanic.full$Fsize == 1] <- 'loner'
titanic.full$FsizeC[titanic.full$Fsize < 5 & titanic.full$Fsize > 1] <- 'small'
titanic.full$FsizeC[titanic.full$Fsize > 4] <- 'large'

table(titanic.full$Survived, titanic.full$Fsize)
table(titanic.full$Survived, titanic.full$FsizeC)

display.brewer.all()
display.brewer.pal(n = 12, name = 'Paired')
brewer.pal(n = 12, name = "Paired")

F1<-c("#A6CEE3","#1F78B4")
FA<-ggplot(titanic.full[1:891,], aes(x = Fsize, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(1:12)) + labs(x="")

b1<-FA+scale_fill_manual(values = F1) + scale_color_grey()+theme(legend.position="right")

F2<-c("#B2DF8A","#33A02C")
FB<-ggplot(titanic.full[1:891,], aes(x = FsizeC, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') + labs(x="")

b2<-FB+scale_fill_manual(values = F2) + scale_color_grey()+theme(legend.position="right")
ggarrange(b1, b2, 
          labels = c("          Fsize", "         FsizeC"),
          ncol = 1, nrow = 2)

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

#As there are no missing ages, we will form age categories and look at this.

titanic.full$AgeC[titanic.full$Age <= 11] <- '0'
titanic.full$AgeC[titanic.full$Age > 11 & titanic.full$Age <= 18] <- '1'
titanic.full$AgeC[titanic.full$Age > 18 & titanic.full$Age <= 25] <- '2'
titanic.full$AgeC[titanic.full$Age > 25 & titanic.full$Age <= 35] <- '3'
titanic.full$AgeC[titanic.full$Age > 35 & titanic.full$Age <= 45] <- '4'
titanic.full$AgeC[titanic.full$Age > 45 & titanic.full$Age <= 65] <- '5'
titanic.full$AgeC[titanic.full$Age > 65] <- '6'

display.brewer.pal(n = 8, name = "Accent")
brewer.pal(n = 8, name = "Accent")
AgePC<-c("#F0027F","#666666")
AgePCB<-ggplot(titanic.full[1:891,], aes(Age, fill = factor(Survived))) + 
  geom_histogram() + facet_grid(.~Pclass) + ggtitle("Pclass")
AgePCB+scale_fill_manual(values = AgePC) + theme_classic2() + labs(x="Age")



AgeCC<-c("#BDBDBD","#525252")
AgeCBar<-ggplot(titanic.full[1:891,], aes(x = AgeC, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') + labs(x="Survival by Age Category")

AgeCBar+scale_fill_manual(values = AgeCC) + theme_classic2()

#Looking at the relationship between FsizeC and survival by Ages.
display.brewer.pal(n = 11, name = 'Spectral')
brewer.pal(n = 11, name = "Spectral")
display.brewer.pal(n = 11, name = 'BrBG')
brewer.pal(n = 11, name = "BrBG")

p<-ggplot(titanic.full[1:891,], aes(Age, fill = factor(Survived))) + 
  geom_histogram() + facet_grid(.~FsizeC)

p+scale_fill_manual(values=c("#9E0142", "#5E4FA2", "#01665E" )) +theme(legend.position="bottom")


#Created Child and Mother variables
titanic.full$Child[titanic.full$Age < 18] <- 'Child'
titanic.full$Child[titanic.full$Age >= 18] <- 'Adult'
titanic.full$Mother <- 'Not Mother'
titanic.full$Mother[titanic.full$Sex == 'female' & titanic.full$Parch > 0 & titanic.full$Age > 18 & titanic.full$Title != 'Miss'] <- 'Mother'

#Analyzing both the Mother and Child variables
table(titanic.full$Survived, titanic.full$Child)
table(titanic.full$Survived, titanic.full$Mother)

display.brewer.all()
display.brewer.pal(n = 9, name = 'Reds')
brewer.pal(n = 9, name = 'Reds')

C1<-c("#A50F15","#FC9272")
CA<-ggplot(titanic.full[1:891,], aes(x = Child, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') + labs(x="Child") + theme_classic2()

c1<-CA+scale_fill_manual(values = C1) + scale_color_grey()+theme(legend.position="right")

display.brewer.pal(n = 9, name = 'PuBu')
brewer.pal(n = 9, name = "PuBu")

C2<-c("#045A8D","#A6BDDB")
CB<-ggplot(titanic.full[1:891,], aes(x = Mother, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') + labs(x="Mother") + theme_classic2()

c2<-CB+scale_fill_manual(values = C2) + scale_color_grey()+theme(legend.position="right") 
ggarrange(c1, c2, 
          labels = c("", ""),
          ncol = 1, nrow = 2)



#Creating Dummy Variables for Sex, Child and Mother variables (need to assign numerical values
# for these variables to build a correlation plot later)
titanic.full$SexD <- as.integer(titanic.full$Sex =="female")

titanic.full$ChildD <- revalue(titanic.full$Child,
                               c("Adult"="0", "Child"="1"))

titanic.full$MotherD <- revalue(titanic.full$Mother,
                                c("Not Mother"="0", "Mother"="1"))

#Creating numerical categories for Embarked, Title and Fsize (we will need this to build our
#correlation matrix later)
titanic.full$EmbarkedD <- revalue(titanic.full$Embarked,
                                  c("S"="0", "C"="1", "Q"="2"))
titanic.full$TitleD <- revalue(titanic.full$Title,
                               c("Mr"="1", "Miss"="2", "Mrs"="3", "Master"="4", "Special Title"="5"))

titanic.full$FsizeD <- revalue(titanic.full$FsizeC,
                               c("loner"="0", "small"="1", "large"="2"))



#Checking data and seeing what we need to convert as factors
str(titanic.full)

titanic.full$Child  <- factor(titanic.full$Child)
titanic.full$Mother <- factor(titanic.full$Mother)
titanic.full$ChildD  <- factor(titanic.full$ChildD)
titanic.full$MotherD <- factor(titanic.full$MotherD)
titanic.full$AgeC <- factor(titanic.full$AgeC)
titanic.full$SexD <- factor(titanic.full$SexD)


#Checking for any missing values for variables that we want to use(Cabin is useless) 
md.pattern(titanic.full)

#Let's proceed to make a correlation matrix before predicting

data.corr <- subset(titanic.full[1:891,], select = c(2,3,6,7,8,10,15,17,19,22,23,24,25,26,27))

#Let's check to see if all variables are numeric.
#All variables must be numeric before performing correlation matrix
str(data.corr)
data.corr$Survived<- as.numeric(data.corr$Survived)
data.corr$Pclass<- as.numeric(data.corr$Pclass)
data.corr$DeckD<- as.numeric(data.corr$DeckD)
data.corr$AgeC<- as.numeric(data.corr$AgeC)
data.corr$SibSp<- as.numeric(data.corr$SibSp)
data.corr$Parch<- as.numeric(data.corr$Parch)
data.corr$EmbarkedD<- as.numeric(data.corr$EmbarkedD)
data.corr$TitleD<- as.numeric(data.corr$TitleD)
data.corr$FsizeD<- as.numeric(data.corr$FsizeD)
data.corr$ChildD<- as.numeric(data.corr$ChildD)
data.corr$MotherD<- as.numeric(data.corr$MotherD)
data.corr$SexD<- as.numeric(data.corr$SexD)

M<-cor(data.corr)
head(round(M,2))
corrplot(M, method="circle")
corrplot(M, method="pie")
corrplot(M, method="color")
corrplot(M, method="number")
corrplot(M, type="upper", order="hclust")
corrplot(M, type="upper")
corrplot(M, type="lower")
corrplot(M, type="upper", order="hclust",
         col=brewer.pal(n=8, name="RdYlBu"))

#Based on the results of the correlation matrix Age and AgeC are highly correlated
#and SibSp and Fsize are also strongly correlated.
#Based on the results of our correlation matrix and missing values in DeckD we opted to 
#perform backward regression with the following variables 
#Pclass, Sex , Age , SibSp , Parch ,  Fare , Embarked , Title , FsizeC , Child and Mother.  
# Titanic Machine Learning
-------------------------------------------------------------------------------------------------
## Executive Overview ##
-------------------------------------------------------------------------------------------------
The aim of this machine learning project was to develop a model to predict the number of people
who survived the sinking of the Titanic.  At the end of my Exploratory Data Analysis (EDA) and 
modelling, I successfully developed a logistic regression model that yielded an accuracy of 79.9 
percent.  

In the future, I will attempt to improve this accuracy with another classification method like
K-Nearest Neighbours (KNN) and various sampling methods. 

However, it was surprising to note that **Gender** was not included in the final model. I believe that
the creation of the variable **Title** turned out to be a more accurate predictor for survival rate.

My final Logistic Regression model was:
Survived ~ Pclass + Age + Fare + Title + FsizeC.  

-------------------------------------------------------------------------------------------------

## List of Initial Features ##
-------------------------------------------------------------------------------------------------
- Pclass - Passenger Class (1=First Class, 2=Second Class, 3=Third Class)
- Survival - Survival (0=Passenger did not survive, 1=Passenger survived)
- Name - Name of passenger
- Sex - Passenger's gender (male or female)
- Age - Passenger's age
- SibSp - Number of siblings/spouses aboard
- Parch - Number of parents/children aboard
- Ticket Number
- Fare - Passenger Fare (British Pound)
- Cabin - Cabin Number
- Embarked - Port of Embarkation (C=Cherbourg, Q=Queenstown, S=Southampton)

-------------------------------------------------------------------------------------------------
## Feature Analysis ##
-------------------------------------------------------------------------------------------------
### Pclass ###                                                                                                                           
High percentage of Third Class passengers perished, while First Class was the only category to have 
a higher percentage of passengers that survived.

### Sex ###
It appears that males had a lower chance of survival compared to females.



|**Number of Survived by Pclass**                             | **Number of Survived by Gender**                                        |  
|-------------------------------------------------------------|-------------------------------------------------------------------------|
|<img src="https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot03.jpeg" width="400"> | <img src="https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot04.jpeg" width="400">|


-------------------------------------------------------------------------------------------------

### Age ###
The age distributions for both 'Survived' and 'Not Survived' are similar but it seems that
younger age groups (somewhere between 1-10) had a slightly higher chance of survival.

The average age for the 'Survived' group was slightly lower than the mean age for the 'Not 
Survived' group.  However, I must emphasize that it is a minor difference.

-------------------------------------------------------------------------------------------------
**Age Distribution: 'Survived' vs 'Not Survived'**

src="https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot05.jpeg" width="400">

-------------------------------------------------------------------------------------------------

### SibSp and Parch ###
From our initial analysis, it seems that being a 'loner' did not help one's chances of
survival.  Nevertheless, I did observe that a large number of 'loners' also managed to
survive the sinking of the Titanic.

A high percentage of passengers with both no siblings and parents or children (SibSp = 0 and
Parch = 0) did not survive. For pesrons with 1 sibling or spouse, there was a slightly higher
chance of survival.  Furthermore, anyone with a Parch value of 1 or 2 had a higher probability
for surviving.

Nonetheless, I must emphasize that anybody with more than 4 siblings (SibSp > 4), perished and
any passenger with 3 or more parent/child affilliations (Parch >= 3), had a lower probability 
for survival.

-------------------------------------------------------------------------------------------------
**SibSp and Parch Survival Analysis**

src="https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot07.jpeg" width="400">
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot07.jpeg)

The correlation between these two variables is < 0.5, sowe can infer that there is no 
significant relationship between SibSp and Parch.

-------------------------------------------------------------------------------------------------

### Fare ###
No clear insight into whether Fare is related to survival but the average Fare for those who
survived is 119 percent higher (more than double) than the average Fare for non-survivors.

-------------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot11.png)

-------------------------------------------------------------------------------------------------
Surprisingly, there is no strong correlation between Fare and Pclass.  At -0.6, this is a 
significant negative correlation but not a strong one.

-------------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot12.png)

-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

### Embarked ###
Cherbourg was the only port that had a higher proportion of 'Survived' compared to 'Not 
Survived'.  Queenstown recorded a higher number of deaths compared to number of survived, while
passengers who boarded in Southampton registered the highest number of deaths.

-------------------------------------------------------------------------------------------------
**Survived by Embarked**

![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot13.jpeg)

-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
## Feature Creation ##
-------------------------------------------------------------------------------------------------
New variables were created for further exploratory analysis.  This is the list of additional
variables:

- Title - (Master, Miss, Mr, Mrs and Special Title)
- Fsize - (Family size)
- FsizeC - (Refers to family size category; there are three categories, large, small and loner)
- Deck - (Deck Number)
- AgeC - (Age category)
- Child - (Whether passenger is a child or not)
- Mother - (Whether passenger is a mother or not)
-------------------------------------------------------------------------------------------------

### Title ###
This new variable provides some meaningful insights.  We can infer that passengers with the 
title 'Mr.' had a very low chance of survival.

-------------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot14.jpeg)

-------------------------------------------------------------------------------------------------

On the contrary, persons with the titles 'Miss', 'Mrs.' and 'Master' probably stood a better
chance at surviving.

-------------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot16.jpeg)

-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
## Fsize and FsizeC ##
Fsize = SibSp + Parch + 1
For FsizeC, Loners are passengers with Fsize = 1, Small represents passengers with Fsize 
between 1 to 4 and Large are those with Fsize >= 5.

-------------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot17.jpeg)

------------------------------------------------------------------------------------------------
Loners definitely had a lower probability of survival.  Passengers in small families had the 
best chance of survival out of all these family size categories.

------------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot23.jpeg)

-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
## Deck ##
For this variable, unknown decks are labelled as 'U'. On closer analysis, I am not sure if
this variable would add value to our predictive model, as there is a large percentage of
passengers who are assigned to unknown decks.

-------------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot.jpeg)

-------------------------------------------------------------------------------------------------
## AgeC ##
Ages were broken down into the following categories:
1) Category 0: Age<=11
2) Category 1: 11<Age<=18
3) Category 2: 18<Age<=25
4) Category 3: 25<Age<=35
5) Category 4: 35<Age<=45
6) Category 5: 45<Age<=65
7) Category 6: Age>65
-------------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot22.jpeg)

This provides little insight. Although a high number of passengers perished in the age 
categories 2 and 3, a high number of them also survived.  No clear pattern or relationship
identified here.

-------------------------------------------------------------------------------------------------
## Child and Mother ##
These new variables show that being a child does have a major impact on survival. 

![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot24.jpeg)

Passengers who were mothers had a slightly better chance of survival.

-------------------------------------------------------------------------------------------------
## Correlation ##
As expected, there is a strong correlation between Age and AgeC. Fsize is also strongly
correlated with both SibSp and Parch, as Fsize is a function of both these variables.

![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot25.jpeg)

I have noticed that there are negative correlations between Deck and Pclass.  Furthermore,
there is an inverse relationship between Fare and Pclass.  Obviously, this indicates that
passengers who paid higher fares were more likely to ride first class, which is what I
expected.

Out of all the variables, 'Sex' has the strongest correlation with 'Survived'.

-------------------------------------------------------------------------------------------------
## Missingness ##
-------------------------------------------------------------------------------------------------
I dealt with missing values for the variable 'Deck' but the variables, 'Age', 'Embarked' 
and 'Fare' also have some missing values.

-------------------------------------------------------------------------------------------------
### Embarked ###
Looking at PassengerIds 62 and 830, they were both First Class passengers and paid a fare
of 80 pounds.

![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot18.jpeg)

In constructing a boxplot that illustrates the median Fares for all passenger classes and 
all points of embarkation, the median Fare for a First Class passenger who boarded at
Cherbourg was 80 pounds.

Therefore, I assigned Cherbourg (C) to the missing Embarked values for both passengers 62
and 830.

------------------------------------------------------------------------------------------------
### Fare ###
Fare is missing for passengerId 1044.  From the dataset, this person was a Third Class 
passenger who boarded the Titanic at Southampton.  I assigned the missing Fare value for 
the median Fare of all Third Class passengers who boarded at Southampton, which was 8.05
pound Sterling.

**Median Fare - Third Class Passenger Southampton**

![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot19.jpeg)

------------------------------------------------------------------------------------------------
### Age ###
Missing ages were replaced using the Multivariate Imputation by Chained Equations (MICE)
method.  The age distribution for the MICE output was similar to that of the original ages
in the dataset.

![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot20.jpeg)

------------------------------------------------------------------------------------------------
## Modeling and Analysis ##
------------------------------------------------------------------------------------------------
Based on the key insights from our EDA process, I experimented with different models before
settling on the best option.  I went with a logistic regression model:

      *Survived~Pclass+Age+Fare+Title+FsizeC

I initially started with the following model and then performed backward selection to 
arrive at the most parsimonious model:

      *Survived~Pclass+Sex+Age+SibSp+Parch+Fare+Embarked+Title+FsizeC+Child+Mother
      
### Proceeded to use logistic regression model => Survived ~ Pclass + Age + Fare + Title + FsizeC
### This model produced an accuracy level of 79.9 percent (Refer to code in the following link:
### https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Log_Regression.R)

--------------------------------------------------------------------------------------------------


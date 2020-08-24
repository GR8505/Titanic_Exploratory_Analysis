# Titanic Exploratory Data Analysis (EDA)
-------------------------------------------------------------------------------------------------
## List of Variables ##
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
## Variable Analysis ##
-------------------------------------------------------------------------------------------------
### Pclass ###
High percentage of Third Class passengers perished, while First Class was the only category to
have a higher percentage of survivors compared to non-survivors.

------------------------------------------------------------------------------------------------
**Number of Survived by Pclass**

![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot03.jpeg)

------------------------------------------------------------------------------------------------

### Sex ###
It appears that males had a lower chance of survival compared to females.

------------------------------------------------------------------------------------------------
**Number of Survived by Gender**

![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot04.jpeg)

------------------------------------------------------------------------------------------------

### Age ###
The age distributions for both 'Survived' and 'Not Survived' are similar but it seems that
younger age groups (somewhere between 1-10) had a slightly higher chance of survival.

The average age for the 'Survived' group was slightly lower than the mean age for the 'Not 
Survived' group.  However, I must emphasize that it is a minor difference.

Admittedly,this variable has missing data but I moved to address this problem for the 
entire dataset at a later stage.

-----------------------------------------------------------------------------------------------
**Age Distribution: 'Survived' vs 'Not Survived'**

![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot05.jpeg)

-----------------------------------------------------------------------------------------------

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

----------------------------------------------------------------------------------------------
**SibSp and Parch Survival Analysis**

![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot07.jpeg)

The correlation between these two variables is < 0.5, sowe can infer that there is no 
significant relationship between SibSp and Parch.

----------------------------------------------------------------------------------------------

### Fare ###
No clear insight into whether Fare is related to survival but the average Fare for those who
survived is 119 percent higher (more than double) than the average Fare for non-survivors.

---------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot11.png)

---------------------------------------------------------------------------------------------
Surprisingly, there is no strong correlation between Fare and Pclass.  At -0.6, this is a 
significant negative correlation but not a strong one.

----------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot12.png)

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

### Embarked ###
Cherbourg was the only port that had a higher proportion of 'Survived' compared to 'Not 
Survived'.  Queenstown recorded a higher number of deaths compared to number of survived, while
passengers who boarded in Southampton registered the highest number of deaths.

----------------------------------------------------------------------------------------------
**Survived by Embarked**

![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot13.jpeg)

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
## New Variables ##
----------------------------------------------------------------------------------------------
New variables were created for further exploratory analysis.  This is the list of additional
variables:

- Title - (Master, Miss, Mr, Mrs and Special Title)
- Fsize - (Family size)
- FsizeC - (Refers to family size category; there are three categories, large, small and loner)
- Deck - (Deck Number)
- AgeC - (Age category)
- Child - (Whether passenger is a child or not)
- Mother - (Whether passenger is a mother or not)
----------------------------------------------------------------------------------------------

### Title ###
This new variable provides some meaningful insights.  We can infer that passengers with the 
title 'Mr.' had a very low chance of survival.

---------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot14.jpeg)

---------------------------------------------------------------------------------------------

On the contrary, persons with the titles 'Miss', 'Mrs.' and 'Master' probably stood a better
chance at surviving.

---------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot16.jpeg)

---------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
## Fsize and FsizeC ##
Fsize = SibSp + Parch + 1
For FsizeC, Loners are passengers with Fsize = 1, Small represents passengers with Fsize 
between 1 to 4 and Large are those with Fsize >= 5.

---------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot17.jpeg)

---------------------------------------------------------------------------------------------
Loners definitely had a lower probability of survival.  Passengers in small families had the 
best chance of survival out of all these family size categories.

---------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot23.jpeg)

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
## Deck ##
For this variable, unknown decks are labelled as 'U'. On closer analysis, I am not sure if
this variable would add value to our predictive model, as there is a large percentage of
passengers who are assigned to unknown decks.

---------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot.jpeg)

---------------------------------------------------------------------------------------------
## AgeC ##
Ages were broken down into the following categories:
1) Category 0: Age<=11
2) Category 1: 11<Age<=18
3) Category 2: 18<Age<=25
4) Category 3: 25<Age<=35
5) Category 4: 35<Age<=45
6) Category 5: 45<Age<=65
7) Category 6: Age>65
---------------------------------------------------------------------------------------------
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot22.jpeg)

This provides little insight. Although a high number of passengers perished in the age 
categories 2 and 3, a high number of them also survived.  No clear pattern or relationship
identified here.

---------------------------------------------------------------------------------------------
## Child and Mother ##
These new variables show that being a child does have a major impact on survival. 

![]()

--------------------------------------------------------------------------------------------
Passengers who were mothers had a slightly better chance of survival.

![]()

--------------------------------------------------------------------------------------------


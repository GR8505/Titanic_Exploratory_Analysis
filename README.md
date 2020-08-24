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

![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot11.png)

Surprisingly, there is no strong correlation between Fare and Pclass.  At -0.6, this is a 
significant negative correlation but not a strong one.

![]()

----------------------------------------------------------------------------------------------






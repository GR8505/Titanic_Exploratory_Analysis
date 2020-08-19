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

#### Number of Survived by Pclass ####
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot03.jpeg)


### Sex ###
It appears that males had a lower chance of survival compared to females.

#### Number of Survived by Gender ####
![](https://github.com/GR8505/Titanic_Exploratory_Analysis/blob/master/Images/Rplot04.jpeg)


### Age ###
The age distributions for both 'Survived' and 'Not Survived' are similar but it seems that
younger age groups (somewhere between 1-10) had a slightly higher chance of survival.

The average age for the 'Survived' group was slightly lower than the mean age for the 'Not 
Survived' group.  However, I must emphasize that it is a minor difference.

Admittedly,this variable has missing data but I moved to address this problem for the 
entire dataset at a later stage.

#### Age Distribution: 'Survived' vs 'Not Survived'
![]()


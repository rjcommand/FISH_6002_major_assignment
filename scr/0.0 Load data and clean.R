#### Tuna catch data
#### Rylan J Command
#### Created Spet 24 2019

## 0.0 Load in data
catch <- read.csv("data/cdis5016-all9sp.csv", header = TRUE)
View(catch)

## Variables list
# SpeciesCode: Three letter code corresponding to each species
# YearC: Calendar year
# Decade: Years collated into decades (1950, 1960... etc.)
# FlagName: ICCAT Flag name
# FleetCode: ICCAT Fleet code
# Stock: Species related stock or management unit
# GearGrp: Gear types used to capture tunas
# SchoolType: Type of fishing operation
# Trimester: Time strata (trimester 1, 2, 3, 4)
# QuadID: ICCAT Quadrants
# Lat5: Latitude of a 5x5 square
# Lon5: Longitude of a 5x5 square
# yLat5ctoid: Latitude (decimal degrees) centroid (Cartesian) of a 5x5 square
# xLon5ctoid: Longitude (decimal degrees) centroid (Cartesian) of a 5x5 square
# Catch_t: Nominal catches (tonnes)

## 0.1 Check to see if the data are clean

#### 0.1.1 Did the data load correctly? ####
head(catch)
str(catch)
## Looks good

#### 0.1.2 Are the data types correct? ####
sapply(catch, class)
## Looks good

#### 0.1.3 Check for impossible values ####
## Go through all of the numerical values to check if they are impossible
sapply(catch[, sapply(catch, is.numeric)], range)  # Ranges look good!

## Plot each numerical value to visually assess
plot(catch$Year)
plot(catch$Decade)
plot(catch$Trimester)
plot(catch$QuadID)
plot(catch$Lat5)
plot(catch$Lon5)
plot(catch$yLat5ctoid)
plot(catch$xLon5ctoid)
plot(catch$Catch_t)
## All look good!


#### 0.1.4 Are factor levels correct? ####
## Go through all factors and make sure levels are correct
sapply(catch[,sapply(catch, is.factor)], levels)  # All factor levels look good!

## I want to look specifically at swordfish, let's clean the dataset
## 0.1 Load in packages
library(ggplot2)
library(tidyr)
library(dplyr)
library(tidyselect)

#### 0.2 Create a wide-format dataset
# Ok, so there are six factors here, which makes "spreading" the easy way impossible!
# Here is the basic idea behind how to spread multiple factors from long to wide format:
#     1. gather() your data into long form, with each factor as a column and all of the numeric variables as a single column associated with another "value" column, with the value associated with each factor/numeric combination
#
#     2. unite() the levels of each factor within the same row into a single temporary column, where each combination of levels is also associated with a numeric variable (e.g. Species_Country_Fleet_Stock_Gear_School_var)
#
#     3. group_by(temp) and mutate(grouped_id = row_number()) to create a unique identifier for each row (this will solve any problem with spreading the same key values)
#
#     4. spread() the rows into columns, leaving the dataframe in wideformat!
#
# Here is a simple example of how this works:
# df <- data.frame(month=rep(1:3,2),  # A numerical value, not affected by the spread
#                 student=rep(c("Amy", "Bob"), each=3),  # A factor, each of the levels here will become columns
#                 A=c(9, 7, 6, 8, 6, 9),  # 
#                 B=c(6, 7, 8, 5, 6, 7))
# df %>% 
#   gather(variable, value, -(month:student)) %>% 
#   unite(temp, student, variable) %>% 
#   spread(temp, value)

# Now let's apply this to the ICCAT dataset:
catch.wide <- catch %>% 
                select(SpeciesCode, FlagName, FleetCode, Stock, GearGrp, SchoolType, 
                       Catch_t, YearC, Decade, Trimester, QuadID, Lat5, Lon5, yLat5ctoid, xLon5ctoid) %>%  # Re-order columns for ease of access
                gather(variable, value, -(SpeciesCode:SchoolType)) %>%  # Gather all factors by Catch
                unite(temp, SpeciesCode:SchoolType, variable) %>%  # Unite real combinations of levels in each of the 6 factors into rows, which are associated with a numerical variable (here, catch) (e.g. Species_Country_Fleet_Stock_Gear_School_var)
                group_by(temp) %>%  # There are some repeated labels
                mutate(grouped_id = row_number()) %>%  # Give each row a unique identifier so each combination of factor levels can become its own column
                spread(temp, value) %>%  # Spread the rows into columns, leaving the dataframe (tibble) in wide format!
                select(-grouped_id)  # Remove the unique identifier (don't need this anymore)
View(catch.wide)
# Success!

## 0.3 Clean data to work with swordfish in north atlantic
clean <- catch %>% 
  
  filter(SpeciesCode == "SWO",
         Stock == "ATN" | Stock == "ATS")

## 0.4 Visualize catch (t) over time
ggplot(clean, aes(x = YearC, y = Catch_t, colour = Stock)) +
  geom_point()

## 0.5 Clean data to get mean catch per year
clean_mean <- clean %>% 
  
  group_by(YearC, Stock) %>% 
  summarise(mean_Catch = mean(Catch_t),
            sd_Catch = sd(Catch_t))

## 0.6 Visualize mean catch (t) per year over time
ggplot(clean_mean, aes(x = YearC, y = mean_Catch, colour = Stock)) +
  geom_point() +
  geom_line()

## 0.7 Clean for gear type
clean_gear <- clean %>% 
  
  group_by(YearC,
           GearGrp) %>% 
  summarise(mean_Catch = mean(Catch_t))

## 0.8 Visualize catch (t) over time by gear type
ggplot(clean_gear, aes(x = YearC, y = mean_Catch, fill = GearGrp, colour = GearGrp)) +
  geom_point() +
  geom_line() +
  facet_wrap(~ GearGrp)


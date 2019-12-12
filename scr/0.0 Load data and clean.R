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

## Load in packages
library(ggplot2)
library(tidyr)
library(dplyr)
library(tidyselect)


#### 0.1 Check to see if the data are clean ####

#### 0.1.1 Did the data load correctly? ####
head(catch)
tail(catch)
str(catch)
## Looks good


#### 0.1.2 Are the data types correct? ####
sapply(catch, class)
## Looks good


#### 0.1.3 Check for impossible values ####
## Go through all of the numerical values to check if they are impossible
sapply(catch[, sapply(catch, is.numeric)], range)  # Ranges look good!
# I am going to rename "Catch_t" as "Catch", because we know it's in tons, and having an underscore in the name might be problamatic later
catch <- catch %>% 
  rename(Catch = Catch_t)


## Plot each numerical value to visually assess
## These take a while to load so I commented them out - less painful if you run the whole thing at once
# plot(catch$Year)
# plot(catch$Decade)
# plot(catch$Trimester)
# plot(catch$QuadID)
# plot(catch$Lat5)
# plot(catch$Lon5)
# plot(catch$yLat5ctoid)
# plot(catch$xLon5ctoid)
# plot(catch$Catch)
## All look good!


#### 0.1.4 Are factor levels correct? ####
## Go through all factors and make sure levels are correct
sapply(catch[,sapply(catch, is.factor)], levels)  
# 1. In in the FlagName factor, there are some special characters - et's recode these so they print properly.
# 2. In the GearGrp factor, let's rename "oth" to "OTHER" so it looks a bit nicer.
# 3. In the SchoolType factor, there is a defined "n/a" value. This caught my attention, and may cause problems if variable names have "/" in it, so let's re-define it to "None"

# Let's fix it up
catch <- catch %>% 
  mutate(FlagName = recode(FlagName,  # First address the special characters in FlagName
                           "C\xf4te d'Ivoire" = "Côte d'Ivoire",
                           "Cura\xe7ao" = "Curaçao",
                           "EU.Espa\xf1a" = "EU.España",
                           "Guin\xe9e Rep." = "Guinée Rep.",
                           "S. Tom\xe9 e Pr\xedncipe" = "São Tomé and Príncipe",
                           ),
         GearGrp = recode(GearGrp,  # Then rename the "oth" level in GearGrp
                          "oth" = "OT"),
         SchoolType = recode(SchoolType,
                             "n/a" = "None")
         )

# Check it out:
sapply(catch[, sapply(catch, is.factor)], levels)  
# Much better!
# Everything else looks good, so let's move on


#### 0.2 Subset North Atlantic swordfish ####
## I want to look specifically at North Atlantic swordfish, let's clean the dataset
catch_swo <- catch %>% 
  filter(SpeciesCode == "SWO",  # Select only those rows that contain swordfish observations
         Stock == "ATN") %>%   # Select only those rows that concern the North Atlantic stock
  select(-SpeciesCode, 
         -Stock) # %>%  # Remove SpeciesCode and Stock as a factor, since we're only looking at North Atlantic swordfish now
 # group_by(YearC, FlagName, FleetCode, GearGrp)  # Re-order the rows

## Check it out
View(catch_swo)


#### 0.3 Create a wide-format dataset ####
## I want to spread by FlagName, FleetCode, GearGrp, and SchoolType to look at how much swordfish was caught by each fleet/country using each gear type on what school type
w <- catch_swo %>% 
  unite(temp, FlagName, FleetCode, GearGrp, SchoolType) %>%  # Unite the FlagName, FleetCode, GearGrp, and SchoolType columns into one column "temp", separated by "_"
  mutate(grouped_id = row_number()) %>%  # Add a column to give each row a unique identifyer; need to do this because multiple rows have the same "keys" (e.g. there are several Canadian Longline catches, just at different locations)
  spread(temp, Catch) %>%  # Spread the united column "temp" by the values of "Catch" to get a column of catch in tons for each Country_Fleet_Gear_School combination
  select(-grouped_id)  # Remove the unique identifyer column

## Check it out
View(w)

## Save the .csv file to the data/ directory
write.csv(w, "./outputs/catch_swo_wideformat.csv")


#### 0.4 Create a long-format dataset ####
## Basically, get it back to how it was
l <- w %>% 
  mutate(grouped_id = row_number()) %>%  # Add a unique identifyer for each row
  gather(temp, Catch, Barbados_BRB_LL_None:Venezuela_VEN.ARTISANAL_GN_None) %>%  # Gather all of the Country_Fleet_Gear_School into one column, "temp", and their catches into another "Catch" column
  group_by(temp) %>% 
  separate(col = temp, into = c("FlagName", "FleetCode", "GearGrp", "SchoolType"), sep = "_", extra = "drop", fill = "right") %>%  # Separate the single "temp" column into 4 columns, one for each factor, indicating they were separated by underscores
  filter(!is.na(Catch)) %>%  # Remove all rows that produce NA for "Catch" (e.g. Barbados with CAN fleet code doesn't exist), as there weren't any in the original dataset
  select(YearC, Decade, FlagName, FleetCode, GearGrp, SchoolType, Trimester, QuadID, Lat5, Lon5, yLat5ctoid, xLon5ctoid, Catch) %>%  # Re-order the columns
  mutate_if(is.character, as.factor)  # Convert the factors back into factors

## Check it out
View(l)

## Save the .csv file to the data/directory
write.csv(l, "./outputs/catch_swo_longformat.csv")

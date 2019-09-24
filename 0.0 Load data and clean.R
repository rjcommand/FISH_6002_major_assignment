#### Tuna catch data
#### Rylan J Command
#### Created Spet 24 2019

## 0.0 Load in data
catch <- read.csv("data/cdis5016-all9sp.csv", header = TRUE)
head(catch)
str(catch)

## 0.1 Load in packages
library(ggplot2)
library(tidyr)
library(dplyr)

## 0.2 Clean data to work with swordfish in north atlantic
clean <- catch %>% 
  
  filter(SpeciesCode == "SWO",
         Stock == "ATN")

## 0.3 Visualize catch (t) over time
ggplot(clean, aes(x = YearC, y = Catch_t)) +
  geom_point()

## 0.4 Clean data to get mean catch per year
clean_mean <- clean %>% 
  
  group_by(YearC) %>% 
  summarise(mean_Catch = mean(Catch_t),
            sd_Catch = sd(Catch_t))

## 0.5 Visualize mean catch (t) per year over time
ggplot(clean_mean, aes(x = YearC, y = mean_Catch)) +
  geom_point()

## 0.6 Clean for gear type
clean_gear <- clean %>% 
  
  group_by(YearC,
           GearGrp) %>% 
  summarise(mean_Catch = mean(Catch_t))

## 0.7 Visualize catch (t) over time by gear type
ggplot(clean_gear, aes(x = YearC, y = mean_Catch, fill = GearGrp, colour = GearGrp)) +
  geom_point() +
  geom_line() +
  facet_wrap(~ GearGrp)


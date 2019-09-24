#### Script for FISH 6002 major assignment
#### Rylan J. Command
#### Started on Sept 11, 2019

## 0.1 Load in data and view
rf_data <- read.csv("Redfish_data.csv", header = TRUE)
View(rf_data)
str(rf_data)

rf_data$Year <- as.factor(rf_data$Year)

## 0.2 Load in packages
library(ggplot2)
library(tidyr)

## 0.3 Visualize Total redfish catch from 1953 - 2015
ggplot(rf_data, aes(x = Year, y = Total, group = 1)) +
  geom_point() + 
  geom_line() +
  scale_x_discrete(name = "Year", breaks = seq(1953, 2015, 5)) +
  scale_y_continuous(name = "Total redfish catch (t)", breaks = seq(0, 150000, 20000)) +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## 0.4 Convert dataframe to long-form
rf_data_long <- gather(rf_data, Division, Catch, X4R:Total, factor_key = TRUE)

## 0.5 Visualize redfish catch from 1953 - 2015 in all divisions
ggplot(rf_data_long, aes(x = Year, y = Catch, group = Division, colour = Division)) +
  geom_point() +
  geom_line() +
  facet_wrap(~Division) +
  scale_x_discrete(name = "Year", breaks = seq(1953, 2015, 5)) +
  scale_y_continuous(name = "Redfish catch (t)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
?geom_bar

## 0.6 Visualize redfish catch from 1953 - 2015 in all divisions minus "Total"
# Filter out "Total catch"
rf_data_long_noT <- rf_data_long %>% 
  
  filter(Division != "Total")

# Visualize
ggplot(rf_data_long_noT, aes(x = Year, y = Catch, fill = Division, colour = Division)) +
  geom_bar(stat = "identity", width = 0.4) +
  scale_x_discrete(breaks = seq(1953, 2015, 5)) +
  scale_y_continuous(name = "Redfish catch (t)", breaks = seq(0, 160000, 20000), expand = c(0, 0)) +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90))

# Plot only data from 1995 - 2015
rf_data_95 <- rf_data_long_noT %>% 
  
  filter(Year == 1995:2015)

# Get "Total catch" data from 1995 - 2015
rf_data_95_tot <- rf_data_long %>% 
  
  filter(Division == "Total",
         Year == 1995:2015)

ggplot(rf_data_95, mapping = aes(x = Year, y = Catch, fill = Division, colour = Division)) +
  geom_bar(stat = "identity", width = 0.4) +
  geom_point(rf_data_95_tot, mapping = aes(x = Year, y = Catch)) +
  scale_y_continuous(name = "Redfish catch (t)", expand = c(0, 0)) +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90))
  
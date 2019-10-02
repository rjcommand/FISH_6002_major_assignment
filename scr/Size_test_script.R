size <- read.csv("data/casSWO7505.csv", sep = ",", header = TRUE)
head(size)

library(tidyr)
library(dplyr)
library(ggplot2)



size_long <- gather(size, Catch_size, Ammount_caught, X.49:X301.) %>% 
  
  filter(StockID == "AN" &
           FlagName == "Canada" | FlagName == "U.S.A." | FlagName == "EC.Espa<96>a")

ggplot(size_long, aes(x = Catch_size, y = Ammount_caught)) +
  geom_point() +
  facet_grid(~FlagName)

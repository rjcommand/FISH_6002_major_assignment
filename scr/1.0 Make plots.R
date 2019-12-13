#### Script for creating figures 1-3 for the FISH 6002 Major Assignment Part 3
#### "0.0 Load data and clean.R" must be run prior to this script
#### Rylan J. Command
#### Updated: Dec 12 2019


#### Figure 1. Total swordfish catch per year by gear group ####
## The 4 less common gears are difficult to distinguish on a full plot, so let's make a multiplot!

## Get the total catch per year by the top two gear types (longline and harpoon)
catch_maj <- catch_swo %>% 
  filter(GearGrp == "LL" | GearGrp == "HP") %>%  # Select only longline and harpoon gears
  group_by(YearC, GearGrp) %>% 
  summarise(total_catch = sum(Catch))  # Get total catch per year in each gear type

catch_maj$GearGrp <- factor(catch_maj$GearGrp, levels = c("LL", "HP"))  # Reorder gear types to be in descending order

## Create the plot for the two major gear types (longline and harpoon)
p1 <- ggplot(catch_maj, aes(x = YearC, y = total_catch, colour = GearGrp)) +
        geom_point() +
        geom_line() +
        scale_x_continuous(name = "Time", breaks = c(seq(1950, 2016, 5))) +
        scale_y_continuous(name = "Catch (t)") +
        scale_colour_brewer(name = "Gear type", palette = "Set1") +
        theme_bw() +
        #labs(tag = "A") +
        theme(axis.title.y = element_text(size = 14),
              axis.title.x = element_blank(),
              axis.text = element_text(size = 10),
              legend.title = element_blank())

## Get the total catch per year by the other gear types
catch_min <- catch_swo %>% 
  filter(GearGrp != "LL",  # Filter out the top two gear types
         GearGrp != "HP") %>% 
  group_by(YearC, GearGrp) %>% 
  summarise(total_catch = sum(Catch))  # Get total catch per year in each gear type

catch_min$GearGrp <- factor(catch_min$GearGrp, levels = c("GN", "BB", "PS", "OT"))  # Reorder gear types in descending order

## Create the plot for the less common gear types
p2 <- ggplot(catch_min, aes(x = YearC, y = total_catch, colour = GearGrp)) +
        geom_point() +
        geom_line() +
        scale_x_continuous(name = "Time", breaks = c(seq(1950, 2016, 5))) +
        scale_y_continuous(name = "Catch (t)") +
        scale_colour_brewer(name = "Gear type", palette = "Dark2", direction = -1) +
        theme_bw() +
        #labs(tag = "B") +
        theme(axis.title = element_text(size = 14),
              axis.text = element_text(size = 10),
              legend.title = element_blank())

## Create a multi-panel plot 
## Load the gridExtra library
library(gridExtra)

## Create lables for multiplot
p1 <- arrangeGrob(p1,
                  top = textGrob("A", 
                                  x = unit(0.05, "npc"), 
                                  y = unit(0.5, "npc"), 
                                  just=c("left","top"), 
                                  gp = gpar(col="black", 
                                            fontsize=18, 
                                            fontfamily="Times Roman")))

p2 <- arrangeGrob(p2, 
                  top = textGrob("B", 
                                 x = unit(0.05, "npc"), 
                                 y = unit(0.5, "npc"), 
                                 just=c("left","top"), 
                                 gp = gpar(col="black", 
                                           fontsize=18, 
                                           fontfamily="Times Roman")))

## Put all of the plots and labels together
pl <- grid.arrange(p1, p2, ncol = 1, nrow = 2)

## Save the plot
ggsave("./figs/COMMAND_Figure1.tiff", # save in the /plots subfolder
       pl,
       dpi=300, #300 DPI
       width = 20, height = 12, #SELECT WIDTH AND HEIGHT
       device = "tiff", #export as tiff
       compression = "lzw",
       units = "cm")



#### Figure 2. Total catch of North Atlantic swordfish over time by the Top5 fishers + others ####
## Get Top5 fishers of North Atlantic swordfish
catch_top5 <- catch_swo %>% 
  mutate(FlagName = recode(FlagName,  # Rename country codes to appear nicer in fig.
                           "EU.España" = "Spain",
                           "EU.Portugal" = "Portugal")) %>% 
  filter(FlagName == "Canada" |  # Select only these countries, since they catch the most swordfish
           FlagName == "U.S.A." | 
           FlagName == "Spain" |
           FlagName == "Japan" |
           FlagName == "Portugal") %>% 
  group_by(FlagName, YearC) %>% 
  summarise(total_catch = sum(Catch))  # Get total catch by each country each year


## Get "other" fishers of North Atlantic swordfish
catch_other <- catch_swo %>% 
  group_by(FlagName, YearC) %>% 
  summarise(total_Catch = sum(Catch)) %>%  # Get the total catch by year for each country
  arrange(desc(total_Catch)) %>%  # Rearrange to see which countries are the Top5 fishers
  filter(FlagName != "Canada",  # Remove the Top5 to get everyone else
         FlagName != "U.S.A.", 
         FlagName != "EU.España", 
         FlagName != "Japan", 
         FlagName != "EU.Portugal") %>% 
  ungroup() %>% 
  select(-FlagName) %>%  # Remove the FlagName column
  group_by(YearC) %>% 
  mutate(total_catch = sum(total_Catch),  # Get the total catch for each year
         FlagName = "Other") %>%  # Create a new column with FlagName "Other"
  select(-total_Catch) %>%  # Remove a redundant column
  select(FlagName, YearC, total_catch)  # Reorder the columns


## Combine the Top5 and Others
catch_all <- rbind(catch_top5, catch_other)


## Plot for top 5 fishers + others of North Atlantic swordfish
ggplot(catch_all, aes(x = YearC, y = total_catch, colour = FlagName)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  scale_colour_brewer(type = "qual", palette = "Set2", limits = c("Spain", "U.S.A.", "Canada", "Japan", "Portugal", "Other")) +
  scale_x_continuous(name = "Time", breaks = c(seq(1950, 2016, 5))) +
  scale_y_continuous(name = "Catch (t)") +
  theme(axis.title = element_text(size = 16),
        axis.text = element_text(size = 10),
        legend.title = element_blank()) +
  labs(colour = "Country code")

ggsave("./figs/COMMAND_Figure2.tiff", # save in the /plots subfolder
       dpi=300, #300 DPI
       width = 20, height = 12, #SELECT WIDTH AND HEIGHT
       device = "tiff", #export as tiff
       compression = "lzw",
       units = "cm")

#### Figure 3. Total catch of Tunas in the North Atlantic stock ####
ggplot(catch, aes(x = YearC, y = Catch, fill = SpeciesCode)) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(type = "qual", palette = "Set3") +
  scale_x_continuous(name = "Time", breaks = c(seq(1950, 2016, 5)), expand = c(0.01, 0.01)) +
  scale_y_continuous(name = "Catch (t)", breaks = c(seq(0,700000, 50000)), expand = expand_scale(mult = c(0, 0.05))) +
  theme_bw() +
  theme(axis.title = element_text(size = 16),
        axis.text = element_text(size = 10),
        legend.title = element_blank())

ggsave("./figs/COMMAND_Figure3.tiff", # save in the /figs subfolder
       dpi=300, #300 DPI
       width = 20, height = 12, #SELECT WIDTH AND HEIGHT
       device = "tiff", #export as tiff
       compression = "lzw",
       units = "cm")




#### Junk code ####

#### Figure 1. Total swordfish catch per year by gear group ###
catch_year <- catch_swo %>% 
  group_by(YearC, GearGrp) %>% 
  summarise(total_Catch = sum(Catch))

catch_year$GearGrp <- factor(catch_year$GearGrp, levels = c("LL", "HP", "GN", "BB", "PS", "OTHER"))

ggplot(catch_year, aes(x = YearC, y = total_Catch, colour = GearGrp)) +
  geom_point() +
  geom_line() +
  scale_x_continuous(name = "Time", breaks = c(seq(1950, 2016, 5))) +
  scale_y_continuous(name = "Catch (t)") +
  scale_colour_brewer(name = "Gear type", palette = "Dark2") +
  theme_bw() +
  theme(axis.title = element_text(size = 14),
        axis.text = element_text(size = 10),
        legend.title = element_blank())

ggsave("./figs/COMMAND_Figure1.tiff", # save in the /plots subfolder
       dpi=300, #300 DPI
       width = 20, height = 12, #SELECT WIDTH AND HEIGHT
       device = "tiff", #export as tiff
       compression = "lzw",
       units = "cm")

## 1.0 Visualize catch (t) over time
ggplot(catch_swo, aes(x = YearC, y = Catch, colour = GearGrp)) +
  geom_point() +
  geom_line()


## 1.1 Clean data to get mean catch per year
clean_mean <- catch_swo %>% 
  
  group_by(YearC, GearGrp) %>% 
  summarise(mean_Catch = mean(Catch),
            sd_Catch = sd(Catch))
catch_year_sm <- catch_year %>% 
  filter(GearGrp != "LL" & GearGrp != "HP")
  
ggplot(catch_year_sm, aes(x = YearC, y = total_Catch, colour = GearGrp)) +
  geom_point() +
  geom_line() +
  scale_x_continuous(name = "Time", breaks = c(seq(1950, 2016, 5))) +
  scale_y_continuous(name = "Catch (t)") +
  scale_colour_manual(name = "Gear type", values = c("green", "purple", "pink", "grey")) +
  theme_bw() +
  theme(axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.title = element_blank())

## 1.2 Visualize mean catch (t) per year over time
ggplot(clean_mean, aes(x = YearC, y = mean_Catch, colour = GearGrp)) +
  geom_point() +
  geom_line()

## 1.3 Clean for gear type
clean_gear <- clean %>% 
  
  group_by(YearC,
           GearGrp) %>% 
  summarise(mean_Catch = mean(Catch_t))

## 1.4 Visualize catch (t) over time by gear type
ggplot(clean_gear, aes(x = YearC, y = mean_Catch, fill = GearGrp, colour = GearGrp)) +
  geom_point() +
  geom_line() +
  facet_wrap(~ GearGrp)




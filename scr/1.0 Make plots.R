## 1.0 Visualize catch (t) over time
ggplot(clean, aes(x = YearC, y = Catch_t, colour = Stock)) +
  geom_point()

## 1.1 Clean data to get mean catch per year
clean_mean <- clean %>% 
  
  group_by(YearC, Stock) %>% 
  summarise(mean_Catch = mean(Catch_t),
            sd_Catch = sd(Catch_t))

## 1.2 Visualize mean catch (t) per year over time
ggplot(clean_mean, aes(x = YearC, y = mean_Catch, colour = Stock)) +
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


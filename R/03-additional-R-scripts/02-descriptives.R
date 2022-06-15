
# 00) NOtes ---------------------------------------------------------------
# This script produces descriptive statistic for key variables
#     Age
#     Gender

# Total sample size of raw data
SampleSize <- length(unique(GamingStudyData$ID))


# 01) Age -----------------------------------------------------------------

Age_summary <- GamingStudyData %>% 
               summarise(N = nrow(.),
                         Mean = mean(Age),
                         SD = sd(Age),
                         Min = min(Age),
                         Max = max(Age))


# 02) Gender --------------------------------------------------------------



Gender_summary <- GamingStudyData %>% 
                  group_by(Gender) %>% 
                  summarise(N = n(),
                            Percentage = (n()/SampleSize)*100) %>% 
                  ungroup()



# 03) Age x Gender --------------------------------------------------------

Age_Gender <- GamingStudyData %>% 
  group_by(Gender) %>% 
  summarise(N = n(),
            Mean = mean(Age),
            SD = sd(Age),
            Min = min(Age),
            Max = max(Age)) %>% 
  ungroup()

write_csv(Age_Gender, "output/Age_Gender.csv")



# 04) Most popular game ---------------------------------------------------
# League of Legends is the most popular game
Game_popularity <- GamingStudyData %>% 
                   group_by(Game) %>% 
                   summarise(N = n(),
                             Percentage = (n()/SampleSize)*100) %>% 
                   ungroup() %>% 
                   arrange(desc(N))


# 05) Game X Gender plot --------------------------------------------------

# (1) Extract list of games ordered by N of players
Games <- GamingStudyData %>% 
         group_by(Game) %>% 
         summarise(N = n(),
                   Percentage = (n()/SampleSize)*100) %>% 
         ungroup() %>%  
         arrange(Percentage) %>%  
         select(Game) %>% 
         pull()



# (2) Create bar plot of gender and game preference
#     X axis is percentage
#     y axis is Gender
#     Bars are grouped by Gender
#     Plot is faceted by Game (which is ordered by Game preference as a whole)
#     Convert character variables to ordered factors (to have a constant in the visual)


Game_by_Gender_bar_plot <- GamingStudyData %>% 
  
                           # summary
                           group_by(Gender, Game) %>% 
                           summarise(N1 = n()) %>% 
                           ungroup() %>% 
                           
                           # join summary data with gender counts: create Percentage of Gender playing Y game
                           left_join(x = ., 
                                     y = Age_Gender %>% 
                                       select(Gender, N),
                                     by = "Gender") %>% 
  
                           mutate(Percentage = (N1/N)*100) %>% 
                           
                           # factor variables
                           mutate(Gender = factor(Gender, levels = c("Other", "Female", "Male"), ordered = TRUE)) %>% 
                           mutate(Game   = factor(Game, level = rev(Games), ordered = TRUE)) %>% 
                           
                           # ggplot code
                           ggplot(aes(y = Gender, x = Percentage))+
                           geom_col(aes(group = Gender, fill = Gender), 
                                    position = "dodge") +
                           geom_text(aes(label = paste0(N1, "/ ", N), group = Gender), 
                                     hjust = -.5,
                                     size = 2)+
                           
                           # create facets in the plot based on Game
                           facet_wrap(~Game, ncol = 1, strip.position = "left")+
  
                           # scales
                           scale_fill_manual(values = c( "orange", "steelblue",  "#475559"), name = "Gender")+
                           scale_x_continuous(limits = c(0, 100))+
  
                           # Thematic settings
                           theme_minimal()+
                           theme(axis.text.y        = element_blank(),
                                 strip.text.y.left  = element_text(angle = 0),
                                 panel.grid.major.y = element_blank(),
                                 legend.position    = "bottom")


# 06) Country of residence ------------------------------------------------

# Table is very long
Nationality_summary <- GamingStudyData %>% 
                       group_by(Residence) %>% 
                       summarise(N = n(),
                                 Percentage = (n()/SampleSize)*100) %>% 
                       ungroup() %>% 
                       arrange(desc(N))

Nationality_Top_10 <- Nationality_summary %>%  top_n(n = 10)


# Bar plot is also messy
# US eclipses other nationalities
Nationality_summary %>% 
       mutate(Residence = factor(Residence, levels = rev(Nationality_summary$Residence), ordered = TRUE)) %>% 
       ggplot(aes(x = Percentage, y = Residence))+
       geom_col(colour = 'white')+
       ylab("")+
       theme_classic()+
       theme(axis.text.y = element_text(size = 4))

Nationality_summary2 <- Nationality_summary %>% 
                        mutate(Colour_group = case_when(Percentage > 30                      ~ "> 30%",
                                                        Percentage < 30  & Percentage >= 10  ~ "< 30% > 10%",
                                                        Percentage < 10  & Percentage >= 5   ~ "<10% >5%",
                                                        Percentage <   5 & Percentage >= 2.5 ~ "<5% >2.5%",
                                                        Percentage < 2.5 & Percentage >= 1   ~ "<2.5% >1%",
                                                        Percentage < 1                       ~ "<1%")) %>% 
                        mutate(Colour_group = factor(Colour_group,
                                                     levels = c("> 30%", "< 30% > 10%", "<10% >5%",
                                                                "<5% >2.5%", "<2.5% >1%", "<1%"),
                                                     ordered = TRUE))




# 07) Nationality Map -----------------------------------------------------
# as the bar plot and tables aer both too long, create a map!

world <- map_data("world")

world2 <- left_join(world, 
                    Nationality_summary2 %>% rename(region = Residence), 
                    by = "region") %>% 
          filter(region %in% Nationality_summary2$Residence)



Nationality_Map <- ggplot() +
                   theme_void()+  # load theme here
       
                   # Base map
                   geom_map(data = world, map = world,
                            aes(long, lat, map_id = region, fill = "No Data"),
                            colour = 'white') +
   
                   # theme and scale  base map layer
                   scale_fill_manual(values = c("No Data" = "grey90"),name = "")+
                   theme(legend.key.width = unit(.5, "cm"))+
                   
                   # coloured layer of map
                   new_scale_fill()+
                   geom_map(data = world2, map = world,
                            aes(long, lat, map_id = region, fill = Percentage),
                            colour = NA) +
  
                   # Scale coloured map
                   scale_fill_viridis(option = "G", name = "", direction = -1,
                                      breaks = c(-1,0, 10, 20, 30),
                                      labels = c("-1%", "0%", "10%", "20%", "30%"))+

                   # Thematic settings coloured map
                   theme(legend.position = "bottom",
                         legend.key.width = unit(2.5, "cm"))

# save as RDS data
saveRDS(Nationality_Map, 'output/Nationality_Map.RDS')


# save to png file
ggsave(filename = 'output/Nationality_Map.png',   # output file
       plot     = Nationality_Map,                # object to save
       dpi      = 300,                            # resolution
       width    = 7.78,
       height   = 5.92,
       units    = "in")



# 08) Estimated Number of hours spent gaming every week -------------------
# This section will give us parameters for cleaning data

# (1) Find number of NA values
hours_number_of_missing_values <- GamingStudyData %>% 
                                  mutate(H_missing = ifelse(is.na(Hours), 1, 0)) %>% 
                                  filter(H_missing == 1) %>% 
                                  nrow(.)

Game_Hours_summary <- GamingStudyData %>% 
                      filter(!is.na(Hours)) %>% 
                      summarise(N    = nrow(.),
                                Mean = mean(Hours),
                                SD   = sd(Hours),
                                SE   = sd(Hours)/sqrt(nrow(.)),
                                Min  = min(Hours),
                                Max  = max(Hours))

# 8000 is not a a possible number
# There are 168 hrs in a week (although 168 hrs is not possible, accounting for sleep)

# N = 14
Game_hours_zero_or_impossible <- GamingStudyData %>% 
                                 filter(Hours == 0 | Hours > 168) %>% 
                                 nrow(.)




# 09) Satisfaction With Life Scale ----------------------------------------
# SWL is bound between 1-7
# No incorrect responses to items
GamingStudyData %>% 
       select(ID, starts_with("SWL"), -SWL_T) %>% 
       pivot_longer(cols = paste0("SWL", 1:5), values_to = "Response", names_to = "Item") %>% 
       mutate(BadResp = ifelse(Response < 1 | Response  > 7, "Bad", "Good")) %>% 
       filter(BadResp == "Bad")

# SWL Cronbach Alpha ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SWL_alpha <- alpha(GamingStudyData[, paste0("SWL", 1:5)]) # from psych package

SWL_alpha$total # results of coefficient alpha




# 10) Generalised Anxiety Disorder Scale ----------------------------------

GamingStudyData %>% 
  select(ID, starts_with("GAD"), -GAD_T) %>% 
  pivot_longer(cols = paste0("GAD", 1:5), values_to = "Response", names_to = "Item") %>% 
  mutate(BadResp = ifelse(!Response %in% 0:4, "Bad", "Good")) %>% 
  filter(BadResp == "Bad")
  
# Notes remove participants with extreme Hours values and missing Hours values

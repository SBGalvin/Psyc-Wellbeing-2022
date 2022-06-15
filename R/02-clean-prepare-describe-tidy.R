# 01-clean-prepare-describe-tidy.R

# 00) Notes  --------------------------------------------------------------
# This script reads in data and prepares it for analysis
# In tidyverse! (dplyr, ggplot2 packages)


# 01) options and settings ------------------------------------------------
library(tidyverse)
options(scipen = 999)
set.seed(42)


# 02) Read in data --------------------------------------------------------
GamingStudyData <- read_csv('data/GamingStudy_data.csv')


# 03) Remove Missing values  ----------------------------------------------

# (1) remove missing values for Hours
# (2) remove hours greater than 168 or less than 0
# (3) remove missing values for SPIN
# (4) keep only league of legends players
# (5) keep non-professional players

GamingStudyData_clean <- GamingStudyData_clean %>% 
                         filter(!is.na(Hours)) %>% 
                         filter(Hours > 0 & Hours < 168) %>% 
                         filter(!is.na(SPIN_T)) %>% 
                         filter(Game == "League of Legends") %>% 
                         filter(earnings == "I play for fun")




# 04) Store Data set ------------------------------------------------------
write_csv(GamingStudyData_clean, 'data/GamingStudyData_clean-base-R.csv')


# 05) Histogram and summary of Hours  -------------------------------------


Hours_histogram <- GamingStudyData_clean %>% 
  
                   # Map aesthetics
                   ggplot(mapping = aes(x = Hours))+
                   
                   # Use histogram geometry
                   geom_histogram(fill = "#0277BD", 
                                  colour = 'white',
                                  breaks = seq(0, 120, by = 5))+
                   
                   # Plot/axis labels
                   xlab("Hours")+
                   ylab("Frequency")+
                   ggtitle("Histogram of Hours Played (Weekly)")+
                   
                   # scale definitions
                   scale_x_continuous(breaks = seq(0, 120, by = 20))+
                   
                   # Thematic settings
                   theme_minimal()


# summary
GamingStudyData_clean %>% 
  summarise(N    = nrow(.),
            Mean = mean(Hours),
            SD   = sd(Hours),
            SE   = sd(Hours)/sqrt(nrow(.)),
            Min  = min(Hours),
            Max  = max(Hours))



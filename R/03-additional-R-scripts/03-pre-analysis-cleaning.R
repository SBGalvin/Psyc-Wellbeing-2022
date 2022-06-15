
# 00) Notes ---------------------------------------------------------------
# based on script 02, several variables are filtered
# (1) missing values for the number of hours
# (2) Extreme values for number of hours (0 or greater than 168)
# (3) Filtered for league of legends players only
# (4) Filtered for USA residents only

# Also grouped qualitative data

GamingStudyData_clean <- GamingStudyData %>% 
                         filter(!is.na(Hours)) %>% 
                         filter(Hours > 0 & Hours < 168) %>% 
                         filter(Game == "League of Legends" ) %>% 
                         filter(!is.na(SPIN_T)) %>% 
                         filter(earnings == "I play for fun" ) %>%
                         
                         # SPIN SCORE CATEGORIES
                         mutate(SPIN_Anx = case_when(SPIN_T < 21                ~ "None",
                                                     SPIN_T >= 21 & SPIN_T < 31 ~ "Mild",
                                                     SPIN_T >= 31 & SPIN_T < 41 ~ "Moderate",
                                                     SPIN_T >= 41 & SPIN_T < 51 ~ "Severe",
                                                     SPIN_T >= 51               ~ "Very Severe")) %>% 
                         mutate(SPIN_Anx = factor(SPIN_Anx, levels = c("None", "Mild", "Moderate", "Severe", "Very Severe"), 
                                                  ordered = TRUE)) %>% 
                         
                         # GAD 7 SCORE CATEGORIES
                         mutate(GAD_Anx = case_when(GAD_T < 5                ~ "None",
                                                    GAD_T >= 5  & GAD_T < 10 ~ "Mild",
                                                    GAD_T >= 10 & GAD_T < 15 ~ "Moderate",
                                                    GAD_T >= 15              ~ "Severe")) %>% 
                         mutate(GAD_Anx = factor(GAD_Anx, levels = c("None", "Mild", "Moderate", "Severe"), ordered = TRUE))


write_csv(GamingStudyData_clean, 'data/GamingStudyData_clean.csv')

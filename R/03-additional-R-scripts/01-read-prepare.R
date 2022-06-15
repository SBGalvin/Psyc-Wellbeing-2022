
# 00) Notes ---------------------------------------------------------------
# This script reads in the data file and makes any alterations as necessary
# Makes liberal use of the dplyr pipe ( %>% ) and functions


# 01) Read in data --------------------------------------------------------
GamingStudyData <- read_csv('data/GamingStudy_data.csv') %>% 
                   # create an id code for each participant
                   mutate(X1 = paste0("id_", sprintf(fmt = "%05d", X1))) %>% 
                   rename(ID = X1,
                          time_stamp = Zeitstempel)



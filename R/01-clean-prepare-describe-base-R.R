# R/00-clean-prepare-describe-base-R.R

# 00) Notes  --------------------------------------------------------------
# This script reads in data and prepares it for analysis
# does not use any external packages to read in data


# 01) options and settings ------------------------------------------------

options(scipen = 999) # ensure scientific notation is turned off, useful for p values at psych scale
set.seed(42)


# 02) Read in data --------------------------------------------------------
# the data are stored in a folder called data
GamingStudyData <- read.csv('data/GamingStudy_data.csv')


# 03) Remove Missing values  ----------------------------------------------

# GD_1 remove missing values for Hours
# GD_2 remove hours greater than 168 or less than 0
# GD_3 remove missing values for SPIN
# GD_4 keep only league of legends players
# GD_5 keep non-professional players

GD_1 <- GamingStudyData[!is.na(GamingStudyData$Hours), ]  
GD_2 <- GD_1[GD_1$Hours > 0 & GD_1$Hours < 168, ]
GD_3 <- GD_2[!is.na(GD_2$SPIN_T), ]
GD_4 <- GD_3[GD_3$Game     == "League of Legends", ]
GD_5 <- GD_4[GD_4$earnings == "I play for fun", ]

GamingStudyData_clean <- GD_5         # keep last for clean data

rm(GD_1, GD_2, GD_3, GD_4, GD_5)      # remove objects


# 04) Store Data set ------------------------------------------------------
write.csv(GamingStudyData_clean, 'data/GamingStudyData_clean-base-R.csv')


# 05) Histogram and summary of Hours  -------------------------------------
# To save the plot as a png file highlight from line 45-59 and press `ctrl + enter`

png(filename = "output/figs/Hours_histogram_base_device.png", 
    res = 300,
    type = "cairo",   # higher definition base R plots
    height = 5.92, 
    width = 7.78, 
    units = "in")

hist(GamingStudyData_clean$Hours,
     main   = "Histogram of Hours Played (Weekly)",
     xlab   = "Hours",
     col    = "#0277BD",
     border = 'white',
     breaks = seq(0, 120, by = 5))

dev.off()


# summary stats of hours
# You will need to install the psych package to run this chunk of code:
# install.packages("psych") ## only run if not previously installed
library(psych) # loads psych into the current environment

Hours_summary <- as.data.frame(psych::describe(GamingStudyData_clean$Hours) )
write.csv(Hours_summary[, c("n", "mean", "median", "sd", "se", "min", "max")],
          file = "output/tables/Gstudy_summary_base_psych.csv")

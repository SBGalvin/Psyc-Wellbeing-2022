
# 00) Notes ---------------------------------------------------------------
# Original analysis script was written in 2017
# This script was written in 2022 and sets options and loads packages for analysis


# 01) R packages ----------------------------------------------------------
# Extension packages to handle data
# load libraries
library(tidyverse)    # general data management/ graphics: loads multiple packages
library(Hmisc)        # general help (correlations)
library(lme4)         # linear modeling
library(gtools)       # helper functions
library(viridis)      # uniform colour perception palettes
library(ggnewscale)   # for multiple scales of the same type
library(psych)        # psychometric methods




# 02) Options and Settings ------------------------------------------------

options(scipen = 999,              # turns of scientific notation (e.g. p values)
        stringsAsFactors = FALSE)  # stops strings (texts) bening automatically converted to factors

set.seed(42) # use this in case random numbers are created anywhere

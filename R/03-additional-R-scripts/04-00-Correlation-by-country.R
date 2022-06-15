
# 00) Setup and data ------------------------------------------------------
options(scipen = 999)
library(tidyverse)
library(broom)
library(patchwork)

# This data was cleaned in files contained in R/03-additional--R-scripts/ 00-03
GamingStudyData_clean <- read_csv('data/GamingStudyData_clean.csv')


# United States  (USA)
GamingData_clean_US <- GamingStudyData_clean %>% filter(Residence == "USA")


# Germany  (DEU)
GamingData_clean_DE <- GamingStudyData_clean %>% filter(Residence == "Germany")


# UK
GamingData_clean_UK <- GamingStudyData_clean %>% filter(Residence == "UK")




# 01) Correlation between Gaming Hours and Anxiety (GAD-7) ----------------

US_hours_GAD_cor <- with(GamingData_clean_US,
                         cor.test(GAD_T, Hours)) %>% tidy()


DE_hours_GAD_cor <- with(GamingData_clean_DE,
                         cor.test(GAD_T, Hours)) %>% tidy()


UK_hours_GAD_cor <- with(GamingData_clean_UK,
                         cor.test(GAD_T, Hours)) %>% tidy()


# Correlations table -  within Residences
# row bind (rbind()) the results together
# then rename, and alter columns etc, to produce a table (no values have been rounded yet!)
Correlation_GAD_Hours <- rbind(US_hours_GAD_cor,
                               DE_hours_GAD_cor,
                               UK_hours_GAD_cor) %>% 
  
                         rename(r = estimate, t = statistic) %>% select(-method, -alternative) %>% 
                         mutate(R2 = r^2) %>% 
                         mutate(Country = c("USA", "DEU", "UK")) %>% 
                         select(Country, r, R2, t, p.value, parameter, conf.low, conf.high)

# Store table as file
write_csv(Correlation_GAD_Hours, 'output/tables/Correlation_GAD_Hours.csv')

# 02) Scatterplot ---------------------------------------------------------
All_Scatter <- GamingStudyData_clean %>% 
               ggplot(aes(x = GAD_T, y = Hours))+
               geom_point(colour = 'black',  shape = 21, alpha = .4)+
               geom_smooth(method = "lm", se = F, colour = 'grey10')+
               xlab("GAD-7 Total Score All Residences (n = 9702)")+
               ylab("Weekly Hours Gaming")+
               scale_x_continuous(limits = c(0, 28), position = "top")+
               scale_y_continuous(limits = c(0, 168))+
               theme_classic()

US_scatter <- GamingData_clean_US %>% 
              ggplot(aes(x = GAD_T, y = Hours))+
              geom_point(colour = 'steelblue', shape = 21, alpha = .4)+
              geom_smooth(method = "lm", se = F, colour = 'grey10')+
              xlab("GAD-7 Total Score USA (n = 3382)")+
              ylab("")+
              scale_x_continuous(limits = c(0, 28), position = "top")+
              scale_y_continuous(limits = c(0, 168))+
              theme_classic()+
              theme(axis.text.y = element_blank(),
                    axis.ticks.y = element_blank())

DE_scatter <- GamingData_clean_DE %>% 
              ggplot(aes(x = GAD_T, y = Hours))+
              geom_point(colour = 'orange', shape = 21, alpha = .4)+
              geom_smooth(method = "lm", se = F, colour = 'grey10')+
              xlab("GAD-7 Total Score DE (n = 1004)")+
              ylab("Weekly Hours Gaming")+
              scale_x_continuous(limits = c(0, 28))+
              scale_y_continuous(limits = c(0, 168))+
              theme_classic()


UK_scatter <- GamingData_clean_UK %>% 
              ggplot(aes(x = GAD_T, y = Hours))+
              geom_point(colour = 'tomato', shape = 21, alpha = .4)+
              geom_smooth(method = "lm", se = F, colour = 'grey10')+
              xlab("GAD-7 Total Score UK (n = 743)")+
              ylab("")+
              scale_x_continuous(limits = c(0, 28))+
              scale_y_continuous(limits = c(0, 168))+
              theme_classic()+
              theme(axis.text.y = element_blank(),
                    axis.ticks.y = element_blank())

# use patchwork to stitch the plots together
All_scatter_plots <- ((All_Scatter)|(US_scatter))/((DE_scatter)|(UK_scatter))
All_scatter_plots


ggsave(plot = All_scatter_plots,
       filename = "output/figs/All_scatter_plots_ggplot2.png", 
       dpi = 300, 
       height = 5.92, 
       width = 7.78,
       units= "in")

saveRDS(All_scatter_plots, "assets/All_scatter_plots.RDS")


# 03) Scatterplot faceted by Residence ------------------------------------


Gad_7_Avg_hours <- GamingStudyData_clean %>% 
  filter(Residence %in% c("USA", "UK", "Germany")) %>% 
  ggplot(aes(x = GAD_T, y = Hours, group = Residence))+
  geom_jitter(aes(colour = Residence),  shape = 21, alpha = .4)+
  geom_smooth(method = "lm", se = F, colour = 'grey10')+
  xlab("GAD-7 Total Score")+
  ylab("Avg. Weekly Hours Gaming")+
  facet_wrap(~Residence, ncol = 1)+
  scale_colour_manual(values = c("orange", "tomato", "steelblue"))+
  scale_x_continuous(limits = c(0, 22))+
  scale_y_continuous(limits = c(0, 100))+
  theme_minimal()+
  theme(legend.position = "none")

ggsave(plot = Gad_7_Avg_hours,
       filename = "output/figs/Gad_7_Avg_hours.png", 
       dpi = 300, 
       height = 5.92, 
       width = 7.78,
       units= "in")

saveRDS(Gad_7_Avg_hours, "assets/Gad_7_Avg_hours.RDS")



# 04) Correlation of Anxiety Measures -------------------------------------
# correlation of Anxiety measures in the data set

GamingX <- GamingStudyData_clean %>% 
  filter(Residence %in% c("USA", "UK", "Germany")) %>% 
  
  group_by(Residence) %>% 
  summarise(GAD7_SPIN  = cor(x = GAD_T, y = SPIN_T),
            GAD7_SPINp = cor.test(x = GAD_T, y = SPIN_T)$p.value,
            GAD7_SWL   = cor(x = GAD_T, y = SWL_T),
            GAD7_SWLp  = cor.test(x = GAD_T, y = SWL_T)$p.value,
            SPIN_SWL   = cor(x = SPIN_T, y = SWL_T),
            SPIN_SWLp  = cor.test(x = SPIN_T, y = SWL_T)$p.value)


AnxMeasure_correlations <- left_join(x = GamingX %>% 
                                       select(Residence, all_of(c("GAD7_SPIN", "GAD7_SWL", "SPIN_SWL"))) %>% 
                                       pivot_longer(cols = c("GAD7_SPIN", "GAD7_SWL", "SPIN_SWL"), names_to = "Measures", values_to = "r") %>% 
                                       separate(Measures, into = c("Measure1", "Measure2"), sep = "_"),
                                     
                                     y = GamingX %>% 
                                       select(Residence, ends_with("p")) %>% 
                                       pivot_longer(cols = c("GAD7_SPINp", "GAD7_SWLp", "SPIN_SWLp"), names_to = "Measures", values_to = "p") %>% 
                                       mutate(Measures = str_remove(Measures, "p")) %>% 
                                       separate(Measures, into = c("Measure1", "Measure2"), sep = "_"),
                                     
                                     by = c("Residence", "Measure1", "Measure2"))

write_csv(AnxMeasure_correlations, 'output/tables/AnxMeasure_correlations.csv')

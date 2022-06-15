

# 01) Comparing GAD and SPIN ----------------------------------------------

GAD_SPin_plot_de <- GamingData_clean_DE %>% 
  ggplot(aes(x = GAD_T, y = SPIN_T))+
  geom_jitter(size = 1, alpha = .4, width = .25, aes(colour = GAD_Anx))+
  
  scale_colour_manual(values = c("#482475", "#3f4788", "#6bcd5b", "#fbb800"))+
  guides(colour = guide_legend(title = "GAD-7 Categories:", override.aes = c(alpha=1, size = 3)))+
  
  xlab("Generalized Anxiety Disorder 7")+
  ylab("Social Phobia Inventory")+
  
  theme_minimal()+
  theme(legend.position = "bottom",
        legend.key = element_rect(fill = NA, colour = NA))


GAD_SWL_plot_de <- GamingData_clean_DE %>% 
  
  mutate(Gender = factor(Gender, levels = c("Other", "Female", "Male"))) %>% 
  ggplot(aes(x = GAD_T, y = SWL_T))+
  geom_jitter(size = 1, alpha = .4, width = .25, aes(colour = GAD_Anx))+
  
  scale_colour_manual(values = c("#482475", "#3f4788", "#6bcd5b", "#fbb800"))+
  
  guides(colour = guide_legend(title = "GAD-7 Categories:", override.aes = c(alpha=1, size = 3)))+
  
  xlab("Generalized Anxiety Disorder 7")+
  ylab("Satisfaction With Life Scale")+
  
  theme_minimal()+
  theme(legend.position = "bottom",
        legend.key = element_rect(fill = NA, colour = NA))



SPIN_SWL_plot_de <- GamingData_clean_DE %>% 
  
  mutate(Gender = factor(Gender, levels = c("Other", "Female", "Male"))) %>% 
  ggplot(aes(x = SPIN_T, y = SWL_T))+
  geom_jitter(size = 1, alpha = .6, width = .1, aes(colour = SPIN_Anx))+
  scale_color_brewer(palette = "Dark2")+
  guides(colour = guide_legend(title = "SPIN Categories:", override.aes = c(alpha=1, size = 3)))+
  
  xlab("Social Phobia Inventory")+
  ylab("Satisfaction With Life Scale")+
  
  theme_minimal()+
  theme(legend.position = "bottom",
        legend.key = element_rect(fill = NA, colour = NA))

pairs(GamingData_clean_DE[, c("Hours", "GAD_T", "SWL_T", "SPIN_T")])

cor(GamingData_clean_DE[, c("Hours", "GAD_T", "SWL_T", "SPIN_T")], method = "spearman")
cor(GamingData_clean_DE[GamingData_clean_DE$Gender == "Female", c("Hours", "GAD_T", "SWL_T", "SPIN_T")], method = "spearman")
cor(GamingData_clean_DE[GamingData_clean_DE$Gender == "Male",   c("Hours", "GAD_T", "SWL_T", "SPIN_T")], method = "spearman")
cor(GamingData_clean_DE[GamingData_clean_DE$Gender == "Other",  c("Hours", "GAD_T", "SWL_T", "SPIN_T")], method = "spearman")


GamingData_clean_DE %>% select(Gender, all_of(c("Hours", "GAD_T", "SWL_T", "SPIN_T"))) %>% 
  group_by(Gender) %>% 
  cor()

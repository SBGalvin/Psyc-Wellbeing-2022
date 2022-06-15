GAD_res <- GamingStudyData %>% 
           filter(Residence %in% c("USA", "Germany", "UK")) %>% 
           mutate(Residence = ifelse(Residence == "Germany", "DE", Residence)) %>% 
           mutate(Residence = factor(Residence, levels = c("USA", "UK", "DE"), ordered = TRUE)) %>% 
           ggplot(aes(x = GAD_T, y = Hours))+
           geom_jitter(size = 1, alpha = .4, width = .25, aes(colour = Residence))+
           scale_colour_manual(values = c("USA" = "steelblue", "UK" = "tomato", "DE" = "gold"))+
           
           
           xlab("Generalized Anxiety Disorder 7")+
           ylab("Weekly Average Hours Gaming")+
           facet_wrap(~Residence, nrow = 1)+
           theme_minimal()+
           theme(legend.position = "none")


SPIN_res <- GamingStudyData %>% 
            filter(Residence %in% c("USA", "Germany", "UK")) %>% 
            mutate(Residence = ifelse(Residence == "Germany", "DE", Residence)) %>% 
            mutate(Residence = factor(Residence, levels = c("USA", "UK", "DE"), ordered = TRUE)) %>% 
            ggplot(aes(x = SPIN_T, y = Hours))+
            geom_jitter(size = 1, alpha = .4, width = .25, aes(colour = Residence))+
            scale_colour_manual(values = c("USA" = "steelblue", "UK" = "tomato", "DE" = "gold"))+
            
            
            xlab("Social Phobia Inventory")+
            ylab("Weekly Average Hours Gaming")+
            facet_wrap(~Residence, nrow = 1)+
            theme_minimal()+
            theme(legend.position = "none",
                  strip.background = element_blank(),
                  strip.text.x = element_blank())

SWL_res <- GamingStudyData %>% 
           filter(Residence %in% c("USA", "Germany", "UK")) %>% 
           mutate(Residence = ifelse(Residence == "Germany", "DE", Residence)) %>% 
           mutate(Residence = factor(Residence, levels = c("USA", "UK", "DE"), ordered = TRUE)) %>% 
           ggplot(aes(x = SWL_T, y = Hours))+
           geom_jitter(size = 1, alpha = .4, width = .25, aes(colour = Residence))+
           scale_colour_manual(values = c("USA" = "steelblue", "UK" = "tomato", "DE" = "gold"))+
           
           
           xlab("Satisfaction With Life Scale")+
           ylab("Weekly Average Hours Gaming")+
           facet_wrap(~Residence, nrow = 1)+
           theme_minimal()+
           theme(legend.position = "none",
                 strip.background = element_blank(),
                 strip.text.x = element_blank())


Hours_survey_plot <- (GAD_res+ylab(""))/(SPIN_res)/(SWL_res+ylab(""))



saveRDS(Hours_survey_plot, 'output/Hours_survey_plot.RDS')

ggsave(filename = 'output/figs/Hours_survey_plot.png',   # output file
       plot     = Hours_survey_plot,                # object to save
       dpi      = 300,                              # resolution
       width    = 7.78,
       height   = 5.92,
       units    = "in")

unique(GamingData_clean$Playstyle)

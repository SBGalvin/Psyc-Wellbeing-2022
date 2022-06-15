
# 00) Notes ---------------------------------------------------------------
# this script is to merge more complex plots generated in scripts 04
# Faceted by Nationality (USA, UK, DE)

library(patchwork) # additional package for plots

# 01) Create plot by variable and country ---------------------------------


# GAD and SPIN plots 
p1 <- (GAD_SPin_plot_us+xlab("USA")+ylab("SPIN")+theme(legend.position = "none")|
    GAD_SPin_plot_uk+ylab("")+xlab("UK\nGeneralized Anxiety Disorder 7")+theme(legend.position = "none")|
    GAD_SPin_plot_de+xlab("DE")+ylab(""))+ 
  plot_layout(guides = "collect")&
  theme(legend.position = "bottom")

# GAD and SWL plots
p2 <- (GAD_SWL_plot_us+xlab("USA")+ylab("SWL")+theme(legend.position = "none")|
    GAD_SWL_plot_uk+ylab("")+xlab("UK\nGeneralized Anxiety Disorder 7")+theme(legend.position = "none")|
    GAD_SWL_plot_de+xlab("DE")+ylab(""))+ 
  plot_layout(guides = "collect")&
  theme(legend.position = "bottom")


# SPIN and SWL plots
p3 <- (SPIN_SWL_plot_us+xlab("USA")+ylab("SWL")+theme(legend.position = "none")|
    SPIN_SWL_plot_uk+ylab("")+xlab("UK\nSocial Phobia Inventory")+theme(legend.position = "none")|
    SPIN_SWL_plot_de+xlab("DE")+ylab(""))+ 
  plot_layout(guides = "collect")&
  theme(legend.position = "bottom")



# 02) Merge all plots -----------------------------------------------------
Survey_Plots <- (p1)/(p2)/(p3)


# save
saveRDS(Survey_Plots, 'output/additional/Survey_Plots.RDS')

ggsave(filename = 'output/additional/Survey_Plots.png',   # output file
       plot     = Survey_Plots,                # object to save
       dpi      = 300,                         # resolution
       width    = 7.78,
       height   = 5.92,
       units    = "in")

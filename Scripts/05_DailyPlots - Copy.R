
library(zoo)
library(tidyverse)


Merged_data_7MA <- Merged_data_2


#Gewenste dagen subsetten
Merged_data_short <- Merged_data_7MA[Merged_data_7MA$dateInTable>"2020-01-01"&Merged_data_7MA$dateInTable<=Sys.Date(),]
Merged_data_short$observation <- 1:nrow(Merged_data_short) 


Merged_data_short$fixedDate <- as.Date(Merged_data_short$dateInTable,format="%Y-%m-%d")


test.date.df =data.frame(date=as.Date(c("2020-01-01")),event="verruiming testbeleid")


ggplot(Merged_data_short)+
    geom_point(stat='identity', mapping = aes(x=fixedDate, y=cases), color = "#96afde")+     #, color = "#96afde"
     geom_line(mapping = aes(x=fixedDate, y=MACases), color = "#F5F5F5",lwd = 3)+
    geom_line(mapping = aes(x=fixedDate, y=MACases), color = "#44546a",lwd = 2)+
   
    scale_y_continuous(limits = c(0, 12500),breaks = c(2500, 5000, 7500,10000,12500), labels = label_comma(big.mark = ".", decimal.mark = ","))+
    
    scale_x_date(limits = c(as.Date("2020-01-20"),Sys.Date() ),
                 date_breaks = "1 month", 
                 date_labels= format("%b"))+
    
    theme_classic()+
    xlab("")+ 
    ylab("")+
    labs(title = "Nieuw gemelde besmettingen",
         subtitle = "met 7 daags voortschrijdend gemiddelde",
         caption = paste("Bron: RIVM | Plot: @YorickB | ",Sys.Date()))+
    theme(
        plot.background = element_rect(fill = "#F5F5F5"), #background color/size (border color and size)
        panel.background = element_rect(fill = "#F5F5F5", colour = "#F5F5F5"),
        legend.position = "none",   # no legend
        plot.title = element_text(hjust = 0.5,size = 30,face = "bold"),
        plot.subtitle =  element_text(hjust=0.5,color = "black", face = "italic"),
       #scale_x_date(),
        axis.text = element_text(size=14,color = "black",face = "bold"),
       #axis.text.x=element_blank(),
        axis.text.y = element_text(face="bold", color="black", size=14),  #, angle=45),
        axis.ticks = element_line(colour = "#F5F5F5", size = 1, linetype = "solid"),
        axis.ticks.length = unit(0.5, "cm"),
        axis.line = element_line(colour = "#F5F5F5"),
        panel.grid.major.y = element_line(colour= "lightgray", linetype = "dashed"))

ggsave("data/05_new_cases-limeline-clean-dots.png",width=16, height = 9)




ggplot(Merged_data_short)+
    geom_bar(stat='identity', mapping = aes(x=fixedDate, y=hosp, fill = "x"))+     #, color = "#96afde"
    scale_fill_manual(values=c("#f4b183"))+
    geom_line(mapping = aes(x=fixedDate, y=MAhosp), color = "#F5F5F5",lwd = 3)+
    geom_line(mapping = aes(x=fixedDate, y=MAhosp), color = "#c55a11",lwd = 2)+
    theme_classic()+
    xlab("")+ 
    ylab("")+
    labs(title = "Nieuw gemelde opnames",
         subtitle = "met 7 daags voortschrijdend gemiddelde",
         caption = paste("Bron: RIVM | Plot: @YorickB | ",Sys.Date()))+
    geom_vline(data=test.date.df,  mapping=aes(xintercept=date), linetype = "dashed", size = 1.5, color = "black")+
    geom_text(data=test.date.df  , mapping=aes(x=date, y=125, label=event), size=7, angle=-90, vjust=-0.4, hjust=0, color= "black")+
    
    theme(
        plot.background = element_rect(fill = "#F5F5F5"), #background color/size (border color and size)
        panel.background = element_rect(fill = "#F5F5F5", colour = "#F5F5F5"),
        legend.position = "none",   # no legend
        plot.title = element_text(hjust = 0.5,size = 30,face = "bold"),
        plot.subtitle =  element_text(hjust=0.5,color = "black", face = "italic"),
        #scale_x_date(),
       axis.text = element_text(size=14,color = "black",face = "bold"),
       # axis.text.x=element_blank(),
        axis.text.y = element_text(face="bold", color="black", size=14),  #, angle=45),
        axis.ticks = element_line(colour = "#F5F5F5", size = 1, linetype = "solid"),
        axis.ticks.length = unit(0.5, "cm"),
        axis.line = element_line(colour = "#F5F5F5"),
        panel.grid.major.y = element_line(colour= "lightgray", linetype = "dashed"))
ggsave("data/09_new_hosp-more_tests-2.png",width=16, height = 9)




ggplot(Merged_data_short)+
    geom_bar(stat='identity', mapping = aes(x=fixedDate, y=hosp, fill = "x"))+     #, color = "#96afde"
    scale_fill_manual(values=c("#f4b183"))+
    geom_line(mapping = aes(x=fixedDate, y=MAhosp), color = "#F5F5F5",lwd = 3)+
    geom_line(mapping = aes(x=fixedDate, y=MAhosp), color = "#c55a11",lwd = 2)+
    theme_classic()+
    xlab("")+ 
    ylab("")+
    labs(title = "New hospitalizations",
         subtitle = "with 7 day moving average",
         caption = paste("Source: RIVM / CBS | Plot: @YorickB | ",Sys.Date()))+
    theme(
        plot.background = element_rect(fill = "#F5F5F5"), #background color/size (border color and size)
        panel.background = element_rect(fill = "#F5F5F5", colour = "#F5F5F5"),
        legend.position = "none",   # no legend
        plot.title = element_text(hjust = 0.5,size = 30,face = "bold"),
        plot.subtitle =  element_text(hjust=0.5,color = "black", face = "italic"),
        #scale_x_date(),
        axis.text = element_text(size=14,color = "black",face = "bold"),
        # axis.text.x=element_blank(),
        axis.text.y = element_text(face="bold", color="black", size=14),  #, angle=45),
        axis.ticks = element_line(colour = "#F5F5F5", size = 1, linetype = "solid"),
        axis.ticks.length = unit(0.5, "cm"),
        axis.line = element_line(colour = "#F5F5F5"),
        panel.grid.major.y = element_line(colour= "lightgray", linetype = "dashed"))
ggsave("data/09_EN_new_hosp.png",width=16, height = 9)




ggplot(Merged_data_short)+
    geom_bar(stat='identity', mapping = aes(x=fixedDate, y=dead, fill = "x"))+     #, color = "#96afde"
    scale_fill_manual(values=c("#fab0b0"))+
    geom_line(mapping = aes(x=fixedDate, y=MAdead), color = "#F5F5F5",lwd = 3)+
    geom_line(mapping = aes(x=fixedDate, y=MAdead), color = "#ff0505",lwd = 2)+
    theme_classic()+
    xlab("")+ 
    ylab("")+
    labs(title = "Nieuw gemelde overledenen",
         subtitle = "met 7 daags voortschrijdend gemiddelde",
         caption = paste("Bron: RIVM | Plot: @YorickB | ",Sys.Date()))+
    theme(
        plot.background = element_rect(fill = "#F5F5F5"), #background color/size (border color and size)
        panel.background = element_rect(fill = "#F5F5F5", colour = "#F5F5F5"),
        legend.position = "none",   # no legend
        plot.title = element_text(hjust = 0.5,size = 30,face = "bold"),
        plot.subtitle =  element_text(hjust=0.5,color = "black", face = "italic"),
        #scale_x_date(),
       axis.text = element_text(size=14,color = "black",face = "bold"),
       # axis.text.x=element_blank(),
        axis.text.y = element_text(face="bold", color="black", size=14),  #, angle=45),
        axis.ticks = element_line(colour = "#F5F5F5", size = 1, linetype = "solid"),
        axis.ticks.length = unit(0.5, "cm"),
        axis.line = element_line(colour = "#F5F5F5"),
        panel.grid.major.y = element_line(colour= "lightgray", linetype = "dashed"))
ggsave("data/13_new_deceased.png",width=16, height = 9)


ggplot(Merged_data_short)+
    geom_bar(stat='identity', mapping = aes(x=fixedDate, y=dead, fill = "x"))+     #, color = "#96afde"
    scale_fill_manual(values=c("#fab0b0"))+
    geom_line(mapping = aes(x=fixedDate, y=MAdead), color = "#F5F5F5",lwd = 3)+
    geom_line(mapping = aes(x=fixedDate, y=MAdead), color = "#ff0505",lwd = 2)+
    theme_classic()+
    xlab("")+ 
    ylab("")+
    labs(title = "New deceased",
         subtitle = "with 7 day moving average",
         caption = paste("Source: RIVM | Plot: @YorickB | ",Sys.Date()))+
    theme(
        plot.background = element_rect(fill = "#F5F5F5"), #background color/size (border color and size)
        panel.background = element_rect(fill = "#F5F5F5", colour = "#F5F5F5"),
        legend.position = "none",   # no legend
        plot.title = element_text(hjust = 0.5,size = 30,face = "bold"),
        plot.subtitle =  element_text(hjust=0.5,color = "black", face = "italic"),
        #scale_x_date(),
        axis.text = element_text(size=14,color = "black",face = "bold"),
        # axis.text.x=element_blank(),
        axis.text.y = element_text(face="bold", color="black", size=14),  #, angle=45),
        axis.ticks = element_line(colour = "#F5F5F5", size = 1, linetype = "solid"),
        axis.ticks.length = unit(0.5, "cm"),
        axis.line = element_line(colour = "#F5F5F5"),
        panel.grid.major.y = element_line(colour= "lightgray", linetype = "dashed"))
ggsave("data/13_EN_new_deceased.png",width=16, height = 9)

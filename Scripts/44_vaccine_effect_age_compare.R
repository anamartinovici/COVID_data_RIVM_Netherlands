
read.aantal.landelijk.path <- paste("C:\\Rdir\\data\\",Sys.Date(),"\\", Sys.Date(), "_COVID-19_casus_landelijk.csv",sep="")
cases_per_day <- read.csv(read.aantal.landelijk.path,sep=";")

cases_per_day = filter(cases_per_day, Agegroup !="Unknown")

cases_per_day <- cases_per_day %>% mutate(age_grouping = case_when(str_detect(Agegroup, "0-9") ~ '0-49', 
                                                                   str_detect(Agegroup, "10-19") ~ '0-49',
                                                                   str_detect(Agegroup, "20-29") ~ '0-49',
                                                                   str_detect(Agegroup, "30-39") ~ '0-49',
                                                                   str_detect(Agegroup, "40-49") ~ '0-49',
                                                                   str_detect(Agegroup, "<50") ~ '0-49',
                                                                   str_detect(Agegroup, "50-59") ~ '50-59',
                                                                   str_detect(Agegroup, "60-69") ~ '60-69',
                                                                   str_detect(Agegroup, "70-79") ~ '70-79',
                                                                   str_detect(Agegroup, "80-89") ~ '80-89',
                                                                   str_detect(Agegroup, "90+") ~ '90+',))

#cases_per_day <-count(cases_per_day,date,age_grouping)

casus.working <-count(cases_per_day,date,age_grouping)

hosp_per_day = filter(cases_per_day, Agegroup !="Unknown" & Hospital_admission == "Yes")
casus.working.hosp <-count(hosp_per_day,date,age_grouping)

#Take rolling 7-day averages
casus.working <- casus.working %>% 
  group_by(age_grouping) %>% 
  arrange(date) %>% 
  mutate(case.avg=roll_mean(n, 7, align="right", fill=0))

dag<-strftime(Sys.Date()-7)

casus.working <- casus.working[casus.working$date>"2020-02-29"&casus.working$date<dag,]
casus.working$date <- as.Date(casus.working$date)


draw_key_polygon3 <- function(data, params, size) {
  lwd <- min(data$size, min(size) / 4)
  
  grid::rectGrob(
    width = grid::unit(0.6, "npc"),
    height = grid::unit(0.6, "npc"),
    gp = grid::gpar(
      col = data$colour,
      fill = alpha(data$fill, data$alpha),
      lty = data$linetype,
      lwd = lwd * .pt,
      linejoin = "mitre"
    ))
}
GeomBar$draw_key = draw_key_polygon3


#### PLOT  onderlinge verhouding ####

ggplot(casus.working, aes(date, case.avg, fill=age_grouping))+
  
  geom_bar(stat="identity", position=position_fill(), width=1) + scale_y_reverse() +
  
  theme_classic()+
  
  theme(legend.position = "right", 
        legend.direction = "vertical",
        legend.title = element_blank(),
        legend.background =element_rect(fill = "#F5F5F5") ,
        legend.spacing.y = unit(0, "cm"), 
        legend.key.size = unit(1, "cm"))+ 
  
  xlab("")+ 
  ylab("")+
  
  scale_x_date(date_breaks = "1 month", 
               date_labels= format("%b"),
               limits = as.Date(c("2020-10-01", Sys.Date())))+
  
  scale_fill_manual(values=c("darkgray", '#f8cbad','#c55a11', '#2f5597', '#8faadc', '#5b9bd5', "black" ))+ # Use custom colors
  
  guides(fill = guide_legend(reverse = TRUE))+
  
  labs(title = "Besmettingen COVID-19",
       subtitle = "Op basis van eerste ziektedag",
       fill="",
       caption = paste("Bron data: RIVM  | Plot: @YorickB | ",Sys.Date()-1))+
  
  theme(plot.background = element_rect(fill = "#F5F5F5"), #background color/size (border color and size)
        panel.background = element_rect(fill = "#F5F5F5", colour = "#F5F5F5"),
        plot.title = element_text(hjust = 0.5,size = 25,face = "bold"),
        plot.subtitle =  element_text(hjust=0.5,color = "black", face = "italic"),
        axis.text = element_text(size=14,color = "black",face = "bold"),
        axis.ticks = element_line(colour = "#F5F5F5", size = 1, linetype = "solid"),
        axis.text.y = element_blank(),
        axis.ticks.length = unit(0.1, "cm"),
        axis.line = element_line(colour = "#F5F5F5"))+
  
  ggsave("data/99_leeftijd_rel_case.png",width=16, height = 9)

  
casus.working <- casus.working[ -c(4)]
casus.working_wide <- spread(casus.working, age_grouping, n)

casus.working_wide$MA049   <- rollmeanr(casus.working_wide$`0-49`, 7, fill = 0)
casus.working_wide$MA5059  <- rollmeanr(casus.working_wide$`50-59`, 7, fill = 0)
casus.working_wide$MA6069  <- rollmeanr(casus.working_wide$`60-69`, 7, fill = 0)
casus.working_wide$MA7079  <- rollmeanr(casus.working_wide$`70-79`, 7, fill = 0)
casus.working_wide$MA8089  <- rollmeanr(casus.working_wide$`80-89`, 7, fill = 0)
casus.working_wide$MA90    <- rollmeanr(casus.working_wide$`90+`, 7, fill = 0)


maxMA049 <- max(casus.working_wide$MA049, na.rm = TRUE)
casus.working_wide$MA049_rel <- casus.working_wide$MA049/maxMA049
maxMA5059 <- max(casus.working_wide$MA5059, na.rm = TRUE)
casus.working_wide$MA5059_rel <- casus.working_wide$MA5059/maxMA5059
maxMA6069 <- max(casus.working_wide$MA6069, na.rm = TRUE)
casus.working_wide$MA6069_rel <- casus.working_wide$MA6069/maxMA6069
maxMA7079 <- max(casus.working_wide$MA7079, na.rm = TRUE)
casus.working_wide$MA7079_rel <- casus.working_wide$MA7079/maxMA7079
maxMA8089 <- max(casus.working_wide$MA8089, na.rm = TRUE)
casus.working_wide$MA8089_rel <- casus.working_wide$MA8089/maxMA8089
maxMA90 <- max(casus.working_wide$MA90, na.rm = TRUE)
casus.working_wide$MA90_rel <- casus.working_wide$MA90/maxMA90


key <- "date"
value <- "number"
gathercols <- c("MA049_rel","MA5059_rel","MA6069_rel","MA7079_rel","MA8089_rel","MA90_rel")
casus.working.long <- gather(casus.working_wide, key, value, gathercols,)

casus.working.long$key <- as.factor(casus.working.long$key)
casus.working.long <- casus.working.long %>% filter(date > "2020-09-07")


ggplot(casus.working.long, aes(date, value, color=key))+
  geom_line(lwd=2)+
 #facet_wrap(~key, scales = "free_y")
ggsave("data/99_leeftijd_relatief_case.png",width=16, height = 9)






hosp.working_wide <- spread(casus.working.hosp, age_grouping, n)

two.weeks.ago = Sys.Date()-14

hosp.working_wide <- hosp.working_wide %>% filter(date > "2020-09-07" & date < two.weeks.ago)

hosp.working_wide$MA049   <- rollmeanr(hosp.working_wide$`0-49`, 7, fill = 0)
hosp.working_wide$MA5059  <- rollmeanr(hosp.working_wide$`50-59`, 7, fill = 0)
hosp.working_wide$MA6069  <- rollmeanr(hosp.working_wide$`60-69`, 7, fill = 0)
hosp.working_wide$MA7079  <- rollmeanr(hosp.working_wide$`70-79`, 7, fill = 0)
hosp.working_wide$MA8089  <- rollmeanr(hosp.working_wide$`80-89`, 7, fill = 0)
hosp.working_wide$MA90    <- rollmeanr(hosp.working_wide$`90+`, 7, fill = 0)


maxMA049 <- max(hosp.working_wide$MA049, na.rm = TRUE)
hosp.working_wide$MA049_rel <- hosp.working_wide$MA049/maxMA049
maxMA5059 <- max(hosp.working_wide$MA5059, na.rm = TRUE)
hosp.working_wide$MA5059_rel <- hosp.working_wide$MA5059/maxMA5059
maxMA6069 <- max(hosp.working_wide$MA6069, na.rm = TRUE)
hosp.working_wide$MA6069_rel <- hosp.working_wide$MA6069/maxMA6069
maxMA7079 <- max(hosp.working_wide$MA7079, na.rm = TRUE)
hosp.working_wide$MA7079_rel <- hosp.working_wide$MA7079/maxMA7079
maxMA8089 <- max(hosp.working_wide$MA8089, na.rm = TRUE)
hosp.working_wide$MA8089_rel <- hosp.working_wide$MA8089/maxMA8089
maxMA90 <- max(hosp.working_wide$MA90, na.rm = TRUE)
hosp.working_wide$MA90_rel <- hosp.working_wide$MA90/maxMA90


key <- "date"
value <- "number"
gathercols <- c("MA049_rel","MA5059_rel","MA6069_rel","MA7079_rel","MA8089_rel","MA90_rel")
hosp.working.long <- gather(hosp.working_wide, key, value, gathercols,)

hosp.working.long$key <- as.factor(hosp.working.long$key)
hosp.working.long$date <- as.Date(hosp.working.long$date)

hosp.working.long <- hosp.working.long %>% filter(date > "2020-10-07" & date < two.weeks.ago)


ggplot(hosp.working.long, aes(date, value, color=key))+
  geom_line(lwd=2)+
  #facet_wrap(~key, scales = "free_y")
  ggsave("data/99_leeftijd_relatief_hosp.png",width=16, height = 9)








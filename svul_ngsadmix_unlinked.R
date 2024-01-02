# Process NGSadmix output

library(tidyverse)
library(purrr)
library(forcats)
library(readxl)
library(data.table)
library(wesanderson)
library(patchwork)
library(devtools)
library(cowplot)
library(ggplot2)
library(grid)
library(MoMAColors)
library(MetBrewer)


# meta
setwd("\\\\cmvm.datastore.ed.ac.uk\\cmvm\\eb\\users\\mmarr3\\R_all\\r_data\\svul_ngsadmix\\unlinked")
meta <- read.csv("\\\\cmvm.datastore.ed.ac.uk\\cmvm\\eb\\users\\mmarr3\\R_all\\r_data\\svul_ngsadmix\\unlinked\\pop_admix.txt")

#~~~~~~~~~~~~~~~~~~~~~~~~~#
#     Ln and Delta K      #
#~~~~~~~~~~~~~~~~~~~~~~~~~#

data_path <- ("\\\\cmvm.datastore.ed.ac.uk\\cmvm\\eb\\users\\mmarr3\\R_all\\r_data\\svul_ngsadmix\\unlinked\\")
files <- dir(data_path, pattern = "*.log")

df <- tibble(filename = files) %>%
  mutate(file_contents = map(filename,
                             ~ readLines(file.path(data_path, .))))

get_best_like <- function(df) {
  like <- df[grep(pattern = "best like=",df)]
  like <- substr(like,regexpr(pattern="=",like)[1]+1,regexpr(pattern="=",like)[1]+14)
}

lnl <- df %>%
  mutate(lnl = map(df$file_contents, get_best_like)) %>%
  select(-file_contents) %>%
  unnest(cols = c(lnl)) %>%
  mutate(filename = gsub("NGSadmix_", "", filename)) %>%
  mutate(filename = gsub("_noreps", "", filename)) %>%
  separate(filename, c("K", "run"), sep = "_") %>%
  mutate(run = gsub("run", "", run)) %>%
  mutate(run = as.numeric(run)) %>%
  mutate(K = as.factor(K)) %>%
  mutate(lnl = as.numeric(lnl)) %>%
  group_by(K) %>%
  summarise(mean = mean(lnl),
            minlnl = min(lnl),
            maxlnl = max(lnl),
            sd = sd(lnl)) %>%
  mutate(K = as.numeric(gsub("K", "", K)))

lnl_plot <- ggplot(lnl, aes(K, mean)) +
  geom_point() +
  geom_pointrange(aes(ymin = minlnl, ymax = maxlnl),
                  size = 0.5) +
  ylab("Likelihood") +
  scale_y_continuous(labels = scales::scientific) +
  ggtitle("A") +
  scale_x_discrete(name ="K", 
                   limits=c("1","2","3","4","5","6","7","8","9","10",
                            "11","12","13","14","15"))

pdf("lnl_plot_unlinked.pdf", height=10, width=8)
lnl_plot
dev.off()

#~~ Delta K

deltaK <- lnl %>%
  mutate(LprimeK = c(NA,mean[-1]-mean[-length(mean)]),
         LdblprimeK = c(NA,LprimeK[-c(1,length(mean))]-(LprimeK)[-(1:2)],NA),
         delta = LdblprimeK/sd) 

deltak_plot <- ggplot(deltaK, aes(K, delta)) +
  geom_line() +
  geom_point() +
  # scale_x_continuous(limits=c(2, 5)) +
  ylab("Delta K") +
  ggtitle("B") +
  scale_y_continuous(labels = scales::scientific) +
  scale_x_discrete(name ="K", 
                   limits=c("1","2","3","4","5","6","7","8","9","10",
                            "11","12","13","14","15"))

deltak_plot

pdf("lnl_plot_unlinked.pdf", height=6, width=10)
lnl_plot + deltak_plot
dev.off()

#~~~~~~~~~~~~~~~~~~~~~~~~~~#
#         Plotting         #
#~~~~~~~~~~~~~~~~~~~~~~~~~~#



data_path <- ("\\\\cmvm.datastore.ed.ac.uk\\cmvm\\eb\\users\\mmarr3\\R_all\\r_data\\svul_ngsadmix\\unlinked")
files <- dir(data_path, pattern = "*.qopt")

df <- tibble(filename = files) %>%
  mutate(file_contents = map(filename,
                             ~ fread(file.path(data_path, .))))

# add metadata 
meta <- fread("\\\\cmvm.datastore.ed.ac.uk\\cmvm\\eb\\users\\mmarr3\\R_all\\r_data\\svul_ngsadmix\\unlinked\\pop_admix.txt", header = F)
head(meta)

meta <- meta %>%
  mutate(numeric_location = case_when(V1 == "Isle_of_Arran" ~ 6, 
                                      V1 == "SouthWest_Scotland" ~ 4,
                                      V1 == "Central_Scotland" ~ 3,
                                      V1 == "Scottish_Borders" ~ 5,
                                      V1 == "NorthEast_Scotland" ~ 2,
                                      V1 == "Formby" ~ 7,
                                      V1 == "Highlands_&_Moray" ~ 1))

# Unnest data
df <- unnest(df, cols = c(file_contents)) %>%
  mutate(Location = rep(meta$V1, 50)) %>%
  mutate(numeric_location = rep(meta$numeric_location, 50)) %>%
  mutate(ID = rep(meta$V2, 50)) %>%
  pivot_longer(cols = c(V1, V2, V3, V4, V5, V6)) %>%
  drop_na %>%
  mutate(numeric_location = factor(numeric_location))

df <- df %>%
  mutate(name = case_when(
    name == "V1" ~ "K1",
    name == "V2" ~ "K2",
    name == "V3" ~ "K3",
    name == "V4" ~ "K4",
    name == "V5" ~ "K5",
    name == "V6" ~ "K6",
    TRUE ~ name  # Keep the original value if none of the conditions are met
  ))

colnames(df)[colnames(df) == "name"] <- "nK"


K2_squ <- filter(df, grepl("NGSadmix_K2_run1_noreps.qopt$", filename)) %>%
  mutate(ID = as.factor(ID),
         name = as.factor(nK))
K3_squ <- filter(df, grepl("NGSadmix_K3_run1_noreps.qopt$", filename)) %>%
  mutate(ID = as.factor(ID),
         name = as.factor(nK))
K4_squ <- filter(df, grepl("NGSadmix_K4_run1_noreps.qopt$", filename)) %>%
  mutate(ID = as.factor(ID),
         name = as.factor(nK))
K5_squ <- filter(df, grepl("NGSadmix_K5_run1_noreps.qopt$", filename)) %>%
  mutate(ID = as.factor(ID),
         name = as.factor(nK))
K6_squ <- filter(df, grepl("NGSadmix_K6_run1_noreps.qopt$", filename)) %>%
  mutate(ID = as.factor(ID),
         name = as.factor(nK))

#colour scheme
#SouthWest_Scotland - ("Grand Budapest2")[3] "#D8A499"
#Central_Scotland - ("Darjeeling1")[2] "#00a08a"
#Formby - ("IsleofDogs1")[6] "#8D8680"
#Highlands_and_Moray - ("FantasticFox1")[3] "#46ACC8"
#Isle_of_Arran = "#FD6467"
#NorthEast_Scotland - ("GrandBudapest2")[2] "#E6A0C4"
#Scottish_Borders - ("Moonrise3")[5] "#FAD77B"



col_palette <- c("#D8A499", #south
                 "#00a08a", #cen 
                 "#FD6467", #arr
                 "#E6A0C4", #ne 
                 "#46ACC8", #hig
                 "#8D8680") #for


K6_colMap<-tibble(nK=unique(K6_squ$nK), col=col_palette)
K6_col<-left_join(K6_squ,K6_colMap)

#from here would want to put in loop/function so can do the various values of K
#it may be better to store the data for each value in a list so can refer to the 
#corresponding tibble by its position in the list rather than by its different name


#~~~~K2~~~~#

K<-2
K2_squ_col<-K2_squ
K2_squ_col$col<-NA

K2_squ_preAv<-K2_squ %>% group_by(nK,Location) %>% summarise(av=mean(value)) %>% arrange(desc(av))
 
#need to remake this each K, always for whatever max K is
K6_squ_av<-K6_col %>% group_by(nK,Location,col) %>% summarise(av=mean(value)) %>% arrange(desc(av))

for(i in 1:K)
{
  thisColour<-K6_squ_av[which(K6_squ_av$Location==K2_squ_preAv[1,]$Location),]$col[1]
  #remove this colour as an option for other Ks
  K6_squ_av<-K6_squ_av %>% filter(col != thisColour)
  thisAnc<-K2_squ_preAv[1,]$nK
  #remove this ancestry as an option
  K2_squ_preAv<-K2_squ_preAv %>% filter(nK!=thisAnc)
  #set the colour for this ancestry
  K2_squ_col$col[which(K2_squ_col$nK==thisAnc)]<-thisColour
}


K2_plot_all <- ggplot(K2_squ, aes(factor(ID), value, fill = factor(nK, levels=unique(nK)))) +
  geom_col(color = "grey", linewidth = 0.001) +
  geom_col(linewidth = 0.001) +
  facet_grid(~fct_inseq(numeric_location), switch = "x", scales = "free", space = "free") +
  theme_minimal() + 
  scale_fill_manual(values = unique(K2_squ_col$col)) +
  scale_x_discrete(expand = expansion(add = 0.5)) +
  scale_y_continuous(breaks = c(0.50,1.00)) +
  theme(panel.spacing.x = unit(0.15,"lines"),
        axis.text.x =  element_blank(),
        #axis.text.y =  element_text(size=7.5, angle=0),
        axis.title.y = element_text(size=14),
        axis.ticks.y = element_blank(),
        axis.text.y =  element_blank(),
        axis.title.x = element_blank(),
        strip.text.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "none",
        plot.margin=unit(c(1,1,-0.1,1),"cm"))+
  ylab("K=2")


#~~K3~~ 

K<-3
K3_squ_col<-K3_squ
K3_squ_col$col<-NA

K3_squ_preAv<-K3_squ %>% group_by(nK,Location) %>% summarise(av=mean(value)) %>% arrange(desc(av))

#need to remake this each K, always for whatever max K is
K6_squ_av<-K6_col %>% group_by(nK,Location,col) %>% summarise(av=mean(value)) %>% arrange(desc(av))

for(i in 1:K)
{
  thisColour<-K6_squ_av[which(K6_squ_av$Location==K3_squ_preAv[1,]$Location),]$col[1]
  #remove this colour as an option for other Ks
  K6_squ_av<-K6_squ_av %>% filter(col != thisColour)
  thisAnc<-K3_squ_preAv[1,]$nK
  #remove this ancestry as an option
  K3_squ_preAv<-K3_squ_preAv %>% filter(nK!=thisAnc)
  #set the colour for this ancestry
  K3_squ_col$col[which(K3_squ_col$nK==thisAnc)]<-thisColour
}


K3_plot_all <- ggplot(K3_squ, aes(factor(ID), value, fill = factor(nK, levels=unique(nK)))) +
  geom_col(color = "grey", linewidth = 0.001) +
  geom_col(linewidth = 0.001) +
  facet_grid(~fct_inseq(numeric_location), switch = "x", scales = "free", space = "free") +
  theme_minimal() + 
  scale_fill_manual(values = unique(K3_squ_col$col)) +
  scale_x_discrete(expand = expansion(add = 0.5)) +
  scale_y_continuous(breaks = c(0.50,1.00)) +
  theme(panel.spacing.x = unit(0.15,"lines"),
        axis.text.x =  element_blank(),
        #axis.text.y =  element_text(size=7.5, angle=0),
        axis.title.y = element_text(size=14),
        axis.ticks.y = element_blank(),
        axis.text.y =  element_blank(),
        axis.title.x = element_blank(),
        strip.text.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "none",
        plot.margin=unit(c(-0.1,1,-0.1,1),"cm"))+
  ylab("K=3")



#~~K4~~

K<-4
K4_squ_col<-K4_squ
K4_squ_col$col<-NA

K4_squ_preAv<-K4_squ %>% group_by(nK,Location) %>% summarise(av=mean(value)) %>% arrange(desc(av))

#need to remake this each K, always for whatever max K is
K6_squ_av<-K6_col %>% group_by(nK,Location,col) %>% summarise(av=mean(value)) %>% arrange(desc(av))

for(i in 1:K)
{
  thisColour<-K6_squ_av[which(K6_squ_av$Location==K4_squ_preAv[1,]$Location),]$col[1]
  #remove this colour as an option for other Ks
  K6_squ_av<-K6_squ_av %>% filter(col != thisColour)
  thisAnc<-K4_squ_preAv[1,]$nK
  #remove this ancestry as an option
  K4_squ_preAv<-K4_squ_preAv %>% filter(nK!=thisAnc)
  #set the colour for this ancestry
  K4_squ_col$col[which(K4_squ_col$nK==thisAnc)]<-thisColour
}


K4_plot_all <- ggplot(K4_squ, aes(factor(ID), value, fill = factor(nK, levels=unique(nK)))) +
  geom_col(color = "grey", linewidth = 0.001) +
  geom_col(linewidth = 0.001) +
  facet_grid(~fct_inseq(numeric_location), switch = "x", scales = "free", space = "free") +
  theme_minimal() + 
  scale_fill_manual(values = unique(K4_squ_col$col)) +
  scale_x_discrete(expand = expansion(add = 0.5)) +
  scale_y_continuous(breaks = c(0.50,1.00)) +
  theme(panel.spacing.x = unit(0.15,"lines"),
        axis.text.x =  element_blank(),
        #axis.text.y =  element_text(size=7.5, angle=0),
        axis.title.y = element_text(size=14),
        axis.ticks.y = element_blank(),
        axis.text.y =  element_blank(),
        axis.title.x = element_blank(),
        strip.text.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "none",
        plot.margin=unit(c(-0.1,1,-0.1,1),"cm"))+
  ylab("K=4")

#~~K5~~~

K<-5
K5_squ_col<-K5_squ
K5_squ_col$col<-NA

K5_squ_preAv<-K5_squ %>% group_by(nK,Location) %>% summarise(av=mean(value)) %>% arrange(desc(av))

#need to remake this each K, always for whatever max K is
K6_squ_av<-K6_col %>% group_by(nK,Location,col) %>% summarise(av=mean(value)) %>% arrange(desc(av))

for(i in 1:K)
{
  thisColour<-K6_squ_av[which(K6_squ_av$Location==K5_squ_preAv[1,]$Location),]$col[1]
  #remove this colour as an option for other Ks
  K6_squ_av<-K6_squ_av %>% filter(col != thisColour)
  thisAnc<-K5_squ_preAv[1,]$nK
  #remove this ancestry as an option
  K5_squ_preAv<-K5_squ_preAv %>% filter(nK!=thisAnc)
  #set the colour for this ancestry
  K5_squ_col$col[which(K5_squ_col$nK==thisAnc)]<-thisColour
}


K5_plot_all <- ggplot(K5_squ, aes(factor(ID), value, fill = factor(nK, levels=unique(nK)))) +
  geom_col(color = "grey", linewidth = 0.001) +
  geom_col(linewidth = 0.001) +
  facet_grid(~fct_inseq(numeric_location), switch = "x", scales = "free", space = "free") +
  theme_minimal() + 
  scale_fill_manual(values = unique(K5_squ_col$col)) +
  scale_x_discrete(expand = expansion(add = 0.5)) +
  scale_y_continuous(breaks = c(0.50,1.00)) +
  theme(panel.spacing.x = unit(0.15,"lines"),
        axis.text.x =  element_blank(),
        #axis.text.y =  element_text(size=7.5, angle=0),
        axis.title.y = element_text(size=14),
        axis.ticks.y = element_blank(),
        axis.text.y =  element_blank(),
        axis.title.x = element_blank(),
        strip.text.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "none",
        plot.margin=unit(c(-0.1,1,-0.1,1),"cm"))+
  ylab("K=5")



#~~K6~~~

K<-6
K6_squ_col<-K6_squ
K6_squ_col$col<-NA

K6_squ_preAv<-K6_squ %>% group_by(nK,Location) %>% summarise(av=mean(value)) %>% arrange(desc(av))

#need to remake this each K, always for whatever max K is
K6_squ_av<-K6_col %>% group_by(nK,Location,col) %>% summarise(av=mean(value)) %>% arrange(desc(av))

for(i in 1:K)
{
  thisColour<-K6_squ_av[which(K6_squ_av$Location==K6_squ_preAv[1,]$Location),]$col[1]
  #remove this colour as an option for other Ks
  K6_squ_av<-K6_squ_av %>% filter(col != thisColour)
  thisAnc<-K6_squ_preAv[1,]$nK
  #remove this ancestry as an option
  K6_squ_preAv<-K6_squ_preAv %>% filter(nK!=thisAnc)
  #set the colour for this ancestry
  K6_squ_col$col[which(K6_squ_col$nK==thisAnc)]<-thisColour
}

popnames <- as_labeller(c(`1` = "HIG", 
                          `2` = "NE",
                          `3` = "CEN", 
                          `4` = "SW",
                          `5` = "SB",
                          `6` = "ARR",
                          `7` = "FOR"))

K6_plot_all <- ggplot(K6_squ, aes(factor(ID), value, fill = factor(nK, levels=unique(nK)))) +
  geom_col(color = "grey", linewidth = 0.001) +
  geom_col(linewidth = 0.001) +
  facet_grid(~fct_inseq(numeric_location), labeller=popnames, switch = "x", scales = "free", space = "free") +
  theme_minimal() +
  scale_fill_manual(values = unique(K6_squ_col$col)) +
  scale_x_discrete(expand = expansion(add = -0.1)) +
  scale_y_continuous(breaks = c(0.50,1.00)) +
  xlab("Population") +
  ylab("K=6") +
  theme(
    panel.spacing.x = unit(0.2,"lines"),
    panel.grid.major.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.y = element_blank(),
    axis.text.x = element_text(angle = 90,hjust = 1,size=6),
    #axis.text.y =  element_text(size=7.5, angle=0),
    axis.title.y = element_text(size=14),
    legend.position = "none",
    plot.margin=unit(c(-0.1,1,1,1),"cm"),
    strip.background = element_rect(color = "white", fill = "white"),
    strip.text.x = element_text(angle=0, color='black', face="bold", size=10, hjust=0.5))

grid.newpage()
grid.draw(rbind(ggplotGrob(K2_plot_all),ggplotGrob(K3_plot_all),ggplotGrob(K4_plot_all),
                ggplotGrob(K5_plot_all),ggplotGrob(K6_plot_all),size="last"))

pdf("squirrel_admix", height=10, width=20)
grid.newpage()
grid.draw(rbind(ggplotGrob(K2_plot_all),ggplotGrob(K3_plot_all),ggplotGrob(K4_plot_all),
                ggplotGrob(K5_plot_all),ggplotGrob(K6_plot_all),size="last"))
dev.off()










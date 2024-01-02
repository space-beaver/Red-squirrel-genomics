library(tidyverse)
library(ggpubr)
library(ggplot2)
library(ggplot2)
library(wesanderson)
library(RColorBrewer)
library(car)
library(rgl)
library(tidyverse)
library(tidyr)
library(dplyr)
library(readr)
library("stringr")
library(scatterplot3d) 
library(gridExtra)
library(patchwork)

setwd("\\\\cmvm.datastore.ed.ac.uk\\cmvm\\eb\\users\\mmarr3\\R_all\\r_data\\svul_pca_new\\")

#read in data for all samples
cov<-read.table("\\\\cmvm.datastore.ed.ac.uk\\cmvm\\eb\\users\\mmarr3\\R_all\\r_data\\svul_pca_new\\all_noreps.pcangsd.cov")
pop<- as.matrix(read.table("\\\\cmvm.datastore.ed.ac.uk\\cmvm\\eb\\users\\mmarr3\\R_all\\r_data\\svul_pca_new\\poplist_allnoreps_pca.txt"))
e <- eigen(cov)

#Calulate PC variance (proportions)
variance<-e$values/sum(e$values)
print(variance)
write.csv(variance,file="pcangsd.var.csv")

#Convert to percentages
var_percent<-variance * 100
print(var_percent)

#Plot variance 
tiff("varplot_allsamples.tiff")
plot(var_percent[0:15],xlab="PC #", ylab="% Variance", 
     cex.axis=1.5,cex.lab=1.5,cex.main=1.8,main="Variance explained in first 15 PCs", pch=19, cex=1.5)
dev.off()

#plot 2d
#create dataframe 
table=cbind(pop,e$vectors[,1:3])
dat<-data.frame(table)
colnames(dat)<-c("Population","ID","PC1","PC2","PC3")
dat$PC1 <- as.numeric(dat$PC1)
dat$PC2 <- as.numeric(dat$PC2)
dat$PC3 <- as.numeric(dat$PC3)

#replace pop group 
dat$Population = gsub("Central_Scotland", "CEN", dat$Population)
dat$Population = gsub("Highlands_and_Moray", "HIG", dat$Population)
dat$Population = gsub("SW_Scotland", "SW", dat$Population)
dat$Population = gsub("NE_Scotland", "NE", dat$Population)
dat$Population = gsub("Isle_of_Arran", "ARR", dat$Population)
dat$Population = gsub("Scottish_Borders", "SB", dat$Population)
dat$Population = gsub("Formby", "FOR", dat$Population)

pca1v2 <- ggplot(dat, aes(PC1, PC2, col = Population)) +
  geom_point(aes(col = Population), size = 2, stroke = 1, alpha = 0.8) +
  geom_segment(aes(x = 0, y = -Inf, xend = 0, yend = Inf), linetype="dashed") +
  geom_segment(aes(x = -Inf, y = 0, xend = Inf, yend = 0), linetype="dashed") +
  xlab("PC1= 8.75%")+
  ylab("PC2= 7.74%")+
    scale_colour_manual(values = c("#FD6467","#00a08a","#8D8680",
                                 "#46ACC8","#E6A0C4","#FAD77B","#D8A499")) +
# ggtitle("PCA on covariance matrix of GLs") +
  theme(axis.title = element_blank(),
        panel.background = element_rect(fill="white"),
        panel.border = element_rect(color="black", fill=NA),
        axis.text = element_text(size = 12),
        axis.title.y = element_text(size=12),
        axis.title.x= element_text(size=12),
        legend.position = "none")



pca2v3 <- ggplot(dat, aes(PC2, PC3, col = Population)) +
  geom_point(aes(col = Population), size = 2, stroke = 1, alpha = 0.8) +
  geom_segment(aes(x = 0, y = -Inf, xend = 0, yend = Inf), linetype="dashed") +
  geom_segment(aes(x = -Inf, y = 0, xend = Inf, yend = 0), linetype="dashed") +
  xlab("PC2= 7.74%")+
  ylab("PC3= 6.71%")+
  scale_colour_manual(values = c("#FD6467","#00a08a","#8D8680",
                                 "#46ACC8","#E6A0C4","#FAD77B","#D8A499")) +
  # ggtitle("PCA on covariance matrix of GLs") +
  theme(axis.title = element_blank(),
        panel.background = element_rect(fill="white"),
        panel.border = element_rect(color="black", fill=NA),
        axis.text = element_text(size = 12),
        axis.title.y = element_text(size=12),
        axis.title.x= element_text(size=12),
        legend.position = "right")

pca1v2 + pca2v3 + plot_layout(ncol=2)

#save images
pdf("allsam_pc1v2.pdf", height=8, width=8)
pca1v2
dev.off()

pdf("allsam_pc2v3.pdf", height=8, width=8)
pca2v3
dev.off()

pdf("allsam_pc1v2_pc2v3.pdf", height=8, width=16)
pca1v2 + pca2v3 + plot_layout(ncol=2)
dev.off()

#################reduced data########################

#read in data for all samples
cov<-read.table("\\\\cmvm.datastore.ed.ac.uk\\cmvm\\eb\\users\\mmarr3\\R_all\\r_data\\svul_pca_new\\all_subsam.pcangsd.cov")
pop<- as.matrix(read.table("\\\\cmvm.datastore.ed.ac.uk\\cmvm\\eb\\users\\mmarr3\\R_all\\r_data\\svul_pca_new\\poplist_subsam_pca_red.txt"))
e <- eigen(cov)

#Calulate PC variance (proportions)
#variance<-e$values/sum(e$values)
#print(variance)
#write.csv(variance,file="pcangsd_subsam.csv")

#Convert to percentages
var_percent<-variance * 100
print(var_percent)

#Plot variance 
tiff("varplot_subsam.tiff")
plot(var_percent[0:15],xlab="PC #", ylab="% Variance", 
    cex.axis=1.5,cex.lab=1.5,cex.main=1.8,main="Variance explained in first 15 PCs", pch=19, cex=1.5)
dev.off()

#plot 2d
#create dataframe 
table=cbind(pop,e$vectors[,1:3])
dat<-data.frame(table)
colnames(dat)<-c("Population","ID","PC1","PC2","PC3")
dat$PC1 <- as.numeric(dat$PC1)
dat$PC2 <- as.numeric(dat$PC2)
dat$PC3 <- as.numeric(dat$PC3)

#replace pop group 
dat$Population = gsub("Central_Scotland", "CEN", dat$Population)
dat$Population = gsub("Highlands_and_Moray", "HIG", dat$Population)
dat$Population = gsub("SW_Scotland", "SW", dat$Population)
dat$Population = gsub("NE_Scotland", "NE", dat$Population)
dat$Population = gsub("Isle_of_Arran", "ARR", dat$Population)
dat$Population = gsub("Scottish_Borders", "SB", dat$Population)
dat$Population = gsub("Formby", "FOR", dat$Population)

pca1v2 <- ggplot(dat, aes(PC1, PC2, col = Population)) +
  geom_point(aes(col = Population), size = 2, stroke = 1, alpha = 0.8) +
  geom_segment(aes(x = 0, y = -Inf, xend = 0, yend = Inf), linetype="dashed") +
  geom_segment(aes(x = -Inf, y = 0, xend = Inf, yend = 0), linetype="dashed") +
  xlab("PC1= 8.76%")+
  ylab("PC2= 7.74.00%")+
  scale_colour_manual(values = c("#FD6467","#00a08a","#8D8680",
                                 "#46ACC8","#E6A0C4","#FAD77B","#D8A499","red"))+
  # ggtitle("PCA on covariance matrix of GLs") +
  theme(axis.title = element_blank(),
        panel.background = element_rect(fill="white"),
        panel.border = element_rect(color="black", fill=NA),
        axis.text = element_text(size = 12),
        axis.title.y = element_text(size=12),
        axis.title.x= element_text(size=12),
        legend.position = "none")


pca2v3 <- ggplot(dat, aes(PC2, PC3, col = Population)) +
  geom_point(aes(col = Population), size = 2, stroke = 1, alpha = 0.8) +
  geom_segment(aes(x = 0, y = -Inf, xend = 0, yend = Inf), linetype="dashed") +
  geom_segment(aes(x = -Inf, y = 0, xend = Inf, yend = 0), linetype="dashed") +
  xlab("PC2= 7.74%")+
  ylab("PC3= 6.71%")+
  scale_colour_manual(values = c("#FD6467","#00a08a","#8D8680",
                                 "#46ACC8","#E6A0C4","#FAD77B","#D8A499")) +
  # ggtitle("PCA on covariance matrix of GLs") +
  theme(axis.title = element_blank(),
        panel.background = element_rect(fill="white"),
        panel.border = element_rect(color="black", fill=NA),
        axis.text = element_text(size = 12),
        axis.title.y = element_text(size=12),
        axis.title.x= element_text(size=12),
        legend.position = "right")

#save images
pdf("redsam_pc1v2.pdf", height=8, width=8)
pca1v2
dev.off()

pdf("redsam_pc2v3.pdf", height=8, width=8)
pca2v3
dev.off()

pdf("redsam_pc1v2_pc2v3.pdf", height=8, width=16)
pca1v2 + pca2v3 + plot_layout(ncol=2)
dev.off()



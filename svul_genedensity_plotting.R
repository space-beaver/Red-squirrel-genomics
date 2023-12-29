install.packages("devtools")
library(devtools)
install.packages("RIdeogram")
library(RIdeogram)

setwd("\\\\cmvm.datastore.ed.ac.uk\\cmvm\\eb\\users\\mmarr3\\R_all\\r_data\\svul_snp_density")

#load data 
#data(human_karyotype, package="RIdeogram")
#example<-data(gene_density, package="RIdeogram")
#data(Random_RNAs_500, package="RIdeogram")

#load own data 
squirrel_karyotype <- read.table("squirrel_karyotype.txt", sep = "\t", header = T, stringsAsFactors = F)
head(squirrel_karyotype)

snp_density<-read.table("snp_counts_formatted.txt", header = T)
gene_test<-read.table("gene_density_test.txt", header=T)

#extract gene density
#gene_density <- GFFex(input = "Sciurus_vulgaris-GCA_902686455.2-2020_12-genes.gff3", karyotype = "squirrel_karyotype.txt", feature = "gene", window = 1000000)
#head(gene_density)

#plot with gene density
#ideogram(karyotype = squirrel_karyotype, overlaid = gene_test)
#convertSVG("chromosome.svg", device = "png")

#plot SNP density 
ideogram(karyotype = squirrel_karyotype, overlaid = snp_density, colorset1 = c("#edf8b1", "#7fcdbb", "#2c7fb8"), Lx = 80, Ly = 25)
convertSVG("chromosome.svg", device = "png", dpi = 600)


#visualization (basic)
#ideogram(karyotype, overlaid = NULL, label = NULL, label_type = NULL, synteny = NULL, colorset1, colorset2, width, Lx, Ly, output = "chromosome.svg")
#convertSVG(svg, device, width, height, dpi)





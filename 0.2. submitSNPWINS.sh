#!/bin/sh
# Grid Engine options
#$ -N snpwins
#$ -cwd 
#$ -l h_rt=05:00:00
#$ -l h_vmem=32G
#$ -pe sharedmem 4
#$ -P roslin_prendergast_cores
#$ -e e_snpwin
#$ -o o_snpwin

# Initialise the Modules environment
. /etc/profile.d/modules.sh

#load modules
module load igmm/apps/BEDTools/2.30.0 

#define_dirs 
target_dir=/exports/eddie/scratch/mmarr3/red_squirrel/data

#bedtools makewindows -g chromSizes.txt -w 1000000 > bins.bed

bedtools intersect -a bins.bed -b angsd_merged.vcf.gz -c > snp_counts.txt

awk '{print $1, $2, $3, $4}' snp_counts.txt > snp_counts_formatted.txt
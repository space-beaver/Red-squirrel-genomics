#!/bin/sh
# Grid Engine options
#$ -N pcangsd
#$ -wd /exports/eddie/scratch/mmarr3/red_squirrel/data_out/pcangsd
#$ -l h_rt=48:00:00
#$ -l h_vmem=16G
#$ -pe sharedmem 12
#$ -P roslin_prendergast_cores
#$ -e e_pcangsd
#$ -o o_pcangsd

# Initialise the Modules environment
. /etc/profile.d/modules.sh
source /exports/applications/apps/community/roslin/conda/4.9.1/etc/profile.d/conda.sh

#load modules 
module load anaconda
conda activate pcangsd 

#define dirs 
target_dir=/exports/eddie/scratch/mmarr3/red_squirrel/data_out/snps_gls
out_dir=/exports/eddie/scratch/mmarr3/red_squirrel/data_out/pcangsd

#merge beagle files 
#cp chr1_unlinked.beagle.gz merged_unlinked.beagle.gz
#for i in {1..19}
#do
#  gunzip -c chr${i}_unlinked.beagle.gz | sed 1d | gzip -c
#done >> merged_unlinked.beagle.gz

#prune for individuals,reps are Ind41 and Ind86
#zcat merged_unlinked.beagle.gz | cut -f127,128,129,262,263,264 --complement |  gzip > merged_unlinked_noreps.beagle.gz

#prune for sample size 
#zcat $target_dir/merged_unlinked.beagle.gz | cut -f19,20,21,28,29,30,37,38,39,52,53,54,58,59,60,64,65,66,67,68,69,70,\
#71,72,76,77,78,97,98,99,103,104,105,109,110,111,118,119,120,145,146,147,151,152,153,175,176,177,178,179,180,196,197, \
#198,202,203,204,211,212,213,238,239,240,241,242,243,244,245,246,247,248,249,256,257,258,265,266,267,268,269,270,271, \
#272,273,295,296,297,298,299,300,322,323,324,325,326,327 --complement |  gzip > $target_dir/merged_unlinked_subsam.beagle.gz


#run
#pcangsd -b $target_dir/merged_unlinked_noreps.beagle.gz  -t 12 -o all_noreps.pcangsd 
pcangsd -b $target_dir/merged_unlinked_subsam.beagle.gz  -t 12 -o all_subsam.pcangsd 






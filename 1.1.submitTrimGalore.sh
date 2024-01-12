#!/bin/sh
# Grid Engine options
#$ -N trim_galore
#$ -cwd 
#$ -hold_jid stageinNS  
#$ -l h_rt=10:00:00
#$ -l h_vmem=16G
#$ -t 1-96
#$ -pe sharedmem 4

# Jobscript to run trim_galore

#initialise modules and conda 
. /etc/profile.d/modules.sh

#load modules and conda env
module load roslin/conda/5.5.0
source /exports/applications/apps/community/roslin/conda/4.9.1/etc/profile.d/conda.sh
conda activate trim_galore 

#define dirs
target_dir=/exports/eddie/scratch/mmarr3/red_squirrel
sample_list="/exports/eddie/scratch/mmarr3/red_squirrel/samlisttrim.txt"

#get filelist
base=`sed -n "$SGE_TASK_ID"p $sample_list | awk '{print $1}'`
R1=`sed -n "$SGE_TASK_ID"p $sample_list | awk '{print $2}'`
R2=`sed -n "$SGE_TASK_ID"p $sample_list | awk '{print $3}'`

#process
echo Processing sample: ${base} on $HOSTNAME
echo Processing $R1
echo Processing $R2

trim_galore --paired --fastqc -q 30 -j 4 $target_dir/$R1 $target_dir/$R2 

#remove original files 
rm $R1 $R2

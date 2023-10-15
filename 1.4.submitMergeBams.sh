#!/bin/sh
# SGE options (lines prefixed with #$)
#$ -N runMergeBams.sh
#$ -cwd
#$ -l h_rt=36:00:00
#$ -l h_vmem=16G
#$ -P roslin_prendergast_cores
#$ -t 1:42
#$ -pe sharedmem 4 

# Jobscript to merge bam files 

#Initialise the Modules environment
. /etc/profile.d/modules.sh

#Load modules
module add java
module load roslin/samtools/1.10

#Define dirs
tmp_dir=/exports/eddie/scratch/mmarr3/red_squirrel/final_data/tmp
target_dir=/exports/eddie/scratch/mmarr3/red_squirrel/final_data
samples=/exports/eddie/scratch/mmarr3/red_squirrel/final_data/samlistmerge.txt
picard=/exports/cmvm/eddie/eb/groups/ogden_grp/software/picard/picard.jar

base=`sed -n "$SGE_TASK_ID"p $samples | awk '{print $1}'`
file1=`sed -n "$SGE_TASK_ID"p $samples | awk '{print $2}'`
file2=`sed -n "$SGE_TASK_ID"p $samples | awk '{print $3}'`
file3=`sed -n "$SGE_TASK_ID"p $samples | awk '{print $4}'`

# Need to make this into array job

#merge
java -Xmx10g -jar $picard MergeSamFiles \
     I=$file1 \
     I=$file2 \
     I=$file3 \
     O=$target_dir/${base}_merged.map.sort.dedup.bam \
     TMP_DIR=$tmp_dir

#index
samtools index $target_dir/${base}_merged.map.sort.dedup.bam

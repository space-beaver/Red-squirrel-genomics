#!/bin/sh
# SGE options (lines prefixed with #$)
#$ -N runmarkdups.sh
#$ -cwd
#$ -l h_rt=36:00:00
#$ -l h_vmem=16G
#$ -t 1:96
#$ -pe sharedmem 4 

#script to index bams, remove duplicates, and index 

# Initialise the environment modules
. /etc/profile.d/modules.sh
module load roslin/samtools/1.10
module add java 

#define dirs
sample_list="/exports/eddie/scratch/mmarr3/red_squirrel/samlistbwatxt"
out_dir=/exports/eddie/scratch/mmarr3/red_squirrel
picard=/exports/cmvm/eddie/eb/groups/ogden_grp/software/picard/picard.jar

#get sample lists
base=`sed -n "$SGE_TASK_ID"p $sample_list | awk '{print $1}'`

#process
echo Processing sample: ${base} on $HOSTNAME

#index
#samtools index -@ 4 ${base}.map.sort.bam

#mark dups
java -Xmx10g -jar $picard MarkDuplicates \
INPUT=${base}.map.sort.bam \
OUTPUT=${base}.map.sort.dedup.bam \
REMOVE_DUPLICATES=true \
METRICS_FILE=${base}.metrics.txt \
TMP_DIR=tmp
 
#index 
samtools index -@ 4 ${base}.map.sort.dedup.bam

#remove files 
#rm $base.map.sort.bam
#rm $base.map.sort.bam.bai 



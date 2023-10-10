#!/bin/sh
# SGE options (lines prefixed with #$)
#$ -N runBWA.sh
#$ -hold_jid trim_galore
#$ -cwd
#$ -l h_rt=36:00:00
#$ -l h_vmem=16G
#$ -P roslin_prendergast_cores
#$ -t 1:96
#$ -pe sharedmem 4
#  These options are:

# Initialise the environment modules
. /etc/profile.d/modules.sh
module load roslin/samtools/1.10

#define dirs
bwa_dir=/exports/cmvm/eddie/eb/groups/clark_grp2/software/bwa.kit
ref_dir=/exports/eddie/scratch/mmarr3/red_squirrel/ref_genome
sample_list="/exports/eddie/scratch/mmarr3/red_squirrel/samlist.txt"
refgen=/exports/eddie/scratch/mmarr3/red_squirrel/ref_genome/svul_refgen_mod.fa
out_dir=/exports/eddie/scratch/mmarr3/red_squirrel

#get sample lists
base=`sed -n "$SGE_TASK_ID"p $sample_list | awk '{print $1}'`

#process
echo Processing sample: ${base} on $HOSTNAME

#align 
$bwa_dir/run-bwamem -d -t 21 -o $out_dir/${base} -HR"@RG\tID:${base}\tSM:${base}" $refgen ${base}_R1_001_val_1.fq.gz ${base}_R2_001_val_2.fq.gz | sh

#for some reason bwa.kit sort gives an error so do separately
samtools view -bF 4 -q 30 $out_dir/${base}.aln.bam | samtools sort -o $out_dir/${base}.map.sort.bam

#remove aln file 
rm $out_dir/${base}.aln.bam

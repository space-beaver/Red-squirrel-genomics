#!/bin/sh
# Grid Engine options
#$ -N stats
#$ -cwd 
#$ -M mmarr3@ed.ac.uk
#$ -l h_rt=24:00:00
#$ -l h_vmem=8G
#$ -t 1-108
#$ -pe sharedmem 4
#$ -o o_bwa
#$ -e e_bwa

# Jobscript to align reads to reference, remove dups, 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Load Dependencies and setup env variables #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#Initialise the Modules environment
. /etc/profile.d/modules.sh

#Load modules. mapstat conda env with multiqc and mospdepth
module load roslin/samtools/1.10
module load igmm/apps/BEDTools/2.27.1
module load roslin/conda/4.9.1
source /exports/applications/apps/community/roslin/conda/4.9.1/etc/profile.d/conda.sh
conda activate mapstats

#define_dirs
ref_gen="/exports/eddie/scratch/mmarr3/red_squirrel/ref_genome/svul_refgen_mod.fa"
sample_list="/exports/eddie/scratch/mmarr3/red_squirrel/final_bams/samlist.txt"

#get sample lists
base=`sed -n "$SGE_TASK_ID"p $sample_list | awk '{print $1}'`

#getstats
samtools flagstat ${base}.final.bam > ${base}.flagstat.txt
bedtools genomecov -ibam ${base}.final.bam > ${base}.cov.txt
mosdepth -n --fast-mode -t 4 -Q30 ${base} ${base}.final.bam
multiqc .


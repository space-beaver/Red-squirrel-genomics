#!/bin/sh
# Grid Engine options
#$ -N angsd
#$ -cwd 
#$ -l h_rt=72:00:00
#$ -l h_vmem=32G
#$ -pe sharedmem 12
#$ -t 1:19
#$ -P roslin_prendergast_cores

#estimates genotype likelihoods with GATK
#calulates allele frequencies 
#calls and filters SNPS 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Load Dependencies and setup env variables #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#Initialise the Modules environment
. /etc/profile.d/modules.sh

#Load java
module add java

#setdirs
angsd=/exports/cmvm/eddie/eb/groups/clark_grp2/software/angsd
bams="/exports/eddie/scratch/mmarr3/red_squirrel/final_bams/squirrel.bamlist"
target_dir=/exports/eddie/scratch/mmarr3/red_squirrel/final_bams
ref_gen=/exports/eddie/scratch/mmarr3/red_squirrel/ref_genome/svul_refgen_mod.fa

#run and input parameters 
$angsd/angsd \
  -bam $bams \
  -ref $ref_gen \
  -P 12 \
  -out $target_dir/chr${SGE_TASK_ID} \
  -r ${SGE_TASK_ID} \
  -uniqueOnly 1 \
  -minInd 55 \
  -remove_bads 1 \
  -only_proper_pairs 1 \
  -trim 0 \
  -C 50 \
  -baq 1 \
  -minMapQ 30 \
  -minQ 20 \
  -doCounts 1 \
  -GL 2 \
  -doGlf 2 \
  -doMajorMinor 4 \
  -doMaf 1 \
  -SNP_pval 1e-06 \
  -doPost 1 \
  -doGeno 2 \
  -setMinDepth 205 \
  -setMaxDepth 750 \
  -doPlink 2 \
  -dobcf 1
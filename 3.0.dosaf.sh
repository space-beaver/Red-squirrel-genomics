#!/bin/sh
# Grid Engine options
#$ -N dosaf
#$ -cwd
#$ -l h_rt=76:00:00
#$ -l h_vmem=32G
#$ -pe sharedmem 8
#$ -o o_saf
#$ -e e_saf
#$ -t 1-19

#define variables
ANGSD=/exports/cmvm/eddie/eb/groups/clark_grp2/software/angsd/angsd
ANC=/exports/eddie/scratch/mmarr3/ref_genome/svul_refgen.fa
REF=/exports/eddie/scratch/mmarr3/ref_genome/svul_refgen.fa

#dosaf, change min max depth per pop
OPT="-dosaf 1 -gl 2 -P 8 -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 -doCounts 1 -setMinDepth 6 -setMaxDepth 30 -minMapQ 30 -minQ 30"

#run saf
$ANGSD -b arr_list.txt -anc $ANC -ref $REF -r ${SGE_TASK_ID} -out chr${SGE_TASK_ID}_sfs $OPT 

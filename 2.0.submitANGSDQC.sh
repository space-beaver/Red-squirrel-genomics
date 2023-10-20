#!/bin/sh
# Grid Engine options
#$ -N angsdqc
#$ -cwd 
#$ -l h_rt=36:00:00
#$ -l h_vmem=16G
#$ -pe sharedmem 10
#$ -o o_QC
#$ -e e_QC
#$ -t 1-19
#$ -P roslin_prendergast_cores

# Initialise the Modules environment
. /etc/profile.d/modules.sh

# Load java
module add java

#define_dirs
angsd=/exports/cmvm/eddie/eb/groups/clark_grp2/software/angsd
bam_list=/exports/eddie/scratch/mmarr3/red_squirrel/final_bams
out_dir=/exports/eddie/scratch/mmarr3/red_squirrel/final_bams
ref_gen=/exports/eddie/scratch/mmarr3/red_squirrel/ref_genome/svul_refgen_mod.fa
region_file="/exports/eddie/scratch/mmarr3/red_squirrel/final_bams/regions.txt"

#input
$angsd/angsd -bam $bam_list -P 10 -b $bam_list/squirrel.bamlist \
-ref $ref_gen -out $out_dir/${SGE_TASK_ID}.qc -uniqueOnly 1 -remove_bads 1 \
-only_proper_pairs 1 -trim 0 -C 60 -baq 1 -minMapQ 30 -doQsDist 1 \
-doDepth 1 -doCounts 1 -maxDepth 800 -r ${SGE_TASK_ID}
 

#!/bin/sh
# Grid Engine options
#$ -N ngsld
#$ -cwd 
#$ -l h_rt=24:00:00
#$ -l h_vmem=16G
#$ -pe sharedmem 8
#$ -o o_ngsld
#$ -e e_ngsld
#$ -t 1:19
#$ -P roslin_prendergast_cores

#define dirs 
ngsld=/exports/cmvm/eddie/eb/groups/ogden_grp/software/ngsTools/ngsLD
target_dir=/exports/eddie/scratch/mmarr3/red_squirrel/data
ref_gen=/exports/eddie/scratch/mmarr3/red_squirrel/ref_genome/svul_refgen_mod.fa

#modules
. /etc/profile.d/modules.sh

#Load java
module add java 
module load roslin/conda/4.9.1
source /exports/applications/apps/community/roslin/conda/4.9.1/etc/profile.d/conda.sh
conda activate myperl 
cpanm Graph::Easy 

#prep files, no downsampling
zcat $target_dir/chr${SGE_TASK_ID}.beagle.gz | awk 'NR % 5 == 0' | cut -f 4- | gzip   > $target_dir/chr${SGE_TASK_ID}_subsam.beagle.gz 
zcat $target_dir/chr${SGE_TASK_ID}.mafs.gz | cut -f 1,2 |  awk 'NR % 5 == 0' | sed 's/:/_/g'| gzip > $target_dir/chr${SGE_TASK_ID}_subsam.pos.gz


nsites=$(zcat chr${SGE_TASK_ID}_subsam.pos.gz | wc -l)
echo $nsites

#run ngsld
$ngsld/ngsLD \
--geno $target_dir/chr${SGE_TASK_ID}_subsam.beagle.gz   \
--pos $target_dir/chr${SGE_TASK_ID}_subsam.pos.gz \
--probs \
--n_ind 108 \
--n_sites $nsites \
--min_maf 0.05 \
--max_kb_dist 1000 \
--out $target_dir/chr${SGE_TASK_ID}.ld 


#prune 
perl $ngsld/scripts/prune_graph.pl \
  --in_file chr${SGE_TASK_ID}.ld \
  --max_kb_dist 2000 \
  --min_weight 0.5 \
  --out chr${SGE_TASK_ID}_unlinked.id



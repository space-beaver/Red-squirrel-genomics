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
#$ -P roslin_faang

#define dirs 
ngsld=/exports/cmvm/eddie/eb/groups/ogden_grp/software/ngsTools/ngsLD
target_dir=/exports/eddie/scratch/mmarr3/snps_gls
ref_gen=/exports/eddie/scratch/mmarr3/ref_genome/svul_refgen.fa

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
  
#in R 
#basedir="/exports/eddie/scratch/mmarr3/snps_gls/"

#for single file 
#pruned_position <- as.integer(gsub("1:", "", readLines(paste0(basedir, "chr1_unlinked.id"))))
#snp_list <- read.table(paste0(basedir, "chr1.mafs.gz"), stringsAsFactors = F, header = T)[,1:4]
#pruned_snp_list <- snp_list[snp_list$position %in% pruned_position, ]
#write.table(pruned_snp_list, paste0(basedir, "chr1_LDpruned_snps.list"), col.names = F, row.names = F, quote = F, sep = "\t")

#loop 
#for(chr in 1:19) {
#  pruned_position <- as.integer(gsub(paste0(chr, ":"), "", 
#  readLines(paste0(basedir, paste0("chr", chr, "_unlinked.id")))))
#  snp_list <- read.table(paste0(basedir, paste0("chr", chr, ".mafs.gz")), stringsAsFactors = F, header = T)[,1:4]
#  pruned_snp_list <- snp_list[snp_list$position %in% pruned_position, ]
#  write.table(pruned_snp_list[,c(1,2)], paste0(basedir, paste0("chr", chr, "_LDpruned_snps.list")),
#             col.names = F, row.names = F, quote = F, sep = "\t")
#}


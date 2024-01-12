#!/bin/sh
# Grid Engine options
#$ -N merge
#$ -cwd 
#$ -l h_rt=05:00:00
#$ -l h_vmem=8G
#$ -pe sharedmem 4
#$ -o o_m
#$ -e e_m


/exports/cmvm/eddie/eb/groups/clark_grp2/software/angsd/misc/realSFS \
cat  chr1_sfs.saf.idx  chr2_sfs.saf.idx chr3_sfs.saf.idx chr4_sfs.saf.idx \
chr5_sfs.saf.idx chr6_sfs.saf.idx chr7_sfs.saf.idx chr8_sfs.saf.idx chr9_sfs.saf.idx \
chr10_sfs.saf.idx chr11_sfs.saf.idx chr12_sfs.saf.idx chr13_sfs.saf.idx  \
chr14_sfs.saf.idx chr15_sfs.saf.idx chr16_sfs.saf.idx chr17_sfs.saf.idx \
chr18_sfs.saf.idx chr19_sfs.saf.idx -outnames arr_merged -P 8
 

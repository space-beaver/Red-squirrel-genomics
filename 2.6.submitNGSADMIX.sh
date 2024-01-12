#!/bin/sh
# Grid Engine options
#$ -N ngsadmix
#$ -hold_jid pcangsd
#$ -cwd 
#$ -l h_rt=72:00:00
#$ -l h_vmem=32G
#$ -pe sharedmem 12
#$ -t 1-20
#$ -e e_admix
#$ -o o_admix

# Initialise the Modules environment
. /etc/profile.d/modules.sh

ngsadmix=/exports/cmvm/eddie/eb/groups/clark_grp2/melissa/software/
target_dir=/exports/eddie/scratch/mmarr3/red_squirrel/data

for i in 1 2 3 4 5 6 7 8 9 10
do
	$ngsadmix/NGSadmix \
	-likes merged_unlinked_noreps.beagle.gz \
	-K ${SGE_TASK_ID} \
	-P 1 \
	-seed $i \
	-o $target_dir/NGSadmix_K${SGE_TASK_ID}_run${i}_noreps
done

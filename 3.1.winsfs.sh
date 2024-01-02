#Grid Engine options
#$ -N win
#$ -cwd
#$ -M mmarr3@ed.ac.uk
#$ -l h_rt=48:00:00
#$ -l h_vmem=64G
#$ -pe sharedmem 8
#$ -e e_win
#$ -o o_win
#$ -P roslin_faang

#initialise mod env
. /etc/profile.d/modules.sh

#load modulea
module load roslin/conda/4.9.1
source /exports/applications/apps/community/roslin/conda/4.9.1/etc/profile.d/conda.sh
conda activate rust

#add winsfs to path 
export PATH="$HOME/.cargo/bin:$PATH"

#define dirs
TARGET_DIR=/exports/eddie/scratch/mmarr3/sfs/arr

#run winsfs
winsfs ${TARGET_DIR}/arr_merged.saf.idx > arr.sfs

#fold 
winsfs view --fold ${TARGET_DIR}/arr.sfs > arr_folded.sfs

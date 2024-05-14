#!/bin/bash
#SBATCH --time=2:00:00
#SBATCH --mem=64GB
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH --error=/scratch3/bon136/results/slurm-%A_%a.err
#SBATCH --output=/scratch3/bon136/results/slurm-%A_%a.out
#SBATCH --account=OD-228587

#
# Submit runs from a file with each run per line
#
# submit many jobs as an array of jobs
# use e.g. sbatch -a 0-999 experiments/submit_to_cluster_from_file.sh input_file.txt
# where 0-999 are the range of the indices of the jobs
#
module load miniconda3
source /apps/miniconda3/enable_miniconda.sh
conda activate /scratch3/bon136/miniconda3/envs/bayesdag_condaenv

IFS=$'\n' read -d '' -r -a lines < ${1}

# Submit job
if [ ! -z "$SLURM_ARRAY_TASK_ID" ]
then
    i=$SLURM_ARRAY_TASK_ID
    echo ${lines[i]}
    eval "${lines[i]}"
else
    echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
fi


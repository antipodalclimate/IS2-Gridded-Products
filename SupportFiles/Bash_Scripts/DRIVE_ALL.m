#!/bin/bash

#SBATCH -t 48:00:00
#SBATCH -n 8
#SBATCH -N 1
#SBATCH -p batch
#SBATCH --mem=0
#SBATCH --account=epscor-condo
#SBATCH --mail-user=bndnchrs@gmail.com 
#SBATCH --mail-type=ALL
#SBATCH -J=bybeam
# #SBATCH --constraint=skylake
# #SBATCH --exclusive

module load matlab

cd /gpfs/data/epscor/chorvat/IS2/IS2-Gridded-Products/

matlab-threaded -nodisplay -nojvm -nodesktop -r "super_driver, exit"


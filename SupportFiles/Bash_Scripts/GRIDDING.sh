#!/bin/bash

#SBATCH -t 48:00:00
#SBATCH -n 1
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

matlab-threaded -r "config_all, cd('Gridding/'),  drive_gridding, exit"




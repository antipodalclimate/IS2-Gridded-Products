#!/bin/bash

#SBATCH -t 12:00:00
#SBATCH -n 8
#SBATCH --mem=0
#SBATCH --account=epscor-condo
#SBATCH --mail-user=bndnchrs@gmail.com 
#SBATCH --mail-type=ALL
#SBATCH -J=conversion
# #SBATCH --constraint=skylake
# #SBATCH --exclusive

module load matlab

cd /gpfs/data/epscor/chorvat/IS2/IS2-Gridded-Products/Conversion/Drivers/
matlab-threaded -r "drive_conversion, exit"


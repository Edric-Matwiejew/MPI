#!/bin/bash
#
# An example slurm script for a job using MPI.
#
#SBATCH --job-name=mpi_job             # the job's name
#SBATCH --nodes=1                      # Always set to 1 on the QUISA workstation
#SBATCH --ntasks=16                    # number of tasks (or 'programs')
#SBATCH --cpus-per-task=1              # number of threads per task
#SBATCH --mem=8000MB                   # RAM requested for the task
#SBATCH --time=00:10:00                # time limit hrs:min:sec
#SBATCH --output=mpi_example.log       # redirect the task terminal output to a *.log
#SBATCH --partition=coursework         # partition to which the job is submitted

export OMP_NUM_THREADS=1 # set the number of OpenMP threads

module load gcc/
module load open-mpi/4.1.0   # prepare the environment for mpi
module load python3.9/3.9.2  # load any other modules needed

time mpiexec -N 4 python3 your_program.py

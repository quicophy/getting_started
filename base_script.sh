#!/bin/bash
#SBATCH -p c-iq                        # To use the IQ cluster, or -p c-aphex to use our machine
#SBATCH --job-name=output              # The name of the file in which your outputs will be printed
#SBATCH --time=01:00:00                # Time given to run your job (1 hour in this case)
#SBATCH --account=def-ko1              # Keep this as it is
#SBATCH --cpus-per-task=1              # Asked CPUs per task for your job
#SBATCH --mem=40GB # Memory per node   # Memory asked for your job
#SBATCH --mail-user=<your email>       # Receive a notification when your jobs finish running
#SBATCH --mail-type=ALL

# Define virtual environment name and the files' names
env_name="venv"            # Virtual environment name
python_script="job.py"     # job's file name

# Load important modules
module load python/3.9     # Useful to use Python version 
module load scipy-stack

# Activate your virtual environment
source "$env_name"/bin/activate

# Run your python job
python -u "$python_script"

# Deactivate the virtual environment once the job is finished
deactivate

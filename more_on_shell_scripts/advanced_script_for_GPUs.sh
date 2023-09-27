#!/bin/bash
#SBATCH -p c-iq                        # To use the IQ cluster, or -p c-aphex to use our machine
#SBATCH --nodelist=cp3705              # Specify this node to have access to GPUs in the IQ cluster
#SBATCH --job-name=output              # The name of the file in which your outputs will be printed
#SBATCH --time=01:00:00                # Time given to run your job (1 hour in this case)
#SBATCH --account=def-ko1              # Keep this as it is
#SBATCH --output=Outputs/%x-%a.out     # Outputs files will be saved in this `Outputs` folder which you need to create in the same directory that this script is in
#SBATCH --cpus-per-task=1              # Asked CPUs per task for your job
#SBATCH --mem=8GB                      # Memory asked for your job
#SBATCH --array=0-9                    # Send 10 jobs in parallel (you can add %value to limit to `value` jobs running simultaneously)
#SBATCH --mail-user=<your email>       # Receive a notification when your jobs finish running
#SBATCH --mail-type=ALL



# Define virtual environment name and the files' names
env_name="venv"                           # Virtual environment name
requirements="requirements.txt"           # File name containing the packages of the virtual environment
python_script="job.py"                    # Your job's file name

# Function to box any message in `#` symbol (message: str)
display_boxed_message() {
    local message="$1"
    local message_length=${#message}
    local box_width=$((message_length + 2))  # Add padding of 2 on each side
    local horizontal_line=$(printf "%${box_width}s" | tr ' ' '#')
    echo -e "\n##$horizontal_line##"
    printf "#  %s  #\n" "$message"
    echo -e "##$horizontal_line##\n"
}

# Define environment variables
GPU_TO_USE=$(python -c "print($SLURM_ARRAY_TASK_ID%2)")
export CUDA_VISIBLE_DEVICES=$GPU_TO_USE
# export TF_FORCE_UNIFIED_MEMORY=1 # Use CPU and GPU memory for jax.numpy

# Load important modules
module load python/3.9 StdEnv/2020 gcc/9.3.0
module load cuda/11.4 cudnn/8.2
module load scipy-stack

# Build the fresh new environment in the temporary directory in which your jobs run
python3.9 -m venv $SLURM_TMPDIR/"$env_name"
source $SLURM_TMPDIR/"$env_name"/bin/activate
pip install --upgrade pip --no-index > /dev/null
pip install -r "$requirements" --no-index > /dev/null

# Show useful information
display_boxed_message "Built environment contains the following packages"
pip freeze
display_boxed_message "GPU information"
nvidia-smi

# Run your job
display_boxed_message "Python script output"
python -u "$python_script" $SLURM_ARRAY_TASK_ID

# Deactivate the virtual environment once the job is finished
deactivate

If you take a look at the `advanced_script.sh` file, you may think that there is a lot going on, but let's break it down step by step.

# SBATCH commands
First, we see that 2 `SBATCH` commands were added at the top of the file. They are the following:
- `#SBATCH --output=Outputs/%x-%a.out`
- `#SBATCH --array=0-9`

What the first one is doing is simply specify the directory in which you will to save the `.out` files of our jobs so that you know where to find them (in the `Outputs/` folder). There is also the `%x` and the `%a` that are specified in this command. They simply mean that the output files will have the form `<job-name>-<array_task_id>.out`. This makes it easy to go find what you are looking for when searching for outputs.

The second one is where it gets interesting for speeding up your data collection, if you can. If, for instance, you want to evaluate some mean value over 10 samples, that would mean that your code would have to run 10 times with one changing parameter. If each of those samples takes around 2 hours to run, then your whole job would take around 20 hours to finish, which can get pretty long when you need the data. This command lets you parallelize your code by dividing it in 10 arrays, one for each parameter value.

# File variables
You can see that the variable `requirements` has been added at line 17. This one will be used later on in the script to build your virtual environment.

# The `display_boxed_message()` function
This function lets you print any message boxed in the `#` symbol in your `.out` files. An example could be `display_boxed_message "Hello World!"`, for which the output would look like :

```bash
##################
#  Hello World!  #
##################
```

# Building your virtual environment in a temporary directory
This section lets you use the `$SLURM_TMPDIR` variable to build a fresh new virtual environment that is temporary. It uses the `python3.9 -m venv $SLURM_TMPDIR/"$env_name"` command to generate the virutal environment and activates it with `source $SLURM_TMPDIR/"$env_name"/bin/activate`. It then upgrades the `pip` package to its most recent version, and then installs all the packages you have in your requirements file. This file's name is stored in the `requirements` variable defined earlier (line 17). At this point, your virtual environment is activated and should contain all your needed packages with their correct versions. Just to verify this statement, there is the `pip freeze` that will print out all the packages in the newly generated virtual environment and their versions.

# What if you want to use GPUs ?
In python, there are packages that are similar to `numpy` that lets you use the power of GPUs almost automatically, like `cupy` and `jax`.

If you want to use the available GPUs in the IQ cluster, take a look at the `advanced_script_for_GPUs.sh` file, which is a slightly modified version of the `advanced_script.sh` file. First, we see that there is a new command at the top of the script: `#SBATCH --nodelist=cp3705`. This node is specified because the GPUs are only available on this one.

Next, you can see that there is a section for environment variables. This one could be useful if your jobs take a lot of memory to execute, because it separates the even and odd array task ids into the 2 available GPUs in the IQ cluster. It does so by defining the `GPU_TO_USE` variable and use it to define the environment variable `CUDA_VISIBLE_DEVICE`. If your jobs don't need a big amount of memory, then you can comment out/erase those 2 lines.

Then, you can see that there is a new line in the modules section. This one is necessary because you can't use the available GPUs without the `cuda` and `cudnn` modules.

Finally, the new command is `nvidia-smi` at line 51. This one lets you see information about the available GPUs in the cluster.

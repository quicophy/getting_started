# Connect to the clusters, find your folder.
## Connect
To connect to the cluster enter the following command in your Linux terminal: `ssh <CC_username>@<cluster>.computecanada.ca` .

In place of `<CC_username>` enter your compute canada ID.

In place of `<cluster>` enter one of the following cluster name: 
- ``beluga``
- ``cedar``
- ``narval``
- ``graham``
- ``niagara``
If instead you wish to connect to clusters located at the University of Sherbrooke, like Mammoth, the IQ server or our own cluster Aphex, enter: `ssh <CC_username>@ip09.ccs.usherbrooke.ca`.

Press `enter`, and tape your password. You're in.

## Your working folder.
To find your folder on regular CC clusters enter the following command in your terminal: ``cd projects/def-ko1/<CC_username>`` .

For clusters at UdeS use preferably: ``cd /net/nfs-iq/data/<CC_username>/`` .

You're ready to work !

## Exit.

To exit enter ``logout`` in your terminal and press enter.


**More information can be found on the following [link](https://calcul-haute-performance-iq-sherbrooke.github.io/).** 

# Upload your project
There are 2 possibilities to send your project to the cluster :
- `scp`
- `github`
For `scp`, it is simply a Secure Copy of your folder that is sent to the cluster using the `ssh` protocol. In order to use this method, you should open your local Linux terminal on the path on which the project you want to send is. You can call this method like this :
`scp <file_name> <CC_username>@<cluster>.computecanada.ca:/home/<CC_username>/projects/def-ko1/<CC_username>/`

You'll have to enter your password at first. You can avoid this by working with the `ssh` keys mentionned at the start.

You can also simply use `github` to download your project on the cluster using the command `git clone <your_github_repo>`.

# Send a simple job
In order to send your first job on your chosen server, you will have to use a `bash` script. This kind of script lets you group successive terminal commands that will be automatically executed. The one given in this repo (`base_script.sh`) is a good start (of course, you can add any other commands that suit your needs when you get more familiar with it). Read the comments in this script to see what each commands are doing.

In general, this script is placed in the same folder that contains your main `python` script.

As you can see in the script, one of the lines corresponds to your `python` script's name. The command needed to run your job will be the following :
`sbatch base_script.sh`

By running the `sq` command in the terminal, you will be able to see if your job has been sent (`PD`: job is pending, `R`: job is running).

When your job is done, you will see a `.out` file that contains the printed outputs of your `python` job. You can display it with the following command :
`cat <output_file>.out`

You should also see the output of your job ready to be downloaded.

# Download your data
In order to send your newly acquired data, you can use the following command :
`scp <CC_username>@<cluster>.computecanada.ca:/home/<CC_username>/projects/def-ko1/<CC_username>/<file_name> .`

The `.` at the end signifies that your data will end up in the folder your local terminal is already opened in. You can also specify the path where you want them to go by replacing this `.`.

In the case that your data is made of multiple small files in a subfolder, it can be more efficient to compress this folder to download everything at once. To do it, you can use the following command :
`tar -czf <data_folder>.tar.gz <data_folder>`
You now have your compressed folder that you can download using `scp`. To decompress on your local machine, enter the following command :
`tar -xvf <data_folder>.tar.gz`

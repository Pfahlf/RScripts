# RScripts

## Installation 

```
git clone https://github.com/Pfahlf/RScripts.git

cd Rscripts

chmod 777 run.sh

sudo apt-get install jq

sudo apt-get install cron
```


## Script setup

Those steps need to be done only once, after the first installation

### Step 1 -- Setting up R scripts folder
The script requires to have all <b>R Scripts</b> that we want to run in a cron job inside the same folder.
Suppose we have all the R scripts inside a folder `/home/rscrpt/`, then

Paste the path inside `run.sh` by modyfing the variable `R_SCRIPTS_PATH`

```
R_SCRIPTS_PATH="/home/rscrpt/"
```

inside the folder `rscrpt` we can have insidide as man Rscript as we want.

### STEP 2 -- Setting up Rscript command path

Run the following command in the vm, and remember the output
```
$ which Rscript
/usr/bin/Rscript
```

Paste the ouput inside `run.sh` by modyfing the variable `RSCRIPT_CMD_PATH`
```
RSCRIPT_CMD_PATH="/usr/bin/Rscript"
```



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

## Defining Cron Jobs for R scripts
In order to define which r script has to run and when, you need to modify the `data.json` 

The `script_name` is the name of the script that we find inside the folder defined above (in this example `/home/rscrpt/`)

In the belowe example, `test.R` runs every minute, while `test1.R` runs every hour.

```
[
    {
        "script_name" : "test.R",
        "script_time" : {
            "time" : "1",
            "format" : "minute"
        }
    },
    {
        "script_name" : "test1.R",
        "script_time" : {
            "time" : "1",
            "format" : "hour"
        }
    }
]
```




## Running the Scripts

Simply run the following command after having done the previsout steps:
```
./run.sh
```

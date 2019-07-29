#!/bin/bash

declare -a script_array
declare -a script_time_data
declare -a script_cron_format

## DONOT MODIFY THIS
SCRIPT_PATH=$PWD"/"
CRONTABS_PATH=$PWD"/crontab/"
DATA_JSON_PATH=$SCRIPT_PATH"data.json"
U_CRON_FILE_PATH="$PWD"/crontab/"$(date +%Y%m%d_%H%M%s)".cron""

## MODIFY THIS
RSCRIPT_CMD_PATH="/usr/bin/Rscript"
R_SCRIPTS_PATH=$PWD"r_scripts_test/"



run () {
    print_start 
    read_json
    script_handler
}

read_json() {
    while IFS="=" read -r key value
    do
        script_array[$key]="$value"
    done < <(jq -r "to_entries|map(\"\(.key)=\(.value)\")|.[]" $DATA_JSON_PATH)
}

script_handler(){
    for key in "${!script_array[@]}"
    do
        script_name=$(jq '.script_name' <<< ${script_array[$key]}) 
        script_time=$(jq '.script_time.time' <<< ${script_array[$key]})
        script_format=$(jq '.script_time.format' <<< ${script_array[$key]})

        generate_cron_string
        print_info        
    done
    reset_crontab
    start_crontab
    print_exit
}


generate_cron_string(){
    script_time_format=$(
        case "$script_format" in
            (*"minute"*) echo "0" ;;
            (*"hour"*) echo "1" ;;
            (*"day"*) echo "2" ;;
            (*"hour"*) echo "3" ;;
            (*) echo "NA" ;;
        esac)
    DESTINATIONS=""
    for i in 0 1 2 3 4 
        do
            if [ $i == $script_time_format ]; then
                DESTINATIONS+=" */${script_time} "
            else
                if [ "$i" -le "$script_time_format" ];then
                    DESTINATIONS+=' 1 '
                else 
                    DESTINATIONS+=' "\*" '
                fi 
            fi    
        done
    get_final_cron_string
    create_crontab_file
}
get_final_cron_string(){
    final_cron_time_string="$(echo $DESTINATIONS | sed 's|[\\]||g')"
    echo $final_cron_time_string
    final_cron_script_name="$(echo $script_name | sed 's/["]//g')"
    final_cron_string="$final_cron_time_string $RSCRIPT_CMD_PATH $R_SCRIPTS_PATH$final_cron_script_name"
}

create_crontab_file(){
    echo $final_cron_string "> "$SCRIPT_PATH"logs/"$script_name"_temp.log 2>&1 || cat "$SCRIPT_PATH"logs/"$script_name"_temp.log && cat "$SCRIPT_PATH"logs/"$script_name"_temp.log >> "$SCRIPT_PATH"logs/"$script_name"$(date +%Y%m%d_%H%M%s)""_persistent.log && rm "$SCRIPT_PATH"logs/"$script_name"_temp.log" | tr -d "\"" >> $U_CRON_FILE_PATH 
}

reset_crontab(){
    crontab -r
}

start_crontab(){
    crontab $U_CRON_FILE_PATH
}

print_kv(){
    for key in "${!script_array[@]}"
    do
        echo $(jq '.script_name' <<< "${script_array[$key]}") 
        echo $(jq '.script_time.time' <<< "${script_array[$key]}")
        echo $(jq '.script_time.format' <<< "${script_array[$key]}")
    done
}

print_info(){
    echo "----- ---- SCRIPT ---- -----"
    echo "Starting" $script_name 
    echo "Running every" $script_time $script_format
    echo "----- ---- ---- -----"
    echo ""
}

print_start(){
    echo "----- ---- START ---- -----"
    echo "Starting Ads Script Runner"
    echo "----- ---- ---- -----"
    echo ""
}

print_exit(){
    crontab -l
}
run
#!/bin/bash
export HF_ENDPOINT="https://hf-mirror.com"

BASE_CONTENT_DIR="../data/cnt/"
BASE_STYLE_DIR="../data/sty/A_style/"
OUTPUT_DIR_PREFIX="../result/"

MAX_NUM=15

content_number=0

for ((folder_number = 1; folder_number < $MAX_NUM; folder_number++)); do
        CONTENT_DIR="${BASE_CONTENT_DIR}$(printf "%02d" $folder_number)"
        STYLE_DIR="${BASE_STYLE_DIR}$(printf "%02d" $folder_number)/images"
        OUTPUT_DIR="${OUTPUT_DIR_PREFIX}$(printf "%02d" $folder_number)"
        if [ ! -d "${OUTPUT_DIR}" ]; then
            mkdir "${OUTPUT_DIR}"
        fi
        for content_file in "$CONTENT_DIR"/*; do  
            ((content_number++))
            Final_CONTENT_DIR="${CONTENT_DIR}/$(basename "$content_file")"
            Final_OUTPUT_DIR="${OUTPUT_DIR}/$(basename "$content_file")"  
            
            file_count=$(find $STYLE_DIR -maxdepth 1 -type f | wc -l)
            style_number=0
            
            correct_index=$(( content_number % file_count ))
            ((correct_index++))
            
            for style_file in "$STYLE_DIR"/*; do     
                ((style_number++))
                
               if [ $correct_index -eq $style_number ]; then
                    Final_STYLE_DIR="${STYLE_DIR}/$(basename "$style_file")" 
                    break
                else 
                    continue
                fi
            done           
            COMMAND="python run_styleid_diffusers.py\
                --cnt_fn=$Final_CONTENT_DIR \
                --sty_fn=$Final_STYLE_DIR \
                --save_dir=$Final_OUTPUT_DIR\
                --gamma 0.7"
            echo "运行命令："$COMMAND
            eval $COMMAND
            wait
        done
        wait
done

COMMAND_cd="cd /"
COMMAND_cd_result="cd /root/styleid/result"
COMMAND_tar="tar -cvf result.tar ./*"
COMMAND_cd_styleid="cd ../"

eval $COMMAND_cd
eval $COMMAND_cd_result
eval $COMMAND_tar
eval $COMMAND_cd_styleid
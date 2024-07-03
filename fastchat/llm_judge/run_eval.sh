#!/bin/bash

BENCHES=(
"mt_bench_jp" 
"mt_bench_it"
"mt_bench_es" 
"mt_bench_de"
"mt_bench_fr"
"mt_bench_nl"
"mt_bench_pt"
# "oasst_multilingual"
"mt_bench"
"mt_bench_bengali"
"mt_bench_gujarati"
"mt_bench_hindi"
"mt_bench_urdu"
"mt_bench_thai"
"mt_bench_tamil"
)

# Add model paths
MODELS=(

)

# Global parameter for total number of GPUs
NUM_GPUS_TOTAL=1

# Function to extract model-id from model path and add _1
get_model_id() {
    local model_path=$1
    # Remove any trailing slashes
    model_path=$(echo "$model_path" | sed 's:/*$::')
    # Extract everything after axolotl and replace slashes with underscores
    echo "${model_path#*/axolotl/}" | sed 's:/:_:g'
}

model_ids=()
for model_path in "${MODELS[@]}"; do
    model_ids+=($(get_model_id "$model_path"))
done

model_list="${model_ids[*]}"

for bench in "${BENCHES[@]}"; do
    echo "Running command for language: $bench"
    
    for model_path in "${MODELS[@]}"; do
        model_id=$(get_model_id "$model_path")
        echo 
        model_answer_path="./data/${bench}/model_answer/${model_id}.jsonl"
        
        if [ -f "$model_answer_path" ]; then
            num_records=$(jq -c '.' "$model_answer_path" | wc -l)
            if [ "$num_records" -eq 80 ]; then
                echo "Model answer for $model_id already exists with 80 records. Skipping..."
                continue
            fi
        fi

        echo "Running for model: $model_id with path: $model_path"

        python gen_model_answer.py --model-path "$model_path" --model-id "$model_id" --bench-name "$bench" --num-gpus-per-model 1 --num-gpus-total "$NUM_GPUS_TOTAL"
    done
done

for bench in "${BENCHES[@]}"; do
    echo "Running judgements for language: $bench"
    
    if [ "$bench" == "mt_bench" ]; then
        python gen_judgment.py --model-list ${model_ids[@]}  --bench-name "$bench" --parallel 10
    else
        python gen_judgment.py --model-list ${model_ids[@]}  --bench-name "$bench" --parallel 10 --judge-file data/judge_prompts_multilingual.jsonl --multilingual
    fi

    python show_result.py --model-list ${model_ids[@]}  --bench-name "$bench"
done

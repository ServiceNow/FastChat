## Steps to Run Multilingual MT Bench

1. Run the commands below to setup Fastchat.
```
   git clone https://github.com/RishabhMaheshwary/FastChat.git
   cd FastChat
   pip install -e ".[model_worker,llm_judge]"
```
2. Add the pretrained model paths [here](https://github.com/RishabhMaheshwary/FastChat/blob/1f1733b5bd0257559c33b698987bd7b1fbe65713/fastchat/llm_judge/run_eval.sh#L22).

3. Use the [`run_eval.sh`](https://github.com/RishabhMaheshwary/FastChat/blob/main/fastchat/llm_judge/run_eval.sh) script to run evaluations across all MT bench languages. 

4. The GPT-4 prompt used for multilingual evaluation is available [here](https://github.com/RishabhMaheshwary/FastChat/blob/main/fastchat/llm_judge/data/judge_prompts_multilingual.jsonl).


### Citation

Please cite the paper if you use the data or code from M2Lingual.

```
@misc{maheshwary2024m2lingual, 
title={M2Lingual: Enhancing Multilingual, Multi-Turn Instruction Alignment in Large Language Models},
author={Rishabh Maheshwary and Vikas Yadav and Hoang Nguyen and Khyati Mahajan and Sathwik Tejaswi Madhusudhan},
year={2024},
eprint={2406.16783},
archivePrefix={arXiv},
}
```

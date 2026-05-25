
## Create a new workspace brazil 
`ws create -n mlae `

## Change into the workspace directory cd mlae 

# Add the MLAEService package 
`brazil ws use -p MLAEService `

# Sync the workspace 
`brazil workspace sync`

`./run.sh --dataset-group=internal --model-group=bench  --force-sample-refresh`

`CUDA_VISIBLE_DEVICES=3  ./run.sh --dataset-group=internal --model-id=mlae-classifier-v1.5`

```
./run.sh --dataset-group=tabpfn-29c
--config-path=src/mlae_benchmarking_experiment/configs/classification_openml.py
--model-id=mlae-classifier-v1.5
```





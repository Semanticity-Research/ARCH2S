<!-- <p align="center">
ARCH2S: A Dataset and Benchmark for Learning Exterior Architetural Strutures
</p> -->


<p align="center" style="font-size:1.6em;"><em>ARCH2S: Dataset and Benchmark for Learning Exterior Architetural Strutures</em></p>



<!-- #  ARCH2S: Dataset and Benchmark for Learning Exterior Architetural Strutures -->
<!-- **Pointcept** is a powerful and flexible codebase for point cloud perception research. It is also an official implementation of the following paper: -->
**ARCH2S** is a semantically-enriched, photo-realistic 3D architectural models dataset and benchmark for semantic segmentation. 

Our preprocess data are available and can also be downloaded by filling in the
[Google Form](https://forms.gle/ADCLHHxHwtbaAsxR9)

![Teaser](arch2s-teaser.png")

## Highlights
- *April*, 2024*: **ARCH2S** Dataset request form is created.
- *April, 2024*: **ARCH2S** Paper is accepted by **CVPRW 2024**
- *March 2024*: **ARCH2S** repo is created; the dataset, paper, and full code will be released soon.
- *March, 2024*: **ARCH2S** Uploads the semantic views with “Beam” and “Ceiling” labels from our [ARCH2S models](img/add_view_arch2s_model.png)
## Overview
- [TODO](#todo)
- [Installation](#installation)
- [Data Preparation](#data-preparation)
- [Quick Start](#quick-start)
- [Model Zoo](#model-zoo)
- [Citation](#citation)
- [Acknowledgement](#acknowledgement)

## TODO
- [✔] Initial create the repo 
- [✔] dataset, benchmark and code preview for ARCH2S
- [✔] download link for the raw data of ARCH2S dataset.
- [✔] Paper, dataset, benchmark and full code for ARCH2S
<!-- - [ ] BIM Models from ARCH2S -->
<!-- [![ARCH2S Model](img/add_view_arch2s_model.png)](img/add_view_arch2s_model.png) -->

## Installation

### Experiment Settings
- Ubuntu: 22.04
- CUDA: 11.6
- PyTorch: 1.12.1
- cuDNN: 7.4.1
- GPU: Nvidia GeForce RTX 4090 x 2
- CPU: AMD Ryzen 9 7950X 16-Core Processor @ 4.50 GHz

### Conda Environment

```bash
conda create -n ARCH2S python=3.9.18 -y
conda activate ARCH2S
conda install ninja -y
# Choose version you want here: https://pytorch.org/get-started/previous-versions/
conda install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.6-c pytorch -y
conda install h5py pyyaml -c anaconda -y
conda install sharedarray tensorboard tensorboardx yapf addict einops scipy plyfile termcolor timm -c conda-forge -y
conda install pytorch-cluster pytorch-scatter pytorch-sparse -c pyg -y
pip install torch-geometric

# spconv (SparseUNet)
# refer https://github.com/traveller59/spconv
pip install spconv-cu116

# PTv1 & PTv2 or precise eval
cd libs/pointops
# usual
python setup.py install
# docker & multi GPU arch
TORCH_CUDA_ARCH_LIST="ARCH LIST" python setup.py install
# e.g. 7.5: RTX 3000; 8.0: a100 More available in: https://developer.nvidia.com/cuda-gpus
TORCH_CUDA_ARCH_LIST="7.4.1" python setup.py install
cd ../..

# Open3D
pip install open3d
```
<!-- #### Our codebase structure is as follows:
```bash
/s2b
├── code_timer.py
├── config
│   ├── config_ARCH2S_public_services.yaml
    ├── ... (more files)
├── entity_create.py
├── entity_search.py
├── exp
│   ├── class_attribute
│   │   ├── class_attributes_{datatime}.txt
│   │   ├── ... (more files)
├── ifc_label_map.py
├── scripts
│   └── ARCH2S_main.sh
├── ARCH2S_main.py
└── utils
    ├── label_list.py
    ├── parse_yaml.py
    ├── pcd_Loader.py
    ├── pcd_Processor.py
``` -->

## Data Preparation

### Our dataset and benchmark(To be released soon)
<!-- The link for raw FBX Models (open Landsacpe ). Optionally,can also be downloaded [[here](https://drive.google.com/drive/folders/1dF1WHWCpI4NJpkJBm4jStjLFcSBzH6Ep?usp=sharing)] -->

How we  prepare the dataset:
- Mining the data from the raw FBX models and convert it to point cloud data.
- Texture mapping and colorization of the mesh with the .jpg file.
- Sampling the point cloud (5M) data from the mesh .
- Labeling the point cloud data with the semantic label.
 
<!-- Download our dataset and benchmark(To be released soon) and unzip it.
```
# ARCH2S_DIR: the directory of downloaded ARCH2S dataset.
# RAW_ARCH2S_DIR: the directory of ARCH2S dataset.
# PROCESSED_ARCH2S_DIR: the directory of processed ARCH2S dataset and benchmark(output dir).

# ARCH2S
python pointcept/datasets/preprocessing/ARCH2S/preprocess_ARCH2S.py --dataset_root ${ARCH2S_DIR} --output_root ${PROCESSED_ARCH2S_DIR}
```
- Link processed dataset and benchmarkto codebase.
```
mkdir data/ARCH2S
ln -s ${PROCESSED_ARCH2S_DIR} ${CODEBASE_DIR}/data/ARCH2S
``` -->

<!-- ## Quick Start

### Running our Framework
```bash
sh s2b/scripts/ARCH2S_main.sh
```

### Training the segmentation model
**Train from scratch.** The training processing is based on configs in `configs` folder. 
The training script will generate an experiment folder in `exp` folder and backup essential code in the experiment folder.
Training config, log, tensorboard, and checkpoints will also be saved into the experiment folder during the training process.
```bash
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES}
# Script (Recommended)
sh scripts/train.sh -p ${INTERPRETER_PATH} -g ${NUM_GPU} -d ${DATASET_NAME} -c ${CONFIG_NAME} -n ${EXP_NAME}
# Direct
export PYTHONPATH=./
python tools/train.py --config-file ${CONFIG_PATH} --num-gpus ${NUM_GPU} --options save_path=${SAVE_PATH}
```
```bash
# S3DIS
sh scripts/train.sh -g 2 -d s3dis -c semseg-pt-ARCH2S-v1m1-0-base -n semseg-pt-ARCH2S-v1m1-0-base
# SensatUrban
sh scripts/train.sh -g 2 -d sensaturban -c semseg-pt-ARCH2S-v1m1-0-base -n semseg-pt-ARCH2S-v1m1-0-base
# BuildingNet
sh scripts/train.sh -g 2 -d buildingnet -c semseg-pt-ARCH2S-v1m1-0-base -n semseg-pt-ARCH2S-v1m1-0-base
```
For example:
```bash
# By script (Recommended)
# -p is default set as python and can be ignored
sh scripts/train.sh -p python -d scannet -c semseg-pt-v2m2-0-base -n semseg-pt-v2m2-0-base
# Direct
export PYTHONPATH=./
python tools/train.py --config-file configs/scannet/semseg-pt-v2m2-0-base.py --options save_path=exp/scannet/semseg-pt-v2m2-0-base
```




##  Results

#### BIM models
Download example BIM model reconstructed by [here](https://forms.gle/) -->


## Model Zoo (To be released soon)

## Benchmark Results (To be released soon)
<!-- | Method              | G | C | S3DIS mIoU (%) | S3DIS OA (%) | SensatUrban mIoU (%) | SensatUrban OA (%) | BuildingNet mIoU (%) | BuildingNet OA (%) |
|---------------------|---|---|----------------|--------------|----------------------|--------------------|----------------------|--------------------|
| Model_1         | ✔ | ✔ | -              | -            | -                    | -                  | -                    | -                  |
| Model_2    | ✔ | ✔ | -              | -            | -                    | -                  | -                    | -                  |
| Model_3       | ✔ | ✔ | -              | -            | -                    | -                  | -                    | -                  |
| Model_4            | ✔ | ✔ | -              | -            | -                    | -                  | -                    | -                  |
| Ours        | ✔ | ✔ | -              | -            | -                    | -                  | -                    | -                  |
| Ours (a) | ✔ | ✔ | -            | -            | -                    | -                  | -                    | -                  |
| Ours (b)  | ✔ | ✔ | -            | -            | -                    | -                  | -                    | -                  |
| Ours (c)       | ✔ | ✔ | -            | -            | -                    | -                  | -                    | -                  |
| Ours (d)  | ✔ | ✔ | -            | -            | -                    | -                  | -                    | -                  |
| Ours (e)       | ✔ |  ✔  | -            | -            | -                    | -                  | -                    | -                  | -->


## Acknowledgement

#### Our benchmark results implemented the following excellent works:

#### Model Backbone:
Model_1, Model_2, Model_3, Ours, (a), (b)
## Citation
If you find this project useful in your research, please consider cite:

```latex
@article{cheung2024arch2s,
  title={ARCH2S: Dataset, Benchmark and Challenges for Learning Exterior Architectural Structures from Point Clouds},
  author={Cheung, Ka Lung and Lee, Chi Chung},
  journal={arXiv preprint arXiv:2406.01337},
  year={2024}
}
}
```

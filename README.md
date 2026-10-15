<!-- <p align="center">
ARCH2S: Dataset, Benchmark and Challenges for Learning Exterior Architectural Structures from Point Clouds
</p> -->
<!-- <p align="center" style="font-size:1.6em;"><em>ARCH2S: Dataset, Benchmark and Challenges for Learning Exterior Architectural Structures from Point Clouds</em></p> -->

# ARCH2S: Dataset, Benchmark and Challenges for Learning Exterior Architectural Structures from Point Clouds
<!-- **Pointcept** is a powerful and flexible codebase for point cloud perception research. It is also an official implementation of the following paper: -->
**ARCH2S** is a dataset and benchmark repo for learning exterior architectural structures from point clouds. Part of the results and demo can be found in the 
[Google Drive](https://drive.google.com/drive/folders/1Bl5Yx6oPL7om46EqePVFuLEOq_JDVCyJ?usp=sharing). Our preprocess data are availiable and can also be downloaded by filling the
[Google Form](https://forms.gle/ADCLHHxHwtbaAsxR9)

## Highlights
- *May, 2024*: Our paper is accepted by CVPRW'24!

## Overview
- [TODO](#todo)
- [Installation](#installation)
- [Data Preparation](#data-preparation)
- [Quick Start](#quick-start)
- [Citation](#citation)

## TODO
- [✔] Initial create the repo 
- [✔] dataset and code preview for SRBIM
- [✔] download link for the raw data of SRBIM dataset.
- [✔] config for the SRBIM segmentation model training with S3DIS dataset.
<!--  - [ ] Paper, dataset and full code for SRBIM
- [ ] BIM Models from SRBIM
- [ ] Configs for trained segmentation models(SRBIM)
- [ ] Pretrained models for SRBIM  -->


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
conda create -n SRBIM python=3.9.18 -y
conda activate SRBIM
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
#### Our codebase structure is as follows:
```bash
/s2b
├── code_timer.py
├── config
│   ├── config_SRBIM_public_services.yaml
    ├── ... (more files)
├── entity_create.py
├── entity_search.py
├── exp
│   ├── class_attribute
│   │   ├── class_attributes_{datatime}.txt
│   │   ├── ... (more files)
├── ifc_label_map.py
├── scripts
│   └── SRBIM_main.sh
├── SRBIM_main.py
└── utils
    ├── label_list.py
    ├── parse_yaml.py
    ├── pcd_Loader.py
    ├── pcd_Processor.py
```

## Data Preparation

### Our Dataset (To be released soon)
<!-- The link for raw FBX Models (open Landsacpe ). Optionally,can also be downloaded [[here](https://drive.google.com/drive/folders/1dF1WHWCpI4NJpkJBm4jStjLFcSBzH6Ep?usp=sharing)] -->

How we  prepare the dataset:
- Mining the data from the raw FBX Model (open Landsacpe ) and convert it to point cloud data.
- Texture mapping and colorization of the mesh with the .jpg file.
- Sampling the point cloud (5M) data from the mesh .
- Labeling the point cloud data with the semantic label.
 
Download our dataset and unzip it.
```
# SRBIM_DIR: the directory of downloaded SRBIM dataset.
# RAW_SRBIM_DIR: the directory of SRBIM dataset.
# PROCESSED_SRBIM_DIR: the directory of processed SRBIM dataset (output dir).

# SRBIM
python pointcept/datasets/preprocessing/SRBIM/preprocess_SRBIM.py --dataset_root ${SRBIM_DIR} --output_root ${PROCESSED_SRBIM_DIR}
```
- Link processed dataset to codebase.
```
mkdir data/SRBIM
ln -s ${PROCESSED_SRBIM_DIR} ${CODEBASE_DIR}/data/SRBIM
```

### S3DIS

- Download S3DIS data and unzip `Stanford3dDataset_v1.2.zip` file
- Run preprocessing code for S3DIS as follows:

```bash
# S3DIS_DIR: the directory of downloaded Stanford3dDataset_v1.2 dataset.
# RAW_S3DIS_DIR: the directory of Stanford2d3dDataset_noXYZ dataset. (optional, for parsing normal)
# PROCESSED_S3DIS_DIR: the directory of processed S3DIS dataset (output dir).

# S3DIS without aligned angle
python pointcept/datasets/preprocessing/s3dis/preprocess_s3dis.py --dataset_root ${S3DIS_DIR} --output_root ${PROCESSED_S3DIS_DIR}
# S3DIS with aligned angle
python pointcept/datasets/preprocessing/s3dis/preprocess_s3dis.py --dataset_root ${S3DIS_DIR} --output_root ${PROCESSED_S3DIS_DIR} --align_angle
# S3DIS with normal vector (recommended, normal is helpful)
python pointcept/datasets/preprocessing/s3dis/preprocess_s3dis.py --dataset_root ${S3DIS_DIR} --output_root ${PROCESSED_S3DIS_DIR} --raw_root ${RAW_S3DIS_DIR} --parse_normal
python pointcept/datasets/preprocessing/s3dis/preprocess_s3dis.py --dataset_root ${S3DIS_DIR} --output_root ${PROCESSED_S3DIS_DIR} --raw_root ${RAW_S3DIS_DIR} --align_angle --parse_normal
```


- Link processed dataset to codebase.
```bash
# PROCESSED_S3DIS_DIR: the directory of processed S3DIS dataset.
mkdir data
ln -s ${PROCESSED_S3DIS_DIR} ${CODEBASE_DIR}/data/s3dis
```
## SensatUrban
### Download the dataset
Download the files named "data_release.zip" here. Uncompress the folder and move it to /data/SensatUrban.


Preparing the dataset
``` bash
python input_preparation.py --dataset_path $YOURPATH
cd $YOURPATH; 
cd ../; mkdir original_block_ply; mv data_release/train/* original_block_ply; mv data_release/test/* original_block_ply;
mv data_release/grid* ./
```
The data should organized in the following format:
```bash
/data/SensatUrban/
          └── original_block_ply/
                  ├── birmingham_block_0.ply
                  ├── birmingham_block_1.ply 
		  ...
	    	  └── cambridge_block_34.ply 
          └── grid_0.200/
	     	  ├── birmingham_block_0_KDTree.pkl
                  ├── birmingham_block_0.ply
		  ├── birmingham_block_0_proj.pkl 
		  ...
	    	  └── cambridge_block_34.ply 
```


### BuildingNet

- Download BuildingNet data and unzip `POINT_CLOUDS.zip` file
- Run preprocessing code for BuildingNet as follows:

```bash
# BuildingNet_DIR: the directory of downloaded POINT_CLOUDS dataset.
# RAW_BuildingNet_DIR: the directory of Stanford2d3dDataset_noXYZ dataset. 
# PROCESSED_BuildingNet_DIR: the directory of processed BuildingNet dataset (output dir).

# BuildingNet
python pointcept/datasets/preprocessing/buildingNet/preprocess_buildingNet.py --dataset_root ${BuildingNet_DIR} --output_root ${PROCESSED_BuildingNet_DIR}
# BuildingNet
python pointcept/datasets/preprocessing/buildingNet/preprocess_buildingNet.py --dataset_root ${BuildingNet_DIR} 
```

- Link processed dataset to codebase.
```bash
# PROCESSED_S3DIS_DIR: the directory of processed S3DIS dataset.
mkdir data
ln -s ${PROCESSED_S3DIS_DIR} ${CODEBASE_DIR}/data/buildingNet
```
## Quick Start

### Running our Framework
```bash
sh s2b/scripts/SRBIM_main.sh
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
sh scripts/train.sh -g 2 -d s3dis -c semseg-pt-srbim-v1m1-0-base -n semseg-pt-srbim-v1m1-0-base
# SensatUrban
sh scripts/train.sh -g 2 -d sensaturban -c semseg-pt-srbim-v1m1-0-base -n semseg-pt-srbim-v1m1-0-base
# BuildingNet
sh scripts/train.sh -g 2 -d buildingnet -c semseg-pt-srbim-v1m1-0-base -n semseg-pt-srbim-v1m1-0-base
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

<!--
## Model Zoo
-->


## Citation
If you find this project useful in your research, please consider citing:

```latex
@misc{cheung2024arch2s,
    title={ARCH2S: Dataset, Benchmark and Challenges for Learning Exterior Architectural Structures from Point Clouds},
    author={Ka Lung Cheung and Chi Chung Lee},
    year={2024},
    eprint={2406.01337},
    archivePrefix={arXiv},
    primaryClass={cs.CV}
}
```

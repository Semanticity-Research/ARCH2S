# Description: Preprocess S3DIS dataset
S3DIS_DIR=data/Stanford3dDataset_v1.2
PROCESSED_S3DIS_DIR=data/processed/s3dis
RAW_S3DIS_DIR=data/raw/s3dis

# python pointcept/datasets/preprocessing/s3dis/preprocess_s3dis.py --dataset_root ${S3DIS_DIR} --output_root ${PROCESSED_S3DIS_DIR} --raw_root ${RAW_S3DIS_DIR} --align_angle --parse_normal
python pointcept/datasets/preprocessing/s3dis/preprocess_s3dis.py --dataset_root ${S3DIS_DIR} --output_root ${PROCESSED_S3DIS_DIR} --align_angle
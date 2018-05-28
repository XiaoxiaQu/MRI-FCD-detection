#!/bin/bash
########################################


DIR="/media/xiaqu/HardDisk/research/MRI_FCD/Health_T1_v2/"
tolNUM=31
for i in `seq 1 $tolNUM`;do
NUM=`printf "%03d" $i`

cd $DIR"Healthy_"$NUM
mkdir "Hong2014"
cd $DIR"Healthy_"$NUM"/Hong2014"
mkdir "sulcal_depth"

# Compute sulcal depth
######################################################################
# Inputs:
IN1=$DIR"Healthy_"$NUM"/5_AtlasSeg/Health_"$NUM"_affine_pve_0_AtlasSeg.nii.gz"
IN2=$DIR"Healthy_"$NUM"/5_AtlasSeg/Health_"$NUM"_affine_pve_1_AtlasSeg.nii.gz"
IN3=$DIR"Healthy_"$NUM"/5_AtlasSeg/Health_"$NUM"_affine_pve_2_AtlasSeg.nii.gz"
#####################################################################
#-----------------------------------------------------------------------
# Step1: Extract region for measurement
OUT1=$DIR"Healthy_"$NUM"/Hong2014/sulcal_depth/Health_"$NUM"_sulcal_1_extraction.nii.gz"
cd /media/xiaqu/HardDisk/research/MRI_FCD/Code_Exist_Methods/Hong2014/CODES/sulcal_depth/Step1_sulcal_extraction/bin
./source $IN1 $IN2 $IN3 $OUT1 
echo "sulcal extraction is done in NO. "$NUM
#--------------------------------------------------------------------------
# step2: Potential map, default iteration=100
# Usage:[1]InImage  [2]OutImage [3](Optional)IterationTimes
OUT2=$DIR"Healthy_"$NUM"/Hong2014/sulcal_depth/Health_"$NUM"_sulcal_2_Potential.nii.gz"
cd /media/xiaqu/HardDisk/research/MRI_FCD/Code_Exist_Methods/Hong2014/CODES/sulcal_depth/Step2_Potential/bin
./source $OUT1 $OUT2 50 
echo "Potential map is done in NO. "$NUM
#--------------------------------------------------------------------------
# Step3: Calculate thickness or width or depth
OUT3=$DIR"Healthy_"$NUM"/Hong2014/sulcal_depth/Health_"$NUM"_sulcal_3_depth.nii.gz"
cd /media/xiaqu/HardDisk/research/MRI_FCD/Code_Exist_Methods/Hong2014/CODES/sulcal_depth/Step3_depth/bin
./source $OUT2 $OUT3
echo "thickness or width or depth is done in NO. "$NUM

done





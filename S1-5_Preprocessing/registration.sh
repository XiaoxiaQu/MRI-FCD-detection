#!/bin/bash
##############################################################
# Purpose: For convenience of using alsta 
#          and compare subject with healthy controls.
# Methods: rigid+affine register subject data to MNN space
# registration: 
#      [1] Fixed Image: mask of MNI brain
#      [2] Moving Image: mask of subject brain
#      [3] Output of moving Image
#      [4] Input1 for mapping
#      [5] Output of Input1 
#############################################################
DIR1="/ipi/research/xiaqu/MRI_FCD/Patient_T1_v1/"


# DIR="/scratch/MRI_FCD/Patient_T1_v2/"
# for i in `seq 1 1`;do
# NUM=`printf "%03d" $i`

cd $DIR"Patient_"$NUM
mkdir "3_registration"

##############################
# Step1---Rigid registration
###############################
#[1] Fixed Image: mask of MNI brain
RigidFixed="/ipi/research/xiaqu/MRI_FCD/MNI152_T1/MNI152_T1_brain_05mm_mask.nii.gz"
#[2] Moving Image: mask of subject brain
RigidMoving=$DIR1"P"$NUM"/2_brain/P"$NUM"_fine_brain_mask.nii.gz"
#[3] Output of moving Image, by rigid registration
RigidMovingOut=$DIR"Patient_"$NUM"/3_registration/Patient_"$NUM"_fine_brain_mask_rigid.nii.gz"
#[4] In1 of rigid
RigidIn1=$DIR1"P"$NUM"/2_brain/P"$NUM"_fine_brain.nii.gz"
#[5] Out1 of rigid
RigidOut1=$DIR"Patient_"$NUM"/3_registration/Patient_"$NUM"_fine_brain_rigid.nii.gz"
cd /ipi/research/xiaqu/MRI_FCD/code/ITK/Registration/Rigid/bin
./ImageRegistration8 $RigidFixed $RigidMoving $RigidMovingOut $RigidIn1 $RigidOut1
echo "Rigid registration is done in Patient_"$NUM"."

##############################
# Step2---Affine registration
###############################
#[1] Fixed Image: mask of MNI brain
# AffineFixed =RigidFixed
#[2] Moving Image
# AfiineMoving =RigidMovingOut
#[3] Output of moving Image, by affine registration
AffineMovingOut=$DIR"Patient_"$NUM"/3_registration/Patient_"$NUM"_fine_brain_mask_rigid_affine.nii.gz"
#[4] In1 of affine
# AffineIn1 = RigidOut1
#[5] Out1 of affine
AffineOut1=$DIR"Patient_"$NUM"/3_registration/Patient_"$NUM"_fine_brain_rigid_affine.nii.gz"
cd /ipi/research/xiaqu/MRI_FCD/code/ITK/Registration/Affine/bin
./ImageRegistration20 $RigidFixed $RigidMovingOut $AffineMovingOut $RigidOut1 $AffineOut1

echo "Affine registration is done in Patient_"$NUM"."
#-------------------------------------
# done

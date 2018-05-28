#!/bin/bash
##################

# DIR="/scratch/MRI_FCD/Patient_T1_v2/"

# for i in `seq 1 1`;do
# NUM=`printf "%03d" $i`

cd $DIR"Patient_"$NUM
mkdir "4_TissueSeg"

INPUT=$DIR"Patient_"$NUM"/3_registration/Patient_"$NUM"_fine_brain_rigid_affine.nii.gz"
OUTPUT=$DIR"Patient_"$NUM"/4_TissueSeg/Patient_"$NUM"_affine"
#################################
# run software FSL FAST 
#################################
echo "Tissue segmentation begin on Patient_"$NUM"."
#------run-----------
fast -b -B -P -p -o $OUTPUT file $INPUT 
# echo fast -b -B -P -p -o $OUTPUT file $INPUT 
#---------------------
echo "Tissue segmentation is done in Patient_"$NUM"."

# done



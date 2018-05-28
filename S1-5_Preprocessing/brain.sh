#!/bin/bash
##################
#  open file
###################
for i in `seq 1 10`;do
NUM=`printf "%03d" $i`

DIR="/scratch/xiaqu/MRI_FCD/Patient_T1_v1/P"$NUM"/"
INPUT=$DIR"1_ori/Patient_"$NUM"_r.nii"
OUTPUT=$DIR"2_brain/Patient_"$NUM"_r_brain"
#################################
# run software FSL bet
#################################
bet $INPUT $OUTPUT 
###################################
# see what will happen
# echo bet $INDIR/$INPUT $OUTDIR/$OUTPUT -s -m -c 94 130 174
###################################

echo "Segmentation is done in data sets NO."$NUM"."

done

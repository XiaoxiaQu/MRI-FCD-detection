#!/bin/bash
##################


FREQUENCY=(40 15 20 5 10 19 8 19 20 300)

DIR="/home/xiaoxiaqu/research/MRI_FCD/Patient_T1_v2/"

for i in `seq 2 10`;do
# for i in `seq 1 10`;do
PATNO=`printf "%03d" $i`

#------------------------------------------
#  "Usage : " << argv[0] << std::endl;
#  " [1]Data with Labels, include CSF,CSF/GM,GM,GM/WM,WM,FCD" << std::endl;
#  " [2]out.csv" << std::endl;
#  " [3]Label Value " << std::endl;
#  " [4]Frequency " << std::endl;
#  " [5]GMthick"<< std::endl;
#  " [6]GMthick_zscore"<< std::endl;
#  " [7]Gradient" << std::endl;
#  " [8]Gradient_zscore" << std::endl;
#  " [9]GWBthick_Extend" << std::endl;
#  " [10]GWBthick_Extend_zscore" << std::endl;
#  " [11]RIM_smooth" << std::endl;
#  " [12]RIM_smooth_zscore" << std::endl;
#  " [13]sulcal_depth" << std::endl;
#  " [14]sulcal_depth_zscore" << std::endl;
#  " [15]curvatres" << std::endl;
#  " [16]curvatres_zscore" << std::endl;
# cd /home/xiaoxiaqu/research/MRI_FCD/XiaoxiaQu2015_Features/Step4_SamplesPick/Generate_Samples/bin/
# ./Generate_Samples $LableData $OUTPUT $LabelValue $Frequency $INPUT5 $INPUT6 $INPUT7 $INPUT8 $INPUT9 $INPUT10 $INPUT11 $INPUT12 $INPUT13 $INPUT14 $INPUT15 $INPUT16
#------------------------------------------

##---------------------
# Input data
##---------------------
# [1]Labels 
     LableData=$DIR"Patient_"$PATNO"/7_Ground_Truth/Patient_"$PATNO"_labels.nii.gz"
#[2]out.csv
#[3]Label Value
#[4]Frequency    
# [5]GMthick
    INPUT5=$DIR"Patient_"$PATNO"/6_Features1/Patient_"$PATNO"_affine_pve_GMthick.nii.gz"
# [6]GMthick_zscore
    INPUT6=$DIR"Patient_"$PATNO"/Hong2014/z_score/Patient_"$PATNO"_GMthick_z_score.nii.gz"
# [7]Gradient
    INPUT7=$DIR"Patient_"$PATNO"/6_Features1/Patient_"$PATNO"_affine_restore_Gradient.nii.gz"
# [8]Gradient_zscore
    INPUT8=$DIR"Patient_"$PATNO"/Hong2014/z_score/Patient_"$PATNO"_Gradient_z_score.nii.gz"
# [9]GWBthick_Extend
    INPUT9=$DIR"Patient_"$PATNO"/XiaoxiaQu2015_2/Features/Patient_"$PATNO"_GWBthick_Extend.nii.gz"
# [10]GWBthick_Extend_zscore
    INPUT10=$DIR"Patient_"$PATNO"/XiaoxiaQu2015_2/Features/Patient_"$PATNO"_GWBthick_Extend_VS_Healthy_zscore.nii.gz"
# [11]RIM_smooth
    INPUT11=$DIR"Patient_"$PATNO"/XiaoxiaQu2015_2/Features/Patient_"$PATNO"_RIM_smooth.nii.gz"
# [12]RIM_smooth_zscore
    INPUT12=$DIR"Patient_"$PATNO"/Hong2014/z_score/Patient_"$PATNO"_RIM_z_score.nii.gz"
#  " [13]sulcal_depth" << std::endl;
INPUT13=$DIR"Patient_"$PATNO"/Hong2014/sulcal_depth/Patient_"$PATNO"_sulcal_3_depth.nii.gz"
#  " [14]sulcal_depth_zscore" << std::endl;
INPUT14=$DIR"Patient_"$PATNO"/Hong2014/z_score/Patient_"$PATNO"_SulcalDepth_z_score.nii.gz"
#  " [15]curvatres" << std::endl;
INPUT15=$DIR"Patient_"$PATNO"/Hong2014/curvatures/Patient_"$PATNO"_GM_curvatres_Cmean_volume.nii.gz"
#  " [16]curvatres_zscore" << std::endl; 
INPUT16=$DIR"Patient_"$PATNO"/Hong2014/z_score/Patient_"$PATNO"_curvatres_z_score.nii.gz"
## ouput folder
OUTDIR="/home/xiaoxiaqu/research/MRI_FCD/XiaoxiaQu2015_2GAMC_EXP3/SamplesPick/Samples/"
#############################################
# Gray Matter (GM), Label=1
#[2]out.csv
OUTPUT1=$OUTDIR"Patient_"$PATNO"_Samples_GM.csv"
#[3]Label Value
LabelValue1=1
#[4]Frequency  
Frequency1=5000
#
cd /home/xiaoxiaqu/research/MRI_FCD/XiaoxiaQu2015_2GAMC_EXP3/SamplesPick/Generate_Samples/bin/

./Generate_Samples $LableData $OUTPUT1 $LabelValue1 $Frequency1 $INPUT5 $INPUT6 $INPUT7 $INPUT8 $INPUT9 $INPUT10 $INPUT11 $INPUT12 $INPUT13 $INPUT14 $INPUT15 $INPUT16
#############################################
# Gray Matter/White Matter (GWB), Label=5
#[2]out.csv
OUTPUT5=$OUTDIR"Patient_"$PATNO"_Samples_GWB.csv"
#[3]Label Value
LabelValue5=5
#[4]Frequency  
Frequency5=2500
#
cd /home/xiaoxiaqu/research/MRI_FCD/XiaoxiaQu2015_2GAMC_EXP3/SamplesPick/Generate_Samples/bin

./Generate_Samples $LableData $OUTPUT5 $LabelValue5 $Frequency5 $INPUT5 $INPUT6 $INPUT7 $INPUT8 $INPUT9 $INPUT10 $INPUT11 $INPUT12 $INPUT13 $INPUT14 $INPUT15 $INPUT16

#############################################
# FCD, Label=6
#[2]out.csv
OUTPUT6=$OUTDIR"Patient_"$PATNO"_Samples_FCD.csv"
#[3]Label Value
LabelValue6=6
#[4]Frequency  
Frequency6=${FREQUENCY[i-1]}
#
cd /home/xiaoxiaqu/research/MRI_FCD/XiaoxiaQu2015_2GAMC_EXP3/SamplesPick/Generate_Samples/bin

./Generate_Samples $LableData $OUTPUT6 $LabelValue6 $Frequency6 $INPUT5 $INPUT6 $INPUT7 $INPUT8 $INPUT9 $INPUT10 $INPUT11 $INPUT12 $INPUT13 $INPUT14 $INPUT15 $INPUT16

###############################################
done



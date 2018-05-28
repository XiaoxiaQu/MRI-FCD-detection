%*******************************************************************
% 
% This function is to: 
% extract gray/white matter boundary (GWB) region, gray matter (GM) region,
% white matter (WM) region.
% Inputs:
%       (1)gray (images of gray matter)
%       (2)csf (CSF) 
%       (3)white (white matter)
% Outputs:
%       GWBseg (segmented image) 
%       GWBpotential(potential map)
%       GWBwidth(GWB width map) 
% Author: Xiaoxia Qu
% Date: 2017.06
%****************************************************************

clear all;clc;tic;

addpath('../TOOLS/Tools_for_NIfTI_and_ANALYZE_image');


%******************************************
% prepare
%******************************************
InDir='/media/huarui002/XiaoxiaWDBlack1/LINUX_research/MRI_FCD/Patient_T1_v2';
Patient_number=1;
out_folder=sprintf('4_TissueSeg_Feature'); 

for Patient_number=1:1:1

InPath=sprintf('%s/Patient_%03d',InDir,Patient_number);
%******************************************
% inputdata
%******************************************
filename_0=sprintf('%s/4_TissueSeg/Patient_%03d_affine_pve_0.nii.gz',InPath,Patient_number);
filename_1=sprintf('%s/4_TissueSeg/Patient_%03d_affine_pve_1.nii.gz',InPath,Patient_number);
filename_2=sprintf('%s/4_TissueSeg/Patient_%03d_affine_pve_2.nii.gz',InPath,Patient_number);

gray_nii=load_untouch_nii(filename_1); gray=gray_nii.img;
csf_nii=load_untouch_nii(filename_0); csf=csf_nii.img; clear csf_nii
white_nii=load_untouch_nii(filename_2); white=white_nii.img; clear white_nii

%******************************************
% computation
%******************************************
% step1
GWBseg=GWBwidth_1_Seg(gray,csf,white);

% step2
GWBpotential=GWBwidth_2_Potential(GWBseg);
% step3
GWBwidth=GWBwidth_3_Width(GWBpotential,gray_nii);

%******************************************
% output save 
%******************************************
GWBseg_nii=make_nii(GWBseg);
GWBseg_nii.hdr=gray_nii.hdr;

GWBpotential_nii=make_nii(GWBpotential);
GWBpotential_nii.hdr=gray_nii.hdr;

GWBwidth_nii=make_nii(GWBwidth);
GWBwidth_nii.hdr=gray_nii.hdr;

mkdir(InPath,out_folder); 
OutName1=sprintf('%s/%s/Patient_%03d_affine_pve_1GWBseg.nii.gz',InPath,out_folder,Patient_number);
save_nii(GWBseg_nii,OutName1);

OutName1=sprintf('%s/%s/Patient_%03d_affine_pve_2GWBpotential.nii.gz',InPath,out_folder,Patient_number);
save_nii(GWBseg_nii,OutName1);

OutName1=sprintf('%s/%s/Patient_%03d_affine_pve_3GWBwidth.nii.gz',InPath,out_folder,Patient_number);
save_nii(GWBseg_nii,OutName1);

end













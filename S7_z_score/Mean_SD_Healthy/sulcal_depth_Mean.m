%% This file is to compute the 
% mean GWB width of healthy controls
% 
%% 
clear all;clc;close all;
addpath('/media/xiaqu/HardDisk/scratch/Tools_for_NIfTI_and_ANALYZE_image');
%% (*)load T1 MRI images 
DIRht1=sprintf('/media/xiaqu/HardDisk/research/MRI_FCD/Health_T1_v2'); % Directionary of healthy T1 MRI 

NumHealth=31; % total number of healthy controls

%% Initialiation
SubIdx=1;
FileIn=sprintf('%s/Healthy_%03d/Hong2014/sulcal_depth/Health_%03d_sulcal_3_depth.nii.gz',DIRht1,SubIdx,SubIdx);
ImageIn_nii=load_untouch_nii(FileIn);
Isum=ImageIn_nii.img;
HDR=ImageIn_nii.hdr;
clear ImageIn_nii

%% computation
for SubIdx=2:1:NumHealth % SubIdx is index of subjects which include healthy controls and patients.
FileIn=sprintf('%s/Healthy_%03d/Hong2014/sulcal_depth/Health_%03d_sulcal_3_depth.nii.gz',DIRht1,SubIdx,SubIdx);
ImageIn_nii=load_untouch_nii(FileIn);
% (3) mean  of healthy controls, 
Isum=Isum+ImageIn_nii.img;
clear ImageIn_nii
end

Imean=single(Isum/NumHealth);

%% save
Imean_nii=make_nii(Imean); 
Imean_nii.hdr=HDR;
OutName=sprintf('%s/Healthy_001/Hong2014/Mean_SD/Health_sulcal_3_depth_mean.nii.gz',DIRht1);
save_nii(Imean_nii,OutName);










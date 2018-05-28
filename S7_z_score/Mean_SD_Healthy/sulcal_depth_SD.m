%% This file is to compute the 
% std GWB width of healthy controls
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
HDR=ImageIn_nii.hdr;

%% load mean
FileMean=sprintf('%s/Healthy_001/Hong2014/Mean_SD/Health_sulcal_3_depth_mean.nii.gz',DIRht1);
ImageMean_nii=load_untouch_nii(FileMean);
Istdsum=(ImageIn_nii.img-ImageMean_nii.img).^2;
clear ImageIn_nii

%% computation
for SubIdx=2:1:NumHealth % SubIdx is index of subjects which include healthy controls and patients.
FileIn=sprintf('%s/Healthy_%03d/Hong2014/sulcal_depth/Health_%03d_sulcal_3_depth.nii.gz',DIRht1,SubIdx,SubIdx);
ImageIn_nii=load_untouch_nii(FileIn);
%
Istdsum=Istdsum+(ImageIn_nii.img-ImageMean_nii.img).^2;
clear ImageIn_nii
end

Istd=single(sqrt(Istdsum/NumHealth));
clear Istdsum ImageMean_nii

%% save
Istd_nii=make_nii(Istd); 
Istd_nii.hdr=HDR;
OutName=sprintf('%s/Healthy_001/Hong2014/Mean_SD/Health_sulcal_3_depth_std.nii.gz',DIRht1);
save_nii(Istd_nii,OutName);










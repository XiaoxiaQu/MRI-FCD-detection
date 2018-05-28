
clear all;clc;close all;
addpath('/media/xiaqu/HardDisk/scratch/Tools_for_NIfTI_and_ANALYZE_image');


% read data of healths
H_DIR=sprintf('/media/xiaqu/HardDisk/research/MRI_FCD/Health_T1_v2/Healthy_001/Hong2014/Mean_SD');
H_mean_FilenName=sprintf('%s/Health_sulcal_3_depth_mean.nii.gz',H_DIR);
H_mean_nii=load_untouch_nii(H_mean_FilenName); H_mean=H_mean_nii.img;
% [0 9.8] 

H_std_FilenName=sprintf('%s/Health_sulcal_3_depth_std.nii.gz',H_DIR);
H_std_nii=load_untouch_nii(H_std_FilenName); H_std=H_std_nii.img;
% [0 6.7]


%
DIR=sprintf('/media/xiaqu/HardDisk/research/MRI_FCD/Patient_T1_v2');
for SubIdx=2:1:10
    filename=sprintf('%s/Patient_%03d/Hong2014/sulcal_depth/Patient_%03d_sulcal_3_depth.nii.gz',DIR,SubIdx,SubIdx);
    ImageIn_nii=load_untouch_nii(filename); ImageIn=ImageIn_nii.img;
    %% ###################
    offset=0.01;
    MASK=(H_std>=offset);
    
    BKG=0; %  0
    MASK2=(ImageIn<=BKG);% in MASK2, background is 1
    
    ImageOut=(ImageIn-H_mean)./(H_std+eps);
    ImageOut=ImageOut.*MASK;
    
    newBKG=-5;
    ImageOut(MASK2==1)=newBKG;
    
    
    %% save
    ImageOut_nii=make_nii(ImageOut);
    ImageOut_nii.hdr=ImageIn_nii.hdr;
    foldername=sprintf('%s/Patient_%03d/Hong2014/z_score',DIR,SubIdx);
    if ~exist(foldername);
        mkdir(foldername)
    end
    OutName=sprintf('%s/Patient_%03d/Hong2014/z_score/Patient_%03d_SulcalDepth_z_score.nii.gz',DIR,SubIdx,SubIdx);
    save_nii(ImageOut_nii,OutName);
end

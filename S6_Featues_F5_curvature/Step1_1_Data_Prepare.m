

clear all; clc;close all; 
addpath('/media/xiaqu/HardDisk/scratch/Tools_for_NIfTI_and_ANALYZE_image');

DIR=sprintf('/media/xiaqu/HardDisk/research/MRI_FCD/Patient_T1_v2');

for NUM=2:1:10 % NUM=1:1:10
    
%% load a nifity data
filename_CSF=sprintf('%s/Patient_%03d/4_TissueSeg/Patient_%03d_affine_pve_0.nii.gz',DIR,NUM,NUM);
In_CSF=load_untouch_nii(filename_CSF);
filename_GM=sprintf('%s/Patient_%03d/4_TissueSeg/Patient_%03d_affine_pve_1.nii.gz',DIR,NUM,NUM);
In_GM=load_untouch_nii(filename_GM);
filename_WM=sprintf('%s/Patient_%03d/4_TissueSeg/Patient_%03d_affine_pve_2.nii.gz',DIR,NUM,NUM);
In_WM=load_untouch_nii(filename_WM);

%% genarate binary image 
GM_surface=zeros(size(In_GM.img));
GM_surface(((In_GM.img>0)|(In_WM.img>0))&(In_CSF.img==0))=1;
%% save data
GM_surface_nii=make_nii(GM_surface); 
GM_surface_nii.hdr=In_GM.hdr;
foldername=sprintf('%s/Patient_%03d/Hong2014',DIR,NUM);
if ~exist(foldername);
    mkdir(foldername)
end

foldername=sprintf('%s/Patient_%03d/Hong2014/curvatures',DIR,NUM);
if ~exist(foldername);
    mkdir(foldername)
end

OutName=sprintf('%s/Patient_%03d/Hong2014/curvatures/Step1_GM_surface_1.nii.gz',DIR,NUM);
save_nii(GM_surface_nii,OutName);

end











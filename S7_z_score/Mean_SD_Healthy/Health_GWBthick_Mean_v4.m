clc; clear all; close all; tic
%
addpath('/scratch/Tools for NIfTI and ANALYZE image');
Dir=('/scratch/MRI_FCD/Health_T1_v2');


for Num=1:1:31
    if Num==1
        filename=sprintf('%s/Health_%03d/6_Features1/Health_%03d_affine_pve_GWBthick.nii.gz',Dir,Num,Num);
        g_nii=load_nii(filename); g=g_nii.img;
        Out=g;
        
    end
    
    if Num==2
        filename=sprintf('%s/Health_%03d/6_Features1/Health_%03d_affine_pve_GWBthick.nii.gz',Dir,Num,Num);
        g_nii=load_nii(filename); g=g_nii.img;
        Out=(Out+g)/2; 
    end
    if Num>2
       filename=sprintf('%s/Health_%03d/6_Features1/Health_%03d_affine_pve_GWBthick.nii.gz',Dir,Num,Num);
        g_nii=load_nii(filename); g=g_nii.img;
        Out=(Out*(Num-1)+g)/Num;          
    end
end
Out(Out>0)=Out(Out>0)+1.6;
Num=1;
OutName=sprintf('%s/Health_%03d/7_Combine_Healthy_Controls/Health_GWBthick_Mean_v4.nii.gz',Dir,Num);
Out_nii=make_nii(Out); Out_nii.hdr=g_nii.hdr;
save_nii(Out_nii,OutName);
    

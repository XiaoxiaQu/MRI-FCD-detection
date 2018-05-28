clc; clear all; close all; tic
%
addpath('/scratch/Tools for NIfTI and ANALYZE image');
Dir=('/scratch/MRI_FCD/Health_T1_v2');


for Num=1:1:31
    if Num==1
        filename=sprintf('%s/Health_%03d/6_Features1/Health_%03d_affine_pve_GMthick.nii.gz',Dir,Num,Num);
        g_nii=load_nii(filename); g=g_nii.img;
        Out=g;        
    end
    
    if Num==2
        filename=sprintf('%s/Health_%03d/6_Features1/Health_%03d_affine_pve_GMthick.nii.gz',Dir,Num,Num);
        g_nii=load_nii(filename); g=g_nii.img;
        Out(g>0)=(Out(g>0)+g(g>0))/2; 
    end
    if Num>2
       filename=sprintf('%s/Health_%03d/6_Features1/Health_%03d_affine_pve_GMthick.nii.gz',Dir,Num,Num);
        g_nii=load_nii(filename); g=g_nii.img;
        Out(g>0)=(Out(g>0)*(Num-1)+g(g>0))/Num;          
    end
end

Num=1;
OutName=sprintf('%s/Health_%03d/7_Combine_Healthy_Controls/Health_GMthick_Mean_v2.nii.gz',Dir,Num);
Out_nii=make_nii(Out); Out_nii.hdr=g_nii.hdr;
save_nii(Out_nii,OutName);
    
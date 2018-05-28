%***********************************************************************************
%  Input:
%        example: Patient_001_r_brain_itp_restore.nii.gz
%  Output:
%        example: Patient_001_r_brain_itp_restore_gradient_v3.nii         
% 
% 
%***********************************************************************************
clear all
clc
tic
addpath('/scratch/xiaqu/Tools for NIfTI and ANALYZE image');

PATNO=1;
% open data
for PATNO=2:1:10
 if PATNO==10
    Patient_number=('010');
 else
    Patient_number=sprintf('00%d',PATNO);
 end 
 
InPath=sprintf('/ipi/research/xiaqu/MRI_FCD_data/FCD_data/Patient_%s_T1',Patient_number);

InFile=sprintf('%s/5_tissue_seg/Patient_%s_r_brain_itp_restore.nii.gz',InPath,Patient_number);

% load data
InFile_nii=load_nii(InFile);
g=InFile_nii.img;
pixdim=InFile_nii.hdr.dime.pixdim(2:4);
% beigin calculate gradient
str=sprintf ('Data is loaded in Patient %s',Patient_number);
disp(str)

%***********************************************************************************
% test the method in 2D image
%***********************************************************************************
% show the original image
%***********************************************************************************
I=g(:,:,333);
figure, imshow(I,[])
sigma=0.6;
[Ix Iy]=compute_image_derivatives(I,0.6990);

I_out=abs(Ix)+abs(Iy);
figure, imshow(I_out,[])
colormap(jet)

%***********************************************************************************
% Begin to calculate in 3D image
%***********************************************************************************
G=zeros(size(g));
for k=1:size(g,3)
    I=g(:,:,k);
    sigma=0.6990;
    [Ix Iy]=compute_image_derivatives(I,sigma);
    I_G=abs(Ix)+abs(Iy);
    G(:,:,k)=I_G;
end

G_nii=make_nii(G);
G_nii.hdr.dime.pixdim(2:4)=pixdim;
% save file
new_folder=sprintf('6_blur_v3'); 
mkdir(InPath, new_folder); 
OutFile=sprintf('%s/%s/Patient_%s_r_brain_itp_restore_gradient_gaussian.nii',InPath,new_folder,Patient_number);
save_nii(G_nii, OutFile);
Time=toc;
str=sprintf ('Gradient map is done.\n Method: Gaussian filter.');
disp(str)
end





%***********************************************************************************
%  Input:
%        example: Patient_001_r_brain_itp_restore.nii.gz
%  Output:
%        example: Patient_001_r_brain_itp_restore_gradient_v2.nii         
% 
% 
%**********************************************************************************
clear all
clc
tic
addpath('/scratch/xiaqu/Tools for NIfTI and ANALYZE image');

PATNO=1;
% open data
for PATNO=1:1:1
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
% Sobel operator-3D
Sobel_x=zeros(3,3,3);      
Sobel_x(:,:,1)=[-2 -4 -2; 0  0  0; 2  4  2];
Sobel_x(:,:,2)=[-4 -8 -4; 0  0  0; 4  8  4];
Sobel_x(:,:,3)=[-2 -4 -2; 0  0  0; 2  4  2]; 

Sobel_y=zeros(3,3,3);      
Sobel_y(:,:,1)=[-2 0 2; -4 0 4; -2 0 2];
Sobel_y(:,:,2)=[-4 0 4; -8 0 8; -4 0 4];
Sobel_y(:,:,3)=[-2 0 2; -4 0 4; -2 0 2];

Sobel_z=zeros(3,3,3);      
Sobel_z(:,:,1)=[-2 -4 -2; -4 -8 -4; -2 -4 -2];
Sobel_z(:,:,2)=[ 0  0  0;  0  0  0;  0  0  0];
Sobel_z(:,:,3)=[ 2  4  2;  4  8  4;  2  4  2];
% filter begin
Gx=imfilter(g,Sobel_x,'replicate','same');
Gy=imfilter(g,Sobel_y,'replicate','same');
Gz=imfilter(g,Sobel_z,'replicate','same');
G=sqrt((Gx).^2+(Gy).^2+(Gz).^2);% Gradient magnitude

G_nii=make_nii(G);
G_nii.hdr.dime.pixdim(2:4)=pixdim;
% save file
new_folder=sprintf('6_blur_gradient_v2'); 
mkdir(InPath, new_folder); 
OutFile=sprintf('%s/%s/Patient_%s_r_brain_itp_restore_gradient_v2.nii',InPath,new_folder,Patient_number);
save_nii(G_nii, OutFile);
Time=toc;
str=sprintf ('Gradient map is done.\n Method: Sobel operator-3D.');
disp(str)
end

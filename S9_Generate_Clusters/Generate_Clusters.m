clear all;close all;clc;

addpath('/home/xiaoxiaqu/scratch/Tools_for_NIfTI_and_ANALYZE_image');
Dir=sprintf('/home/xiaoxiaqu/research/MRI_FCD/XiaoxiaQu2015_2GAMC_EXP3/Classification3');
FCDlabel=1;
for TestNumber=2:1:10 % 1:1:10

%% 
INPUT=sprintf('%s/Patient_%03d_GAMC3_SEG1.nii.gz',Dir,TestNumber); 
g_nii=load_untouch_nii(INPUT); g=g_nii.img; 
%% ///////////////////////
%% Main Process-Begin
%% ///////////////////////
BW1=(g==FCDlabel);% when voxel value is 2, it is forground lebelled as; while others are  background. 
SE = strel('disk',2); % structure element
BW2 = imerode(BW1,SE);
BW3 = imdilate(BW2,SE);

% Step 1
%------------------------------
% make a binary image
conn=6;
% Label the binary image
%% L
% L is a label matrix, containing labels for the connected
% components in BW. The input image BW can
% have any dimension; L is the same size as BW.
% The elements of L are integer values greater than
% or equal to 0. The pixels labeled 0 are the background.
% The pixels labeled 1 make up one object; the pixels
% labeled 2 make up a second object; and so on.
%% NUM
% NUM is the total number of labels
[L, NUM] = bwlabeln(BW3, conn);
%% ///////////////////////
%% Main Process--End
%% ///////////////////////
%% Save
Out1_nii=make_nii(L); Out1_nii.hdr=g_nii.hdr;
OutName1=sprintf('./Patient_%03d_SEG1_Clusters1.nii.gz',TestNumber);
save_nii(Out1_nii,OutName1);

%% remove tiny regions
STATS = regionprops(L,'Area');
CELL=struct2cell(STATS);
MATRIX=cell2mat(CELL);
MATRIX=MATRIX';
IDX=find(MATRIX<50); % index ofthe tiny regions

for i=1:1:size(IDX,1)
    L(L==IDX(i))=0;
end
Out2_nii=make_nii(L); Out2_nii.hdr=g_nii.hdr;
OutName2=sprintf('./Patient_%03d_SEG1_Clusters2.nii.gz',TestNumber);
save_nii(Out2_nii,OutName2);

end


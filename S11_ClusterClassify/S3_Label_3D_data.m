clear all;clc;close all;tic
addpath('/home/xiaoxiaqu/scratch/Tools_for_NIfTI_and_ANALYZE_image');
DIR=sprintf('/home/xiaoxiaqu/research/MRI_FCD/Patient_T1_v2');
DIR2=sprintf('/home/xiaoxiaqu/research/MRI_FCD/XiaoxiaQu2015_2GAMC_EXP3/ClusterClassify');
%%
LabelFCD=2;
LabelNonFCD=1;
Background=0;

ClassifiedLabelColDX=19; % classified label, 1 is nonFCD, 2 is FCD.
ClusterIndex=18;%  cluster index

for TestNumber=2:1:10 % 1:1:10
    
    % LOAD CLUSTER INDEXS (CluIdx)
    INPUT1=sprintf('../Generate_Clusters/Patient_%03d_SEG1_Clusters2.nii.gz',TestNumber);
    CluIdx_nii=load_untouch_nii(INPUT1); CluIdx=CluIdx_nii.img;
    % load classified results
    InName2=sprintf('../ClusterClassify/Patient_%03d_Results.csv',TestNumber);
    DataIn=csvread(InName2);
    %
    InName1=sprintf('%s/Patient_%03d/5_AtlasSeg/Patient_%03d_affine_mixeltype_AtlasSeg.nii.gz',DIR,TestNumber,TestNumber);
    TissueSeg_nii=load_untouch_nii(InName1); TissueSeg=TissueSeg_nii.img;
    
    
    %% output 1
    
    OutImage1=zeros(size(CluIdx));
    
    for i=1:1:size(DataIn,1)
        
        if DataIn(i,ClassifiedLabelColDX)==LabelFCD
            OutImage1(CluIdx==DataIn(i,ClusterIndex))=LabelFCD;
        end
        
    end
    OutImage1_nii=make_nii(OutImage1);
    OutImage1_nii.hdr=CluIdx_nii.hdr;
    OutName1=sprintf('./Patient_%03d_Label_3D_data.nii.gz',TestNumber);
    save_nii(OutImage1_nii,OutName1);
    
        %% output 2
        
    OutImage2=zeros(size(TissueSeg));
    OutImage2=((TissueSeg==1)|(TissueSeg==5));
    OutImage2=single(OutImage2);
    OutImage2(OutImage1==LabelFCD)=2;
    
    OutImage2_nii=make_nii(OutImage2);
    OutImage2_nii.hdr=CluIdx_nii.hdr;
    OutName2=sprintf('./Patient_%03d_Label_3D_data_V2.nii.gz',TestNumber);
    save_nii(OutImage2_nii,OutName2);
    
    
    %% output 3
    OutImage3=TissueSeg;
    OutImage3(OutImage1==LabelFCD)=6;
    OutImage3_nii=make_nii(OutImage3);
    OutImage3_nii.hdr=CluIdx_nii.hdr;
    OutName3=sprintf('./Patient_%03d_Label_3D_data_V3.nii.gz',TestNumber);
    save_nii(OutImage3_nii,OutName3);
    
    
end
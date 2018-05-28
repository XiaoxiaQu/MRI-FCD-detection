
%%
clear all;clc;close all;tic

addpath('/home/xiaoxiaqu/scratch/Tools_for_NIfTI_and_ANALYZE_image');

Dir=sprintf('/home/xiaoxiaqu/research/MRI_FCD/Patient_T1_v2');
%%
% outputs:
% features and labels including FCD and nonFCD
LabelFCD=2;
LabelNonFCD=1;
Background=0;


for TestNumber=2:1:10 % 1:1:10
    %% LOAD CLUSTER INDEXS (CluIdx)
    INPUT1=sprintf('../Generate_Clusters/Patient_%03d_SEG1_Clusters2.nii.gz',TestNumber);
    CluIdx_nii=load_untouch_nii(INPUT1); CluIdx=CluIdx_nii.img;
    %% Load features
    % [1]GMthick
    % [2]GMthick_zscore
    % [3]Gradient
    % [4]Gradient_zscore
    % [5]GWBthick_Extend
    % [6]GWBthick_Extend_zscore
    % [7]RIM_smooth
    % [8]RIM_smooth_zscore
    % [9]sulcal_depth
    % [10]sulcal_depth_zscore
    % [11]curvatres
    % [12]curvatres_zscore
    
    % [1]GMthick
    FileIn1=sprintf('%s/Patient_%03d/6_Features1/Patient_%03d_affine_pve_GMthick.nii.gz',Dir,TestNumber,TestNumber);
    Image1_nii=load_untouch_nii(FileIn1); Image1=Image1_nii.img; clear Image1_nii;
    % [2]GMthick_zscore
    FileIn2=sprintf('%s/Patient_%03d/Hong2014/z_score/Patient_%03d_GMthick_z_score.nii.gz',Dir,TestNumber,TestNumber);
    Image2_nii=load_untouch_nii(FileIn2); Image2=Image2_nii.img; clear Image2_nii;
    % [3]Gradient
    %     FileIn3=sprintf('%s/Patient_%03d/6_Features1/Patient_%03d_affine_restore_Gradient.nii.gz',Dir,TestNumber,TestNumber);
    %     Image3_nii=load_untouch_nii(FileIn3); Image3=Image3_nii.img; clear Image3_nii
    % [4]Gradient_zscore
    %     FileIn4=sprintf('%s/Patient_%03d/Hong2014/z_score/Patient_%03d_Gradient_z_score.nii.gz',Dir,TestNumber,TestNumber);
    %     Image4_nii=load_untouch_nii(FileIn4); Image4=Image4_nii.img; clear Image4_nii
    % [5]GWBthick_Extend
    FileIn5=sprintf('%s/Patient_%03d/XiaoxiaQu2015_2/Features/Patient_%03d_GWBthick_Extend.nii.gz',Dir,TestNumber,TestNumber);
    Image5_nii=load_untouch_nii(FileIn5); Image5=Image5_nii.img; clear Image5_nii
    %  [6]GWBthick_Extend_zscore
    FileIn6=sprintf('%s/Patient_%03d/XiaoxiaQu2015_2/Features/Patient_%03d_GWBthick_Extend_VS_Healthy_zscore.nii.gz',Dir,TestNumber,TestNumber);
    Image6_nii=load_untouch_nii(FileIn6); Image6=Image6_nii.img; clear Image6_nii
    %      [7]RIM_smooth
    %     FileIn7=sprintf('%s/Patient_%03d/XiaoxiaQu2015_2/Features/Patient_%03d_RIM_smooth.nii.gz',Dir,TestNumber,TestNumber);
    %     Image7_nii=load_untouch_nii(FileIn7); Image7=Image7_nii.img; clear Image7_nii
    % [8]RIM_smooth_zscore
    %     FileIn8=sprintf('%s/Patient_%03d/Hong2014/z_score/Patient_%03d_RIM_z_score.nii.gz',Dir,TestNumber,TestNumber);
    %     Image8_nii=load_untouch_nii(FileIn8); Image8=Image8_nii.img; clear Image8_nii
    % [9]sulcal_depth
    %     FileIn9=sprintf('%s/Patient_%03d/Hong2014/sulcal_depth/Patient_%03d_sulcal_3_depth.nii.gz',Dir,TestNumber,TestNumber);
    %     Image9_nii=load_untouch_nii(FileIn9); Image9=Image9_nii.img; clear Image9_nii
    %  [10]sulcal_depth_zscore
    % FileIn10=sprintf('%s/Patient_%03d/Hong2014/z_score/Patient_%03d_SulcalDepth_z_score.nii.gz',Dir,TestNumber,TestNumber);
    %     Image10_nii=load_untouch_nii(FileIn10); Image10=Image10_nii.img; clear Image10_nii
    %  [11]curvatres
    % FileIn11=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_curvatres_Cmean_volume.nii.gz',Dir,TestNumber,TestNumber);
    %     Image11_nii=load_untouch_nii(FileIn11); Image11=Image11_nii.img; clear Image11_nii
    % [12]curvatres_zscore
    % FileIn12=sprintf('%s/Patient_%03d/Hong2014/z_score/Patient_%03d_curvatres_z_score.nii.gz',Dir,TestNumber,TestNumber);
    %     Image12_nii=load_untouch_nii(FileIn12); Image12=Image12_nii.img; clear Image12_nii
    
    % ground truth, FCD=6;---------------
    INPUT_GT=sprintf('%s/Patient_%03d/7_Ground_Truth/Patient_%03d_labels.nii.gz',Dir,TestNumber,TestNumber);
    GT_nii=load_untouch_nii(INPUT_GT); GT=GT_nii.img; clear GT_nii
    
    %%
    % OUTCSV=[];
    gMAX=max(CluIdx(:)); % the max of the index of clusters
    K=0;
    GT_count=zeros(size(GT));
    
    for  i=1:1:gMAX % index of clusters
        MASK=(CluIdx==i);
        MASKSUM=sum(MASK(:));
        if MASKSUM==0 % empty cluster
            continue;
        else
            
            K=K+1;
            I=Image1(CluIdx==i);
         
            OUTCSV(K,1)=mean(I(:)); 
            OUTCSV(K,2)=std(I(:)); 
            OUTCSV(K,3)=skewness(I(:));
            OUTCSV(K,4)=kurtosis(I(:));
            clear I
            
            I=Image2(CluIdx==i);
            OUTCSV(K,5)=mean(I(:));
            OUTCSV(K,6)=std(I(:));
            OUTCSV(K,7)=skewness(I(:));
            OUTCSV(K,8)=kurtosis(I(:));
            clear I
            
            I=Image5(CluIdx==i);
            OUTCSV(K,9)=mean(I(:));
            OUTCSV(K,10)=std(I(:));
            OUTCSV(K,11)=skewness(I(:));
            OUTCSV(K,12)=kurtosis(I(:));
            clear I
            
            I=Image6(CluIdx==i);
            OUTCSV(K,13)=mean(I(:));
            OUTCSV(K,14)=std(I(:));
            OUTCSV(K,15)=skewness(I(:));
            OUTCSV(K,16)=kurtosis(I(:));
            clear I
            
            
            GT_count=((MASK==1)&(GT==6));
            GT_count_SUM=sum(GT_count(:));
            if  GT_count_SUM>1
                OUTCSV(K,17)=LabelFCD;
            else
                OUTCSV(K,17)=LabelNonFCD;
            end
            OUTCSV(K,18)=i;
        end
        clear MASK MASKSUM
        string=sprintf('Cluster Number:%05d.',i);
        disp(string)
    end
    filename=sprintf('./Patient_%03d_Clusters_Features.csv',TestNumber);
    csvwrite(filename,OUTCSV);
    
    
end


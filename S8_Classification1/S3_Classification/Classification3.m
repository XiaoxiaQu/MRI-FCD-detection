

%%
clear all;clc;close all;tic
%%

Dir2=sprintf('/home/xiaoxiaqu/research/MRI_FCD/Patient_T1_v2');
Dir3=sprintf('/home/xiaoxiaqu/research/MRI_FCD/XiaoxiaQu2015_2GAMC_EXP3');
addpath('/home/xiaoxiaqu/scratch/Tools_for_NIfTI_and_ANALYZE_image');
addpath('/home/xiaoxiaqu/research/MRI_FCD/Patient_T1_v2/CODE/10_Classifier_v5/code/function');
%%
% Features in sample:
%[1]GMthick"<< std::endl;
 %[2]GMthick_zscore"<< std::endl;
 %[3]Gradient" << std::endl;
 %[4]Gradient_zscore" << std::endl;
 %[5]GWBthick_Extend" << std::endl;
 %[6]GWBthick_Extend_zscore" << std::endl;
 %[7]RIM_smooth" << std::endl;
 %[8]RIM_smooth_zscore" << std::endl;
% [9]label


LabelFCD=1;
LabelNonFCD=0;


%%
for TestNumber=2:1:10 % 1:1:10
  
    
    % 
    InFile1=sprintf('%s/Classification1/Patient_%03d_GAMC1_SEG1.nii.gz',Dir3,TestNumber);
    g1_nii=load_untouch_nii(InFile1); g1=g1_nii.img; clear g1_nii
    % 
     InFile2=sprintf('%s/Classification2/Patient_%03d_GAMC2_SEG1.nii.gz',Dir3,TestNumber);
    g2_nii=load_untouch_nii(InFile2); g2=g2_nii.img; clear g2_nii
    
    
    g3=((g1==1) & (g2==1) );
    g3=single(g3);
    
    % Tissue seg-------------------------
    INPUT_TissueSeg=sprintf('%s/Patient_%03d/5_AtlasSeg/Patient_%03d_affine_mixeltype_AtlasSeg.nii.gz',Dir2,TestNumber,TestNumber);
    TissueSeg_nii=load_untouch_nii(INPUT_TissueSeg); TissueSeg=TissueSeg_nii.img; % clear TissueSeg_nii
    % Ground Truth, FCD=6;---------------
    INPUT_GT=sprintf('%s/Patient_%03d/7_Ground_Truth/Patient_%03d_labels.nii.gz',Dir2,TestNumber,TestNumber);
    GT_nii=load_untouch_nii(INPUT_GT); GT=GT_nii.img; clear GT_nii
    %
    
    
    MASK_TissueSeg=((TissueSeg==1)|(TissueSeg==5));
    TestG_GT(:,1)=GT(:);
    MASK_EVA=MASK_TissueSeg(:);

   TestG=g3(:);
 
     
    %  clear TestG_NB  TestG_LDA TestG_MDA TestG_QDA TestD
    
    %% ################################
    SEG1=g3;
    SEG1=SEG1.*MASK_TissueSeg;
    SEG1_nii=make_nii(SEG1); SEG1_nii.hdr=TissueSeg_nii.hdr;
      % save
    OutName1=sprintf('./Patient_%03d_GAMC3_SEG1.nii.gz',TestNumber);
    save_nii(SEG1_nii,OutName1);    
    %% //////////////////////    
    %% Classify MRI data---End
    %% //////////////////////   
    SEG2=TissueSeg;
    SEG2(SEG1==LabelFCD)=6;
    SEG2_nii=make_nii(SEG2); SEG2_nii.hdr=TissueSeg_nii.hdr;
    % save
    OutName2=sprintf('./Patient_%03d_GAMC3_SEG2.nii.gz',TestNumber);
    save_nii(SEG2_nii,OutName2);   
    
    %%
    clear SEG1 SEG1_nii  SEG2 SEG2_nii TissueSeg TissueSeg_nii
    %% Evaluation
    LabelFCD_GT=6;
    [TestEVAtmp]=MyEvaluation_MRI(TestG,TestG_GT,MASK_EVA,LabelFCD,LabelFCD_GT);
    TestEVA(TestNumber,:)=TestEVAtmp;
    
    Evaluation_Name1=sprintf('./Patient_%03d_GAMC3_SEG1.csv',TestNumber);
    csvwrite(Evaluation_Name1,TestEVA);
    clear TestG TestG_GT MASK_EVA
end

for i=1:1:13
    TestEVA(11,i)=mean(TestEVA(:,i));
end

Evaluation_Name2=sprintf('./Patient_GAMC3_SEG1_EVA.csv');
csvwrite(Evaluation_Name2,TestEVA);

% clear TestEVA












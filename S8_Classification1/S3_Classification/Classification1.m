

%%
clear all;clc;close all;tic
%%
Dir1=sprintf('/home/xiaoxiaqu/research/MRI_FCD/XiaoxiaQu2015_2GAMC_EXP3/SamplesPick/Samples');
Dir2=sprintf('/home/xiaoxiaqu/research/MRI_FCD/Patient_T1_v2');
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
 % [9]sulcal_depth
% [10]sulcal_depth_zscore
% [11]curvatres
% [12]curvatres_zscore
% [13]label

FeatureCol=[1,5]; % ColIndex
LabelFCD=1;
LabelNonFCD=0;
LabelCol=13;

%%
for TestNumber=2:1:10% 1:1:10
    i=0;
    % //////////////////////
    %% Training Data
    % //////////////////////
    
    for SampleNum=1:1:10
        if (SampleNum~=TestNumber) % Leave one out cross validation
            i=i+1; % the first group of samples
            filename1=sprintf('%s/Patient_%03d_Samples_FCD.csv',Dir1,SampleNum);
            filename2=sprintf('%s/Patient_%03d_Samples_GM.csv',Dir1,SampleNum);
            filename3=sprintf('%s/Patient_%03d_Samples_GWB.csv',Dir1,SampleNum);
            % load data from 'filename' to array 'data'.
            % starting at zero-based row 1, column 0.
            Sample1 = csvread(filename1,1,0);
            Sample2 = csvread(filename2,1,0);
            Sample3 = csvread(filename3,1,0);
            
            if (i==1)
                Feature1=Sample1(:,FeatureCol);
                Feature2=Sample2(:,FeatureCol);
                Feature3=Sample3(:,FeatureCol);
                Label1(:,1)=Sample1(:,LabelCol)/6*LabelFCD;
                Label2(:,1)=Sample2(:,LabelCol)/1*LabelNonFCD;
                Label3(:,1)=Sample3(:,LabelCol)/5*LabelNonFCD;
            else
                Feature1 =[Feature1; Sample1(:,FeatureCol)];
                Feature2 =[Feature2; Sample2(:,FeatureCol)];
                Feature3 =[Feature3; Sample3(:,FeatureCol)];
                Label1=[Label1;Sample1(:,LabelCol)/6*LabelFCD];
                Label2=[Label2;Sample2(:,LabelCol)/1*LabelNonFCD];
                Label3=[Label3;Sample3(:,LabelCol)/5*LabelNonFCD];
            end
        end
    end
    
    
    TrainD=[Feature1;Feature2;Feature3];
    TrainG_GT=[Label1;Label2;Label3];
    TrainG_GT=round(TrainG_GT);
    
    clear filename1 filename2 filename3
    clear Sample1 Sample2 Sample3
    clear Feature1 Feature2 Feature3
    clear Label1 Label2 Label3
    
    
    %% Load features
    % [*]GMthick
    % [*]GMthick_zscore
    % [*]Gradient
    % [*]Gradient_zscore
    % [*]GWBthick_Extend
    % [*]GWBthick_Extend_zscore
    % [*]RIM_smooth
    % [*]RIM_smooth_zscore
     % [9]sulcal_depth
% [10]sulcal_depth_zscore
% [11]curvatres
% [12]curvatres_zscore
% [13]label
    
%     % [*]GMthick
    FileIn1=sprintf('%s/Patient_%03d/6_Features1/Patient_%03d_affine_pve_GMthick.nii.gz',Dir2,TestNumber,TestNumber);
    Image1_nii=load_untouch_nii(FileIn1); Image1=Image1_nii.img; clear Image1_nii;
%     % [*]GMthick_zscore
%     FileIn2=sprintf('%s/Patient_%03d/Hong2014/z_score/Patient_%03d_GMthick_z_score.nii.gz',Dir2,TestNumber,TestNumber);
%     Image2_nii=load_untouch_nii(FileIn2); Image2=Image2_nii.img; clear Image2_nii;
% %     % [*]Gradient
%     FileIn3=sprintf('%s/Patient_%03d/6_Features1/Patient_%03d_affine_restore_Gradient.nii.gz',Dir2,TestNumber,TestNumber);
%     Image3_nii=load_untouch_nii(FileIn3); Image3=Image3_nii.img; clear Image3_nii
%     % [*]Gradient_zscore
%     FileIn4=sprintf('%s/Patient_%03d/Hong2014/z_score/Patient_%03d_Gradient_z_score.nii.gz',Dir2,TestNumber,TestNumber);
%     Image4_nii=load_untouch_nii(FileIn4); Image4=Image4_nii.img; clear Image4_nii
    % [*]GWBthick_Extend
    FileIn5=sprintf('%s/Patient_%03d/XiaoxiaQu2015_2/Features/Patient_%03d_GWBthick_Extend.nii.gz',Dir2,TestNumber,TestNumber);
    Image5_nii=load_untouch_nii(FileIn5); Image5=Image5_nii.img; clear Image5_nii
    % [*]GWBthick_Extend_zscore
%     FileIn6=sprintf('%s/Patient_%03d/XiaoxiaQu2015_2/Features/Patient_%03d_GWBthick_Extend_VS_Healthy_zscore.nii.gz',Dir2,TestNumber,TestNumber);
%     Image6_nii=load_untouch_nii(FileIn6); Image6=Image6_nii.img; clear Image6_nii
%     % [*]RIM_smooth
%     FileIn7=sprintf('%s/Patient_%03d/XiaoxiaQu2015_2/Features/Patient_%03d_RIM_smooth.nii.gz',Dir2,TestNumber,TestNumber);
%     Image7_nii=load_untouch_nii(FileIn7); Image7=Image7_nii.img; clear Image7_nii
    % [*]RIM_smooth_zscore
%     FileIn8=sprintf('%s/Patient_%03d/Hong2014/z_score/Patient_%03d_RIM_z_score.nii.gz',Dir2,TestNumber,TestNumber);
%     Image8_nii=load_untouch_nii(FileIn8); Image8=Image8_nii.img; clear Image8_nii
 % [9]sulcal_depth
%     FileIn9=sprintf('%s/Patient_%03d/Hong2014/sulcal_depth/Patient_%03d_sulcal_3_depth.nii.gz',Dir2,TestNumber,TestNumber);
%     Image9_nii=load_untouch_nii(FileIn9); Image9=Image9_nii.img; clear Image9_nii
% % [10]sulcal_depth_zscore
% FileIn10=sprintf('%s/Patient_%03d/Hong2014/z_score/Patient_%03d_SulcalDepth_z_score.nii.gz',Dir2,TestNumber,TestNumber);
%     Image10_nii=load_untouch_nii(FileIn10); Image10=Image10_nii.img; clear Image10_nii
% % [11]curvatres
% FileIn11=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_curvatres_Cmean_volume.nii.gz',Dir2,TestNumber,TestNumber);
%     Image11_nii=load_untouch_nii(FileIn11); Image11=Image11_nii.img; clear Image11_nii
% % [12]curvatres_zscore
% FileIn12=sprintf('%s/Patient_%03d/Hong2014/z_score/Patient_%03d_curvatres_z_score.nii.gz',Dir2,TestNumber,TestNumber);
%     Image12_nii=load_untouch_nii(FileIn12); Image12=Image12_nii.img; clear Image12_nii
% [13]label
 
    
    % Tissue seg-------------------------
    INPUT_TissueSeg=sprintf('%s/Patient_%03d/5_AtlasSeg/Patient_%03d_affine_mixeltype_AtlasSeg.nii.gz',Dir2,TestNumber,TestNumber);
    TissueSeg_nii=load_untouch_nii(INPUT_TissueSeg); TissueSeg=TissueSeg_nii.img; % clear TissueSeg_nii
    % Ground Truth, FCD=6;---------------
    INPUT_GT=sprintf('%s/Patient_%03d/7_Ground_Truth/Patient_%03d_labels.nii.gz',Dir2,TestNumber,TestNumber);
    GT_nii=load_untouch_nii(INPUT_GT); GT=GT_nii.img; clear GT_nii
    %%
    i=1;
    TestD(:,i)=Image1(:); i=i+1;
    TestD(:,i)=Image5(:);i=i+1;
  
    
    MASK_TissueSeg=((TissueSeg==1)|(TissueSeg==5));
    TestG_GT(:,1)=GT(:);
    MASK_EVA=MASK_TissueSeg(:);
  clear Image1  Image5

    
    % TissueSeg_nii and TissueSeg control the format of output 3D data
    
    %//////////////////////
   %% Classify MRI data---Begin
    % //////////////////////
    % ///////////////////////////////////////////////////////////////
    % CLassifier---[1] Bayes_Naive: Naive Bayes classifier
    Classifier_Bayes_Naive=NaiveBayes.fit(TrainD,TrainG_GT);
    TestG_NB = predict(Classifier_Bayes_Naive,TestD);
    % /////////////////////////////////////////////////////////////
    % CLassifier---[2] DA_linear: Discriminant analysis (DA) classifier, linear model.
    TestG_LDA=classify(TestD,TrainD,TrainG_GT,'linear');
    % ///////////////////////////////////////////////////////////////
    % CLassifier---[3] DA_mahalanobis
    TestG_MDA=classify(TestD,TrainD,TrainG_GT,'mahalanobis');
    % ///////////////////////////////////////////////////////////////
    % CLassifier---[4] DA_quadratic
    TestG_QDA=classify(TestD,TrainD,TrainG_GT,'quadratic');
    
    %%  ############################
    % GAMC: genetic algorithm optimize the weights of multiple classifiers
    Weights(1)=1;Weights(2)=1;Weights(3)=1;Weights(4)=1; T=4;
     
     TestG1=TestG_NB*Weights(1)+TestG_LDA*Weights(2)+TestG_MDA*Weights(3)+TestG_QDA*Weights(4);
     TestG=ones(size(TestG_NB))*LabelNonFCD;
     TestG(TestG1>=4)=LabelFCD;
     
    %  clear TestG_NB  TestG_LDA TestG_MDA TestG_QDA TestD
    
    %% ################################
    SEG1=reshape(TestG,size(TissueSeg));
    SEG1=SEG1.*MASK_TissueSeg;
    SEG1_nii=make_nii(SEG1); SEG1_nii.hdr=TissueSeg_nii.hdr;
      % save
    OutName1=sprintf('./Patient_%03d_GAMC1_SEG1.nii.gz',TestNumber);
    save_nii(SEG1_nii,OutName1);    
    %% //////////////////////    
    %% Classify MRI data---End
    %% //////////////////////   
    SEG2=TissueSeg;
    SEG2(SEG1==LabelFCD)=6;
    SEG2_nii=make_nii(SEG2); SEG2_nii.hdr=TissueSeg_nii.hdr;
    % save
    OutName2=sprintf('./Patient_%03d_GAMC1_SEG2.nii.gz',TestNumber);
    save_nii(SEG2_nii,OutName2);   
    
    %%
    clear SEG1 SEG1_nii  SEG2 SEG2_nii TissueSeg TissueSeg_nii
    %% Evaluation
    LabelFCD_GT=6;
    [TestEVAtmp]=MyEvaluation_MRI(TestG,TestG_GT,MASK_EVA,LabelFCD,LabelFCD_GT);
    TestEVA(TestNumber,:)=TestEVAtmp;
    
    Evaluation_Name1=sprintf('./Patient_%03d_GAMC1_SEG1.csv',TestNumber);
    csvwrite(Evaluation_Name1,TestEVA);
    clear TestG TestG_GT MASK_EVA
end

for i=1:1:13
    TestEVA(11,i)=mean(TestEVA(:,i));
end

Evaluation_Name2=sprintf('./Patient_GAMC1_SEG1_EVA.csv');
csvwrite(Evaluation_Name2,TestEVA);

% clear TestEVA












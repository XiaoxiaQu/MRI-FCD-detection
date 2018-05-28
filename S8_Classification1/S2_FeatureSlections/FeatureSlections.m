%%
clear all;clc;close all;tic

%% Load Samples
DIR1=sprintf('/home/xiaoxiaqu/research/MRI_FCD/XiaoxiaQu2015_2GAMC_EXP3/SamplesPick/Samples');
%%
% Features in sample:
% [1]GMthick [2]GMthick_zscore [3]Gradient [4]Gradient_zscore [5]GWBthick_Extend [6]GWBthick_Extend_zscore
% [7]RIM_smooth [8]RIM_smooth_zscore  [9]sulcal_depth  [10]sulcal_depth_zscore  [11]curvatres  [12]curvatres_zscore

% label=6, FCD;  label=5,GWB;  label=1,GM
p = mfilename('fullpath');


LabelCol=13;
LabelFCD=2;
LabelFCD_GT=2;
LabelNonFCD=1;


FeatureName=char('GMthick','GMthickFD', 'Gradient', 'GradientFD', 'GWBwidth', ...
    'GWBwidthFD','RIM', 'RIMFD','SulcalDepth','SulcalDepthFD',...
    'Curvatres','CurvatresFD');

for FeatureCol=2:1:12 % 1:12
str=FeatureName(FeatureCol,:);
str((isspace(str))) = [];

for TestNumber=1:1:10
    
    %% test samples
    filename1=sprintf('%s/Patient_%03d_Samples_FCD.csv',DIR1,TestNumber);
    filename2=sprintf('%s/Patient_%03d_Samples_GM.csv',DIR1,TestNumber);
    filename3=sprintf('%s/Patient_%03d_Samples_GWB.csv',DIR1,TestNumber);
    % load data from 'filename' to array 'data'.
    % starting at zero-based row 1, column 0.
    Sample1 = csvread(filename1,1,0);
    Sample2 = csvread(filename2,1,0);
    Sample3 = csvread(filename3,1,0);
    
    Feature1=Sample1(:,FeatureCol);
    Feature2=Sample2(:,FeatureCol);
    Feature3=Sample3(:,FeatureCol);
    Label1(:,1)=Sample1(:,LabelCol)/6*LabelFCD;
    Label2(:,1)=Sample2(:,LabelCol)/1*LabelNonFCD;
    Label3(:,1)=Sample3(:,LabelCol)/5*LabelNonFCD;    
    
    TestD=[Feature1;Feature2;Feature3];
    TestG_GT=[Label1;Label2;Label3];
    TestG_GT=round(TestG_GT);
    
    clear filename1 filename2 filename3
    clear Sample1 Sample2 Sample3
    clear Feature1 Feature2 Feature3
    clear Label1 Label2 Label3
    %% end of test samples
    
    %% training samples
    i=0;
    for SampleNum=1:1:10
        if (SampleNum~=TestNumber) % Leave one out cross validation
            i=i+1; % the first group of samples
            filename1=sprintf('%s/Patient_%03d_Samples_FCD.csv',DIR1,SampleNum);
            filename2=sprintf('%s/Patient_%03d_Samples_GM.csv',DIR1,SampleNum);
            filename3=sprintf('%s/Patient_%03d_Samples_GWB.csv',DIR1,SampleNum);
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
    
    %% end of training samples



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

%% Evaluations


% step1
for i=1:1:4
    switch i
        case 1
            TestG=TestG_NB;
        case 2
            TestG=TestG_LDA;
        case 3
            TestG=TestG_MDA;
        case 4
            TestG=TestG_QDA;
    end


   TPc=((TestG==LabelFCD) & (TestG_GT==LabelFCD_GT)  ); TP=sum(TPc(:));
   FPc=((TestG==LabelFCD) & (TestG_GT~=LabelFCD_GT)  ); FP=sum(FPc(:));
   FNc=((TestG~=LabelFCD) & (TestG_GT==LabelFCD_GT)  ); FN=sum(FNc(:));
%    TNc=((TestG~=LabelFCD) & (TestG_GT~=LabelFCD_GT)  ); TN=sum(TNc(:));
   
   F1=2*TP/(2*TP+FP+FN);
   
   EVA(TestNumber,i)=F1;

end


 EVA(TestNumber,5)=mean(EVA(TestNumber,1:4),2);


end

  for i=1:1:5
  
 EVA(11,i)=mean(EVA(1:10,i),1);
 EVA(12,i)=std(EVA(1:10,i),1);
 
  end


FigName=sprintf('%s_%s.csv',p,str);
csvwrite(FigName,EVA);

clear EVA

end







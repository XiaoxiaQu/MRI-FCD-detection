
clear all; close all; clc;
FCD_label=2;
nonFCD_label=1;
TolCol=16; % the total umber of features, columns

GTlabelColumnIDX=17;
OutLabelColIDX=19;

for TestNUM=2:1:10
    %% load test data
    filename1=sprintf('../ClusterFeatures/Patient_%03d_Clusters_Features.csv',TestNUM);
    dataTest=csvread(filename1);
    TestD=dataTest(:,1:TolCol);
    TestG_GT=dataTest(:,GTlabelColumnIDX);
    
    i=0;
    
    %% load train data
    for TrainNUM=1:1:10
        if (TrainNUM~=TestNUM)
            i=i+1;
            filename2=sprintf('../ClusterFeatures/Patient_%03d_Clusters_Features.csv',TrainNUM);
            dataTrain=csvread(filename2);
            
            if (i==1)
                TrainD=dataTrain(:,1:TolCol);
                TrainG_GT=dataTrain(:,GTlabelColumnIDX);
            else
                TrainD=[TrainD;dataTrain(:,1:TolCol)]; % 4619 rows
                TrainG_GT=[TrainG_GT;dataTrain(:,GTlabelColumnIDX)];
            end
            %
        end
    end
    [row,col]=find(isnan(TrainD));
    TrainD(row,:)=[];
    TrainG_GT(row,:)=[];
    
    %% #################
    % CLassifier---Linear Discriminant analysis (LDA)
    TestG=classify(TestD,TrainD,TrainG_GT,'linear');
    OUTDATA=dataTest;
    OUTDATA(:,OutLabelColIDX)=TestG;
    OutName1=sprintf('./Patient_%03d_Results.csv',TestNUM);
    csvwrite(OutName1,OUTDATA);
    %% #################################
    %% EVALUATION
    TPc=(TestG_GT==FCD_label & TestG==FCD_label);TP=sum(TPc(:));
    FPc=(TestG_GT==nonFCD_label & TestG==FCD_label);FP=sum(FPc(:));
    TNc=(TestG_GT==nonFCD_label & TestG==nonFCD_label);TN=sum(TNc(:));
    FNc=(TestG_GT==FCD_label & TestG==nonFCD_label);FN=sum(FNc(:));
    TPR=TP/(TP+FN);
    TNR=TN/(FP+TN);
    PPV=TP/(TP+FP);
    NPV=TN/(TN+FN);
    FPR=FP/(FP+TN);
    FDR=FP/(FP+TP);
    ACC=(TP+TN)/(TP+FP+TN+FN);
    F1=2*TP/(2*TP+FP+FN);
    MCC=(TP*TN-FP*FN)/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
    TestEVA(1,1)=TP;
    TestEVA(1,2)=FP;
    TestEVA(1,3)=TN;
    TestEVA(1,4)=FN;
    TestEVA(1,5)=TPR;
    TestEVA(1,6)=TNR;
    TestEVA(1,7)=PPV;
    TestEVA(1,8)=NPV;
    TestEVA(1,9)=FPR;
    TestEVA(1,10)=FDR;
    TestEVA(1,11)=ACC;
    TestEVA(1,12)=F1;
    TestEVA(1,13)=MCC;
    OutName2=sprintf('./Patient_%03d_Evaluations.csv',TestNUM);
    csvwrite(OutName2,TestEVA);
    TestEVA_ALL(TestNUM,:)=TestEVA;
    %
end

for i=1:1:13
    TestEVA_ALL(11,i)=mean(TestEVA_ALL(:,i));
    TestEVA_ALL(12,i)=std(TestEVA_ALL(:,i));
end
OutName3=sprintf('./Patient_Evaluations_ALL.csv');
csvwrite(OutName3,TestEVA_ALL);






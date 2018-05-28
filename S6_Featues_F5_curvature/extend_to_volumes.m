
clear all; clc; close all;
% read curvature value file and GM potential file 
% extend the curvature values to the GM potential 
addpath('/media/xiaqu/HardDisk/research/MRI_Tools/Matlab/toolbox_graph/toolbox_graph');
addpath('/media/xiaqu/HardDisk/research/MRI_Tools/Matlab/toolbox_graph/toolbox_graph/toolbox');
addpath('/media/xiaqu/HardDisk/research/MRI_Tools/Matlab/Tools for NIfTI and ANALYZE image');

DIR=sprintf('/media/xiaqu/HardDisk/research/MRI_FCD/Patient_T1_v2');

for NUM=10:1:10 
% read surface curvatures
FileName1=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres_Cmean.nii.gz',DIR,NUM,NUM);
Sur_Curv=load_untouch_nii(FileName1);
% read GM potential 
FileName2=sprintf('%s/Patient_%03d/Hong2014/GM_potential/Patient_%03d_GM_2_potential.nii.gz',DIR,NUM,NUM);
GM_potential=load_untouch_nii(FileName2);
%% ####################### computation ##########################
% GM region vale 50-150

Potential=GM_potential.img;
CurvIn=Sur_Curv.img;
BKG=-0.1;
CurvOut=BKG*ones(size(Potential));

for i=3:size(Potential,1)-3
    for j=3:size(Potential,2)-3
        for k=3:size(Potential,3)-3
            if CurvIn(i,j,k)>=-0.05 && CurvIn(i,j,k)<=0.05
                if Potential(i,j,k)>50 && Potential(i,j,k)<150
                    is=i;js=j;ks=k;
                    ip=i;jp=j;kp=k;
                    while    Potential(is,js,ks)<150
                        tmp1=Potential((is-1):(is+1),(js-1):(js+1),(ks-1):(ks+1))-Potential(is,js,ks);
                        [ison1,json1,kson1]=ind2sub(size(tmp1),find(tmp1==max(tmp1(:))));
                      
                        is=ison1(1)+is-2;
                        js=json1(1)+js-2;
                        ks=kson1(1)+ks-2;
                        CurvOut(is,js,ks)=CurvIn(i,j,k);
                        if tmp1(ison1,json1,kson1)==tmp1(2,2,2) % values are equals, to avoid to enter a dead loop
                            break;
                        end
                    end
                    while    Potential(ip,jp,kp)>50
                        tmp2=Potential((ip-1):(ip+1),(jp-1):(jp+1),(kp-1):(kp+1))-Potential(ip,jp,kp);
                        [ipar1,jpar1,kpar1]=ind2sub(size(tmp2),find(tmp2==min(tmp2(:))));
                        ip=ipar1(1)+ip-2;
                        jp=jpar1(1)+jp-2;
                        kp=kpar1(1)+kp-2;
                        CurvOut(ip,jp,kp)=CurvIn(i,j,k);  
                        if tmp1(ipar1,jpar1,kpar1)==tmp1(2,2,2) % values are equals, to avoid to enter a dead loop
                            break;
                        end
                    end
                end
            end
        end
    end
    str=sprintf('Sagittal %dth slice of %d',i, size(Potential,1));
    disp(str)
end
    str=sprintf('step 1 work done in subject %03d',NUM);
    disp(str)
%%
NEI=3;
for iter=1:1:3   
    for i=(NEI+1):size(Potential,1)-(NEI+1)
        for j=(NEI+1):size(Potential,2)-(NEI+1)
            for k=(NEI+1):size(Potential,3)-(NEI+1)
                if Potential(i,j,k)>50 && Potential(i,j,k)<150 && CurvOut(i,j,k)==BKG
                    tmp=CurvOut((i-NEI):(i+NEI),(j-NEI):(j+NEI),(k-NEI):(k+NEI));
                    idx=find(tmp~=BKG);
                    if ~isempty(idx)
                        tmp2=tmp(idx);
                        CurvOut(i,j,k)=mean(tmp2(:));
                    end
                    
                end
            end
        end
        str=sprintf('Sagittal %dth slice of %d',i, size(Potential,1));
        disp(str)
    end
    
    MASK=(Potential(i,j,k)>50 && Potential(i,j,k)<150);
    TMP=(CurvOut(MASK)==BKG);
    if sum(TMP(:))==0
        break;
    end
end
    str=sprintf('Step 2 work done in subject %03d',NUM);
    disp(str)
% output curvature values on GM regions   
   CurvOut=single(CurvOut);
   CurvOut_nii=make_nii(CurvOut);
   CurvOutName=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_curvatres_Cmean_volume.nii.gz',DIR,NUM,NUM);
   CurvOut_nii.hdr=GM_potential.hdr;
   save_nii(CurvOut_nii,CurvOutName);
end



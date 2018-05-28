function GWBseg=GWBwidth_1_Seg(gray,csf,white)
%*****************************************
% This function is to: 
% extract gray/white matter boundary (GWB) region, gray matter (GM) region,
% white matter (WM) region.
% Inputs:
%       (1)gray (images of gray matter)
%       (2)csf (CSF) 
%       (3)white (white matter)
% Outputs:
%       GWBseg (segmented image) 
% Author: Xiaoxia Qu
% Date: 2017.06
%******************************************
GWBseg=zeros(size(gray));

for i=1:size(gray,1)
  for j=1:size(gray,2)
     for k=1:size(gray,3)
        if gray(i,j,k)==1
          GWBseg(i,j,k)=50; % gray matter region
        elseif gray(i,j,k)>0 & gray(i,j,k)<1
          GWBseg(i,j,k)=100; 
        else
          GWBseg(i,j,k)=0; 
        end
        if white(i,j,k)==1
           GWBseg(i,j,k)=150; %  white matter region
         elseif white(i,j,k)>0 & white(i,j,k)<1
           GWBseg(i,j,k)=100;
%          else
%           GWB(i,j,k)=GWB(i,j,k); 
        end
        if csf(i,j,k)>0
           GWBseg(i,j,k)=0;
%         else
%            GWB(i,j,k)=GWB(i,j,k);
        end
     end
  end
end







function GWBpotential=GWBwidth_2_Potential(GWBseg)
%***************************************************************
% This function is to compute potential map.
% Inputs:
%       GWBseg (segmented image)
% Outputs:
%       GWBpotential(potential map, solve laplace euqation)
% Author: Xiaoxia Qu
% Date: 2017.06
%***************************************************************

GWBpotential=GWBseg;

for h=1:100  % iteration times
 for i=1:size(GWBseg,1)
    for j=1:size(GWBseg,2)
        for k=1:size(GWBseg,3)
            if GWBseg(i,j,k)==100
            GWBpotential(i,j,k)=(GWBpotential(i+1,j,k)+GWBpotential(i-1,j,k)+GWBpotential(i,j-1,k)+GWBpotential(i,j+1,k)+GWBpotential(i,j,k-1)+GWBpotential(i,j,k+1))/6;    
            end
        end
    end
    
 end
 str1=num2str(h);
 str=sprintf('%s th iteration step',str1);
 disp(str)
end



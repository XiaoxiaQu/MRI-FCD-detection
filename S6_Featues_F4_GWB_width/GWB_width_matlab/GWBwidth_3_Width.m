function GWBwidth=GWBwidth_3_Width(GWBpotential,gray_nii)
%*********************************************************
% This function is to compute GWB width.
% Inputs:
%       GWBpotential(potential map)
% Outputs:
%       GWBwidth(GWB width map) 
% Author: Xiaoxia Qu
% Date: 2017.06
%*********************************************************

% 
pixdim=gray_nii.hdr.dime.pixdim(2:4);
pixdim2=gray_nii.hdr.dime.pixdim(2);
pixdim3=gray_nii.hdr.dime.pixdim(3);
pixdim4=gray_nii.hdr.dime.pixdim(4);

GWBwidth=zeros(size(GWBpotential));

 for i=3:size(GWBpotential,1)-3
      for j=3:size(GWBpotential,2)-3
          for k=3:size(GWBpotential,3)-3  
              if GWBpotential(i,j,k)<=50
                  GWBwidth(i,j,k)=0;
              elseif GWBpotential(i,j,k)>=150
                  GWBwidth(i,j,k)=0;
              elseif GWBpotential(i,j,k)>50 && GWBpotential(i,j,k)<150                             
                                            is=i;
                                            js=j;
                                            ks=k; 
                                            ip=i;
                                            jp=j;
                                            kp=k; 
                         while    GWBpotential(is,js,ks)<150 && GWBpotential(ip,jp,kp)>50                                                   
                           tmp1=GWBpotential((is-1):(is+1),(js-1):(js+1),(ks-1):(ks+1))-GWBpotential(is,js,ks);                       
                           [ison1,json1,kson1]=ind2sub(size(tmp1),find(tmp1==max(tmp1(:)))); 
                                    is=ison1(1)+is-2;
                                    js=json1(1)+js-2;
                                    ks=kson1(1)+ks-2;  
                            
                           tmp2=GWBpotential((ip-1):(ip+1),(jp-1):(jp+1),(kp-1):(kp+1))-GWBpotential(ip,jp,kp);                       
                           [ipar1,jpar1,kpar1]=ind2sub(size(tmp2),find(tmp2==min(tmp2(:)))); 
                                    ip=ipar1(1)+ip-2;
                                    jp=jpar1(1)+jp-2;
                                    kp=kpar1(1)+kp-2;  
                                   
                         end
                      GWBwidth(i,j,k)=sqrt(((i-is)*pixdim2)^2+((j-js)*pixdim3)^2+((k-ks)*pixdim4)^2)+sqrt(((i-ip)*pixdim2)^2+((j-jp)*pixdim3)^2+((k-kp)*pixdim4)^2);                             
              end
          end
      end
       str=sprintf('Sagittal %dth slice of %d',i, size(GWBpotential,1));
      disp(str)
  end   

end





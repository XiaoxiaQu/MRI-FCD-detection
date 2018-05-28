

% to extend the curvature values to volumn, so as to compute the mean and
% sd of healthy controls.

clear all;clc; close all;
addpath('/media/xiaqu/HardDisk/research/MRI_Tools/Matlab/toolbox_graph/toolbox_graph');
addpath('/media/xiaqu/HardDisk/research/MRI_Tools/Matlab/toolbox_graph/toolbox_graph/toolbox');
addpath('/media/xiaqu/HardDisk/research/MRI_Tools/Matlab/Tools for NIfTI and ANALYZE image');

DIR=sprintf('/media/xiaqu/HardDisk/research/MRI_FCD/Patient_T1_v2');

for NUM=2:1:10 % NUM=1:1:10
    
    % read vertex and face
    SurfaceName=sprintf('%s/Patient_%03d/Hong2014/curvatures/Step2_GM_surface_2.vtk',DIR,NUM);
    [vertex,face] = read_vtk(SurfaceName);
    % read curvatures
    CurvatureName=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres.mat',DIR,NUM,NUM);
    load (CurvatureName)
    % cordinates
    filename_REF=sprintf('%s/Patient_%03d/Hong2014/curvatures/Step1_GM_surface_1.nii.gz',DIR,NUM);
    REF=load_untouch_nii(filename_REF);
    Spacing=REF.hdr.dime.pixdim; % Spacing(2),Spacing(3),Spacing(4);
    origin(1)=-(REF.hdr.hist.qoffset_x);
    origin(2)=-(REF.hdr.hist.qoffset_y);
    origin(3)=REF.hdr.hist.qoffset_z;
    % REF.hdr.hist.srow_x = [-0.5,0,0,90];
    % REF.hdr.hist.srow_y = [0,0.5,0,-126];
    % REF.hdr.hist.srow_z = [0,0,0.5,-72];
    x=(vertex(1,:)-origin(1))/Spacing(2);
    y=(vertex(2,:)-origin(2))/Spacing(3);
    %% ############## when NUM=10, z=0~306, so I add a +1;
    z=(vertex(3,:)-origin(3))/Spacing(4)+1;
    %% ##################
    coordinate=[x',y', z'];
    coordinate=int16(coordinate);
    %% #######################
    ThLow=-0.05;
    ThHigh=0.05;
    NEWcmean=Cmean;
    NEWcmean(NEWcmean<ThLow)=ThLow;
    NEWcmean(NEWcmean>ThHigh)=ThHigh;
    BKG=-0.1;
    g=BKG*ones(size(REF.img));
    for i=1:1:size(coordinate,1)
        g(coordinate(i,1),coordinate(i,2),coordinate(i,3))=NEWcmean(i); % Cmean is in [-0.05 0.05]
    end
    gnii=make_nii(g);
    gnii.hdr=REF.hdr;
    gniiName=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres_Cmean.nii.gz',DIR,NUM,NUM);
    save_nii(gnii,gniiName);
    
    
end
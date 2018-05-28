

% test for computation of curvature on meshes
clear all;clc; close all;
addpath('/media/xiaqu/HardDisk/research/MRI_Tools/Matlab/toolbox_graph/toolbox_graph');
addpath('/media/xiaqu/HardDisk/research/MRI_Tools/Matlab/toolbox_graph/toolbox_graph/toolbox');
addpath('/media/xiaqu/HardDisk/research/MRI_Tools/Matlab/Tools for NIfTI and ANALYZE image');

DIR=sprintf('/media/xiaqu/HardDisk/research/MRI_FCD/Patient_T1_v2');

for NUM=10:1:10 % NUM=1:1:10
    %% read data
    
    %% use MITK WORK bench to save .vtp as .vtk file.
filename=sprintf('%s/Patient_%03d/Hong2014/curvatures/Step2_GM_surface_2.vtk',DIR,NUM);
[vertex,face] = read_vtk(filename);
 
%% ###########
%% curvature
options.curvature_smoothing = 10;
[Umin,Umax,Cmin,Cmax,Cmean,Cgauss,Normal] = compute_curvature(vertex,face,options);   
Umin=single(Umin);
Umax=single(Umax);
Cmin=single(Cmin);
Cmax=single(Cmax);
Cmean=single(Cmean);
Cgauss=single(Cgauss);
Normal=single(Normal);
%% ###########
OutnameMAT=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres.mat',DIR,NUM,NUM);  
save(OutnameMAT,'Umin','Umax','Cmin','Cmax','Cmean','Cgauss','Normal');  

%% display curvatures
tau = 1.2;
options.normal_scaling = 1.5;
options.normal = [];
clf;
options.face_vertex_color = perform_saturation(Cmax,tau);
plot_mesh(vertex,face, options);
shading interp; camlight; colormap jet(256);
colorbar
namePNG=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres_cmax.png',DIR,NUM,NUM);
nameFIG=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres_cmax.fig',DIR,NUM,NUM);  
saveas(gcf, namePNG, 'png');
saveas(gcf, nameFIG, 'fig');
clf;
options.face_vertex_color = perform_saturation(Cmin,tau);
plot_mesh(vertex,face, options);
shading interp; camlight; colormap jet(256);
colorbar
namePNG=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres_cmin.png',DIR,NUM,NUM);
nameFIG=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres_cmin.fig',DIR,NUM,NUM);  
saveas(gcf, namePNG, 'png');
saveas(gcf, nameFIG, 'fig');
clf;
options.face_vertex_color = perform_saturation(Cmean,tau);
plot_mesh(vertex,face, options);
shading interp; camlight; colormap jet(256);
colorbar
namePNG=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres_cmean.png',DIR,NUM,NUM);
nameFIG=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres_cmean.fig',DIR,NUM,NUM);  
saveas(gcf, namePNG, 'png');
saveas(gcf, nameFIG, 'fig');
clf;
options.face_vertex_color = perform_saturation(Cgauss,tau);
plot_mesh(vertex,face, options);
shading interp; camlight; colormap jet(256);
colorbar
namePNG=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres_cgauss.png',DIR,NUM,NUM);
nameFIG=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres_cgauss.fig',DIR,NUM,NUM);  
saveas(gcf, namePNG, 'png');
saveas(gcf, nameFIG, 'fig');
clf;
options.face_vertex_color = perform_saturation(abs(Cmin)+abs(Cmax),tau);
plot_mesh(vertex,face, options);
shading interp; camlight; colormap jet(256);
colorbar
namePNG=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres_cabs.png',DIR,NUM,NUM);
nameFIG=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres_cabs.fig',DIR,NUM,NUM);  
saveas(gcf, namePNG, 'png');
saveas(gcf, nameFIG, 'fig');
clf
%% 

%% save mesh as .ply data
% PLYname=sprintf('%s/Patient_%03d/Hong2014/Step3_GM_surface_curvatres.ply',DIR,NUM); 
% write_ply(vertex,face,PLYname) % [vertex,face] = read_ply(filename) 

%% save volumns, when there is point in surface, the pixel value is 1. 
filename_REF=sprintf('%s/Patient_%03d/Hong2014/curvatures/Step1_GM_surface_1.nii.gz',DIR,NUM);
REF=load_untouch_nii(filename_REF);
Spacing=REF.hdr.dime.pixdim; % Spacing(2),Spacing(3),Spacing(4);
origin(1)=-(REF.hdr.hist.qoffset_x);
origin(2)=-(REF.hdr.hist.qoffset_y);
origin(3)=REF.hdr.hist.qoffset_z;
% REF.hdr.hist.srow_x = [-0.5,0,0,90]; 
% REF.hdr.hist.srow_y = [0,0.5,0,-126]; 
% REF.hdr.hist.srow_z = [0,0,0.5,-72]; 
% 
x=(vertex(1,:)-origin(1))/Spacing(2);
y=(vertex(2,:)-origin(2))/Spacing(3);
%% ############## when NUM=10, z=0~306, so I add a +1;
z=(vertex(3,:)-origin(3))/Spacing(4)+1;
%% ##################
coordinate=[x',y', z'];
coordinate=int16(coordinate);

g=zeros(size(REF.img));
for i=1:1:size(coordinate,1)
g(coordinate(i,1),coordinate(i,2),coordinate(i,3))=1;
end
gnii=make_nii(g);
gnii.hdr=REF.hdr;
gniiName=sprintf('%s/Patient_%03d/Hong2014/curvatures/Patient_%03d_GM_surface_curvatres_MASK.nii.gz',DIR,NUM,NUM); 
save_nii(gnii,gniiName);

%% ##################

% %% hist of mean curvatures
% bins=-0.3:0.01:0.3;
% z=hist(Cmean,bins);
% figure,plot(bins,z);

%%
% % save Cmin
% g=zeros(size(REF.img));
% for i=1:1:size(coordinate,1)
% g(coordinate(i,1),coordinate(i,2),coordinate(i,3))=Cmin(i);
% end
% gnii=make_nii(g);
% gnii.hdr=REF.hdr;
% gniiName=sprintf('%s/Patient_%03d/Hong2014/Step3_GM_surface_curvatres_Cmin.nii.gz',DIR,NUM); 
% save_nii(gnii,gniiName);
% % save Cmax
% g=zeros(size(REF.img));
% for i=1:1:size(coordinate,1)
% g(coordinate(i,1),coordinate(i,2),coordinate(i,3))=Cmax(i);
% end
% gnii=make_nii(g);
% gnii.hdr=REF.hdr;
% gniiName=sprintf('%s/Patient_%03d/Hong2014/Step3_GM_surface_curvatres_Cmax.nii.gz',DIR,NUM); 
% save_nii(gnii,gniiName);
% % save Cgauss
% g=zeros(size(REF.img));
% for i=1:1:size(coordinate,1)
% g(coordinate(i,1),coordinate(i,2),coordinate(i,3))=Cgauss(i);
% end
% gnii=make_nii(g);
% gnii.hdr=REF.hdr;
% gniiName=sprintf('%s/Patient_%03d/Hong2014/Step3_GM_surface_curvatres_Cgauss.nii.gz',DIR,NUM); 
% save_nii(gnii,gniiName);


%% 
end
clc; close all; clear;
addpath(genpath('utils/'));
addpath('func_main/');
mesh_dir = 'data/';

s1_name = 'L2_m';
s2_name = 'L3_m';
%% read the mesh and compute the LB basis
normalize_ = true;

S1 = MESH.MESH_IO.read_shape([mesh_dir, s1_name], normalize_);
S2 = MESH.MESH_IO.read_shape([mesh_dir, s2_name], normalize_);

S1 = MESH.compute_LaplacianBasis(S1, 50);
S2 = MESH.compute_LaplacianBasis(S2, 50);
%% set the initial map
num_eig = 16;

B1 = S1.evecs(:,1:num_eig);
B2 = S2.evecs(:,1:num_eig);

figure();
n_subp = ceil(sqrt(num_eig));
for i = 1:num_eig
    subplot(n_subp,n_subp,i); plot_func_on_mesh(S1, B1(:,i)); title([s1_name, ': LB',num2str(i)])
end
figure();
for i = 1:num_eig
	subplot(n_subp,n_subp,i); plot_func_on_mesh(S2, B2(:,i));title([s2_name, ': LB',num2str(i)])
end
% we can see that the first four LB basis of the cat and the wolf align
% with each other, therefore, we can use the identity as the initial
% functionl map
% also: if we start with only the first three LBs, we will get the
% symmetric map
C21_ini = diag([1,0,0,0,1,1,0,0,0,0,0,1]);
T12_ini = fMAP.fMap2pMap(B2,B1,C21_ini);

figure();
subplot(1,2,1); visualize_map_on_source(S1, S2, T12_ini); title('Source');
subplot(1,2,2); visualize_map_on_target(S1, S2, T12_ini); title('The initial p2p-map w.r.t. the identity fMap')
%% apply zoomOut
para.k_init = 3;
para.k_step = 1;
para.k_final = 50;
tic
[T12, C21, all_T12, all_C21] = zoomOut_refine(S1.evecs, S2.evecs, T12_ini, para);
t = toc;
fprintf('ZoomOut runtime: %.2f sec\n',t)

% fast version
para.num_samples = 200;
tic
T12_fast = zoomOut_refine_fast(S1, S2, T12_ini, para,1);
t = toc;
fprintf('ZoomOut with sampling runtime: %.2f sec\n',t)

%%
figure();
plot_id = [2,3,4,5,18,48];
subplot(2,7,1); visualize_map_on_source(S1,S2,T12); title('Source');
for i = 1:length(plot_id)
    subplot(2,7,i+1); imagesc(all_C21{plot_id(i)}); axis square; 
    title(['fMap size: ' num2str(size(all_C21{plot_id(i)},1))]);
    subplot(2,7,i+8); visualize_map_on_target(S1, S2, all_T12{plot_id(i)});
end
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.34, 1, 0.65]);
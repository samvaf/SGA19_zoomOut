clc; clear; close all;
addpath(genpath('utils/'));
addpath('func_main/');

%% data

name = 'L2';
filename = ['data/',name];

%% read OFF

fid = fopen([filename,'.off'], 'r');

str = fgets(fid);
sizes = sscanf(str, '%d %d', 2);
while length(sizes) ~= 2
    str = fgets(fid);
    sizes = sscanf(str, '%d %d', 2);
end
nv = sizes(1);
nf = sizes(2);

[X,cnt] = fscanf(fid,'%lf %lf %lf\n', [3,nv]);
[T,cnt] = fscanf(fid, '3 %ld %ld %ld 220 220 220\n', [3,inf]);

fclose(fid);

%% write OFF

fid_w = fopen([filename, '_m.off'], 'w');

% fwrite(fid_w, fgetl('OFF'))
fprintf(fid_w, '%s\n', 'OFF');
fprintf(fid_w, '%d %d %d\n', [nv nf 0]);
fprintf(fid_w, '%1f %1f %1f\n', X);
fprintf(fid_w, '3 %1d %1d %1d\n', T);
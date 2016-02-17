clear all
close all
clc

dir_name_1 = uigetdir(matlabroot);       %default path at MATLAB root folder

dirs_2 = dir(dir_name_1);

for i = 1 : length( dirs_2 )
    
    if( isequal( dirs_2( i ).name, '.' )||... 
        isequal( dirs_2( i ).name, '..')||... 
        dirs_2( i ).isdir ||...
        isequal( dirs_2( i ).name, 'Amended List.txt'))
        continue;
    end
    
    filename = dirs_2(i).name    %testing Abp1.txt
    filename_realignment = strrep(filename,'.txt','_realignment.txt');
    
    dir_name_2 = fullfile(dir_name_1,dirs_2(i).name);
    data_realignment = fullfile(dir_name_1, filename_realignment);
    
    fid_raw_data = importdata(dir_name_2);
    [row,column] = size(fid_raw_data);
    fid_column_data = zeros(row,1);
    fid_realignment_data = zeros(row,column);
    fid_data_tracks = 1;
    
    while fid_data_tracks <= column
        fid_column_data = fid_raw_data(:,fid_data_tracks);
        avg_pre_bleaching = mean(fid_column_data(1:5,:));
        after_bleaching = fid_column_data(6:end,:);
        realignment_factor = 1/avg_pre_bleaching;
        fid_column_data = fid_column_data*realignment_factor;
        fid_realignment_data(:,fid_data_tracks) = fid_column_data;
        fid_data_tracks = fid_data_tracks+1;
    end
    dlmwrite(data_realignment, fid_realignment_data, 'delimiter', ' ', 'precision', 15);
end
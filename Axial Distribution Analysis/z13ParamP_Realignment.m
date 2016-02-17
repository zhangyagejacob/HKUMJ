% this programme is to re-define PC value of "Myosin1e's Contribution in Regulating Podosome Dynamic" 
% the new PC value is calculated by following steps
% this program is to re-align the PC values which will be used as a scalar in axial distribution curve re-scaling
% All PC values will be divided the original PC value of Myo1eWT to get the new value, while PC value of Myo1eWT will be
% scaled to 1

clear all
close all
clc

dir_name_1 = uigetdir(matlabroot);       %default path at MATLAB root folder

dirs_2 = dir(dir_name_1);

for i = 1 : length( dirs_2 )
    
    if( ~isequal( dirs_2( i ).name, 'PC Value Statistics.txt' ))
        continue;
    end
    
    dirs_2(i).name
    pc_raw_statistics = importdata(fullfile(dir_name_1, 'PC Value Statistics.txt'));
%     PC_Parameters = struct('Protein',{}, 'pc_rescaled_value',{});
    
    pc_old_value = pc_raw_statistics.data(7,:);
    pc_new_value = pc_old_value/pc_old_value(10);
%     PC_Parameters(length(PC_Parameters)+1).Protein = 

    dlmwrite (fullfile(dir_name_1,'PC_Rescaled_Value.txt'), pc_new_value, 'precision', 6);
    dlmwrite (fullfile(dir_name_1,'PC_Rescaled_Value.txt'), pc_new_value, 'precision', 6);



%     fid = fopen(dir_file_CH2_Ppara, 'wt');
%     cellfun(@(x,y) fprintf(fid,'%12.9f\t%s\n',x,y), CH2_P_Value(1,:,:), CH2_P_Value(2,:,:));
%     fclose(fid);
end
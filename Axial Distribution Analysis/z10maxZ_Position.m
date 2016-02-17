clear all
close all
clc

dir_name_1 = uigetdir(matlabroot);       %default path at MATLAB root folder

dirs_2 = dir(dir_name_1);

for i = 1 : length( dirs_2 )
    
    if( isequal( dirs_2( i ).name, '.' )||... 
        isequal( dirs_2( i ).name, '..')||... 
        ~dirs_2( i ).isdir )
        continue;
    end  
    
    dirs_2(i).name    %testing Max_Z
    dir_name_2 = fullfile(dir_name_1,dirs_2(i).name);
    dirs_3 = dir(dir_name_2);
    if ( exist( fullfile(dir_name_2, 'Max_Z.txt'),'file'))
        delete(fullfile(dir_name_2, 'Max_Z.txt'));
    end
    max_Z = fullfile(dir_name_2, 'Max_Z.txt');

    for j = 1 : length( dirs_3 ) % test every single proteinX.txt
        if( isequal( dirs_3( j ).name, '.' )||... 
            isequal( dirs_3( j ).name, '..')||... )
            isequal( dirs_3( j ).name, 'Max_Z.txt'))
            continue;
        end

        dirs_3(j).name      %testing  'proteinX.txt'
        dir_name_3 = fullfile(dir_name_2,dirs_3(j).name);       
        
        % Read in data column by column, finding maximum from them
        % Calculation Fomula max_Z = Sigma((Maximum Postion of Each Column - 1) * 0.2) / Column Number
        % Save dirs_3(j).name to Max_Z.txt, with parameter max_Z after it

        protein_Raw = importdata(dir_name_3);
        size_Sample = size(protein_Raw, 2);         % fatch raw Number
        max_Z_protein = double(size_Sample);
        
        for k = 1 : size_Sample
            sample_k = protein_Raw(:,k);
            [value, location] = max(sample_k(:));
            max_Z_protein(k) = (location-1)*0.2;
        end
        max_mean = mean(max_Z_protein);
        max_standard_dev = std(max_Z_protein);
        formatSpec = '%s has %d tracks\nMaximum axial position: %.4fum, Standard Deviation: %.4fum\n\n';
        
        fileID = fopen(max_Z,'a+');
        fprintf(fileID, formatSpec, dirs_3(j).name, size_Sample, max_mean, max_standard_dev);
        fclose(fileID);
    end  
end

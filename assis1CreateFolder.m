clear all
close all
clc

% dir_name_1 set to the main folder that contains data, 'Myosin1e' in this case
dir_name_1 = uigetdir(matlabroot);      % default path at MATLAB root folder

dirs_2 = dir(dir_name_1);               % Myosin1e_Large_File

for i = 1 : length( dirs_2 )

	if( isequal( dirs_2( i ).name, '.' )||... 
        isequal( dirs_2( i ).name, '..')||... 
        ~dirs_2( i ).isdir)
        continue;
    end

    dirs_2(i).name                      % testing    20140309MEFsrc530F-FNglass-gfpMyo1eD3-mcheGelsolin-bfp2Utrch
    dir_name_2 = fullfile(dir_name_1,dirs_2(i).name);

    dirs_3 = dir(dir_name_2);
    for j = 1 : length( dirs_3 )        % sub-folders or files inside one Folder
	    if( ~isequal( dirs_3( j ).name, 'Volocity Image'))
            continue;
        end

        dirs_3(j).name                  % testing 'Volocity Image'
        dir_name_3 = fullfile(dir_name_2,dirs_3(j).name);
        dirs_4 = dir(dir_name_3);       % list files contents of 'Volocity Image'

        % if no folder "FRAP Analysis" && "Axial Distribution"
        % create folder "FRAP Analysis" && "Axial Distribution", delete them if at last there are no files in them
   		% traverse all files in dirs_3, depends on the size and move the recording file in "Axial Distribution" and "FRAP Analysis"
        if exist('FRAP Analysis','dir') == 0
    	   mkdir('FRAP Analysis');
        end
        
        for ics = 1 : length( dirs_4 )
    		if( isequal( dirs_4( ics ).name, '.' )||...
                isequal( dirs_4( ics ).name, '..')||...
                dirs_4( ics ).isdir)
                continue;
            end

            dirs_4(ics).name    %testing 100x  2.ics
            dir_name_ics = fullfile(dir_name_3, dirs_4(ics).name);
            dir_name_ids = fullfile(dir_name_3, dirs_4(ics+1).name);

            if (dirs_4(ics+1).bytes == 157286400)
                % fatch name into a string, and create folder according to file name
                
                % move dirs_4(ics) and dirs_4(ics+1) to folder just created in "FRAP Analysis"
                movefile(dir_name_ics, 'FRAP Analysis')
                movefile(dir_name_ids, 'FRAP Analysis')
            else
            end
        end
    end
end
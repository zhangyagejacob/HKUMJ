clear all
close all

% open the file 00BK-CH1.txt, combine all 00BK-CH1-ratio.txt in one file
fid = fopen('00BK-CH1.txt', 'at+');
A = importdata('00BK-CH1.txt'); 
if (nnz(A) > 0)
    A = A(1:19,:);
else
end
% % open file 00BK-CH1-ratio.txt, read only
%B = dlmread('00BK-CH1-ratio.txt');
B = importdata('00BK-CH1-ratio.txt');
B = B(1:19,:);
% combine B to the new column of fid, and called this new matrix C
C = [A, B];
% write C in file 00BK-CH1.txt
dlmwrite('00BK-CH1.txt', C, 'delimiter', ' ', 'precision', 15);

fclose(fid);

% %path = 'C:\Users\Zhang Yage\Desktop\Programs\Axial Distribution Analysis\Merge Core Test';
% dir_name_1 = uigetdir(matlabroot);       %default path at MATLAB root folder
% dirs_2 = dir(dir_name_1);
% for l = 1:length(dirs_2)
%     if( isequal( dirs_5( m ).name, '.' )||... 
%         isequal( dirs_5( m ).name, '..'))
%         continue;
%     end
%     dirs_2(l).name;
%     dir_name_2 = fullfile(dir_name_1, dirs_2(l).name);
%     
%     dir_file_1 = fullfile(dir_name_2, 'Z-CH1.txt');
% 
% %fid=fopen('Z-CH1.txt','at');
% fid=fopen([path '\' fnm],'wt');     %?入文件路?
% if fid == -1
%     mkdir(path);
%     fid = fopen([path '\' fnm]. 'wt');
% end;
% 
% fprintf('hello');
% B=fopen('00BK-CH1.txt','r');

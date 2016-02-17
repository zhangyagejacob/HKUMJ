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
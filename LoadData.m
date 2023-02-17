%% script for converting OpenBCI CSV file to eegData
[baseName, folder] = uigetfile('*.csv');
fullFileName = fullfile(folder, baseName);

eegData = readtable(fullFileName);
eegData = eegData(2:end,2:5);
eegData = table2array(eegData);
eegData = eegData';

save('RashidEEG-Alphamod.mat','eegData')

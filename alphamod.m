%% Path variables 

PATH='/Users/laythamra/Documents/Boston university school files/Senior Design/Latest-alphamod/LaythEEG-Alphamod.mat';




%% Import Data 

%starts up eeglab
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
%loads in the data described by PATH
EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',PATH,'srate',250,'pnts',0,'xmin',0);
%Saves it into EEGlab memory
[ALLEEG,EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname','alphamod','gui','off'); 
%refreshes GUI
eeglab redraw;

%% Reject Certain Channels(This might only be for this specific use)

% Rejected channel 2 cause of noise
% EEG = pop_select( EEG, 'channel',[3 4] );

eeglab redraw;
%% Filter the data

%Check the set 
EEG = eeg_checkset( EEG );
%Apply FIR filter
EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',40,'plotfreqz',0);
%Save it as new dataset
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname','alphamodfiltered','gui','off'); 

eeglab redraw;


% %% RUN ICA
% 
% EEG = eeg_checkset( EEG );
% EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');
% 
% [ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
% eeglab redraw;
% 
% icaact=eeg_getica(EEG);



%% Get closed eyes data
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',2,'gui','off'); 
EEG = pop_select( EEG, 'time',[45 60] );
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname','alphamodfiltered_closeeyes','gui','off'); 

eeglab redraw;

EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'overwrite','on','gui','off'); 

%zscore normalize the data
normdata = zscore(EEG.data,0,2);
EEG.data = normdata;


specto_closeeyes=pop_spectopo(EEG, 1,[], 'EEG' , 'freqrange',[2 25],'electrodes','off');
err_closedeyes= std(specto_closeeyes(:,1:25),1);


%% Switch dataset

[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',2,'gui','off'); 
eeglab redraw;


%% Get open eyes data
EEG = pop_select( EEG, 'time',[30 45] );
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname','alphamodfiltered_openeyes','gui','off'); 
eeglab redraw;

EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'overwrite','on','gui','off'); 

%zscore normalize the data
normdata = zscore(EEG.data,0,2);
EEG.data = normdata;


specto_openeyes=pop_spectopo(EEG, 1,[] , 'EEG', 'freqrange',[2 25],'electrodes','off');
err_openeyes= std(specto_openeyes(:,1:25),1);

%spectopo(EEG,[],250)


%% Plot means of spectrums

figure

errorbar(mean(specto_openeyes(:,1:25)),err_openeyes,'LineWidth',2)
hold on 
errorbar(mean(specto_closeeyes(:,1:25)),err_closedeyes,'LineWidth',2)
ylabel('Log Power Spectral Density 10*log_{10} (\muV^{2}/Hz)')
xlabel('Frequency (Hz)')
legend({'Open Eyes','Close Eyes'})
title('Alpha Modulation')










%% Plot Sepctrogram data









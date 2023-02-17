%% Path variables 

PATH='/Users/laythamra/Documents/Boston university school files/Senior Design/Latest-alphamod/RashidEEG-Alphamod.mat';




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

%Rejected channel 2 cause of noise
EEG = pop_select( EEG, 'channel',[3 4] );

%eeglab redraw;
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




NUM_DATASETS=7;
closed_eyes_data.data=[];
open_eyes_data.data=[];



for i=1:NUM_DATASETS


%% Get closed eyes data
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',2,'gui','off'); 
eeglab redraw
EEG = pop_select( EEG, 'time',[(2*i-1)*15, (2*i)*15] );


%Make name for dataset based on loop number
name_close=sprintf('alphamodfiltered_closeeyes_%d',i);
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname',name_close,'gui','off'); 

eeglab redraw;
% 
EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',20,'BurstCriterionRefTolerances',10,'WindowCriterion',0.25,'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7],'ReferenceMaxBadChannels','off' );
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'overwrite','on','gui','off'); 

% zscore normalize the data
normdata = zscore(EEG.data,0,2);
EEG.data = normdata;


specto_closeeyes=pop_spectopo(EEG, 1,[], 'EEG' , 'freqrange',[2 25],'electrodes','off');
closed_eyes_data(i).data=specto_closeeyes;
err_closedeyes= std(specto_closeeyes(:,1:25),1);


%% Switch dataset

[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',2,'gui','off'); 
eeglab redraw;


%% Get open eyes data
EEG = pop_select( EEG, 'time',[(2*i-2)*15 (2*i-1)*15] );
name_open=sprintf('alphamodfiltered_openeyes_%d',i);
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname',name_open,'gui','off'); 
eeglab redraw;
% 
if i~=5
EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',20,'WindowCriterion',0.5,'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7],'ReferenceMaxBadChannels','off' );
[ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'overwrite','on','gui','off'); 
end
% zscore normalize the data
normdata = zscore(EEG.data,0,2);
EEG.data = normdata;


specto_openeyes=pop_spectopo(EEG, 1,[] , 'EEG', 'freqrange',[2 25],'electrodes','off');

open_eyes_data(i).data=specto_openeyes;

err_openeyes= std(specto_openeyes(:,1:25),1);

%spectopo(EEG,[],250)

%% Plot means of spectrums

figure(20)
subplot(4,2,i)

errorbar(mean(specto_openeyes(:,1:25)),err_openeyes,'LineWidth',2)
hold on 
errorbar(mean(specto_closeeyes(:,1:25)),err_closedeyes,'LineWidth',2)
ylabel('Log Power Spectral Density 10*log_{10} (\muV^{2}/Hz)')
xlabel('Frequency (Hz)')
legend({'Open Eyes','Close Eyes'})
title('Alpha Modulation')


end



%% Analyze all data


    all_closed_eyes_JM_back2=vertcat(closed_eyes_data(1).data,closed_eyes_data(2).data,closed_eyes_data(3).data,closed_eyes_data(4).data);
    all_closed_eyes_JM_back2=vertcat(all_closed_eyes_JM_back2,closed_eyes_data(5).data,closed_eyes_data(6).data,closed_eyes_data(7).data);
    %all_closed_eyes_JM_back2=vertcat(all_closed_eyes_JM_back2,closed_eyes_data(5).data,closed_eyes_data(6).data,closed_eyes_data(7).data,closed_eyes_data(8).data,closed_eyes_data(9).data,closed_eyes_data(10).data);

    all_open_eyes_JM_back2=vertcat(open_eyes_data(1).data,open_eyes_data(2).data,open_eyes_data(3).data,open_eyes_data(4).data);
    all_open_eyes_JM_back2=vertcat(all_open_eyes_JM_back2,open_eyes_data(5).data,open_eyes_data(6).data,open_eyes_data(7).data);
    %all_open_eyes_JM_back2=vertcat(all_open_eyes_JM_back2,open_eyes_data(5).data,open_eyes_data(6).data,open_eyes_data(7).data,open_eyes_data(8).data,open_eyes_data(9).data,open_eyes_data(10).data);











%% Load in 2 channel data

open_rk_back2=load('all_open_eyes_RK_back2.mat');
open_rk_back2=open_rk_back2.all_open_eyes_JM_back2;

open_la_back2=load('all_open_eyes_LA_back2.mat');
open_la_back2=open_la_back2.all_open_eyes_LA_back2;

open_jm_back2=load('all_open_eyes_JM_back2.mat');
open_jm_back2=open_jm_back2.all_open_eyes_JM_back2;

close_rk_back2=load('all_closed_eyes_RK_back2.mat');
close_rk_back2=close_rk_back2.all_closed_eyes_JM_back2;

close_la_back2=load('all_closed_eyes_LA_back2.mat');
close_la_back2=close_la_back2.all_closed_eyes_LA_back2;

close_jm_back2=load('all_closed_eyes_JM_back2.mat');
close_jm_back2=close_jm_back2.all_closed_eyes_JM_back2;


%% Load in 4 channel data
% open_rk_4chan=load('all_open_eyes_RK_4chan.mat');
% open_la_4chan=load('all_open_eyes_LA_4chan.mat');
% open_jm_4chan=load('all_open_eyes_JM_4chan.mat');
% 
% close_rk_4chan=load('all_closed_eyes_RK_4chan.mat');
% close_la_4chan=load('all_closed_eyes_LA_4chan.mat');
% close_jm_4chan=load('all_closed_eyes_JM_4chan.mat');


open_2chan=vertcat(open_rk_back2,open_la_back2,open_jm_back2);
close_2chan=vertcat(close_rk_back2,close_la_back2,close_jm_back2);

err_openeyes= std(open_2chan(:,1:25),1);
err_closeeyes= std(close_2chan(:,1:25),1);

errorbar(mean(open_2chan(:,1:25)),err_openeyes,'LineWidth',2)
hold on
errorbar(mean(close_2chan(:,1:25)),err_closeeyes,'LineWidth',2)
ylabel('Log Power Spectral Density 10*log_{10} (\muV^{2}/Hz)')
xlabel('Frequency (Hz)')
legend({'Open Eyes','Close Eyes'})
title('Average Power Specturm for 21 datasets(42 channels)')

alphaband_average_open=zeros(42,1);
alphaband_average_close=zeros(42,1);
for i=1:42
    alphaband_average_open(i)=mean(open_2chan(i,8:12));
    alphaband_average_close(i)=mean(close_2chan(i,8:12));
end


figure(2)

both=horzcat(alphaband_average_close,alphaband_average_open);
boxplot(both,'Labels',{'Eyes Closed','Eyes Open'})
ylabel(' Average Log Power Spectral Density 10*log_{10} (\muV^{2}/Hz)')
title('Average Alpha Frequency(Average over 8-12 hz) for Eyes Closed vs Eyes open')





[h, p, ci,stats]=ttest(alphaband_average_close,alphaband_average_open);





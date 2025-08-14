% Data
% Junction
cwd = pwd


% xi = (Xi-Xmin)/(Xmax-Xmin)
function [avg, SEM] = frapAvg(a1, a2, a3)
    avg = [];
    SEM = [];
    for i = 1:181
        io = i+1; 
        avgVal = (a1(i) + a2(i) + a3(i))/3;
        SEM_val = std([a1(i), a2(i), a3(i)])/sqrt(3);
        avg(i) = avgVal;
        SEM(i) = SEM_val;
    end
    avg = transpose(avg);
    SEM = transpose(SEM);
end

function normArray = normalize(a1)
    normArray = [];
    Xmin = min(a1);
    Xmax = max(a1);
    for i = 1:181
        normX = (a1(i)-Xmin)/(Xmax-Xmin);
        normArray(i) = normX;
    end
    normArray = transpose(normArray);
end


%% Junction
noStrep1 = readtable("20240906_juncApt_37C_FRAP1_noStrep.xlsx"); % good
wStrep1 = readtable("20240906_juncApt_37C_FRAP1_wStrep.xlsx"); % good

noStrep2 = readtable("20241113_junctApt_37C_FRAP2_noStrep_0.xlsx"); % good
wStrep2 = readtable("20241114_junctApt_2_5uM_37C_FRAP3_wStrep_0.xlsx"); %good

noStrep3 = readtable("20241114_junctApt_37C_FRAP3_noStrep.xlsx");% good
wStrep3 = readtable("20241114_junction_2_5uM_37C_FRAP3_wStrep_1.xlsx"); %good

%% Middle
% noStrep1 = readtable("20250227_midApt_noStrep_FRAP2_001_data.xlsx");
% wStrep1 = readtable("20250227_midApt_wStrep_FRAP1_002_data.xlsx");
% 
% noStrep2 = readtable("20250227_midApt_FRAP1_data.xlsx");
% wStrep2 = readtable("20250109_midApt_NEW_wStrep_FRAP2_3_data.xlsx");
% 
% % noStrep3 = readtable("20250109_midApt_NEW_FRAP3.xlsx"); % change
% % noStrep3 = readtable("20250227_midApt_FRAP2_data.xlsx");
% noStrep3 = readtable("20250227_midApt_noStrep_FRAP2_001_0728.xlsx");
% wStrep3 = readtable("20250109_midApt_NEW_wStrep_FRAP3.xlsx");

%% Tip
% noStrep1 = readtable("20250226_tipApt_noStrep_FRAP_data.xlsx"); %check!!
% wStrep1 = readtable("20250131_tipApt_wStrep_FRAP1.xlsx"); % good
% 
% noStrep2 = readtable("20250131_tipApt_noStrep_FRAP2.xlsx"); % good
% wStrep2 = readtable("20250226_tipApt_wStrep_FRAP1_data.xlsx"); % good
% 
% noStrep3 = readtable("20250131_tipApt_noStrep_FRAP3.xlsx"); % good
% %wStrep3 = readtable("20250226_tipApt_wStrep_FRAP2_data.xlsx"); % check --> redo
% wStrep3 = readtable("20250226_tipApt_wStrep_FRAP2_data_0728.xlsx");

noStrep1_i = normalize(noStrep1.Var13);
noStrep2_i = normalize(noStrep2.Var13);
noStrep3_i = normalize(noStrep3.Var13);

wStrep1_i = normalize(wStrep1.Var13);
wStrep2_i = normalize(wStrep2.Var13);
wStrep3_i = normalize(wStrep3.Var13);


t = transpose(0:1:180);
% compPlot = figure('Name', 'FRAP raw data');
% ax1 = axes('Parent', compPlot);
% plot(ax1, wStrep1.Var13);
% hold on
% plot(ax1, wStrep2.Var13);
% plot(ax1, wStrep3.Var13);
% % plot(ax1, noStrep3.Var13);
% hold off
% title(ax1, 'Figure 3: Plot of stuff');

[avg_noStrep, sem_noStrep] = frapAvg(noStrep1_i,noStrep2_i,noStrep3_i);  
[avg_wStrep, sem_wStrep] = frapAvg(wStrep1_i,wStrep2_i,wStrep3_i); 
norm_avg_noStrep = normalize(avg_noStrep);
norm_avg_wStrep = normalize(avg_wStrep);
norm_avg_noStrep_SEM = normalize(sem_noStrep);
norm_avg_wStrep_SEM = normalize(sem_wStrep);

% % Exponential fit
% f1 = fit(t, avg_noStrep, 'exp2'); % maybe just create own exp fit
% f2 = fit(t, avg_wStrep,'exp2');

%myfit = fittype('2*exp(b*x) + c', 'independent', 'x', 'dependent', 'y'); % Define a custom exponential model
% a = avg_noStrep(2);
% b = max(avg_noStrep);
a = 0;
b = 1;

myfit = fittype(@(tau, t) a + (b * t ./ tau) ./ (1 + (t ./ tau)), 'independent', 't', 'coefficients', {'tau'});
f1 = fit(t, avg_noStrep, myfit); % Fit using the custom model
tau_estimated1 = f1.tau;

%myfit2 = fittype(@(tau, t) a + (b * t ./ tau) ./ (1 + (t ./ tau)), 'independent', 't', 'coefficients', {'tau'});
f2 = fit(t, avg_wStrep, myfit); % Fit using the custom model
tau_estimated2 = f2.tau;

y1 = feval(f1, t);
y2 = feval(f2, t);

% Just get 1/b for the time constant
% y1i=y1(end);
% idx1 = max(find(abs(y1-y1i)>=0.37*y1i));
% tau_no = t(idx1);
% 
% y2i = y2(end);
% idx2 = max(find(abs(y2-y2i)>=0.37*y2i));
% tau_w = t(idx2);

% Make the plot
figure('Name', 'FRAP');
% no Strep
plot(t, avg_noStrep,'LineWidth', 1,'Color',"#00c855") % green
hold on;
plot(t,avg_wStrep,'LineWidth', 1,'Color',"#e20000") % red
hold on;
plot(t, y1, ':','LineWidth', 1,"Color","black") % green
hold on;
shadedErrorBar(t, avg_noStrep,sem_noStrep,'lineprops','-g')
hold on;

% w Strep
hold on;
plot(t, y2, '--','LineWidth', 1,'Color',"black") % red
hold on;
shadedErrorBar(t, avg_wStrep, sem_wStrep, 'lineprops','-r')
%title('FRAP - Tip Aptamer (n=3)')
xlabel('Time [s]')
ylabel('Intensity [au]')
axis([1 180 0 1])
axis('square')
legend('without SA', 'with SA')
hold off;

%% UPDATED

% Tip
% noStrep1 = readtable("20250226_tipApt_noStrep_FRAP_data.xlsx");
% wStrep1 = readtable("20250131_tipApt_wStrep_FRAP1.xlsx");
% 
% noStrep2 = readtable("20250131_tipApt_noStrep_FRAP2.xlsx");
% wStrep2 = readtable("20250226_tipApt_wStrep_FRAP1_data.xlsx");
% 
% noStrep3 = readtable("20250131_tipApt_noStrep_FRAP3.xlsx");
% wStrep3 = readtable("20250226_tipApt_wStrep_FRAP2_data.xlsx");


% Mid
% noStrep1 = readtable("20250227_midApt_noStrep_FRAP2_001_data.xlsx");
% wStrep1 = readtable("20250227_midApt_wStrep_FRAP1_002_data.xlsx");
% 
% noStrep2 = readtable("20250227_midApt_FRAP1_data.xlsx");
% wStrep2 = readtable("20250109_midApt_NEW_wStrep_FRAP2_3_data.xlsx");
% 
% noStrep3 = readtable("20250109_midApt_NEW_FRAP3.xlsx");
% wStrep3 = readtable("20250109_midApt_NEW_wStrep_FRAP3.xlsx");


% noStrep1 = readtable("20240906_juncApt_37C_FRAP1_noStrep.xlsx");
% wStrep1 = readtable("20240906_juncApt_37C_FRAP1_wStrep.xlsx");
% 
% noStrep2 = readtable("20241113_junctApt_37C_FRAP2_noStrep_0.xlsx");
% wStrep2 = readtable("20241114_junctApt_2_5uM_37C_FRAP3_wStrep_0.xlsx");
% 
% noStrep3 = readtable("20241114_junctApt_37C_FRAP3_noStrep.xlsx");
% wStrep3 = readtable("20241114_junction_2_5uM_37C_FRAP3_wStrep_1.xlsx");

% Mid
% noStrep1 = readtable("20250109_midApt_NEW_FRAP1.xlsx");
% wStrep1 = readtable("20250109_midApt_NEW_wStrep_FRAP1.xlsx");
% 
% noStrep2 = readtable("20250109_midApt_NEW_FRAP2.xlsx");
% wStrep2 = readtable("20250109_midApt_NEW_wStrep_FRAP1.xlsx");
% 
% noStrep3 = readtable("20250109_midApt_NEW_FRAP3.xlsx");
% wStrep3 = readtable("20250109_midApt_NEW_wStrep_FRAP3.xlsx");

%Tip
% noStrep1 = readtable("20250131_tipApt_noStrep_FRAP1.xlsx");
% wStrep1 = readtable("20250131_tipApt_wStrep_FRAP1.xlsx");
% 
% noStrep2 = readtable("20250131_tipApt_noStrep_FRAP2.xlsx");
% wStrep2 = readtable("20250131_tipApt_wStrep_FRAP2_real.xlsx");
% 
% noStrep3 = readtable("20250131_tipApt_noStrep_FRAP3.xlsx");
% wStrep3 = readtable("20250131_tipApt_wStrep_FRAP2.xlsx");
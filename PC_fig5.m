
%% CURRENTLY IN ORDER OF CTRL, 0.5X, 1X, 2X!!!!!!!!!!!!!!
% Junction data (each from average of 5 replicates)
j1 = [7.151846207;1.941840172;0.9467254351;0.8267883196];
j1_s = [0.7788817801;0.6278822884;0.04512705413;0.03324510579]; 

j2 = [9.405333147;6.04916969;0.8265063281;0.7034649017];
j2_s = [0.483341408;3.060050082;0.05753070859;0.08366301083]; 

% Mid data
m1 = [7.194619886;8.841357019;0.8530111086;0.7688848877];
m1_s = [1.337329363;4.591097739;0.09300373167;0.02594727961];
m2 = [8.033549324;3.30519052;0.7523107406;0.6897630748];
m2_s = [1.433188332;0.86040803;0.08424406792;0.08657130147];

% Tip data
t1 = [4.872206939;4.758860045;0.8089223836;0.9490819574];
t1_s = [0.7541735608;0.5557115188;0.09166502828;0.03942286784];
t2 = [4.334532884;4.481565005;0.8065040995;0.7931414842];
t2_s = [0.3238747968;0.511115992;0.01984606066;0.1388441407];

% % Select dataset
% For Junction
%s1 = j1; s2 = j2; s1_s = j1_s; s2_s = j2_s;

% For Mid
%s1 = m1; s2 = m2; s1_s = m1_s; s2_s = m2_s; 

% For Tip
s1 = t1; s2 = t2; s1_s = t1_s; s2_s = t2_s; % Replace with actual SDs if available

% Number of replicates per dataset (update if different)
n_replicates = 5;

% Average of the two datasets
mean_s = (s1 + s2) / 2;

% SEM per s1 and s2
sem_s1 = s1_s / sqrt(n_replicates);
sem_s2 = s2_s / sqrt(n_replicates);

% Combined SEM for the mean of s1 and s2
combined_sem = sqrt(sem_s1.^2 + sem_s2.^2);

% X-axis labels and positions
x = 1:4;
x_labels = {'Control', '0.5x','1x', '2x'};

% Plot with SEM error bars
figure;
errorbar(x, mean_s, combined_sem, 'o', 'LineWidth', 2.5, 'MarkerSize', 12, ...
    'Color', [0 0.4470 0.7410], 'MarkerFaceColor', [0 0.4470 0.7410]);

xticks(x);
xticklabels(x_labels);
xlabel('Concentration', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Average Value', 'FontSize', 16, 'FontWeight', 'bold');
title('Aptamer and Invader (Mean ± SEM)', 'FontSize', 18, 'FontWeight', 'bold');
ylim([0 9]);
xlim([0.75 4.25]);

set(gca, 'FontSize', 14, 'LineWidth', 1.5, 'TickDir', 'out');
grid off;
box on;

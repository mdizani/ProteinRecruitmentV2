%DM 1/7 - growth curves only
%GROWTH CURVE PLOTS - VERSION 5 - new colors

%read data files

%JUNC

%5 min
s1_5min_junc = readmatrix("Sample1_5min_j_1.25_37.csv", 'Delimiter', ',');
s2_5min_junc = readmatrix("Sample2_5min_j_1.25_37.csv", 'Delimiter', ',');
s3_5min_junc = readmatrix("Sample3_5min_j_1.25_37.csv", 'Delimiter', ',');

%60 min
s1_60min_junc = readmatrix("Sample1_60min_j_1.25_37.csv", 'Delimiter', ',');
s2_60min_junc = readmatrix("Sample2_60min_j_1.25_37.csv", 'Delimiter', ',');
s3_60min_junc = readmatrix("Sample3_60min_j_1.25_37.csv", 'Delimiter', ',');

%MID

%5 min
s1_5min_mid = readmatrix("Sample1_5min_m_1.25_37.csv", 'Delimiter', ',');
s2_5min_mid = readmatrix("Sample2_5min_m_1.25_37.csv", 'Delimiter', ',');
s3_5min_mid = readmatrix("Sample3_5min_m_1.25_37.csv", 'Delimiter', ',');

%60 min
s1_60min_mid = readmatrix("Sample1_60min_m_1.25_37.csv", 'Delimiter', ',');
s2_60min_mid = readmatrix("Sample2_60min_m_1.25_37.csv", 'Delimiter', ',');
s3_60min_mid = readmatrix("Sample3_60min_m_1.25_37.csv", 'Delimiter', ',');

%TIP

%5 min
s1_5min_tip = readmatrix("Sample1_5min_t_1.25_37.csv", 'Delimiter', ',');
s2_5min_tip = readmatrix("Sample2_5min_t_1.25_37.csv", 'Delimiter', ',');
s3_5min_tip = readmatrix("Sample3_5min_t_1.25_37.csv", 'Delimiter', ',');

%60 min
s1_60min_tip = readmatrix("Sample1_60min_t_1.25_37.csv", 'Delimiter', ',');
s2_60min_tip = readmatrix("Sample2_60min_t_1.25_37.csv", 'Delimiter', ',');
s3_60min_tip = readmatrix("Sample3_60min_t_1.25_37.csv", 'Delimiter', ',');

%extract necessary data from tables
%column 2 = label, column 3 = area (pix^2), column 4 = mean intensity...
...column 5 = equivalent diameter, column 6 = eccentricity

clear max

%convert pix^2 to micron^2

%JUNC
s1_5min_areas_junc = s1_5min_junc(:, 3).*(38.52/546).^2;
s2_5min_areas_junc = s2_5min_junc(:, 3).*(38.52/546).^2;
s3_5min_areas_junc = s3_5min_junc(:, 3).*(38.52/546).^2;

s1_60min_areas_junc = s1_60min_junc(:, 3).*(38.52/546).^2;
s2_60min_areas_junc = s2_60min_junc(:, 3).*(38.52/546).^2;
s3_60min_areas_junc = s3_60min_junc(:, 3).*(38.52/546).^2;

%MID
s1_5min_areas_mid = s1_5min_mid(:, 3).*(38.52/546).^2;
s2_5min_areas_mid = s2_5min_mid(:, 3).*(38.52/546).^2;
s3_5min_areas_mid = s3_5min_mid(:, 3).*(38.52/546).^2;

s1_60min_areas_mid = s1_60min_mid(:, 3).*(38.52/546).^2;
s2_60min_areas_mid = s2_60min_mid(:, 3).*(38.52/546).^2;
s3_60min_areas_mid = s3_60min_mid(:, 3).*(38.52/546).^2;

%TIP
s1_5min_areas_tip = s1_5min_tip(:, 3).*(38.52/546).^2;
s2_5min_areas_tip = s2_5min_tip(:, 3).*(38.52/546).^2;
s3_5min_areas_tip = s3_5min_tip(:, 3).*(38.52/546).^2;

s1_60min_areas_tip = s1_60min_tip(:, 3).*(38.52/546).^2;
s2_60min_areas_tip = s2_60min_tip(:, 3).*(38.52/546).^2;
s3_60min_areas_tip = s3_60min_tip(:, 3).*(38.52/546).^2;

%take averages

%JUNC
avg_5min_junc = [mean(s1_5min_areas_junc, 'omitnan'), mean(s2_5min_areas_junc, 'omitnan'),...
    mean(s3_5min_areas_junc, 'omitnan')];

avg_60min_junc = [mean(s1_60min_areas_junc, 'omitnan'), mean(s2_60min_areas_junc, 'omitnan'),...
    mean(s3_60min_areas_junc, 'omitnan')];

%MID
avg_5min_mid = [mean(s1_5min_areas_mid, 'omitnan'), mean(s2_5min_areas_mid, 'omitnan'),...
    mean(s3_5min_areas_mid, 'omitnan')];

avg_60min_mid = [mean(s1_60min_areas_mid, 'omitnan'), mean(s2_60min_areas_mid, 'omitnan'),...
    mean(s3_60min_areas_mid, 'omitnan')];

%TIP
avg_5min_tip = [mean(s1_5min_areas_tip, 'omitnan'), mean(s2_5min_areas_tip, 'omitnan'),...
    mean(s3_5min_areas_tip, 'omitnan')];

avg_60min_tip = [mean(s1_60min_areas_tip, 'omitnan'), mean(s2_60min_areas_tip, 'omitnan'),...
    mean(s3_60min_areas_tip, 'omitnan')];

%combine into column vectors; use (i, :) to call the row in loop

%5 min avgs

avg_5min = [avg_5min_junc; avg_5min_mid; avg_5min_tip];
avg_60min = [avg_60min_junc; avg_60min_mid; avg_60min_tip];

%define color values
%junc = pink, mid = purple, tip = blue
light_pink = [0.847, 0.321, 0.545];
dark_pink = [0.498, 0.109, 0.274];
light_purple = [0.576, 0.478, 0.780];
dark_purple = [0.254, 0.160, 0.462];
light_blue = [0.376, 0.517, 0.854];
dark_blue = [0.137, 0.192, 0.560];

%color arrays
lights = [light_pink; light_purple; light_blue];
darks = [dark_pink; dark_purple; dark_blue];

%display name arrays
names = {'Junction', 'Middle', 'Tip'};

%for display names
fit_handles = gobjects(3, 1);

%parameter arrays
g_vals = [0; 0; 0];
alpha_vals = zeros(3, 1);
r_vals = zeros(3, 1);

%empty figure
figure;
    set(gca, 'FontName', 'Arial', 'FontSize', 14); % Sets the font for the current axes
    set(findall(gcf, '-property', 'FontName'), 'FontName', 'Arial'); % Sets Arial
    set(gca, 'color', 'none');
    hold on;

for i = 1:3

    %take absolute averages, stdev, error

    area_0 = 0;
    area_5 = mean(avg_5min(i, :));
    area_60 = mean(avg_60min(i, :));
    
    stdev_0 = 0;
    stdev_5 = std(avg_5min(i, :));
    stdev_60 = std(avg_60min(i, :));

    sem = @(stdev) stdev / sqrt(3);

    sem_0 = 0;
    sem_5 = sem(stdev_5);
    sem_60 = sem(stdev_60);

    sem_all = [sem_0 sem_5 sem_60];

    %growth curve

    time = [0.00001 10 60];
    area = [area_0 area_5 area_60];

    % Fit a growth model to the data

    %exponential model:

    fit_func = @(params, t) params(1)*t.^params(2); % Define logarithmic function
    initial_guess = [1, 0.2]; % Initial guesses for parameters [g, alpha]

    % Perform nonlinear fit
    [params, R, J, covB, mse] = nlinfit(time, area, fit_func, initial_guess);
    g = params(1);
    alpha = params(2);
    time_fit = linspace(min(time), max(time), 200);
    area_fit = fit_func(params, time_fit);

    % FIGURE 1: growth curve + raw data
    %dark for data, light for curve, black for error
    %curve thinner, dots bigger

    %plot data last so it's on top
    fit_handles(i) = plot(time_fit, area_fit, 'color', lights(i, :), 'LineWidth', 3,... ...
    'DisplayName', names{i}, 'Color', lights(i, :));
    hold on;
    eb(1) = errorbar(time, area, sem_all, 'vertical', 'LineStyle', 'none'); % Error bars
    set(eb, 'color', 'k', 'LineWidth', 1.5); % Format error bars
    hold on;
    scatter(time, area, 80, 'k', 'filled'); % Raw data points); % Raw data points

    %calculate r-squared

    SS_total = sum((area-mean(area)).^2);
    SS_residual = sum((area-fit_func(params, time)).^2);
    R_squared = 1 - (SS_residual / SS_total);

    %store g, alpha, r^2
    g_vals(i) = g;
    alpha_vals(i) = alpha;
    r_vals(i) = R_squared;

    hold on;

end

%labels - out of loop
title('1.25 µM, 37C', 'FontSize', 24);
xlabel('time (min)', 'FontSize', 20);
ylabel('<area> (µm^2)', 'FontSize', 20);
ax = gca;
ax.FontSize = 15;
xlim([-1 61]);
ylim([-0.1 15]);

%legend goes in order of plot order
legend(fit_handles, 'Location', 'northwest');
hold off;

%make table with g and alpha and R^2
param_table = table(g_vals, alpha_vals, r_vals, ...
    'VariableNames', {'g', 'alpha', 'R_squared'});
disp(param_table);
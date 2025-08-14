%DM 1/7 - growth curves only
%GROWTH CURVE PLOTS - VERSION 5 - new colors

%read data files

%JUNC

%60 min
s1_60min_junc = readmatrix("Sample1_60min_j_1.25_37.csv", 'Delimiter', ',');
s2_60min_junc = readmatrix("Sample2_60min_j_1.25_37.csv", 'Delimiter', ',');
s3_60min_junc = readmatrix("Sample3_60min_j_1.25_37.csv", 'Delimiter', ',');

%MID

%60 min
s1_60min_mid = readmatrix("Sample1_60min_m_1.25_37.csv", 'Delimiter', ',');
s2_60min_mid = readmatrix("Sample2_60min_m_1.25_37.csv", 'Delimiter', ',');
s3_60min_mid = readmatrix("Sample3_60min_m_1.25_37.csv", 'Delimiter', ',');

%TIP

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

s1_60min_areas_junc = s1_60min_junc(:, 3).*(38.52/546).^2;
s2_60min_areas_junc = s2_60min_junc(:, 3).*(38.52/546).^2;
s3_60min_areas_junc = s3_60min_junc(:, 3).*(38.52/546).^2;

%MID

s1_60min_areas_mid = s1_60min_mid(:, 3).*(38.52/546).^2;
s2_60min_areas_mid = s2_60min_mid(:, 3).*(38.52/546).^2;
s3_60min_areas_mid = s3_60min_mid(:, 3).*(38.52/546).^2;

%TIP

s1_60min_areas_tip = s1_60min_tip(:, 3).*(38.52/546).^2;
s2_60min_areas_tip = s2_60min_tip(:, 3).*(38.52/546).^2;
s3_60min_areas_tip = s3_60min_tip(:, 3).*(38.52/546).^2;

%take averages + concatenate

% === COMBINE + NORMALIZE EACH CONDITION ===

% JUNC
area_60_all_junc = cat(1, s1_60min_areas_junc, s2_60min_areas_junc, s3_60min_areas_junc);
area_60_all_junc_norm = area_60_all_junc / mean(area_60_all_junc, 'omitnan');

% MID
area_60_all_mid = cat(1, s1_60min_areas_mid, s2_60min_areas_mid, s3_60min_areas_mid);
area_60_all_mid_norm = area_60_all_mid / mean(area_60_all_mid, 'omitnan');

% TIP
area_60_all_tip = cat(1, s1_60min_areas_tip, s2_60min_areas_tip, s3_60min_areas_tip);
area_60_all_tip_norm = area_60_all_tip / mean(area_60_all_tip, 'omitnan');

% Put normalized data in cell array
all_areas = {area_60_all_junc_norm, area_60_all_mid_norm, area_60_all_tip_norm};

% === PLOTTING CCDFs ===

%natural log
figure;
set(gca, 'FontName', 'Arial', 'FontSize', 14);
set(findall(gcf, '-property', 'FontName'), 'FontName', 'Arial');
set(gca, 'color', 'none');
hold on;

light_pink = [0.847, 0.321, 0.545];
dark_pink = [0.498, 0.109, 0.274];
light_purple = [0.576, 0.478, 0.780];
dark_purple = [0.254, 0.160, 0.462];
light_blue = [0.376, 0.517, 0.854];
dark_blue = [0.137, 0.192, 0.560];

lights = [light_pink; light_purple; light_blue];

for i = 1:3
    % Get sorted normalized areas
    x_vals = sort(all_areas{i});
    x_vals = x_vals(:);
    N = length(x_vals);

    % Calculate CCDF
    ccdf = 1 - ((1:N) - 0.5)' / N;
    %log_ccdf = log10(ccdf);
    ln_ccdf = log(ccdf);

    %{

    %define functions to be graphed
    log_x = log10(x_vals);
    %log_x = log(x_vals)
    f = @(x) -exp(1)*x;
    %f = @(x) -1.*x;
    y_vals = f(log_ccdf);

    %}

    % Plot
    scatter(x_vals, ln_ccdf, 5, 'filled', ...
        'MarkerFaceColor', lights(i, :), 'MarkerEdgeColor', lights(i, :));
    hold on;
    %plot(x_vals, y_vals, 'color', lights(i, :), 'LineWidth', 2);
    %hold on;
end

%define negative slope
%f = @(x) -exp(1)*x;
f = @(x) -1*x;
x_lin = linspace(0, 7, 100);
%f = @(x) exp(-x);
plot(x_lin, f(x_lin), 'LineStyle', '--','color', 'k', 'LineWidth', 1.25);

%labels and legend

title('1.25 µM, 37C', 'FontSize', 24);
xlabel('area / <area>', 'FontSize', 20);
ylabel('ln(CCDF)', 'FontSize', 20);
ylim([-7, 0]);
xlim([0, 25]);
legend('Junction', 'Mid', 'Tip', 'Location', 'northeast');
ax = gca;
ax.FontSize = 15;
hold off;


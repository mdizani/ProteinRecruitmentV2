%DM 2/10 - junc 2.5uM 25C
%boxplots only, 60 min only

%read data files

%60 min junc
s1_60min_junc = readmatrix("Sample1_60min_j_1.25_37.csv", 'Delimiter', ',');
s2_60min_junc = readmatrix("Sample2_60min_j_1.25_37.csv", 'Delimiter', ',');
s3_60min_junc = readmatrix("Sample3_60min_j_1.25_37.csv", 'Delimiter', ',');

%60 min mid
s1_60min_mid = readmatrix("Sample1_60min_m_1.25_37.csv", 'Delimiter', ',');
s2_60min_mid = readmatrix("Sample2_60min_m_1.25_37.csv", 'Delimiter', ',');
s3_60min_mid = readmatrix("Sample3_60min_m_1.25_37.csv", 'Delimiter', ',');

%60 min tip
s1_60min_tip = readmatrix("Sample1_60min_t_1.25_37.csv", 'Delimiter', ',');
s2_60min_tip = readmatrix("Sample2_60min_t_1.25_37.csv", 'Delimiter', ',');
s3_60min_tip = readmatrix("Sample3_60min_t_1.25_37.csv", 'Delimiter', ',');

%extract necessary data from tables
%column 2 = label, column 3 = area (pix^2), column 4 = mean intensity...
...column 5 = equivalent diameter, column 6 = eccentricity

clear max

%get column 6; no normalizing
s1_60min_j = s1_60min_junc(:, 6);
s2_60min_j = s2_60min_junc(:, 6);
s3_60min_j = s3_60min_junc(:, 6);

s1_60min_m = s1_60min_mid(:, 6);
s2_60min_m = s2_60min_mid(:, 6);
s3_60min_m = s3_60min_mid(:, 6);

s1_60min_t = s1_60min_tip(:, 6);
s2_60min_t = s2_60min_tip(:, 6);
s3_60min_t = s3_60min_tip(:, 6);


%take averages

avg_junc_areas = [mean(s1_60min_j, 'omitnan'), mean(s2_60min_j, 'omitnan'),...
    mean(s3_60min_j, 'omitnan')];

avg_mid_areas = [mean(s1_60min_m, 'omitnan'), mean(s2_60min_m, 'omitnan'),...
    mean(s3_60min_m, 'omitnan')];

avg_tip_areas = [mean(s1_60min_t, 'omitnan'), mean(s2_60min_t, 'omitnan'),...
    mean(s3_60min_t, 'omitnan')];

%define color values
%junc = pink, mid = purple, tip = blue
light_pink = [0.847, 0.321, 0.545];
dark_pink = [0.498, 0.109, 0.274];
light_purple = [0.576, 0.478, 0.780];
dark_purple = [0.254, 0.160, 0.462];
light_blue = [0.376, 0.517, 0.854];
dark_blue = [0.137, 0.192, 0.560];

%put color values in 2 arrays (light/dark)

lights = [light_pink; light_pink; light_pink;...
    light_purple; light_purple; light_purple;...
    light_blue; light_blue; light_blue];

darks = [dark_pink; dark_pink; dark_pink;...
    dark_purple; dark_purple; dark_purple;...
    dark_blue; dark_blue; dark_blue];


%FIGURES 2-3: BOXPLOT

% Combine all areas into a single cell array
all_areas = {s1_60min_j, s2_60min_j, s3_60min_j,...
    s1_60min_m, s2_60min_m, s3_60min_m,...
    s1_60min_t, s2_60min_t, s3_60min_t};

% Define positions for the boxplots
positions = [1, 2, 3, 5, 6, 7, 9, 10, 11]; % Positions of the boxplots

% Create figure 2 (bottom boxplot): 0 < y < 43
figure;
hold on;
set(gca, 'FontName', 'Arial', 'FontSize', 14); % Sets the font for the current axes
set(findall(gcf, '-property', 'FontName'), 'FontName', 'Arial'); % Sets Arial
set(gca, 'color', 'none');

% Loop to manually create boxplots with full boxes
for i = 1:9
    % Extract the data for the current boxplot
    data = all_areas{i};
    
    % Compute quartiles
    q1 = quantile(data, 0.25);
    q3 = quantile(data, 0.75);
    iqr = q3 - q1;
    lower_whisker = max(min(data), q1 - 1.5 * iqr);
    upper_whisker = min(max(data), q3 + 1.5 * iqr);
    mean_val = mean(data, 'omitnan');
    median_val = median(data, 'omitnan');
    
    % Create the full box using `fill`
    x_box = [positions(i) - 0.4, positions(i) + 0.4, positions(i) + 0.4, positions(i) - 0.4];
    y_box = [q1, q1, q3, q3];
    fill(x_box, y_box, lights(i, :), 'EdgeColor', 'k', 'LineWidth', 1);
    
    % Add the median + mean lines
    line([positions(i) - 0.4, positions(i) + 0.4], [median_val, median_val], 'Color', 'k', ...
        'LineWidth', 2.5, 'LineStyle', '-'); %Median
    plot(positions(i), mean_val, 'diamond', 'MarkerSize', 5, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k',...
        'LineWidth', 1.5, 'DisplayName', 'Mean', 'Color', 'k'); % Mean

    % Add whiskers
    plot([positions(i), positions(i)], [q3, upper_whisker], 'k', 'LineWidth', 1.5); % Upper whisker
    plot([positions(i), positions(i)], [q1, lower_whisker], 'k', 'LineWidth', 1.5); % Lower whisker
    plot([positions(i) - 0.2, positions(i) + 0.2], [upper_whisker, upper_whisker], 'k', 'LineWidth', 1.5); % Upper bar
    plot([positions(i) - 0.2, positions(i) + 0.2], [lower_whisker, lower_whisker], 'k', 'LineWidth', 1.5); % Lower bar
    
    % Add outliers
    outliers = data(data > upper_whisker | data < lower_whisker);
    scatter(repmat(positions(i), size(outliers)), outliers, 11, 'k', 'filled');
    
    % Add the number of points above the boxplot
    %num_points = length(data);
    %text(positions(i), 43, ...
        %num2str(num_points), 'HorizontalAlignment', 'center', 'FontSize', 14);

end

% Customize the x-axis
%set(gcf, 'Position', [100 100 600 400]); %change dimensions (wider)
set(gca, 'XTick', [2, 6, 10]); % Centered positions for aptamer labels
set(gca, 'XTickLabel', {'Junction', 'Middle', 'Tip'});
ylabel('Eccentricity', 'FontSize', 17);
ax = gca;
ax.FontSize = 16;

% Add title and labels
title('1.25 µM, 37C', 'FontSize', 19);
xlim([0.5, 11.5]);
ylim([0, 1.01]);
hold on;
%breakyaxis([50, 150]);


% Customize plot appearance
box on;
hold off;

%DM 2/3
%CYTOFLUOROGRAM/INTENSITY

%note: PCC values (10, 60 min)
    %junc: 0.814, 0.751
    %mid: 0.764, 0.863
    %tip: 0.787, 0.733

%read data files

%10 min and 60 min 

data_1 = readmatrix("NEW_cytofluorogram_04262025_m10.xlsx", 'Range', 'C3:D1048576');
%data_1 = data_1(2:end);
data_2 = readmatrix("NEW_cytofluorogram_04262025_j60.xlsx", 'Range', 'C3:D1048576');
%data_2 = data_2(2:end);

%data_1 = readmatrix("10_Min_Cytofluorogram_Junction.xlsx");
%data_2 = readmatrix("10_Min_Cytofluorogram_Tip.xlsx");

ten_vals = data_1(~any(isnan(data_1),2), :);
sixty_vals = data_2(~any(isnan(data_2),2), :);

%extract x_i, y_i

x_i_10 = ten_vals(:, 1);
y_i_10 = ten_vals(:, 2);
x_i_60 = sixty_vals(:, 1);
y_i_60 = sixty_vals(:, 2);

%define function

r = corr(x_i_10, y_i_10); 

p = polyfit(x_i_10, y_i_10, 1);  % Linear fit: y = p(1)*x + p(2)
y_fit = polyval(p, x_i_10);

r_60 = corr(x_i_60, y_i_60);
p_60 = polyfit(x_i_60, y_i_60, 1);
y_fit_60 = polyval(p_60, x_i_60);

%10 min figure

figure;
hold on;

%define color values
%junc = pink, mid = purple, tip = blue
light_pink = [0.847, 0.321, 0.545];
dark_pink = [0.498, 0.109, 0.274];
light_purple = [0.576, 0.478, 0.780];
dark_purple = [0.254, 0.160, 0.462];
light_blue = [0.376, 0.517, 0.854];
dark_blue = [0.137, 0.192, 0.560];

%plot
set(gcf, 'Position', [100 100 500 500]); 
set(gca, 'FontName', 'Arial', 'FontSize', 14); % Sets the font for the current axes
set(findall(gcf, '-property', 'FontName'), 'FontName', 'Arial'); % Sets Arial
set(gca, 'color', 'none');
scatter(x_i_10, y_i_10, 2.5, light_purple, 'filled');
hold on;
plot(x_i_10, y_fit, "Color", 'k', 'LineWidth', 7.5);
hold on;

%labels
%title("TIP - 60 min");
%xlabel('Alexa 647', 'FontSize', 35);
%ylabel('FAM', 'FontSize', 35);
ax = gca;
ax.FontSize = 30;
xlim([0 1]);
xticks([0 0.5 1]);
%xticklabels({'0.0', '0.5', '1.0'});
yticks([0 0.5 1]);
%yticklabels({'0.0', '0.5', '1.0'});
ylim([0 1]);
%txt2 = 'r = 0.81';
%text(0.1, 0.9, txt2, 'FontSize', 35, 'FontWeight', 'Bold');
hold off;

%60 min figure

figure;
hold on;

%plot
set(gcf, 'Position', [100 100 500 500]); %change dimensions (skinny)
set(gca, 'FontName', 'Arial', 'FontSize', 14); % Sets the font for the current axes
set(findall(gcf, '-property', 'FontName'), 'FontName', 'Arial'); % Sets Arial
set(gca, 'color', 'none');
scatter(x_i_60, y_i_60, 2.5, light_blue, 'filled');
hold on;
plot(x_i_60, y_fit_60, "Color", 'k', 'LineWidth', 7.5);
hold on;

%labels
%title("TIP - 60 min");
%xlabel('Alexa 647', 'FontSize', 35);
%ylabel('FAM', 'FontSize', 35);
ax = gca;
ax.FontSize = 30;
xlim([0 1]);
xticks([0 0.5 1]);
%xticklabels({'0.0', '0.5', '1.0'});
yticks([0 0.5 1]);
%yticklabels({'0.0', '0.5', '1.0'});
ylim([0 1]);
%txt2 = 'r = 0.75';
%text(0.1, 0.9, txt2, 'FontSize', 40, 'FontWeight', 'Bold');
hold off;

%{

%extract intensity data

intensity = readmatrix("60_min_Intensity_Junction.xlsx");
x_green = intensity(:, 1);
y_green = intensity(:, 3);
x_red = intensity(:, 7);
y_red = intensity(:, 9);

%green figure
figure;
hold on;

%plot
set(gca, 'FontName', 'Arial', 'FontSize', 14); % Sets the font for the current axes
set(findall(gcf, '-property', 'FontName'), 'FontName', 'Arial'); % Sets Arial
set(gca, 'color', 'none');
plot(x_green, y_green, "Color", "green", 'LineWidth', 3);
hold on;

%labels
title("JUNC - 60 min");
xlabel('(µm)', 'FontSize', 14);
ylabel('gray value', 'FontSize', 14);
ax = gca;
ax.FontSize = 13.5;
xlim([0 1]);
xticks([0 0.5 1]);
xticklabels({'0.0', '0.5', '1.0'});
yticks([0 0.5 1]);
yticklabels({'0.0', '0.5', '1.0'});
ylim([0 1]);
hold off;

%}



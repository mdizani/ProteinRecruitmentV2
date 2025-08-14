clear all
close all

% Settings
Alpha = 0.2;    % Transparency for shaded error
LW = 2;         % Line width
N = 587;        % Number of data points
M = 30;         % Smoothing parameter
Size = 12;   % Figure height (cm)

% Load and normalize data
Data1r = xlsread('annealing_final', 'Annealing 1');
Data2r = xlsread('annealing_final', 'Annealing 2');

for k = 2:4
    Data1(:,k) = normalize(Data1r(:,k));
    Data2(:,k) = normalize(Data2r(:,k));
end

% Temperature vectors
Temp1 = Data1r(1:N,1);
Temp2 = Data2r(1:N,1);
TempMean = mean([Temp1 Temp2], 2)';

% Define Tmax (transition temperature index)
Tmax = find(TempMean < 50, 1, 'last');
DT = diff(TempMean(1:Tmax));
DTNS = diff(TempMean(Tmax:end));

% Smooth data for Junc, Mid, Tip
Junc = smooth_data(Data1, Data2, 2, N, M);
Mid  = smooth_data(Data1, Data2, 3, N, M);
Tip  = smooth_data(Data1, Data2, 4, N, M);

% Compute mean and std for each region
[JuncMean, JuncStd] = compute_stats(Junc);
[MidMean, MidStd]   = compute_stats(Mid);
[TipMean, TipStd]   = compute_stats(Tip);

% Identify melting points for each region
[MaxJuncIndex, MaxJuncIndexNS] = find_melting_points(JuncMean, DT, DTNS, Tmax);
[MaxMidIndex, MaxMidIndexNS]   = find_melting_points(MidMean, DT, DTNS, Tmax);
[MaxTipIndex, MaxTipIndexNS]   = find_melting_points(TipMean, DT, DTNS, Tmax);

% ---- Plotting ----
figure
hold on

% Plot each curve and retrieve Tm values
[JuncTm, JuncTmNS] = plot_with_shading(TempMean, JuncMean, JuncStd, 'Violet', LW, Alpha, MaxJuncIndex, MaxJuncIndexNS, 'Junc');
[MidTm, MidTmNS]   = plot_with_shading(TempMean, MidMean, MidStd, 'DarkViolet', LW, Alpha, MaxMidIndex, MaxMidIndexNS, 'Mid');
[TipTm, TipTmNS]   = plot_with_shading(TempMean, TipMean, TipStd, 'DarkBlue', LW, Alpha, MaxTipIndex, MaxTipIndexNS, 'Tip');

xlim([25 80])
ylim([0 1])

% Add consolidated Tm annotations
text(30, .7, sprintf('Cond Tm:\nJunc: %.1f°C\nMid: %.1f°C\nTip: %.1f°C', JuncTm, MidTm, TipTm), ...
    'VerticalAlignment', 'bottom', 'FontWeight', 'bold');

text(65, 0.3, sprintf('NS Tm:\nJunc: %.1f°C\nMid: %.1f°C\nTip: %.1f°C', JuncTmNS, MidTmNS, TipTmNS), ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold');


% Styling figure for export
set(gcf, 'PaperPositionMode', 'manual', ...
         'PaperUnits', 'centimeters', ...
         'PaperPosition', [0 0 Size Size], ...
         'PaperSize', [Size Size]);

% Save figure as SVG
print(gcf, '-dsvg', 'annealingCurve_0721_EF.svg')


%% --- Functions ---

function normData = normalize(col)
    normData = (col - min(col)) ./ (max(col) - min(col));
end

function smoothed = smooth_data(Data1, Data2, colIndex, N, M)
    smoothed = [smooth(Data1(1:N,colIndex), M), smooth(Data2(1:N,colIndex), M)];
end

function [meanVals, stdVals] = compute_stats(data)
    meanVals = mean(data,2);
    stdVals = std(data,0,2);
end

function [maxIdx, maxIdxNS] = find_melting_points(meanData, DT, DTNS, Tmax)
    diffData = diff(meanData(1:Tmax));
    slope = diffData ./ DT';
    [~, maxIdx] = max(slope);

    diffDataNS = diff(meanData(Tmax:end));
    slopeNS = diffDataNS ./ DTNS';
    [~, maxRelIdxNS] = max(slopeNS);
    maxIdxNS = Tmax + maxRelIdxNS;
end

function [tmCond, tmNS] = plot_with_shading(temp, meanData, stdData, colorName, lw, alpha, idxCond, idxNS, labelName)
    plot(temp, meanData, 'Color', rgb(colorName), 'LineWidth', lw);
    
    % Shaded error
    X = [temp, fliplr(temp)];
    Y = [meanData' - stdData', fliplr(meanData' + stdData')];
    h = fill(X, Y, rgb(colorName), 'EdgeColor', 'none');
    set(h, 'FaceAlpha', alpha);
    
    % Markers
    plot(temp(idxCond), meanData(idxCond), 'o', 'Color', rgb(colorName), 'LineWidth', lw);
    plot(temp(idxNS), meanData(idxNS), 's', 'Color', rgb(colorName), 'LineWidth', lw);
    
    xlabel('Temperature (°C)')
    ylabel('Normalized Absorbance')
    grid on;


    tmCond = temp(idxCond);
    tmNS = temp(idxNS);
end

function c = rgb(colorName)
    colors = struct(...
        'Violet',      [238, 130, 238]/255,...
        'DarkViolet',  [148, 0, 211]/255,...
        'DarkBlue',    [0, 0, 139]/255 ...
    );

    if isfield(colors, colorName)
        c = colors.(colorName);
    else
        error('Unknown color name: %s', colorName)
    end
end

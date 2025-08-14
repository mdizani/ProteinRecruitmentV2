%% Correct Melting curve - checked 08/02

file = 'Annealing_dupe.xlsx';        
sheetNames = sheetnames(file);

for k = 1:numel(sheetNames)
    thisTable = readtable(file, 'Sheet', sheetNames{k});
    if k == 1
        a_nsa = thisTable;
    elseif k == 2
        m_nsa = thisTable;
    end
end

% Select data
j = m_nsa(1:719,"JUNC"); 
m = m_nsa(1:719,"MID"); 
t = m_nsa(1:719, "TIP"); 
temp = m_nsa(1:719,"T");

% Combine data sets
y_data = {j, m, t};
x_data = {temp, temp, temp};

% Plot settings
figure;
hold on;
colors = ['r', 'g', 'b'];
labels = {'JUNC', 'MID', 'TIP'};
target_y = 0.5;

for i = 1:3
    x = table2array(x_data{i});
    y = table2array(y_data{i});
    
    % Normalize
    y_norm = (y - min(y)) ./ (max(y) - min(y));
    
    % Sort for plotting
    [x_sorted, sort_idx] = sort(x);
    y_sorted = y_norm(sort_idx);

    % Plot normalized data
    plot(x_sorted, y_sorted, '-', 'LineWidth', 2, 'DisplayName', labels{i}, 'Color', colors(i));

    % Find where y = 0.5 using interpolation
    x_half = interp1(y_sorted, x_sorted, target_y, 'linear', 'extrap');

    % Plot marker at y = 0.5
    plot(x_half, target_y, 'o', 'MarkerSize', 8, 'MarkerEdgeColor', colors(i), ...
         'MarkerFaceColor', colors(i), 'DisplayName', [labels{i} ' Half-max']);

    fprintf('%s crosses y=0.5 at %.2f°C\n', labels{i}, x_half);
end

xlabel('Temperature (°C)');
ylabel('Normalized Signal');
title('Melting no SA (norm)');
legend('Location', 'best');
xlim([25, 80]);
ylim([0 1]);
axis square;
grid on;

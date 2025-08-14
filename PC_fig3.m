

j_ns = [43.96493559
    43.33394334
    50.76094773
    31.6007332
    35.03531869
    ];

j_sa = [9.180271532
    8.631894541
    9.418559664
    7.255089213
    7.320313387
    ];

m_ns = [32.77917382
    37.76738079
    37.76738079
    49.81294164
    48.3873452
    ];

m_sa = [8.220813025
    8.404283849
    6.922189844
    9.975647806
    9.542878869
    ];

t_ns = [20.52877453
    22.12309417
    21.60846321
    30.10787341
    33.21819721
    ];

t_sa = [4.270507714
    4.166905768
    4.555936151
    4.916670662
    5.421152712
    ];

plot_and_save(j_ns, 'j_ns');
plot_and_save(j_sa, 'j_sa');


plot_and_save(m_ns, 'm_ns');
plot_and_save(m_sa, 'm_sa');

plot_and_save(t_ns, 't_ns');
plot_and_save(t_sa, 't_sa');

function plot_and_save(normA, varName)
    figure;

    % Plot boxplot
    boxplot(normA, 'Whisker', 1.5, 'Colors', 'k', 'Widths', 1);
    ylim([0 52]);

    % Display mean and standard deviation in command window
    fprintf('Mean of %s: %.2f\n', varName, mean(normA));
    fprintf('Standard deviation of %s: %.2f\n', varName, std(normA));

    % Plot individual data points
    hold on;
    scatter(ones(size(normA)), normA, 'filled', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'k');
    xlabel(varName);
    ylabel('Partition Coefficient');
    set(gcf, 'Position', [100, 100, 100, 500]);
    hold off;

    % Save as SVG
    filename = sprintf('%s_rep2.svg', varName);
    saveas(gcf, filename);
end

function normArray = normalize(a1)
    normArray = [];
    Xmin = min(a1);
    Xmax = max(a1);
    for i = 1:length(a1)
        normX = (a1(i)-Xmin)/(Xmax-Xmin);
        normArray(i) = normX;
    end
    normArray = transpose(normArray);
end


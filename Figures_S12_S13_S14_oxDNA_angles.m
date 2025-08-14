%oxDNA processing code
%attempt 5 - 
%21 July 2025

% Read file (XYZ only)
data = readmatrix("middleNS-trajectory.dat", 'Delimiter', ' ', 'NumHeaderLines', 3);
data = data(:, 1:3);

% Separate into 4000 frames
%{
time = cell(1, 4000);
for i = 1:4000
    i_start = (i-1)*186 + 1;
    i_end = i_start + 182;
    time{i} = data(i_start:i_end, :);
end
%}

% FOR MID ONLY
%%{
time = cell(1, 4000);
for i = 1:4000
    i_start = (i-1)*187 + 1;
    i_end = i_start + 183;
    time{i} = data(i_start:i_end, :);
end

%}

% Assign positions for arms and spacers
s1 = zeros(4000, 3); s2 = zeros(4000, 3); s3 = zeros(4000, 3); s4 = zeros(4000, 3);
sp1a = zeros(4000, 3); sp1b = zeros(4000, 3);
sp2a = zeros(4000, 3); sp2b = zeros(4000, 3);
sp3a = zeros(4000, 3); sp3b = zeros(4000, 3);
sp4a = zeros(4000, 3); sp4b = zeros(4000, 3);

s1_1 = zeros(4000, 3);
s2_1 = zeros(4000, 3);
s3_1 = zeros(4000, 3);
s4_1 = zeros(4000, 3);

%junc sp 4a, 4b: 131, 163
%tip sp 4a, 4b: 162, 163
%mid sp 4a, 4b: 131, 132

%v1: s1, s3
%v2: s1, s2
%v3: s3, s4
%v4: s2, s4

for i = 1:4000
    t = time{i};
    s1(i, :) = t(1, :); s1_1(i, :) = t(110, :);
    s2(i, :) = t(34, :); s2_1(i, :) = t(39, :);
    s3(i, :) = t(77, :); s3_1(i, :) = t(180, :); %179-JT 180-M
    s4(i, :) = t(72, :); s4_1(i, :) = t(115, :); %115-JM 146-T
    sp1a(i, :) = t(17, :); sp1b(i, :) = t(18, :);
    sp2a(i, :) = t(55, :); sp2b(i, :) = t(56, :);
    sp3a(i, :) = t(93, :); sp3b(i, :) = t(94, :);
    sp4a(i, :) = t(131, :); sp4b(i, :) = t(132, :); 
end

% === Unwrap and recenter each frame ===
box_length = 28;
half_box = box_length / 2;
num_frames = size(s1, 1);

coj = zeros(num_frames, 3);
com_1 = zeros(num_frames, 3);
com_2 = zeros(num_frames, 3);
com_3 = zeros(num_frames, 3);
com_4 = zeros(num_frames, 3);
v1 = zeros(num_frames, 3);
v2 = zeros(num_frames, 3);
v3 = zeros(num_frames, 3);
v4 = zeros(num_frames, 3);

%preallocate for unwrapped arm points individually
us1 = zeros(num_frames, 3); us1_1 = zeros(num_frames, 3);
us2 = zeros(num_frames, 3); us2_1 = zeros(num_frames, 3);
us3 = zeros(num_frames, 3); us3_1 = zeros(num_frames, 3);
us4 = zeros(num_frames, 3); us4_1 = zeros(num_frames, 3);


for t = 1:num_frames
    pts = [sp1a(t,:); sp1b(t,:); sp2a(t,:); sp2b(t,:); sp3a(t,:); sp3b(t,:); sp4a(t,:); sp4b(t,:)];
    ref = pts(1,:);
    for j = 2:size(pts,1)
        for k = 1:3
            delta = pts(j,k) - ref(k);
            if delta > half_box
                pts(j,k) = pts(j,k) - box_length;
            elseif delta < -half_box
                pts(j,k) = pts(j,k) + box_length;
            end
        end
    end
    coj(t,:) = mean(pts, 1);

    arms = {
        [s1(t,:); s1_1(t,:)];
        [s2(t,:); s2_1(t,:)];
        [s3(t,:); s3_1(t,:)];
        [s4(t,:); s4_1(t,:)];
    };
    coms = zeros(4, 3);
    for a = 1:4
        for p = 1:2
                % Store unwrapped positions relative to COJ
    switch a
        case 1
            us1(t,:)   = arms{a}(1,:) - coj(t,:); %1
            us1_1(t,:) = arms{a}(2,:) - coj(t,:); %110
        case 2
            us2(t,:)   = arms{a}(1,:) - coj(t,:); %34
            us2_1(t,:) = arms{a}(2,:) - coj(t,:); %39
        case 3
            us3(t,:)   = arms{a}(1,:) - coj(t,:); %77
            us3_1(t,:) = arms{a}(2,:) - coj(t,:); %179, 180M
        case 4
            us4(t,:)   = arms{a}(1,:) - coj(t,:); %72
            us4_1(t,:) = arms{a}(2,:) - coj(t,:); %146T, 115JM
    end

            for k = 1:3
                delta = arms{a}(p,k) - coj(t,k);
                if delta > half_box
                    arms{a}(p,k) = arms{a}(p,k) - box_length;
                elseif delta < -half_box
                    arms{a}(p,k) = arms{a}(p,k) + box_length;
                end
            end
        end
        coms(a,:) = mean(arms{a}, 1) - coj(t,:);
    end

    com_1(t,:) = coms(1,:);
    com_2(t,:) = coms(2,:);
    com_3(t,:) = coms(3,:);
    com_4(t,:) = coms(4,:);
    v1(t,:) = coms(1,:);
    v2(t,:) = coms(2,:);
    v3(t,:) = coms(3,:);
    v4(t,:) = coms(4,:);
end

% === Compute angles between vectors ===
vector_angle = @(vA, vB) acosd(dot(vA, vB, 2) ./ ...
    (vecnorm(vA, 2, 2) .* vecnorm(vB, 2, 2)));

theta12 = vector_angle(v1, v2);
theta13 = vector_angle(v1, v3);
theta14 = vector_angle(v1, v4);
theta23 = vector_angle(v2, v3);
theta24 = vector_angle(v2, v4);
theta34 = vector_angle(v3, v4);

% Plot vectors from COJ to arms at a chosen frame ===
t = 1;  % Frame to visualize
origin = [0, 0, 0];  % After centering, COJ is at origin

vecs = [com_1(t,:); com_2(t,:); com_3(t,:); com_4(t,:)];

X = repmat(origin(1), 1, 4);
Y = repmat(origin(2), 1, 4);
Z = repmat(origin(3), 1, 4);

U = vecs(:, 1)';
V = vecs(:, 2)';
W = vecs(:, 3)';

figure;
q = quiver3(X, Y, Z, U, V, W, 0, 'LineWidth', 2);
hold on;
h1 = scatter3(com_1(t,1), com_1(t,2), com_1(t,3), 60, 'r', 'filled');
h2 = scatter3(com_2(t,1), com_2(t,2), com_2(t,3), 60, 'g', 'filled');
h3 = scatter3(com_3(t,1), com_3(t,2), com_3(t,3), 60, 'b', 'filled');
h4 = scatter3(com_4(t,1), com_4(t,2), com_4(t,3), 60, 'm', 'filled');
h5 = scatter3(origin(1), origin(2), origin(3), 100, 'k', 'filled');
% === Overlay all nucleotide positions at frame t (centered and unwrapped) ===
raw_frame = time{t};
frame_centered = raw_frame;

% Unwrap each nucleotide relative to coj
for i = 1:size(raw_frame, 1)
    for k = 1:3
        delta = raw_frame(i,k) - coj(t,k);
        if delta > half_box
            frame_centered(i,k) = raw_frame(i,k) - box_length;
        elseif delta < -half_box
            frame_centered(i,k) = raw_frame(i,k) + box_length;
        else
            frame_centered(i,k) = raw_frame(i,k);
        end
    end
end

% Center all coordinates by subtracting the COJ
frame_centered = frame_centered - coj(t,:);

% Plot all nucleotides
% Plot strands by index range
scatter3(frame_centered(1:38,1), frame_centered(1:38,2), frame_centered(1:38,3), ...
    20, 'filled', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
scatter3(frame_centered(39:76,1), frame_centered(39:76,2), frame_centered(39:76,3), ...
    20, 'filled', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'g');
scatter3(frame_centered(77:114,1), frame_centered(77:114,2), frame_centered(77:114,3), ...
    20, 'filled', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
scatter3(frame_centered(115:end,1), frame_centered(115:end,2), frame_centered(115:end,3), ...
    20, 'filled', 'MarkerFaceColor', [1 0.4 1], 'MarkerEdgeColor', [1 0.4 1]);  % pink


legend([q, h1, h2, h3, h4, h5], {'Vectors', 's1', 's2', 's3', 's4', 'coj'});
hold off;

% === Histogram of angles - concatenated ===
angle_labels = {'\theta_{1-2}', '\theta_{1-3}', '\theta_{1-4}', ...
                '\theta_{2-3}', '\theta_{2-4}', '\theta_{3-4}'};
angle_datapre = [theta12; theta13; theta14; theta23; theta24; theta34];
angle_data = angle_datapre(~any(isnan(angle_datapre), 2), :);
m = mean(angle_data);
standard = std(angle_data);

figure;
set(gca, 'FontName', 'Arial', 'FontSize', 18);
histogram(angle_data, 'BinWidth', 15);
%xlabel('\theta', 'FontSize', 17);
%ylabel('Frequency', 'FontSize', 17);
ylim([0 4000]);
title(['Distribution of \theta - Middle'], 'FontSize', 20);
ax = gca;
ax.FontSize = 14;
m_text = sprintf('\\mu = %.2f', m);
s_text = sprintf('\\sigma = %.2f', standard);

text(0.04, 0.95, ['$' m_text '$'], 'Units', 'normalized', 'Interpreter', 'latex', 'FontSize', 18, 'VerticalAlignment', 'top');
text(0.04, 0.90, ['$' s_text '$'], 'Units', 'normalized', 'Interpreter', 'latex', 'FontSize', 18, 'VerticalAlignment', 'top');
grid on;
hold off;

%prep for individual angles
ind_angles = {theta12, theta13, theta14, theta23, theta24, theta34};

%histograms

% Loop through and plot one histogram per angle
for i = 1:length(ind_angles)
    mu = mean(ind_angles{i});
    sma = std(ind_angles{i});
    figure;
    set(gca, 'FontName', 'Arial', 'FontSize', 18);
    histogram(ind_angles{i}, 'BinWidth', 15)
    %xlabel('\theta', 'FontSize', 17')
    %ylabel('Frequency', 'FontSize', 17);
    ylim([0 900]);
    title(['Distribution of ', angle_labels{i}, ' - Middle'], 'FontSize', 20);
    ax = gca;
    ax.FontSize = 14;
    mu_text = sprintf('\\mu = %.2f', mu);
    sma_text = sprintf('\\sigma = %.2f', sma);
    text(0.04, 0.95, ['$' mu_text '$'], 'Units', 'normalized', 'Interpreter', 'latex', 'FontSize', 22, 'VerticalAlignment', 'top');
    text(0.04, 0.85, ['$' sma_text '$'], 'Units', 'normalized', 'Interpreter', 'latex', 'FontSize', 22, 'VerticalAlignment', 'top');
    grid on;
end








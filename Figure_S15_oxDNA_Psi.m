%% === READ TRAJECTORY ===
data = readmatrix("middleNS-trajectory.dat", 'Delimiter', ' ', 'NumHeaderLines', 3);
data = data(:, 1:3);

particles_per_frame = 187;
total_rows = size(data, 1);
num_frames = floor(total_rows / particles_per_frame);
remainder = mod(total_rows, particles_per_frame);
if remainder ~= 0
    warning('%d rows will be ignored (incomplete last frame)', remainder);
end

% Store each frame
time = cell(1, num_frames);
for i = 1:num_frames
    i_start = (i - 1) * particles_per_frame + 1;
    i_end   = i_start + particles_per_frame - 1;
    time{i} = data(i_start:i_end, :);
end

%% === PREALLOCATE ===
s1 = zeros(num_frames,3); s2 = s1; s3 = s1; s4 = s1;
s1_1 = s1; s2_1 = s1; s3_1 = s1; s4_1 = s1;
mp1 = s1; mp2 = s1;

sp1a = s1; sp1b = s1; sp2a = s1; sp2b = s1;
sp3a = s1; sp3b = s1; sp4a = s1; sp4b = s1;

coj = s1;
com_1 = s1; com_2 = s1; com_3 = s1; com_4 = s1; com_mid = s1;
v1 = s1; v2 = s1; v3 = s1; v4 = s1; u1 = s1; u2 = s1;

box_length = 28;
half_box = box_length / 2;

for i = 1:num_frames
    t = time{i};
    s1(i,:) = t(1,:);   s1_1(i,:) = t(110,:);
    s2(i,:) = t(34,:);  s2_1(i,:) = t(39,:);
    s3(i,:) = t(77,:);  s3_1(i,:) = t(180,:);
    s4(i,:) = t(72,:);  s4_1(i,:) = t(115,:);
    sp1a(i,:) = t(17,:); sp1b(i,:) = t(18,:);
    sp2a(i,:) = t(55,:); sp2b(i,:) = t(56,:);
    sp3a(i,:) = t(93,:); sp3b(i,:) = t(94,:);
    sp4a(i,:) = t(131,:); sp4b(i,:) = t(132,:);
    mp1(i,:) = t(140,:); mp2(i,:) = t(174,:);
end

%% === UNWRAP AND CENTER ===
for t = 1:num_frames
    pts = [sp1a(t,:); sp1b(t,:); sp2a(t,:); sp2b(t,:); ...
           sp3a(t,:); sp3b(t,:); sp4a(t,:); sp4b(t,:)];
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
    coj(t,:) = mean(pts,1);

    % Arm vectors and COMs
    arms = {
        [s1(t,:); s1_1(t,:)];
        [s2(t,:); s2_1(t,:)];
        [s3(t,:); s3_1(t,:)];
        [s4(t,:); s4_1(t,:)];
        [mp1(t,:); mp2(t,:)];
    };
    coms = zeros(5,3);
    for a = 1:5
        for p = 1:2
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
    com_1(t,:) = coms(1,:); v1(t,:) = coms(1,:);
    com_2(t,:) = coms(2,:); v2(t,:) = coms(2,:);
    com_3(t,:) = coms(3,:); v3(t,:) = coms(3,:);
    com_4(t,:) = coms(4,:); v4(t,:) = coms(4,:);
    com_mid(t,:) = coms(5,:); u1(t,:) = coms(5,:);
    u2(t,:) = com_mid(t,:) - com_4(t,:);
end

%% === ANGLE COMPUTATION ===
vector_angle = @(vA, vB) acosd(dot(vA, vB, 2) ./ ...
    (vecnorm(vA,2,2) .* vecnorm(vB,2,2)));

theta12 = vector_angle(v1, v2);
theta13 = vector_angle(v1, v3);
theta14 = vector_angle(v1, v4);
theta23 = vector_angle(v2, v3);
theta24 = vector_angle(v2, v4);
theta34 = vector_angle(v3, v4);
alpha    = vector_angle(u1, u2);

%% === PLOTTING: VECTOR TRIANGLE ===
t = 1;
origin = [0, 0, 0];
vecs = [com_1(t,:); com_2(t,:); com_3(t,:); com_4(t,:); com_mid(t,:)];
X = repmat(0, 1, 5); Y = X; Z = X;
U = vecs(:,1)'; V = vecs(:,2)'; W = vecs(:,3)';

figure;
q = quiver3(X, Y, Z, U, V, W, 0, 'LineWidth', 2);
hq_u2 = quiver3(com_4(t,1), com_4(t,2), com_4(t,3), ...
        u2(t,1), u2(t,2), u2(t,3), 0, ...
        'Color', [0.3 0.3 0.3], 'LineWidth', 2, 'LineStyle', '--');
hold on;
h1 = scatter3(com_1(t,1), com_1(t,2), com_1(t,3), 60, 'r', 'filled');
h2 = scatter3(com_2(t,1), com_2(t,2), com_2(t,3), 60, 'g', 'filled');
h3 = scatter3(com_3(t,1), com_3(t,2), com_3(t,3), 60, 'b', 'filled');
h4 = scatter3(com_4(t,1), com_4(t,2), com_4(t,3), 60, 'm', 'filled');
h5 = scatter3(0, 0, 0, 100, 'k', 'filled');
hu1 = scatter3(com_mid(t,1), com_mid(t,2), com_mid(t,3), 60, [0.1 0.6 0.9], 'filled');
hu2 = scatter3(com_mid(t,1), com_mid(t,2), com_mid(t,3), 60, [1 0.5 0], 'filled');

text(com_mid(t,1), com_mid(t,2), com_mid(t,3), ...
    sprintf('\\alpha = %.1f°', alpha(t)), ...
    'FontSize', 14, 'Color', 'k', 'HorizontalAlignment', 'left');

% Unwrap and plot nucleotides
raw_frame = time{t};
frame_centered = raw_frame;
for i = 1:size(raw_frame,1)
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
frame_centered = frame_centered - coj(t,:);
scatter3(frame_centered(1:38,1), frame_centered(1:38,2), frame_centered(1:38,3), ...
    20, 'filled', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
scatter3(frame_centered(39:76,1), frame_centered(39:76,2), frame_centered(39:76,3), ...
    20, 'filled', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'g');
scatter3(frame_centered(77:114,1), frame_centered(77:114,2), frame_centered(77:114,3), ...
    20, 'filled', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
scatter3(frame_centered(115:end,1), frame_centered(115:end,2), frame_centered(115:end,3), ...
    20, 'filled', 'MarkerFaceColor', [1 0.4 1], 'MarkerEdgeColor', [1 0.4 1]);
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal; grid on;
title('\alpha angle visualization — original format');

%% === HISTOGRAMS ===
%angle_labels = {'\theta_{1-2}', '\theta_{1-3}', '\theta_{1-4}', ...
                ...'\theta_{2-3}', '\theta_{2-4}', '\theta_{3-4}', '\alpha'};
angle_labels = {'\alpha'};
angle_datapre = [theta12; theta13; theta14; theta23; theta24; theta34];
angle_data = angle_datapre(~any(isnan(angle_datapre),2), :);
m = mean(angle_data); standard = std(angle_data);

figure;
set(gca, 'FontName', 'Arial', 'FontSize', 18);
histogram(angle_data, 'BinWidth', 15);
xlabel('\theta', 'FontSize', 17);
ylabel('Frequency', 'FontSize', 17);
ylim([0 4000]);
title(['Distribution of \theta - Middle'], 'FontSize', 20);
text(0.04, 0.95, ['$\mu = ', num2str(m,'%.2f'), '$'], 'Units', 'normalized', 'Interpreter', 'latex', 'FontSize', 18);
text(0.04, 0.90, ['$\sigma = ', num2str(standard,'%.2f'), '$'], 'Units', 'normalized', 'Interpreter', 'latex', 'FontSize', 18);
grid on;

% Individual histograms
%ind_angles = {theta12, theta13, theta14, theta23, theta24, theta34, alpha};
ind_angles = {alpha};

for i = 1:length(ind_angles)
    mu = mean(ind_angles{i});
    sigma = std(ind_angles{i});
    figure;
    set(gca, 'FontName', 'Arial', 'FontSize', 18);
    histogram(ind_angles{i}, 'BinWidth', 15);
    ylim([0 1500]);
    xlim([0 180]);
    title(['Distribution of ', angle_labels{i}, ' - Middle'], 'FontSize', 20);
    ax = gca;
    ax.FontSize = 14;
    text(0.04, 0.95, ['$\mu = ', num2str(mu,'%.2f'), '$'], 'Units', 'normalized', 'Interpreter', 'latex', 'FontSize', 18);
    text(0.04, 0.85, ['$\sigma = ', num2str(sigma,'%.2f'), '$'], 'Units', 'normalized', 'Interpreter', 'latex', 'FontSize', 18);
    grid on;
end

%% === Triangle Plot for Alpha Angle at Frame t ===
t = 1;
p_coj = [0, 0, 0];            % COJ centered at origin
p_mid = com_mid(t,:);
p_v4  = com_4(t,:);           % COM of arm 4

figure;
hold on;

% Triangle edges
plot3([p_coj(1), p_mid(1)], [p_coj(2), p_mid(2)], [p_coj(3), p_mid(3)], ...
      'c-', 'LineWidth', 2);   % COJ → mid
plot3([p_v4(1), p_mid(1)], [p_v4(2), p_mid(2)], [p_v4(3), p_mid(3)], ...
      'm-', 'LineWidth', 2);   % v4 → mid
plot3([p_coj(1), p_v4(1)], [p_coj(2), p_v4(2)], [p_coj(3), p_v4(3)], ...
      'k-', 'LineWidth', 2);   % COJ → v4

% Points
scatter3(p_coj(1), p_coj(2), p_coj(3), 100, 'k', 'filled');
scatter3(p_mid(1), p_mid(2), p_mid(3), 100, 'm', 'filled');
scatter3(p_v4(1), p_v4(2), p_v4(3), 100, 'b', 'filled');

% Alpha label at com_mid
text(p_mid(1), p_mid(2), p_mid(3), sprintf('\\alpha = %.1f°', alpha(t)), ...
    'FontSize', 14, 'Color', 'k', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'bottom');

xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal; grid on;
title('\alpha Triangle: COJ–com\_mid–arm 4');











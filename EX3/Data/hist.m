clear; close all;

load IR_50.mat

cmap = [0.850000000000000, 0.325000000000000, 0.0980000000000000;  % Màu cho Cluster 1
        0.000000000000000, 0.447000000000000, 0.741000000000000];  % Màu cho Cluster 2

hold on;

for i = 1:max(labels)
    % Find indices corresponding to the current label
    idx = find(labels == i);
    % Plot all curves for the current label
    h = plot(grid, Data(:, idx), 'Color', cmap(i, :), 'LineWidth', 1.5);
    
    % For multiple lines in one call, hide all but the first from the legend
    if numel(h) > 1
        set(h(2:end), 'HandleVisibility', 'off');
    end
    % Set the legend label for the first curve
    h(1).DisplayName = ['Cluster ' num2str(i)];
end

legend('show');


temp(25,15,15);


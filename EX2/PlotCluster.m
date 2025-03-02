function PlotCluster(data, labels, grid)
% Plot probability density functions from data matrix
% Input:
%   - data: a matrix containing PDF data. Rows represent the x-axis values, and columns represent different PDFs.
%           The last row contains the label for each PDF.
%   - labels: a vector containing the labels for each PDF.
%   - x (optional): a vector of x-axis values. If not provided, a default vector is created.
% Output:
%   - A figure displaying the PDFs with a legend, axis labels, and title.

% Check if x is provided, if not, create a default vector

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting
colors = winter(max(labels));
unique_labels = unique(labels);
num_labels = numel(unique_labels);
color_map = containers.Map(unique_labels, mat2cell(colors, ones(size(colors, 1), 1), size(colors, 2)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ploting

for i = 1:numel(labels)
    color = color_map(labels(i));
    plot(grid, data(:,i), 'Color', color, 'LineWidth', .5, 'LineStyle', '-');
    % plot(grid, data(:,i), 'LineWidth', .5, 'LineStyle', ':', 'Color', [.8 .8 .8]);

    hold on
end
    tilName = sprintf('The %d Probability Density Functions Data', ...
        length(labels));
    title(tilName);

    % Create legend based on color using graphics objects
    % legend_entries = cell(1, num_labels);
    % legend_objects = gobjects(1, num_labels);
    % for j = 1:num_labels
    %     legend_entries{j} = sprintf('Cluster %d', ...
    %         unique_labels(j));
    %     legend_objects(j) = plot(NaN, NaN, 'Color', color_map(unique_labels(j)), ...
    %         'DisplayName', legend_entries{j});
    % end
    % legend(legend_objects, 'Location', 'southoutside', 'Box','off','NumColumns',2);
    % Remove y-axis labels and line
    set(gca, 'YColor', 'none'); % Hide y-axis line
    box off;
end

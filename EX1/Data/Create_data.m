clear; close all;

h = 0.1; % Step size for the grid
grid = -18:h:18; % Range of values for the grid

% Loop over 100 iterations
for IR = 1:100
    rng(IR);


    % Define the ranges for the means of the distributions
    mu_ranges = {
        normrnd(-5, 0.5, 10*IR,1); % Increasing number of samples, maxing at 1000
        normrnd(5, 0.5, 10,1); % Constant 10 samples
    };

    sig_values = [3, 3]; % Standard deviations for the groups

    num_groups = length(mu_ranges); % Number of groups
    pdfs = []; % Initialize PDFs
    labels = []; % Initialize labels

    % Loop over each group
    for group = 1:num_groups
        mu_range = mu_ranges{group};
        % Generate PDFs for each mean in the range
        for i = 1:length(mu_range)
            f_single = normpdf(grid, mu_range(i), sig_values(group));
            pdfs = [pdfs; f_single]; % Collect PDFs
            labels = [labels; group]; % Assign group labels
        end
    end

    Data = pdfs'; % Transpose for correct orientation
    labels = labels'; % Transpose labels

    % Save the data and labels in a MAT-file
    save(sprintf('IR_%d.mat', IR), 'Data', 'labels', 'h', 'grid');

end

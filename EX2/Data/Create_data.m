clear; close all;

xmin = -10.0;
xmax = 10.0;
h = 0.1;

grid = xmin:h:xmax;
nx = length(grid);

extcx = (xmin-100):h:(xmax+100);
ng = nx; % Number of grid points

% Loop over 5 iterations
for IR = 1:100
    rng(IR);
    % Define the ranges for the means of the distributions
    SkewXi = {
        normrnd(0, 0.2, 10, 1); 
        normrnd(2, 0.2, 10*IR, 1);
        normrnd(-2, 0.2, 10*IR, 1)
    };
    SkewLambda = [0, 10, -10];   % Skewness (any number)
    SkewSigma  = [1, 2, 2];      % Scale (must be positive)

    num_groups = length(SkewXi); % Number of groups
    pdfs = []; % Initialize PDFs
    labels = []; % Initialize labels

    for group = 1:num_groups
        SkewXis = SkewXi{group};
        SkewPhi = exp(-0.5 * (extcx.^2)) / sqrt(2 * pi);   

        for i = 1:length(SkewXis)
            ofv = zeros(nx,1); % Initialize PDF vector

            for j = 1:nx
                ct = (grid(j) - SkewXis(i)) / SkewSigma(group); % Use 'group' instead of 'i'
                intid = ceil((SkewLambda(group) * (grid(j) - SkewXis(i)) / SkewSigma(group) - (xmin - 100)) / h);

                % Ensure intid is within valid range
                intid = max(min(intid, length(SkewPhi)), 1);

                ofv(j) = (2 / SkewSigma(group)) * (exp(-0.5 * (ct^2)) / sqrt(2 * pi)) * (sum(SkewPhi(1:intid)) * h);
            end

            pdfs = [pdfs; ofv']; % Collect PDFs
            labels = [labels; group]; % Assign group labels
        end
    end

    Data = pdfs'; % Transpose for correct orientation
    labels = labels'; % Transpose labels

    % Save the data and labels in a MAT-file
    save(sprintf('IR_%d.mat', IR), 'Data', 'labels', 'h', 'grid');

end


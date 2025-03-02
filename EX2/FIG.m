clear; close all;
h = 0.1;
x = -18:h:18;

% Gaussian distributions
A = normpdf(x, 5, 3);
B = normpdf(x, -5, 3);

% Colors
cls = sky(6); % Assuming 'sky' is a defined colormap

% Plotting Gaussian PDFs
plot(x, A, 'LineWidth', 3, 'Color', cls(4,:)); hold on;
plot(x, B, 'LineWidth', 3, 'Color', cls(5,:)); hold on;

% Compute and plot the Hellinger area between the two distributions
% Uncomment the following line if 'sky' colormap and plotting Hellinger distance are needed
% area(x, sqrt(A.*B), "EdgeColor", cls(3,:), "FaceColor", cls(3,:));

title('Gaussian PDFs');
legend({'Dist A', 'Dist B'}, 'Location', 'NorthEast');
xlabel('x');
ylabel('PDF value');




%%
clear; close all;

h = 0.1;
[x, y] = meshgrid(-5:h:5, -5:h:5);

% Centers of the Gaussians
mu = [2 0; 0 2];

% Standard deviations
sig = [1; 1];

% Initialize the figure
figure(1);

% Loop through each Gaussian
for j = 1:size(mu, 1)
    fi = mvnpdf([x(:) y(:)], mu(j,:), eye(2) * sig(j)); % Calculate PDF values
    f = reshape(fi, size(x, 1), size(x, 2)); % Reshape into grid format
    
    % Surface plot
    surf(x, y, f, 'FaceAlpha', .7); hold on;
    % Contour plot
    contour(x, y, f, 'LineWidth', 3);
end

colormap("sky") % Set colormap
shading flat % Set shading
title('2D Multivariate Gaussian Distributions');
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Probability Density');

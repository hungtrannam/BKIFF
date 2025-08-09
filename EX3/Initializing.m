function [max_distance, best_tt, curve] = Initializing(f, c, algorithm, h, dim)

numAgents = 30;
maxIterations = 30;
lb = ones(1, c); 

switch dim
    case '2D'
        numSample = size(f,3);
        objectiveFcn = @(tt) -min(arrayfun(@(i) min(arrayfun(@(j) ...
        sqrt(2*(1-(Integration(h, sqrt(f(:,:, round(tt(j))) .* f(:,:, round(tt(i)))), 2)))), ...
        1:i-1)), 2:c)); 
    case '1D'
        numSample = size(f,2);
        objectiveFcn = @(tt) -min(arrayfun(@(i) min(arrayfun(@(j) ...
        sqrt(2*(1-(Integration(h, sqrt(f(:, round(tt(j))) .* f(:, round(tt(i)))), 1)))), ...
        1:i-1)), 2:c)); 
        
end

ub = numSample * ones(1, c); 

optionsPSO = optimoptions('particleswarm', ...
    'SwarmSize', 80, ...
    'MaxIterations', 300, ...
    'FunctionTolerance', 1e-9, ...
    'Display', 'iter', ...
    'PlotFcn', 'pswplotbestf');
optionsGA = optimoptions('ga', ...
    'PopulationSize', 80, ...  
    'MaxGenerations', 100, ...  
    'FunctionTolerance', 1e-9, ...
    'Display', 'iter', ...
    'PlotFcn', 'gaplotbestf');  

tic
switch algorithm
    case 'ALO'
        [max_distance, best_tt, curve] = ALO(numAgents, maxIterations, lb, ub, c, objectiveFcn);
    case 'BKA'
        [max_distance, best_tt, curve] = BKA(numAgents, maxIterations, lb, ub, c, objectiveFcn);
    case 'GWO'
        [max_distance, best_tt, curve] = GWO(numAgents, maxIterations, lb, ub, c, objectiveFcn);
    case 'WOA'
        [max_distance, best_tt, curve] = WOA(numAgents, maxIterations, lb, ub, c, objectiveFcn);
    case 'STOA'
        [max_distance, best_tt, curve] = stoa(numAgents, maxIterations, lb, ub, c, objectiveFcn);
    case 'MVO'
        [max_distance, best_tt, curve] = MVO(numAgents, maxIterations, lb, ub, c, objectiveFcn);
    case 'PSO'
        [best_tt, max_distance] = particleswarm(objectiveFcn, c, lb, ub, optionsPSO);
    case 'GA'
        [best_tt, max_distance] = ga(objectiveFcn, c, [], [], [], [], lb, ub, [], optionsGA);
end

time_woa = toc;
fprintf('Max Distance = %f, Best TT = %s, Time = %f seconds\n', max_distance, mat2str(round(best_tt)), time_woa);

end


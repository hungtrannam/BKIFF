function results = KMEAN_(Data, param)


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting
% rng(4);
f            = Data;
numSample    = size(f, 2);
numCluster   = param.kClust;
iter         = 0;
maxIter      = 500;
epsilon      = 10^(-6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clustering

rng(param.Ran);

%% Repeat KMEAN until convergence or max iterations
fv = f(:, randperm(numSample, numCluster));

while iter < maxIter
    iter = iter + 1;
    
    for j = 1:numSample
        for i = 1:numCluster
            D(i, j) = Integration(param.h, abs(fv(:, i) - f(:, j)), 1) + 10^(-10);
        end
    end

    [~, IDX] = min(D);

    for i = 1:numCluster
        if sum(IDX == i) > 0
            fv(:, i) = mean(f(:, IDX == i), 2);
        end
    end

    ObjFun = sum(min(D));
    % fprintf('Iteration count = %d, obj. kmeans = %f\n', iter, ObjFun);

    if iter > 1 && norm(fvnew - fv) < epsilon
        break;
    end
    fvnew = fv;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Results

results.Centre = fvnew;
results.iter = iter;
results.Data = f;
results.IDX = IDX;
results.Dist = D;

end

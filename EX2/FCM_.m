function results = FCM_(Data, param)


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting
% rng(4);
f            = Data;
iter         = 0;
max_iter     = 500;
fm           = param.mFuzzy;
epsilon      = 10^(-3);
numSample    = size(f, 2);
numCluster   = param.kClust;


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clustering

rng(param.Ran);

%% Initialize the partition matrix with FCM
    fv = f(:, randperm(numSample, numCluster));

%% Repeat FCM until convergence or max iterations
while iter < max_iter
    iter = iter + 1;

    % Calculate the distance between fv with fi PDFs
    for j = 1:numSample
        for i = 1:numCluster
            D(i, j) = Integration(param.h, abs(fv(:, i) - f(:, j)), 1) + 10^(-10); % L1
            % D(i, j) = sqrt(1 - (Integration(param.h, sqrt(fv(:,i) .* f(:,j)), 1)) + 10^(-10));
        end
    end


    % Update partition matrix
    Unew = ones(numCluster, numSample) / numCluster;
    for i = 1:numCluster
        for j = 1:numSample
            sumDist = 0;
            for k = 1:numCluster
                sumDist = sumDist + (D(i,j)^(1/(fm-1))) / (D(k,j)^(1/(fm-1)));
            end
            Unew(i, j) = 1 / sumDist;
        end
    end

    % Calculate the cluster centers
    fvnew = (f * Unew.^fm') ./ sum(Unew.^fm, 2)';
    % ObjFun = sum(sum((Unew) .* D));
    % fprintf('Iteration count = %d, obj. fcm = %f\n', iter, ObjFun);

    % Check for convergence
    if norm(fv - fvnew, 1) < epsilon
        break;
    end

    fv = fvnew;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Results

[~,IDX] = max(Unew);

results.member = Unew;
results.Centre = fv;
results.iter = iter;
% results.ObjFun = ObjFun;
results.Data = f;
results.IDX = IDX;
results.Dist = D;

end

function results = IFCM_(Data, param)

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting

f            = Data;
iter         = 0;
max_iter     = 500;
fm           = param.mFuzzy;
epsilon      = 10^(-6);
numSample    = size(f, 2);
numCluster   = param.kClust;

fv           = param.fv;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clustering

rng(param.Ran);


U = ones(numCluster, numSample) ./ numCluster;
counts = zeros(numCluster);


%% Repeat FCM until convergence or max iterations
while iter < max_iter
    iter = iter + 1;

    % Calculate the distance between fv with fi PDFs
    for j = 1:numSample
        for i = 1:numCluster
            % D(i, j) = Integration(param.h, abs(fv(:, i) - f(:, j)), 1) + 10^(-10); % L1
            % D(i, j) = 1 - Integration(param.h, min(fv(:, i), f(:, j)), 1) + 10^(-10);
            D(i,j) = Integration(param.h, (sqrt(fv(:,i)) - sqrt(f(:,j))).^2, 1) + 1e-10;
            % D(i, j) = Integration(param.h, fv(:,i) .* log(fv(:,i) ./ f(:,j)), 1) + 10^(-10);
            % D(i, j) = (Integration(param.h, abs(fv(:, i) - f(:, j)),1) + max(abs(fv(:, i) - f(:, j)))) / 2 + 10^(-10);
        end
    end
    
    % fci = sum(U,2)/numSample;

    [~,nj] = max(U);

    for i = 1:numCluster
        counts(i) = sum(nj == i);
    end
    Sj = counts ./ numSample;
    % fci = Sj;
    fci = (1-Sj) / (1-min(Sj));
    
    for j = 1:numSample
        for i = 1:numCluster
            denom = 0;
            for s = 1:numCluster
                denom = denom + ( (D(i,j)/fci(i)) / (D(s,j)/fci(s)) )^(1/(fm-1));
            end
            Unew(i,j) = 1 / denom;
        end
    end


    % Calculate the cluster centers
    num = (Unew.^fm) * sqrt(f)';     % (c x d)
    den = sum(Unew.^fm, 2);          % (c x 1)
    fvnew = (num ./ den).^2;         % (c x d)
    fvnew = fvnew';                  % đưa về (d x c) như ban đầu

    % ObjFun = sum(sum((Unew) .* D ./ fci));    
    % fprintf('Iteration count = %d, obj. ifcm = %f\n', iter, ObjFun);

    % Check for convergence
    if norm(fv - fvnew, 1) < epsilon
        break;
    end

    fv = fvnew;
    U = Unew;
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
results.omega = fci;
end

function results = PCM_(Data, param, varargin)



%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = Data;
iter = 0;
max_iter = 200;
fm = 2;
epsilon = 10^-6;
numSample = size(f, 2);
numCluster = param.kClust;
alpha = .1;

K = 1;
abnormal = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clustering PCM


%% Initialize the partition matrix with FCM (U, fv, num_cluster)
fv = param.fv;
while iter < max_iter
    iter = iter + 1;

    % Calculate the distance between fv with fi PDFs
    for j = 1:numSample
        for i = 1:numCluster
            D(i, j) = Integration(param.h, abs(fv(:, i) - f(:, j)), 1) + 10^(-10); % L1
        end
    end

    % Update partition matrix
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
    % Check for convergence
    if norm(fv - fvnew, 1) < epsilon
        break;
    end
    fv = fvnew;


end
iter = 0;

% Estimate eta by FCM results
for i = 1:numCluster
    eta(i) = K * sum((Unew(i,:).^fm) .* D(i,:)) / sum(Unew(i,:).^fm);
end

%% Repeat PCM until true condition nor max_ter
while iter < max_iter
    iter = iter + 1;

    % Calculate the distance between fv with fi PDFs
    for j = 1:numSample
        for i = 1:numCluster
            D(i, j) = Integration(param.h, abs(fv(:, i) - f(:, j)), 1) + 10^(-10); % L1
        end
    end


    % Update partition matrix
    for j = 1:numSample
        m = 0;
        for k = 1:numCluster
            if D(k, j) == 0
                m = m + 1;
            end
        end
        if m == 0
            Upcm = 1./(1 + (D./eta').^(1/(fm-1)));
        else
            for l = 1:numCluster
                if D(l, j) == 0
                    Upcm(l, j) = 1 / m;
                else
                    Upcm(l, j) = 0;
                end
            end
        end
    end

    % Calculate ObfFun by Krishnapuram 1993
    ObjFun = sum(sum(Upcm.^fm .* D)) + sum(eta).*sum((1 - Upcm).^fm, 'all');

    % Update the representation PDF fv
    fv = (f * (Upcm.^fm)') ./ sum(Upcm.^fm, 2)';


    Cond = norm(Upcm - Unew, 1);
    % fprintf('Iteration count = %d, obj. pcm = %f\n', iter, ObjFun);

    if Cond < epsilon
        break
    end
    Unew = Upcm;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Results
[~, IDX] = max(Upcm);
for i = 1:numSample
    if all(Upcm(:, i) < alpha) == 1
        IDX(i) = 0;
        abnormal = [abnormal i];
    end
end

results.member = Upcm;
results.Centre = fv;
results.iter = iter;
results.ObjFun = ObjFun;
results.Data = f;
results.IDX = IDX;
results.Dist = D;


end

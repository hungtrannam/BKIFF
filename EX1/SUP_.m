function results = SUP_(Data, param)


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting
% rng(4);
f            = Data;
epsilon      = 10^(-6);
iter         = 0;
numSample    = size(f, 2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clustering


% Calculate the distance between fv with fi PDFs
for j = 1:numSample
    for i = 1:numSample
        D(i, j) = Integration(param.h, abs(f(:, i) - f(:, j)), 1) + 10^(-10); % L1
        % D(i, j) = 1 - (Integration(param.h, sqrt(f(:,i) .* f(:,j)), 1)) + 10^(-10);
    end
end
% D = D.^2;
    
Dist = [];
for i = 1 : numSample-1
    for j = i+1 : numSample
        Dist = [Dist; D(i, j)];
    end
end
mu = sum(Dist) / nchoosek(numSample, 2);  % mean pairwise distance
sigma = sqrt(sum((Dist-mu).^2) / nchoosek(numSample, 2));
lambda = sigma;

alp = ones(numSample,numSample);
alpnew = alp;



v = f;


while true

    % Cập nhật các giá trị trong fnew
    for i = 1:numSample
        tu = 0;
        mau = 0;
        for j = 1:numSample
            if D(i, j) > mu * alp(i, j)
                U = 0;
            else
                U = exp(-D(i,j)/(lambda));
            end
            alpnew(i, j) = alp(i, j) / (1 + alp(i, j) * U);
            tu = tu + f(:,j) * U;
            mau = mau + U;
        end
        v(:,i) = tu / mau;
    end

    if norm(v - f,1) < epsilon
        break;
    end

    alp = alpnew;
    f = v;
    for j = 1:numSample
        for i = 1:numSample
            D(i, j) = Integration(param.h, abs(f(:, i) - f(:, j)), 1) + 10^(-10); % L1
        end
    end
    % D = D.^2;

    iter = iter + 1;
end

% Làm tròn kết quả fnew
res = roundn(v',-6);
fv = unique(res,'rows');
IDX = zeros(size(res,1),1);
for i = 1:size(IDX,1)
    for j = 1:size(fv,1)
        if res(i,:) == fv(j,:)
            IDX(i) = j;
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Results

results.Centre = fv;
results.iter = iter;
results.Data = f;
results.IDX = IDX;
results.Dist = D;

end

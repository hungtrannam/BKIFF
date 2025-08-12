function [Sil, Dunn] = internal(labels2, fv, h)
        % --- ma trận khoảng cách ---
        distM = computeDistanceMatrix(fv, h);
    
        % --- chuẩn hoá nhãn về 1..K, K là số cụm thực tế ---
        [~, ~, ind] = unique(labels2(:));   % ind ∈ {1..K}
        K = numel(unique(ind));
    
        % --- nếu chỉ có 1 cụm: Silhouette=0, Dunn=NaN để tránh lỗi ---
        if K < 2
            Sil  = 0;
            Dunn = NaN;
            return;
        end
    
        % --- Silhouette (không tự-khoảng cách) ---
        Sil = silhouette_fromD(distM, ind, K);
    
        % --- Dunn: gọi đúng chữ ký, GIỮ NGUYÊN HÀM dunnIndex ---
        Dunn = dunnIndex(K, distM, ind);
        if isempty(Dunn), Dunn = NaN; end   % phòng hờ
    
    function D_matrix = computeDistanceMatrix(fv, h)
        n = size(fv, 2);
        D_matrix = zeros(n);
        for i = 1:n
            for j = i+1:n
                D_matrix(i,j) = 2*(1 - Integration(h, sqrt(fv(:,i).*fv(:,j)), 1)) + 1e-10;
                D_matrix(j,i) = D_matrix(i,j);
            end
        end
    end
    
    function SilhouetteScore = silhouette_fromD(D, ind, K)
        n = numel(ind);
        s = zeros(n,1);
        for i = 1:n
            Ci = (ind == ind(i));
            Ci(i) = false;                         % bỏ chính nó
            if any(Ci), a = mean(D(i, Ci)); else, a = 0; end
    
            b = inf;
            for k = 1:K
                if k == ind(i), continue; end
                Ck = (ind == k);
                if any(Ck), b = min(b, mean(D(i, Ck))); end
            end
            s(i) = (b - a) / max(a, b);
        end
        SilhouetteScore = mean(s);
    end


    % ====== GIỮ NGUYÊN THÂN HÀM DƯỚI (không sửa nội dung) ======
    function DI=dunnIndex(clusters_number,D_matrix,ind)   
    %%%Dunn's index for clustering compactness and separation measurement
    % dunns(clusters_number,distM,ind)
    % clusters_number = Number of clusters 
    % distM = Dissimilarity matrix
    % ind   = Indexes for each data point aka cluster to which each data point
    % belongs
    i=clusters_number;
    denominator=[];
    for i2=1:i
        indi=find(ind==i2);
        indj=find(ind~=i2);
        x=indi;
        y=indj;
        temp=D_matrix(x,y);
        denominator=[denominator;temp(:)];
    end
    num=min(min(denominator)); 
    neg_obs=zeros(size(distM,1),size(distM,2));
    for ix=1:i
        indxs=find(ind==ix);
        neg_obs(indxs,indxs)=1;
    end
    dem=neg_obs.*distM;
    dem=max(max(dem));
    DI=num/dem;
    end
end

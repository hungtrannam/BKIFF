function [Sil, Dunn] = internal(labels2, fv, h)
    % The function calculates the Silhouette Index (Sil) and Dunn Index (Dunn)
    % for multi-class clustering using L1 distance and manual computation.

    % Silhouette Index
    Sil = silhouetteIndex(fv, labels2, h);

    % Dunn Index
    Dunn = dunnIndex(fv, labels2, h);
end


function D_matrix = computeDistanceMatrix(fv, h)
    % Tính toán ma trận khoảng cách giữa các vector trong fv
    numVectors = size(fv, 2);
    D_matrix = zeros(numVectors);

    for i = 1:numVectors
        for j = i+1:numVectors
            D_matrix(i, j) = Integration(h, abs(fv(:, i) - fv(:, j)).^2, 1) + 10^(-10); % L1
            D_matrix(j, i) = D_matrix(i, j); % Ma trận đối xứng
        end
    end
end

function SilhouetteScore = silhouetteIndex(fv, labels, h)
    % Tính toán Silhouette Index cho các vector fv và nhãn labels
    numVectors = size(fv, 2);
    D_matrix = computeDistanceMatrix(fv, h);
    uniqueLabels = unique(labels);
    numClusters = length(uniqueLabels);

    Sil = zeros(numVectors, 1);

    for i = 1:numVectors
        cluster_i = labels(i);
        indices_same_cluster = find(labels == cluster_i);
        indices_other_clusters = find(labels ~= cluster_i);

        if length(indices_same_cluster) > 1
            a_i = mean(D_matrix(i, indices_same_cluster));
        else
            a_i = 0; % Nếu chỉ có một điểm trong cụm
        end

        min_b_i = inf;
        for j = 1:numClusters
            if j ~= cluster_i
                indices_cluster_j = labels == j;
                b_i_j = mean(D_matrix(i, indices_cluster_j));
                if b_i_j < min_b_i
                    min_b_i = b_i_j;
                end
            end
        end

        Sil(i) = (min_b_i - a_i) / max(a_i, min_b_i);
    end

    SilhouetteScore = mean(Sil);
end


function Dunn = dunnIndex(fv, labels,h)
    % Tính toán Dunn Index cho các vector fv và nhãn labels
    D_matrix = computeDistanceMatrix(fv, h);
    uniqueLabels = unique(labels);
    numClusters = length(uniqueLabels);

    min_inter_cluster_dist = inf;
    max_intra_cluster_dist = 0;

    for i = 1:numClusters
        cluster_i_indices = find(labels == uniqueLabels(i));
        intra_cluster_dists = D_matrix(cluster_i_indices, cluster_i_indices);
        intra_cluster_dists(intra_cluster_dists == 0) = inf; % Loại bỏ các giá trị 0
        max_intra_cluster_dist = max(max_intra_cluster_dist, min(intra_cluster_dists(:)));

        for j = i+1:numClusters
            cluster_j_indices = labels == uniqueLabels(j);
            inter_cluster_dists = D_matrix(cluster_i_indices, cluster_j_indices);
            min_inter_cluster_dist = min(min_inter_cluster_dist, min(inter_cluster_dists(:)));
        end
    end

    Dunn = min_inter_cluster_dist / max_intra_cluster_dist;
end
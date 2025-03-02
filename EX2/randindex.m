function [RI, ARI, NMI] = randindex(labels1, labels2)
    % The function calculates the Rand Index (RI), Adjusted Rand Index (ARI),
    % Normalized Mutual Information (NMI), Balanced Accuracy (BA),
    % Sensitivity (Sens), and Specificity (Spec) for multi-class clustering.

    N = numel(labels1);  % Get the number of elements in the label vector

    % Initialize the four quantities: TP (True Positive), FN (False Negative),
    % FP (False Positive), TN (True Negative)
    TP = 0; FN = 0; FP = 0; TN = 0;

    % Calculate TP, FN, FP, and TN
    for i = 1:N-1
        for j = i+1:N
            if (labels1(i) == labels1(j)) && (labels2(i) == labels2(j))  % TP
                TP = TP + 1;
            elseif (labels1(i) == labels1(j)) && (labels2(i) ~= labels2(j))  % FN
                FN = FN + 1;
            elseif (labels1(i) ~= labels1(j)) && (labels2(i) == labels2(j))  % FP
                FP = FP + 1;
            else  % TN
                TN = TN + 1;
            end
        end
    end

    % Calculate Rand Index (RI)
    RI = (TP + TN) / (TP + FP + FN + TN);






    % Calculate Adjusted Rand Index (ARI)
    try
        C = confusionmat(labels1, labels2);  
    catch
        C = myConfusionMat(labels1, labels2); 
    end

    % Compute necessary quantities for ARI calculation
    sum_C = sum(C(:));
    sum_C2 = sum_C * (sum_C - 1);
    sum_rows = sum(C, 2);
    sum_rows2 = sum(sum_rows .* (sum_rows - 1));
    sum_cols = sum(C, 1);
    sum_cols2 = sum(sum_cols .* (sum_cols - 1));
    sum_Cij2 = sum(sum(C .* (C - 1)));

    % Compute ARI
    ARI = 2 * (sum_Cij2 - sum_rows2 * sum_cols2 / sum_C2) / ...
        ((sum_rows2 + sum_cols2) - 2 * sum_rows2 * sum_cols2 / sum_C2);

    % Calculate Normalized Mutual Information (NMI)
    NMI = normalized_mutual_information(labels1, labels2);



end



function C = myConfusionMat(g1, g2)
    % This function generates a confusion matrix if the built-in function confusionmat is not available.
    % It takes two input vectors, g1 and g2, which represent two different label assignments.

    groups = unique([g1; g2]);  % Get the unique groups in g1 and g2

    C = zeros(length(groups));  % Initialize the confusion matrix with zeros

    % Calculate the confusion matrix
    for i = 1:length(groups)
        for j = 1:length(groups)
            C(i, j) = sum(g1 == groups(i) & g2 == groups(j));  % Count the number of samples in group i (g1) and group j (g2)
        end
    end
end

function nmi = normalized_mutual_information(labels1, labels2)
    nmi = 0;
    % This function calculates the Normalized Mutual Information (NMI)
    % between two label assignments: labels1 and labels2.

    C = confusionmat(labels1, labels2);  % Generate confusion matrix
    N = sum(C(:));  % Total number of elements

    pi = sum(C, 2) / N;  % Row-wise probabilities
    uj = sum(C, 1) / N;  % Column-wise probabilities

    piuj = C / N;  % Joint probability distribution
    piuj = piuj + 1e-10;  % Add a small constant to avoid log2(0)

    % Calculate Mutual Information (I)
    I = sum(sum(piuj .* log2(piuj ./ (pi * uj))));

    % Calculate Entropies H(pi) and H(uj)
    Hpi = -sum(pi .* log2(pi + 1e-10));
    Huj = -sum(uj .* log2(uj + 1e-10));

    
    % Compute NMI
    nmi = 2 * I / (Hpi + Huj);
    if nmi == Inf
        nmi = 0;
    end
end

clear;
clc;
close all;

logFile = fopen('EVA/YESNO.txt', 'w');


addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/WOA'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/GSO'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/STOA'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/SBOA'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/Black-winged Kite Algorithm (BKA)'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/MVO'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/ALO'

% Khởi tạo cấu trúc để lưu trữ các chỉ số trung bình
averageMetrics = struct();

for IR = 1:100
    filename = sprintf('Data/IR_%d.mat', IR);
    logMessage(logFile, sprintf('Đang tải file: %s', filename));
    load(filename)
    

    param.h = h;
    param.mFuzzy = 2;
    param.kClust = 3;
    param.Init = 2;

    n = 30;
    for l = 1:n

        param.Ran = l;
        % param.Ran = 'shuffle';
        [max_distance, best_tt, curve] = Initializing(Data, param.kClust, 'BKA', param.h, '1D');
        best_tt = round(best_tt);
        param.fv = Data(:, best_tt);

        % methods = { ...       % DIS
        %     'IFCM_',          % Proposed
        %     'IFCM_L',
        %     'IFCM_CWD', 
        %     'IFCM_L2',
        %     };
         methods = { ...       % YESNO
            'IFCM_',          % Proposed
            'IFCM_NOBK'
            };

        for M = 1:length(methods) 
            method = methods{M};

            tic; 
            results = feval(method, Data, param);
            elapsed_time = toc;

            % Calculate Rand Index (RI), Adjusted Rand Index (ARI), and Normalized Mutual Information (NMI)
            [RI, ARI, NMI] = randindex(labels, results.IDX);

            % Calculate Silhouette Index (Sil) and Dunn Index (Dunn)
            [Sil, Dunn] = internal(results.IDX, results.Data, param.h);

            % Store the metrics
            metrics.(method).RI(l) = RI;
            metrics.(method).ARI(l) = ARI;
            metrics.(method).NMI(l) = NMI;
            metrics.(method).Sil(l) = Sil;
            metrics.(method).Dunn(l) = Dunn;
            metrics.(method).iter(l) = results.iter;
            metrics.(method).Time(l) = elapsed_time;

            % Log the metrics for each method
            logMessage(logFile, sprintf('METHODS: %s, Lần lặp: %d, RI: %.4f, ARI: %.4f, NMI: %.4f, Sil: %.4f, Dunn: %.4f, TIME: %.4f giây', ...
                method, l, RI, ARI, NMI, Sil, Dunn, elapsed_time));
        end % end for M
    end % end for l

    % Calculate average metrics for this IR
    for M = 1:length(methods)
        method = methods{M};
        averageMetrics.(method).RI(IR) = mean(metrics.(method).RI);
        averageMetrics.(method).ARI(IR) = mean(metrics.(method).ARI);
        averageMetrics.(method).NMI(IR) = mean(metrics.(method).NMI);
        averageMetrics.(method).Sil(IR) = mean(metrics.(method).Sil);
        averageMetrics.(method).Dunn(IR) = mean(metrics.(method).Dunn);
        averageMetrics.(method).iter(IR) = mean(metrics.(method).iter);
        averageMetrics.(method).Time(IR) = mean(metrics.(method).Time);
    end

    save(sprintf('EVA/YESNO_%d.mat', IR), 'metrics', 'IR');
end % end for IR

% Calculate overall average metrics across all IRs
overallAverageMetrics = struct();
for M = 1:length(methods)
    method = methods{M};
    overallAverageMetrics.(method).RI = mean([averageMetrics.(method).RI]);
    overallAverageMetrics.(method).ARI = mean([averageMetrics.(method).ARI]);
    overallAverageMetrics.(method).NMI = mean([averageMetrics.(method).NMI]);
    overallAverageMetrics.(method).Sil = mean([averageMetrics.(method).Sil]);
    overallAverageMetrics.(method).Dunn = mean([averageMetrics.(method).Dunn]);
    overallAverageMetrics.(method).iter = mean([averageMetrics.(method).iter]);
    overallAverageMetrics.(method).Time = mean([averageMetrics.(method).Time]);
end

% Log overall average metrics
for M = 1:length(methods)
    method = methods{M};
    logMessage(logFile, sprintf('METHODS: %s, RI: %.4f, ARI: %.4f, NMI: %.4f, Sil: %.4f, Dunn : %.4f, REPEATED: %.4f, COMP.TIME: %.4f S', ...
        method, overallAverageMetrics.(method).RI, overallAverageMetrics.(method).ARI, overallAverageMetrics.(method).NMI, ...
        overallAverageMetrics.(method).Sil, overallAverageMetrics.(method).Dunn, overallAverageMetrics.(method).iter, overallAverageMetrics.(method).Time));
end


% Đóng file log
fclose(logFile);
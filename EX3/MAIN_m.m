%% ================== YES/NO Eval với IR cố định & quét mFuzzy ==================
clear; clc; close all;

if ~exist('EVA','dir'), mkdir('EVA'); end
logFile = fopen('EVA/M1.txt', 'w');

% === Add path metaheuristics (nếu cần cho Initializing) ===
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/WOA'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/GSO'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/STOA'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/SBOA'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/Black-winged Kite Algorithm (BKA)'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/MVO'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/ALO'

% === Chỉ chạy 4 IR này ===
IR_list = [20, 50, 80, 100];

% === Quét mFuzzy ===
m_list = [1.1, 1.5, 2, 2.5, 3, 5, 10];

% === 2 phương pháp: IFF (IFCM_) và BKIFF (IFCM_NOBK) ===
methods = {'IFCM_',};
method_alias = struct('IFCM_','BKIFF');

% Để tính overall trung bình sau cùng (trên các IR đã chọn)
overallAverageMetrics = struct();
for M = 1:numel(methods)
    method = methods{M};
    for mi = 1:numel(m_list)
        mval = m_list(mi);
        overallAverageMetrics.(method)(mi).m = mval;
        overallAverageMetrics.(method)(mi).RI   = [];
        overallAverageMetrics.(method)(mi).ARI  = [];
        overallAverageMetrics.(method)(mi).NMI  = [];
        overallAverageMetrics.(method)(mi).Sil  = [];
        overallAverageMetrics.(method)(mi).Dunn = [];
        overallAverageMetrics.(method)(mi).iter = [];
        overallAverageMetrics.(method)(mi).Time = [];
    end
end

% ======================= Vòng lặp qua IR =======================
for IR = IR_list
    filename = sprintf('Data/Data/IR_%d.mat', IR);
    logMessage(logFile, sprintf('Đang tải file: %s', filename));
    S = load(filename);

    Data   = S.Data;
    labels = S.labels;
    h      = S.h;

    % --- tham số cố định ---
    param.h      = h;
    param.kClust = 2;
    param.Init   = 2;

    nRepeat = 30;  % số lần lặp mỗi m

    % === metrics theo từng m ===
    metrics = struct();

    for mi = 1:numel(m_list)
        mval = m_list(mi);
        param.mFuzzy = mval;

        % reset container theo m
        for M = 1:numel(methods)
            method = methods{M};
            metrics.(method)(mi).m   = mval;
            metrics.(method)(mi).RI   = zeros(nRepeat,1);
            metrics.(method)(mi).ARI  = zeros(nRepeat,1);
            metrics.(method)(mi).NMI  = zeros(nRepeat,1);
            metrics.(method)(mi).Sil  = zeros(nRepeat,1);
            metrics.(method)(mi).Dunn = zeros(nRepeat,1);
            metrics.(method)(mi).iter = zeros(nRepeat,1);
            metrics.(method)(mi).Time = zeros(nRepeat,1);
        end

        for l = 1:nRepeat
            param.Ran = l;
            % Khởi tạo bằng BKA để công bằng cho cả 2 phương pháp
            [~, best_tt, ~] = Initializing(Data, param.kClust, 'BKA', param.h, '1D');
            best_tt = round(best_tt);
            param.fv = Data(:, best_tt);

            for M = 1:numel(methods)
                method = methods{M};

                tic;
                results = feval(method, Data, param);
                elapsed_time = toc;

                % ngoại lệ: nếu hàm trả về ít trường
                if ~isfield(results,'IDX'), error('%s không trả về IDX', method); end
                if ~isfield(results,'Data'), results.Data = Data; end
                if ~isfield(results,'iter'), results.iter = NaN; end

                [RI, ARI, NMI] = randindex(labels, results.IDX);
                [Sil, Dunn]     = internal(results.IDX, results.Data, param.h);

                metrics.(method)(mi).RI(l)   = RI;
                metrics.(method)(mi).ARI(l)  = ARI;
                metrics.(method)(mi).NMI(l)  = NMI;
                metrics.(method)(mi).Sil(l)  = Sil;
                metrics.(method)(mi).Dunn(l) = Dunn;
                metrics.(method)(mi).iter(l) = results.iter;
                metrics.(method)(mi).Time(l) = elapsed_time;

                logMessage(logFile, sprintf( ...
                    'IR=%d | m=%.3f | %s | rep=%d | RI=%.4f ARI=%.4f NMI=%.4f Sil=%.4f Dunn=%.4f Time=%.4fs', ...
                    IR, mval, method_alias.(method), l, RI, ARI, NMI, Sil, Dunn, elapsed_time));
            end % method loop
        end % repeat loop
    end % m loop

    % ---- Tính trung bình theo m cho IR này ----
    averageMetrics = struct();
    for M = 1:numel(methods)
        method = methods{M};
        for mi = 1:numel(m_list)
            avg.RI   = mean(metrics.(method)(mi).RI);
            avg.ARI  = mean(metrics.(method)(mi).ARI);
            avg.NMI  = mean(metrics.(method)(mi).NMI);
            avg.Sil  = mean(metrics.(method)(mi).Sil);
            avg.Dunn = mean(metrics.(method)(mi).Dunn);
            avg.iter = mean(metrics.(method)(mi).iter);
            avg.Time = mean(metrics.(method)(mi).Time);
            avg.m    = metrics.(method)(mi).m;

            averageMetrics.(method)(mi) = avg;

            % Dồn vào overall để cuối cùng tính trung bình trên các IR đã chọn
            overallAverageMetrics.(method)(mi).RI   = [overallAverageMetrics.(method)(mi).RI,   avg.RI];
            overallAverageMetrics.(method)(mi).ARI  = [overallAverageMetrics.(method)(mi).ARI,  avg.ARI];
            overallAverageMetrics.(method)(mi).NMI  = [overallAverageMetrics.(method)(mi).NMI,  avg.NMI];
            overallAverageMetrics.(method)(mi).Sil  = [overallAverageMetrics.(method)(mi).Sil,  avg.Sil];
            overallAverageMetrics.(method)(mi).Dunn = [overallAverageMetrics.(method)(mi).Dunn, avg.Dunn];
            overallAverageMetrics.(method)(mi).iter = [overallAverageMetrics.(method)(mi).iter, avg.iter];
            overallAverageMetrics.(method)(mi).Time = [overallAverageMetrics.(method)(mi).Time, avg.Time];
        end
    end

    % ---- Lưu theo IR & m ----
    save(sprintf('EVA/M1_IR%d_all_m.mat', IR), 'metrics', 'averageMetrics', 'IR', 'm_list', 'methods');
    % Lưu từng m riêng (tuỳ chọn)
    for mi = 1:numel(m_list)
        smetrics = struct();
        for M = 1:numel(methods)
            method = methods{M};
            smetrics.(method) = metrics.(method)(mi);
        end
        save(sprintf('EVA/M1_IR%d_m%.3f.mat', IR, m_list(mi)), 'smetrics', 'IR', 'methods');
    end
end % IR loop

% =================== Overall trung bình trên các IR đã chọn ===================
for M = 1:numel(methods)
    method = methods{M};
    logMessage(logFile, sprintf('==== OVERALL (method=%s) trên IR=[%s] ====', ...
        method_alias.(method), num2str(IR_list)));

    for mi = 1:numel(m_list)
        mval = m_list(mi);
        ov.RI   = mean(overallAverageMetrics.(method)(mi).RI);
        ov.ARI  = mean(overallAverageMetrics.(method)(mi).ARI);
        ov.NMI  = mean(overallAverageMetrics.(method)(mi).NMI);
        ov.Sil  = mean(overallAverageMetrics.(method)(mi).Sil);
        ov.Dunn = mean(overallAverageMetrics.(method)(mi).Dunn);
        ov.iter = mean(overallAverageMetrics.(method)(mi).iter);
        ov.Time = mean(overallAverageMetrics.(method)(mi).Time);

        overallAverageMetrics.(method)(mi).overall = ov;

        logMessage(logFile, sprintf( ...
            'm=%.3f | RI=%.4f ARI=%.4f NMI=%.4f Sil=%.4f Dunn=%.4f Repeated=%.3f Time=%.4fs', ...
            mval, ov.RI, ov.ARI, ov.NMI, ov.Sil, ov.Dunn, ov.iter, ov.Time));
    end
end

% Lưu overall
save('EVA/YESNO_overall_m.mat', 'overallAverageMetrics', 'IR_list', 'm_list', 'methods');

% Đóng file log
fclose(logFile);

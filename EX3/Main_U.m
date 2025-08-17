%% ----------  Re-write script to save membership matrices  ----------
clear; clc; close all;

EFF = 'EVA';
logFile = fopen(sprintf('EVA/%s.txt', EFF), 'w');

addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/WOA'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/GSO'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/STOA'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/SBOA'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/Black-winged Kite Algorithm (BKA)'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/MVO'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/ALO'

% --- create output folder for membership matrices ---
mkdir('EVA/member');

switch EFF
    case 'EVA'
        methods = {'IFCM_'};
        % methods = {'FCM_CWD_', 'FCM_', 'KMEAN_', 'SUP_'};
    otherwise
        error('EFF không hợp lệ: %s', EFF);
end

param.mFuzzy = 2;
param.kClust = 2;
param.Init   = 2;

nRun = 1;

for IR = 80
    % ---- create IR sub-folder ----
    mkdir(sprintf('EVA/member/', IR));

    filename = sprintf('Data/Data/IR_%d.mat', IR);
    logMessage(logFile, sprintf('Loading: %s', filename));
    load(filename);          % variables: Data, labels, h
    param.h  = h;

    for r = 1:nRun
        param.Ran = r;

        % --- BKA-based initialization (unchanged) ---
        [~, best_tt, ~] = Initializing(Data, param.kClust, 'BKA', param.h, '1D');
        best_tt         = round(best_tt);
        param.fv        = Data(:, best_tt);

        for m = 1:length(methods)
            method = methods{m};

            tic;
            result = feval(method, Data, param);
            if isfield(result, 'member')
                member = result.member;           % fuzzy
            else
                % one-hot membership from hard labels
                nPoint = numel(result.IDX);
                member = full(sparse(1:nPoint, result.IDX, 1, nPoint, max(result.IDX)))';
            end
            % ---- save membership matrix ----
            save(sprintf('EVA/member/IR%d_%s.mat', IR, method), 'member');

        end
    end
end

fclose(logFile);


clear;
clc;
close all;

addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/WOA'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/GSO'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/STOA'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/SBOA'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/Black-winged Kite Algorithm (BKA)'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/MVO'
addpath '/home/hung-tran-nam/A_Clustering/OPTIMAL/ALO'

for IR =1:100
% for IR = 1:100
    filename = sprintf('Data/IR_%d.mat', IR);
    load(filename);


    param.h = h;
    param.mFuzzy = 2;
    param.kClust = 2;
    param.Init = 2;



    n = 30;
    for l = 1:n
        [max_distance, best_tt, curve] = Initializing(Data, param.kClust, 'BKA', param.h, '1D');
        best_tt = round(best_tt);
        param.fv = Data(:, best_tt);
        param.Ran = l;
        % param.Ran = 'shuffle';

        methods = { ...
            'FCM_CWD_',       % Tai Vo-Van (2019)
            'FCM_',           % Thao Nguyen-Trang (2017)
            'KMEAN_',         % Thao Nguyen-Trang (2024)
            'SUP_',           % Chen J-H, Hung W-L (2015)
            % 'PCM_'            % Hung Tran-Nam (2024)

            % 'IFCM_NOBK'
            'IFCM_',            % Proposed
            % 'IFCM_L',
            % 'IFCM_CWD', 
            % 'IFCM_L2',
            };


        for M = 1:length(methods) 
            method = methods{M};


            tic; 
            results = feval(method, Data, param);
            elapsed_time = toc;

            [RI, ARI, NMI] = randindex(labels, results.IDX);

            metrics.(method).RI(l) = RI;
            metrics.(method).ARI(l) = ARI;
            metrics.(method).NMI(l) = NMI;
            metrics.(method).iter(l) = results.iter;
            metrics.(method).Time(l) = elapsed_time;

        end % end for M
    end % end for l

    save(sprintf('EVA/EVA_%d.mat', IR), 'metrics', 'IR');
end % end for IR

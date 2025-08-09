clear; clc;

% --- Cấu hình ---
type = 'YESNO';                % ví dụ: 'YESNO', 'DIS', ...
IRs  = [20 50 80 100];         % các mức IR trong bảng
cols = {'IFF', 'BKIFF'}; % thứ tự cột trong bảng

metrics_list = {'ARI','NMI','Dunn','Silhouette','Time'};
metric_keys = { ...
    {'ari','ARI'}, ...
    {'nmi','NMI'}, ...
    {'dunn','Dunn','dunnIndex','DunnIndex'}, ...
    {'sil','silhouette','Silhouette'}, ...
    {'time','Time','cpu','runtime','elapsed'} ...
};

nM = numel(metrics_list);
nI = numel(IRs);
nC = numel(cols);

% Bảng kết quả dạng cell: (metric, IR, col)
tableCells = repmat({''}, nM, nI, nC);

% --- Vòng lặp qua từng IR ---
for ii = 1:nI
    ir = IRs(ii);
    file = sprintf('EVA/%s_%d.mat', type, ir);

    S = load(file);
    ms = S.metrics;

    meth_names = fieldnames(ms);
    for k = 1:numel(meth_names)
        mname = meth_names{k};
        sub = ms.(mname);

        
        % --- Xác định cột theo tên phương pháp ---
        switch upper(strtrim(mname))
            case 'IFCM_'
                col_name = 'BKIFF';
            case 'IFCM_NOBK'
                col_name = 'IFF';
            otherwise
                col_name = ''; % nếu không khớp thì bỏ qua
        end

        ci = find(strcmp(cols, col_name), 1);
        if isempty(ci), continue; end

        % --- Dò các field con, lấy median ± IQR ---
        sub_fns = fieldnames(sub);

        for mi = 1:nM
            keys = metric_keys{mi};

            % tìm field phù hợp theo từ khóa
            pick_idx = 0;
            for jj = 1:numel(keys)
                key_l = lower(keys{jj});
                for ff = 1:numel(sub_fns)
                    fn = sub_fns{ff};
                    if isnumeric(sub.(fn)) && ~isempty(sub.(fn)) && contains(lower(fn), key_l)
                        pick_idx = ff; break;
                    end
                end
                if pick_idx>0, break; end
            end

            % nếu chưa tìm thấy, lấy field numeric dài nhất (fallback)
            if pick_idx==0
                best_len = -inf; best_ff = 0;
                for ff = 1:numel(sub_fns)
                    fn = sub_fns{ff};
                    if isnumeric(sub.(fn))
                        L = numel(sub.(fn));
                        if L>best_len
                            best_len = L; best_ff = ff;
                        end
                    end
                end
                pick_idx = best_ff;
            end

            if pick_idx>0
                vals = sub.(sub_fns{pick_idx});
                if isnumeric(vals) && ~isempty(vals)
                    medv = median(vals(:));
                    iqrv = iqr(vals(:));
                    tableCells{mi, ii, ci} = sprintf('%.3f~(%.3f)', medv, iqrv);
                end
            end
        end
    end
end

for mi = 1:nM
    fprintf('%% --- %s ---\n', metrics_list{mi});
    fprintf('\\multirow{3}{*}{%s}\n', metrics_list{mi});
    for ii = 1:nI
        row = cell(1,nC);
        for ci = 1:nC
            v = tableCells{mi, ii, ci};
            if isempty(v), v = '--'; end
            row{ci} = v;
        end
        fprintf('& %4d & %s & %s\\\\\n', IRs(ii), row{1}, row{2});
    end
    fprintf('\\midrule\n');
end

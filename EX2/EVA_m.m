close all; clc; clear

%% ===== CẤU HÌNH =====
IR_list = [20 50 80 100];
method  = 'IFCM_';                 % chỉ 1 method
metrics = {'ARI', 'Sil'};           % 2 subplot
xscale_log = true;

% kiểu nét/marker phân biệt IR
ls_all = {'-','--','-.',':','-','--','-.'};
mk_all = {'o','s','^','d','>','<','p'};

%% ===== LẤY m_list =====
m_list = [];
for IR = IR_list
    f = sprintf('EVA/M2_IR%d_all_m.mat', IR);
    if exist(f,'file')
        S = load(f,'m_list'); 
        if isfield(S,'m_list'), m_list = S.m_list; break; end
    end
end
Mnum = numel(m_list);
colsIR = abyss(numel(IR_list));              % màu khác nhau cho từng IR

%% ===== FIGURE =====
t = tiledlayout(1, numel(metrics), 'Padding', 'compact', 'TileSpacing', 'compact');
set(gcf, 'Color', 'w'); % nền trắng

for r = 1:numel(metrics)
    met = metrics{r};
    ax = nexttile; hold(ax,'on'); box(ax,'on');

    for ii = 1:numel(IR_list)
        IR = IR_list(ii);
        ls = ls_all{ii}; mk = mk_all{ii};
        col= colsIR(ii,:);

        med = nan(1,Mnum);

        % đọc từng m để lấy median
        for mi = 1:Mnum
            mval = m_list(mi);
            f_one = sprintf('EVA/M2_IR%d_m%.3f.mat', IR, mval);
            if exist(f_one,'file')~=2, continue; end
            T = load(f_one);  

            v = T.smetrics.(method).(met);
            v = v(:); v = v(~isnan(v));
            if isempty(v), continue; end
            med(mi) = median(v);
        end

        ok = ~isnan(med);
        
        temp(25,35,15);
        plot(ax, m_list(ok), med(ok), ...
            'LineStyle', ls, 'Color', col, ...
            'Marker', mk, 'MarkerSize', 10, ...
            'MarkerFaceColor', col, ...
            'LineWidth', 2.8, ...
            'DisplayName', sprintf('IR=%d',IR));
    end

    xlabel(ax,'$m$ (fuzziness)','Interpreter','latex');
    ylabel(ax, met,'Interpreter','latex');
    xlim(ax, [min(m_list)*0.95, max(m_list)*1.05]);
    if any(strcmpi(met,{'Sil','ARI'})), ylim(ax,[-0.05 1.05]); end
    legend(ax, 'Location','northoutside','Orientation','horizontal','Interpreter' , 'latex');
end

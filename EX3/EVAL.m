close all; clc; clear

% ===== chọn metric một chỗ để đổi =====
metric   = 'iter';          % 'NMI' | 'ARI' | 'iter' | 'Time' | 'NMI' | 'Sil' | 'Dunn'
agg_fun  = @median;        % @median | @mean
spread_f = @iqr;           % @iqr | @std

methods = { ...
    'IFCM_L', ...
    'IFCM_CWD', ...
    'IFCM_L2', ...
    'IFCM_', ...
};

% màu
if exist('abyss','file')
    colors = abyss(length(methods)-1);
else
    colors = lines(length(methods)-1);
end

IRMAX = 100;
Mean_ = nan(IRMAX, numel(methods));
Std_  = nan(IRMAX, numel(methods));

for IR = 1:IRMAX
    filename = sprintf('EVA/DIS_%d.mat', IR);
    if exist(filename, 'file')
        load(filename); % cần biến metrics trong file

        for M = 1:numel(methods)
            method = methods{M};
            if isfield(metrics, method) && isfield(metrics.(method), metric)
                v = metrics.(method).(metric);
                v = v(:); v = v(~isnan(v));
                if ~isempty(v)
                    Mean_(IR, M) = agg_fun(v);
                    Std_(IR, M)  = spread_f(v);
                end
            end
        end
    end
end

% IR hợp lệ (có dữ liệu)
validIR = find(any(~isnan(Mean_),2))';
if isempty(validIR), error('Không có dữ liệu metric: %s', metric); end
x = validIR;

figure; hold on;
% Giữ nguyên hàm temp bạn đang dùng
temp(25,20,15);
for M = 1:numel(methods)
    mean_values = Mean_(x, M)';
    std_values  = Std_(x, M)';
    if all(isnan(mean_values)), continue; end

    if M < numel(methods)
        col = colors(min(M,size(colors,1)),:);
        plot(x, mean_values, 'LineWidth', 3, 'Color', col, 'DisplayName', methods{M});
        [yl,yu] = suggest_ylim(metric, mean_values, std_values);
        y_lower = max(mean_values - std_values, yl);
        y_upper = min(mean_values + std_values, yu);
        h_fill = fill([x, fliplr(x)], [y_lower, fliplr(y_upper)], col, ...
            'FaceAlpha', 0.35, 'EdgeColor','none');
        h_fill.Annotation.LegendInformation.IconDisplayStyle = 'off';
    else
        plot(x, mean_values, 'LineWidth', 6, 'Color','r', 'LineStyle',':', 'DisplayName', methods{M});
        [yl,yu] = suggest_ylim(metric, mean_values, std_values);
        y_lower = max(mean_values - std_values, yl);
        y_upper = min(mean_values + std_values, yu);
        h_fill = fill([x, fliplr(x)], [y_lower, fliplr(y_upper)], 'r', ...
            'FaceAlpha', 0.2, 'EdgeColor','none');
        h_fill.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
end
hold off; grid on; legend('Location','northwest');

xlabel('Imbalanced Ratio');
ylabel(metric);
ylim(final_ylim(metric, Mean_(x,:), Std_(x,:)));


% ===== helpers =====
function [yl,yu] = suggest_ylim(metric, mu, sp)
m = lower(metric);
if any(strcmp(m, {'nmi','ari'}))
    yl = 0; yu = 1;
elseif contains(m,'iter')
    top = max(mu+sp); yl = 0; yu = max(10, top*1.1);
elseif contains(m,'time') || contains(m,'sec') || contains(m,'ms')
    top = max(mu+sp); yl = 0; yu = max(0.1, top*1.15);
else
    lo = min(mu-sp); hi = max(mu+sp);
    if ~isfinite(lo), lo=0; end; if ~isfinite(hi), hi=1; end
    pad = 0.05*(hi-lo+eps); yl = lo-pad; yu = hi+pad;
end
end

function yl = final_ylim(metric, MU, SP)
m = lower(metric);
mu = MU(:); sp = SP(:);
mu = mu(~isnan(mu)); sp = sp(~isnan(sp));
if isempty(mu), yl = [0 1]; return; end
if any(strcmp(m, {'nmi','ari'}))
    yl = [0 1];
elseif contains(m,'iter')
    top = max(mu+sp); yl = [0, max(10, top*1.1)];
elseif contains(m,'time') || contains(m,'sec') || contains(m,'ms')
    top = max(mu+sp); yl = [0, max(0.1, top*1.15)];
else
    lo = min(mu-sp); hi = max(mu+sp);
    if ~isfinite(lo), lo=0; end; if ~isfinite(hi), hi=1; end
    pad = 0.05*(hi-lo+eps); yl = [lo-pad, hi+pad];
end
end

clear; close all;

%% ----------  Load & plot membership for ALL methods at IR = 80 ----------
IR       = 80;
runIndex = 1;

% Danh sách các method cần vẽ (giữ nguyên thứ tự với file lưu)
methods  = {'IFCM_', 'SUP_', 'FCM_CWD_', 'KMEAN_', };

% Tính số frame (method)
nMethod  = numel(methods);

% Tạo figure
figure('Units','normalized');


for m = 1:nMethod
    nameMed = {'(a) BKIFF', '(b) Self-Updating', '(c) FCM CWD', '(d) $K$MEAN'};
    meth   = methods{m};
    fname  = sprintf('EVA/member/IR%d_%s.mat', IR, meth);

    if exist(fname,'file') ~= 2
        warning('Không tìm thấy %s – bỏ qua', fname);
        continue
    end

    load(fname, 'member');   % member: N × k
    
    ax = subplot(ceil(nMethod),1,m);
    temp(20,20,20);
    imagesc(member);                    % vẽ heat-map
    colormap sky
    axis tight                          % bỏ padding
    title(nameMed{m}, 'Interpreter','latex', 'FontSize',16);
    yticks(1:size(member, 2));      % 1,2,3,...
    yticklabels(string(1:size(member, 2)));
    ylabel('Cluster', 'Interpreter','latex');
    set(gca, ...
    'TickLabelInterpreter', 'latex', ...
    'FontSize'      , 14-1      ,...
    'FontWeight'    , 'normal' ); 
end
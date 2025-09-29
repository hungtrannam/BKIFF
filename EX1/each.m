clear; clc; close all;

%% ===== Range khoảng cách =====
H2 = linspace(0.001, 2, 200);   % Dãy H^2 (Normalized H^2)

%% ===== IR và omega =====
IRs = [1, 5, 10];
Omegas = [1 1; 1 0.2; 1 0.1];   % omega tương ứng

%% ===== Các m cần xét =====
ms = [1.1, 1.5, 2, 2.5, 3, 5, 10];
colors = abyss(length(ms));

%% ===== Vẽ =====
figure;
allLines = []; allLabels = {};

for w = 1:length(IRs)
    IR = IRs(w);
    omega = Omegas(w,:);
    D1 = H2;
    D2 = (2-H2);
    
    subplot(1,length(IRs),w); hold on;
    temp(15,40,15);
    for mm = 1:length(ms)
        m = ms(mm);
        mu1 = zeros(size(D1));
        for j = 1:length(D1)
            mu1(j) = 1 / (1 + ((D1(j)/omega(1))/(D2(j)/omega(2)))^(1/(m-1)));
        end
        if m==2
            h = plot(D1, mu1, 'LineWidth', 4.5, 'Color', colors(mm,:), ...
            'DisplayName', sprintf('$m=%.1f$', m)); hold on;
        else
            h =plot(D1, mu1, 'LineWidth', 1.5, 'Color', colors(mm,:), ...
            'DisplayName', sprintf('$m=%.1f$', m)); hold on;
        end
        if w==1   % chỉ lấy label 1 lần (tránh trùng lặp)
            allLines(end+1) = h;
            allLabels{end+1} = sprintf('$m=%.1f$', m);
        end

    end
    % Vẽ đường ngang y=0.5
    yline(0.5, '--k', 'LineWidth', 1);

    xlabel('Normalised $\mathcal{H}^2$',"Interpreter","latex");
    ylabel('Membership',"Interpreter","latex");
    title(sprintf('$IR = %d, \\ [\\omega_1=%.1f,\\, \\omega_2=%.1f$]', ...
        IR, omega(1), omega(2)),"Interpreter","latex");
    grid on;
    pbaspect([2 1 1]);   % trục ngang gấp đôi trục dọc
end

% Legend chung bên ngoài, ở giữa dưới
lgd = legend(allLines, allLabels, 'Orientation','horizontal', ...
       'Interpreter','latex', 'NumColumns',3);
lgd.Position(1) = 0.5 - lgd.Position(3)/2;  % căn giữa theo X
lgd.Position(2) = 0.1;                     % đặt bên ngoài phía dưới

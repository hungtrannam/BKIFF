close all; clc; clear

methods = { ...
            %'FCM_CWD_',       % Tai Vo-Van (2019)
             %'FCM_',           % Thao Nguyen-Trang (2017)
             %'KMEAN_',         % Thao Nguyen-Trang (2024)
             %'SUP_',           % Chen J-H, Hung W-L (2015)
            % 'PCM_'            % Hung Tran-Nam (2024)

            %'IFCM_NOBK'
            
                        % Proposed
            'IFCM_L',
            'IFCM_CWD', 
            'IFCM_L2',
            'IFCM_',
            
    };

colors = abyss(length(methods)-1); % Tạo bảng màu tự động

% for IR = 1:100
for IR = 1:100
    filename = sprintf('EVA/DIS_%d.mat', IR);
    if exist(filename, 'file') % Kiểm tra file tồn tại
        load(filename);


        for M = 1:length(methods)
            method = methods{M};

            % NMI, ARI, iter, Time
            Mean_(IR, M) = median(metrics.(method).Time);
            Std_(IR, M) = iqr(metrics.(method).Time);

        end

    end
end

figure;
hold on;
for M = 1:length(methods)
    mean_values = Mean_(:, M)';
    std_values = Std_(:, M)';
    % x = 1:100;
    x = 1:IR;

    if M < length(methods)
        % Vẽ các phương pháp thông thường
        h_plot = plot(x, mean_values, 'LineWidth', 3, 'Color', colors(M, :), DisplayName=methods{M});
        y_lower = (mean_values - std_values); % Giới hạn dưới >= 0
        y_upper = min(mean_values + std_values, 1); % Giới hạn trên <= 1
        
        h_fill = fill([x, fliplr(x)], ...
            [y_lower, fliplr(y_upper)], ...
            colors(M, :), 'FaceAlpha', 0.5, 'EdgeColor', 'none'); % Vùng tô bóng
        % Ẩn fill khỏi legend
        h_fill.Annotation.LegendInformation.IconDisplayStyle = 'off'; 
    else
        % Vẽ phương pháp cuối cùng riêng với màu đỏ
        h_plot = plot(x, mean_values, 'LineWidth', 6, 'Color', 'r',  DisplayName=methods{M}, LineStyle= ':');
        
        % Vẽ vùng dao động (fill) với giá trị hợp lệ
        y_lower = (mean_values - std_values);
        y_upper = min(mean_values + std_values, 1);
        h_fill = fill([x, fliplr(x)], [y_lower, fliplr(y_upper)], ...
                      'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
        h_fill.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end

end

hold off;
legend; % Hiển thị legend


xlabel('Imbalanced Ratio');
% ylabel('NMI');
% ylabel('Iterations')
ylim([0 1])
% ylabel('ARI');
ylabel('Computer Time');
legend('Location', 'northwest'); % Thêm chú thích
grid on;
% title('Geometry Mean of Methods Across Imbalanced Ratio');
% title('ARI of MeRthods Across Imbalanced Ratio');


temp(25,20,15);

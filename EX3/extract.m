% Đọc ảnh gốc
D_list = {'D82', 'D102'};

% Lặp qua các giá trị IR
for IR = 1:100
    Data = [];
    labels = [];
    
    for D_idx = 1:length(D_list)
        D = D_list{D_idx};
        folderPath = sprintf('IMG/%s_IR%d', D, IR);
        
        % Kiểm tra nếu thư mục tồn tại
        if exist(folderPath, 'dir')
            imds = imageDatastore(folderPath, 'IncludeSubfolders', true, 'LabelSource', 'none');
            
            % Lấy số lượng ảnh
            numImages = numel(imds.Files);
            
            h = 1;
            grid = -100:h:300;
            
            for i = 1:numImages
                img = readimage(imds, i);
                img = double(img(:)); % Chuyển đổi ảnh thành vector cột
                
                % Ước lượng hàm mật độ sử dụng KDE
                bandwidth = 1.06 * std(img) * length(img)^(-1/5);
                [f, ~] = ksdensity(img, grid, 'Bandwidth', bandwidth);
                Data = [Data, f(:)]; % Lưu theo cột
                labels = [labels; D_idx]; % Gán nhãn số theo thư mục
            end
        else 
            sprintf('None')
        end
    end
    
    % Lưu kết quả ra file MAT theo từng giá trị IR
    save(sprintf('Data/IR_%d.mat', IR), 'Data', 'grid', 'h', 'labels');
end

plot(grid, Data)

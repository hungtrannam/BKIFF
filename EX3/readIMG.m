
D = 'D102';

for IR = 1:100
    rng(IR);
    numCrops = 30 * IR;
    
    imagePath = sprintf('./%s.gif', D);
    img = imread(imagePath);
    
    % Kích thước ảnh con
    cropSize = 64;
    
    % Tạo thư mục lưu ảnh nếu chưa có
    outputFolder = sprintf('IMG/%s_IR%d', D, IR);
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end
    
    % Lấy kích thước ảnh gốc
    [height, width] = size(img);
    
    for i = 1:numCrops
        % Chọn ngẫu nhiên toạ độ góc trên bên trái của ảnh con
        x = randi([1, width - cropSize + 1]);
        y = randi([1, height - cropSize + 1]);
        
        % Cắt ảnh
        croppedImg = img(y:y+cropSize-1, x:x+cropSize-1);
        
        % Lưu ảnh
        outputFilename = fullfile(outputFolder, sprintf('%03d.png', i));
        imwrite(croppedImg, outputFilename);
    end
end


%%

D = 'D82';

for IR = 1:100
    rng(IR);
    numCrops = 30;
    
    imagePath = sprintf('./%s.gif', D);
    img = imread(imagePath);
    
    % Kích thước ảnh con
    cropSize = 64;
    
    % Tạo thư mục lưu ảnh nếu chưa có
    outputFolder = sprintf('IMG/%s_IR%d', D, IR);
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end
    
    % Lấy kích thước ảnh gốc
    [height, width] = size(img);
    
    for i = 1:numCrops
        % Chọn ngẫu nhiên toạ độ góc trên bên trái của ảnh con
        x = randi([1, width - cropSize + 1]);
        y = randi([1, height - cropSize + 1]);
        
        % Cắt ảnh
        croppedImg = img(y:y+cropSize-1, x:x+cropSize-1);
        
        % Lưu ảnh
        outputFilename = fullfile(outputFolder, sprintf('%03d.png', i));
        imwrite(croppedImg, outputFilename);
    end
end

%% ====== IFCM trên coins.mat cho k = 2..7 và vẽ patch theo màu cụm ======
clear; clc; close all;

% ---- Nạp dữ liệu KDE theo patch + ảnh gốc ----
matFile = 'Data/app2.mat';            % đã tạo ở bước trước
imgPath = 'Data/app2.png';            % ảnh gốc
S = load(matFile);

density  = S.density;             % (256 x nPatch), mỗi cột = KDE patch
P        = S.P;                   % kích thước patch (PxP) — ở đây là 4
targetSz = S.targetSz;            % 256
nRow     = S.nRow;                % 256 / 4 = 64
nCol     = S.nCol;
nPatch   = nRow * nCol;

I = imread(imgPath);
if size(I,3)>1, I = rgb2gray(I); end
% I = imresize(I, [targetSz targetSz]);   % 256x256
H = size(I,1); W = size(I,2);

% ---- Data cho IFCM: mỗi cột là 1 đối tượng (hàm mật độ) ----
Data = density;                    % 256 x nPatch

% ---- Thư mục lưu kết quả ----
outDir = 'EVA';

% ---- Tham số mặc định cho IFCM ----
baseParam = struct();
baseParam.h      = S.h;     % theo định nghĩa khoảng cách của bạn (1D grid)
baseParam.mFuzzy = 2;
baseParam.Init   = 2;
baseParam.Ran    = 1;

% ---- Lưu nhãn cho mọi k ----
labels_all = struct();

% ---- Chạy cho k = 2..7 ----
for kClust = 2:11
    fprintf('=== Running IFCM with k = %d ===\n', kClust);

    % Param cho k hiện tại
    param = baseParam;
    param.kClust = kClust;

    % (tuỳ chọn) Khởi tạo tâm bằng BKA nếu có Initializing
    [~, best_tt, ~] = Initializing(Data, param.kClust, 'BKA', param.h, '1D');
    param.fv = Data(:, round(best_tt));


    % ---- Gọi IFCM (yêu cầu hàm IFCM_ trong path) ----
    results = feval('IFCM_', Data, param);    % <-- đổi tên nếu bạn dùng hàm khác
    lab = results.IDX(:);                     % nPatch x 1, có thể không phải 1..k

    % Chuẩn hoá nhãn về 1..k (ổn định)
    [~,~,lab_mapped] = unique(lab, 'stable');

    % Lưu nhãn
    labels_all.(sprintf('k%d', kClust)) = lab_mapped;

    % ---- Vẽ overlay patch theo màu cụm ----
    % Tạo bảng màu có kClust màu (có thể đổi 'hsv' -> 'lines' tuỳ gu)
    Cmap = lines(kClust);     % hoặc: lines(kClust), parula(kClust), turbo(kClust) (R2020a+)
    edgeW     = 0.8;        % viền mảnh để đỡ rối (nPatch=4096)

    figure('Name',sprintf('IFCM k=%d', kClust), 'Color','w');

    % (tuỳ chọn) KHÔNG kẻ lưới vì patch 4x4 rất dày; nếu thích, bật 2 vòng for kẻ lưới
    % for rr = 1:nRow-1, y = rr*P + 0.5; plot([0.5 W+0.5],[y y],'w-','LineWidth',0.25); end
    % for cc = 1:nCol-1, x = cc*P + 0.5; plot([x x],[0.5 H+0.5],'w-','LineWidth',0.25); end

    % ---- Vẽ overlay patch mờ ----
    alphaFace = 0.2; % 0.0 = trong suốt hoàn toàn, 1.0 = che hoàn toàn
    I3 = repmat(mat2gray(I), [1,1,3]);  % Ảnh gốc dạng RGB [0..1]
    Overlay = I3;                       % Khởi tạo overlay
    
    kidx = 1;
    for r = 1:nRow
        ys = (r-1)*P + (1:P);
        for c = 1:nCol
            xs = (c-1)*P + (1:P);
            cid = lab_mapped(kidx);      % 1..kClust
            col = Cmap(cid, :);          % màu RGB 1x3
    
            % blend màu vào vùng patch
            for ch = 1:3
                Overlay(ys, xs, ch) = (1-alphaFace)*Overlay(ys, xs, ch) + ...
                                       alphaFace*col(ch);
            end
    
            kidx = kidx + 1;
        end
    end
    
    imshow(Overlay);
    title(sprintf('IFCM (k=%d) — P=%d', kClust, P));


    % Lưu ảnh
    outPNG = fullfile(outDir, sprintf('coins_IFCM_k%d_P%d.png', kClust, P));
    frame = getframe(gca); 
    imwrite(frame.cdata, outPNG);
    fprintf('Saved: %s\n', outPNG);
end

% ---- Lưu tất cả nhãn ra .mat ----
save(fullfile(outDir,'coins_IFCM_labels_2to7.mat'), ...
     'labels_all','P','targetSz','nRow','nCol');

disp('Done.');

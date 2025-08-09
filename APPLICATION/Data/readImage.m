clear; clc;

imgPath   = 'app2.png';   % thay đường dẫn nếu cần
targetSz  = 512;           % scale về 256x256
P         = 4;            % kích thước patch PxP

% --- Đọc & chuẩn hoá ảnh xám về [0,1] ---
I = imread(imgPath);
if size(I,3) > 1
    I = rgb2gray(I);
end
% I = imresize(I, [targetSz targetSz]);   % 256x256
I = double(I) / 255;                    % chuẩn hóa về [0,1]

% --- Chia patch ---
H = size(I,1); W = size(I,2);
assert(mod(H,P)==0 && mod(W,P)==0, '256 phải chia hết cho P.');
nRow = H / P; 
nCol = W / P;
nPatch = nRow * nCol;

% --- Lưới giá trị cường độ (0..1) ---
h = 0.01; % Step size for the grid
grid = -0.2:h:1.2; % Range of values for the grid
density     = zeros(numel(grid), nPatch, 'double');
bandwidths  = zeros(nPatch,1);   % Scott per-patch
patch_rc    = zeros(nPatch,2);   % (rowIdx, colIdx)
patch_bbox  = zeros(nPatch,4);   % [y1 y2 x1 x2]

% --- KDE cho từng patch ---
k = 1;
for r = 1:nRow
    for c = 1:nCol
        ys = (r-1)*P + (1:P);
        xs = (c-1)*P + (1:P);
        patch = I(ys, xs);                 % PxP, đã chuẩn hóa
        samples = patch(:);                % P^2 x 1
        n = numel(samples);
        sigma = std(samples, 1);            % std theo Scott (population)
        bw = 1.06 * sigma * n^(-1/5);        % Scott bandwidth (Gaussian)
        if bw <= 0 || isnan(bw)
            bw = 0.001; % fallback nhỏ khi patch đồng nhất
        end

        f = ksdensity(samples, grid, 'Kernel','normal', 'Bandwidth', bw);

        density(:, k) = f;
        bandwidths(k) = bw;
        patch_rc(k,:) = [r, c];
        patch_bbox(k,:) = [ys(1), ys(end), xs(1), xs(end)];
        k = k + 1;
    end
end

% --- Lưu .mat cho pipeline clustering & ghép lại ---
save('app2.mat', ...
     'density', 'grid', 'h', 'P', 'targetSz', ...
     'bandwidths', 'nRow', 'nCol', 'patch_rc', 'patch_bbox');

% --- Vẽ nhanh (tùy chọn) ---
figure; 
plot(grid, density); % vẽ 20 patch đầu
xlabel('Cường độ [0..1]');
ylabel('Mật độ');
title('KDE cho một số patch');

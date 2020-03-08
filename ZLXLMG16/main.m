% main.m (256x256 grayscale image is only supported)
%
% Restoration of JPEG Compressed Image 
% with Narrow Quantization Constraint Set 
% without Parameter Optimization
%
% Written by  : Chihiro Tsutake
% Affiliation : University of Fukui
% E-mail      : ctsutake@icloud.com
% Created     : Feb. 2020
%

addpath('../Utilities');

% Quantization table
Q = [
    016 011 010 016 024 040 051 061;
    012 012 014 019 026 058 060 055;
    014 013 016 024 040 057 069 056;
    014 017 022 029 051 087 080 062;
    018 022 037 056 068 109 103 077;
    024 035 055 064 081 104 113 092;
    049 064 078 087 103 121 120 101;
    072 092 095 098 112 100 103 099
    ];

% Quantization factor
qf = 60;

% Make table
if (qf < 50)
    Q = double(round(((5000 / qf) * Q + 50) / 100));
else
    Q = double(round(((200 - 2 * qf) * Q + 50) / 100));
end

%  Read original image
f = double(imread('../Img/1.pgm'));

% Forward DCT
F = blockdct2(f);

% Quantization
Fdash = blockquantize(F, Q);

% Dequantization
Fbar = blockdequantize(Fdash, Q);

% Inverse DCT
fbar = blockidct2(Fbar);

% Restore
ftmp = zeros(size(fbar, 1), size(fbar, 2), 3);
[ftmp(:, :, 1)] = fbar;
[ftmp(:, :, 2), iter] = restore(Fbar, Q, 0.5, ftmp(:, :, 1)); 
[ftmp(:, :, 3), iter] = restore(Fbar, Q, 1.0, ftmp(:, :, 2)); 
ftld = 0.5 * (max(ftmp, [], 3) + min(ftmp, [], 3));

% Write
imwrite(uint8(fbar), 'jpg.pgm'); 
imwrite(uint8(ftld), 'res.pgm'); 

% PSNR
printf("PSNR(x, xbar) = %4.2f\n", psnr(uint8(f), uint8(fbar)));
printf("PSNR(x, xtld) = %4.2f\n", psnr(uint8(f), uint8(ftld)));

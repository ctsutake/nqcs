% restore.m
%
% Restore a decoded image based on singular value thresholding in [17]
%
% Written by  : Chihiro Tsutake
% Affiliation : University of Fukui
% E-mail      : ctsutake@icloud.com
% Created     : Feb. 2020
%

function [ftld, iter] = restore(Fbar, Q, mu, f0)

    % Size
    [Y, X] = size(f0);

    % Inverse DCT
    fbar = blockidct2(Fbar);

    % Shifted images
    seq = zeros(Y, X, 31 * 31);

    for mv_ver = -15:15

        for mv_hor = -15:15
            key = (mv_ver + 15) * 31 + mv_hor + 15 + 1;
            seq(:, :, key) = circshift(fbar, [mv_ver, mv_hor]);
        end

    end

    % SSE
    err = (seq - fbar).^2;
    err = padarray(err, [7, 7, 0], 'post', 'circular');
    sse = convn(err, ones(8), 'valid');

    % Indexing
    [~, Gidx] = sort(sse, 3);

    % Constraint
    Fmin = Fbar - mu * repmat(Q, [Y, X] / 8) / 2;
    Fmax = Fbar + mu * repmat(Q, [Y, X] / 8) / 2;

    % Initial guess
    ftld = f0;

    for mv_ver = -15:15

        for mv_hor = -15:15
            key = (mv_ver + 15) * 31 + mv_hor + 15 + 1;
            seq(:, :, key) = circshift(f0, [mv_ver, mv_hor]);
        end

    end

    for iter = 1:8192

        fold = ftld;
        ftmp = wind = zeros(Y, X);

        % SVT
        for y = 1:3:Y

            for x = 1:3:X
                ry = [1:Y, 1:7](y:y + 7);
                rx = [1:X, 1:7](x:x + 7);
                Bs = seq(ry, rx, Gidx(y, x, 1:40));
                Bs = reshape(Bs, 64, []);
                [U, S, V] = svd(Bs, 'econ');
                S = max(S - 16, 0);
                Bs = U * S * V';
                ftmp(ry, rx) = ftmp(ry, rx) + reshape(Bs(:, 1), [8, 8]);
                wind(ry, rx) = wind(ry, rx) + 1;
            end

        end

        ftld = ftmp ./ wind;

        % Projection
        Ftld = blockdct2(ftld);
        Ftld = max(min(Ftld, Fmax), Fmin);
        ftld = blockidct2(Ftld);

        % Convergence
        mad = sum(abs(ftld(:) - fold(:))) / (X * Y);

        if mad < 0.08
            break;
        end

        % Remake
        for mv_ver = -15:15

            for mv_hor = -15:15
                key = (mv_ver + 15) * 31 + mv_hor + 15 + 1;
                seq(:, :, key) = circshift(ftld, [mv_ver, mv_hor]);
            end

        end

    end

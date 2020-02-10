% restore.m
%
% Restore a decoded image based on low-path filtering in [14]
%
% Written by  : Chihiro Tsutake
% Affiliation : University of Fukui
% E-mail      : ctsutake@icloud.com
% Created     : Feb. 2020
%

function [ftld, iter] = restore(Fbar, Q, mu, f0)

    % Inverse DCT
    fbar = blockidct2(Fbar);

    % Size
    [Y, X] = size(f0);

    % Constraint
    Fmin = Fbar - mu * repmat(Q, [Y, X] / 8) / 2;
    Fmax = Fbar + mu * repmat(Q, [Y, X] / 8) / 2;

    % Constant
    l = padarray([0.2741, 0.4519, 0.2741]' * [0.2741, 0.4519, 0.2741], [Y - 3, X - 3], 'post');
    l = circshift(l, [-1, -1]);
    const = real(ifft2(fft2(fbar) .* fft2(l)));

    % Initialize
    ftld = f0;

    for iter = 1:8192

        fold = ftld;

        % Gradient descent
        ftld = ftld - 0.1 * (ftld - const);

        % Projection
        Ftld = blockdct2(ftld);
        Ftld = max(min(Ftld, Fmax), Fmin);
        ftld = blockidct2(Ftld);

        % Convergence
        mad = sum(abs(ftld(:) - fold(:))) / (X * Y);

        if mad < 0.02
            break;
        end

    end

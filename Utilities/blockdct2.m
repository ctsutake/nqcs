function B = blockdct2(A)
    u = 2 * e.^(-sqrt(-1) * pi * [0:7] / 16).';
    v = [5.6568542, 4.0000000, 4.0000000, 4.0000000, 4.0000000, 4.0000000, 4.0000000, 4.0000000]';
    X = size(A, 2);
    Y = size(A, 1);

    B = A;
    B = reshape(B, Y, 8, []);
    B = permute(B, [2 1 3]);
    B = reshape(B, 8, 8, []);
    B = permute(B, [2 1 3]);

    B = [B; zeros(size(B))];
    B = fft(B)(1:8, 1:8, :);
    B = real(B .* u);
    B = B ./ v;
    B = permute(B, [2 1 3]);

    B = [B; zeros(size(B))];
    B = fft(B)(1:8, 1:8, :);
    B = real(B .* u);
    B = B ./ v;
    B = permute(B, [2 1 3]);
    
    B = permute(B, [2 1 3]);
    B = reshape(B, 8, Y, []);
    B = permute(B, [2 1 3]);
    B = reshape(B, Y, X);

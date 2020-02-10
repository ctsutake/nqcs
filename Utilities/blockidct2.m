function B = blockidct2(A)
    u = 2 * e.^(+sqrt(-1) * pi * [0:7] / 16).';
    v = [1/5.6568542, 1/4.0000000, 1/4.0000000, 1/4.0000000, 1/4.0000000, 1/4.0000000, 1/4.0000000, 1/4.0000000]';
    X = size(A, 2);
    Y = size(A, 1);

    B = A;
    B = reshape(B, Y, 8, []);
    B = permute(B, [2 1 3]);
    B = reshape(B, 8, 8, []);
    B = permute(B, [2 1 3]);

    B = B .* v .* u;
    B = [B; zeros(size(B))];
    B = ifft(B)(1:8, 1:8, :);
    B = real(B);
    B = permute(B, [2 1 3]);

    B = B .* v .* u;
    B = [B; zeros(size(B))];
    B = ifft(B)(1:8, 1:8, :);
    B = real(B) * 256;
    B = permute(B, [2 1 3]);

    B = permute(B, [2 1 3]);
    B = reshape(B, 8, Y, []);
    B = permute(B, [2 1 3]);
    B = reshape(B, Y, X);

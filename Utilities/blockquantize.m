function B = blockquantize(A, Q)
    X = size(A, 2);
    Y = size(A, 1);

    B = A;
    B = reshape(B, Y, 8, []);
    B = permute(B, [2 1 3]);
    B = reshape(B, 8, 8, []);
    B = permute(B, [2 1 3]);

    B = round(B ./ Q);

    B = permute(B, [2 1 3]);
    B = reshape(B, 8, Y, []);
    B = permute(B, [2 1 3]);
    B = reshape(B, Y, X);

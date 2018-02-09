function Padmat = pad( A, padval)
%this function is used to pad the specified value around the matrix

Padmat = [ padval * ones( 1, size( A, 2) + 2)
    padval * ones( size( A, 1), 1) A padval * ones( size( A, 1), 1)
    padval * ones( 1, size( A, 2) + 2)];
end

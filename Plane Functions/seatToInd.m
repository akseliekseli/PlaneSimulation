function I = seatToInd(L, cn)
% Converts the vector of seat numbers into a 2-dimensional vector of indeces.
    R = ceil(L./cn);     % Counts the row in plane from the seat number [1, n]
    C = mod(L-1, cn)+1;  % Counts the row position from the seat number [1, 6]
    I = [R, C];
end

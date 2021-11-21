function N = indToSeat(V, cn)
% Converts the vector of indeces into a 1-dimensional vector of seat numbers.
    N = (V(:,1) - 1)*cn + V(:,2);  % Counts the seat number from given indices
    N = N(1);
end
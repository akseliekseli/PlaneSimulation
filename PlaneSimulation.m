%% PlaneSimulation


%% TestiCommit

x=1;
<<<<<<< HEAD
y=1;
=======

% Noi on nyt rakennettu ks. jarjestyksella ja vaakasuoralla palautuksella:
% 1, 7, 13, ...
% 2, 8, ...
% 3, 9,
% ..

% Kaannetaan jos halutaan vaihtaa tarkastelu esim pystysuoraksi.

function I = seatToInd(L);
% Converts the vector of seat numbers into a 2-dimensional vector of indeces.
    C = ceil(L./6);     % Counts the column from the seat number [1, n]
    R = mod(L-1, 6)+1;  % Counts the row from the seat number [1, 6]
    I = [C; R];
end

function N = indToSeat(V);
% Converts the vector of indeces into a 1-dimensional vector of seat numbers.
    N = (V(1,:) - 1)*6 + V(2,:);  % Counts the seat number from given indices
<<<<<<< HEAD
end
>>>>>>> a32f8eaa7e2730b34ab0f2b1ed1ac7edafd658a1
=======
end
>>>>>>> a32f8eaa7e2730b34ab0f2b1ed1ac7edafd658a1

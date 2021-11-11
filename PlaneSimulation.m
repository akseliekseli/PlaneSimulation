%% PlaneSimulation


x = [1, 2, 3, 5, 6, 7, 8, 9, 10,...
    11, 12, 13, 14, 15, 16, 17 ,18, 19, 20, 21];


I = seatToInd(x)


seats_in_row = 6;

t_step = 1;
i = 1;
t_tot = 0;

plane = zeros(max(x(:,1)), seats_in_row);

while i<=length(x)
   row_1 = x(i,1);
   pos_1 = x(i,2);
   
   if row_1 == i
      plane(row_1,pos_1) = 1; 
      i = i + 1;
      continue
   end
   
   
end

% Test

%% Funkkarit


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

end


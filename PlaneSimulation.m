%% PlaneSimulation


x = 1:24;


I = seatToInd(x)
I = I';

seats_in_row = 6;

t_step = 1;
ii = 1;
t_tot = 0;

plane = zeros(max(I(:,1)), seats_in_row);
queue = [];

% TODO:
% Changing row doesnt work at the moment, the first guy can't
% get to his spot. 
while ii<=length(I)
   queue(end+1,:) = I(ii,:);
   
   
   % Check if the first in queue is not on his row
   % If not, add another person to queue and time
   if queue(end,1) < size(queue,1)
        ii = ii + 1;
        t_tot = t_tot + t_step;
        pause
        continue
   end
   % Stop queue and put all people on correct
   % rows to their places
   for jj=1:size(queue,1)
       
       if queue(jj,1) == jj
          queue(jj,1)
          queue(jj,2)
          plane(queue(jj,1),queue(jj,2)) = 1
          queue(jj,:) = 0;
          
          
       end
   end
   queue( all(~queue,2), : ) = [];
   ii = ii + 1;
   
   
end



% Noi on nyt rakennettu ks. jarjestyksella ja vaakasuoralla palautuksella:
% 1, 7, 13, ...
% 2, 8, ...
% 3, 9,
% ..

% Kaannetaan jos halutaan vaihtaa tarkastelu esim pystysuoraksi.

function I = seatToInd(L)
% Converts the vector of seat numbers into a 2-dimensional vector of indeces.
    C = ceil(L./6);     % Counts the column from the seat number [1, n]
    R = mod(L-1, 6)+1;  % Counts the row from the seat number [1, 6]
    I = [C; R];
end

function N = indToSeat(V)
% Converts the vector of indeces into a 1-dimensional vector of seat numbers.
    N = (V(1,:) - 1)*6 + V(2,:);  % Counts the seat number from given indices

end


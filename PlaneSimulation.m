%% PlaneSimulation


x = 1:24;

x = x(randperm(length(x))); % Shuffle seats

I = seatToInd(x)

time = planeBoarding(I)



%% Funkkarit


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


function time = planeBoarding(lineIn)
    
% setuppia
    time = 0;
    rows = max(lineIn(1,:));
    seat = max(lineIn(2,:));
    seats = zeros(rows, seat);
    aisle = zeros(rows, 2)';
    
    % Main Run: käydään läpi niin kauan kun joko jonossa tai käytävällä on
    % ihmisiä.
    while (any(any(lineIn)) || any(any(aisle)))
        aisle
        %lineIn
        
        % Käydään läpi käytävä alkaen koneen lopusta
        for i = rows:-1:1
            r = aisle(1,i);
            s = aisle(2,i);
            % Jos käytävä jonottaja on omalla rivillä niin lisää kaveri
            % paikalleen ja poista käytävästä. Muussa tapauksessa jos
            % jonottajan edessä ei ole ketään, niin hän voi siirtyä
            % eteenpäin.
            if(r == i) 
                seats(r,s) = 1;
                aisle(:,i) = [0;0];
            elseif(r && aisle(1,i+1) == 0)
                aisle(:,i+1) = [r;s];
                aisle(:,i) = [0;0];
            end
        end
        % Jos käytävän ensimmäinen paikka on tyhjä, niin jonottaja ulkoa
        % voi tulla käytävä jonoon. Poistetaan kokonainen sarake
        % ulkojonosta
        
        if(any(any(lineIn)) && aisle(1,1) == 0)
            aisle(:,1) = lineIn(:,1);
            lineIn(:,1) = [];
        end
        time = time +1;
    end
    seats'
end
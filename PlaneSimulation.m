%% PlaneSimulation
clc

seats_in_row = 6;                               % Penkkien maara rivilla
rows_in_plane = 20;                             % Rivien maara koneessa 

line = [1:1:seats_in_row*rows_in_plane]';       % generoitu jono

% line = line(randperm(length(line)))       % Talla komennolla saa
                                            % randomoitua jarjestyksen

time = planeBoarding(line, seats_in_row, rows_in_plane)  % simulaation aloitus

% fixed. 

%% Funkkarit

function time = planeBoarding(line, seats, rows) 
    % setuppia
    time = 0;
    plane = zeros(rows, seats);
    aisle = zeros(rows, 2);

    % Muunnetaan jono vektori sisaltamaan indeksit
    lineIn = seatToInd(line, seats);
    
    % Main Run: kaydaann lapi niin kauan kun joko jonossa tai kaytavalla on
    % ihmisia.
    while (any(any(lineIn)) || any(any(aisle)));
        % Kaydaan lapi kaytava alkaen koneen lopusta
        for i = rows:-1:1
            person = aisle(i,:);
            % Tehdaan toimenpide jonottavalle henkilolle
            if(person(1) == i)             
                % - Tarkistetaan onko henkilo oikealla rivilla
                % - Asetetaan henkilo paikalleen
                % - Poistetaan henkilo kaytavalta
                plane(person(1), person(2)) = indToSeat(person, seats);
                aisle(i,:) = [0, 0];
            elseif(i ~= 20);
                if (aisle(i + 1, 1) == 0);
                % - Jos han ei ole oikealla rivilla -> siirretaan eteenpain
                % - Siirretaan henkilo eteenpain
                    aisle(i+1,:) = person;
                    aisle(i,:) = [0, 0];
                end
            end
        end
        % Jos kaytavan ensimmainen paikka on tyhja niin jonottaja ulkoa
        % voi tulla paastetaan kaytavalle. Poistetaan kokonainen sarake
        % ulkojonosta.
        if(any(any(lineIn)) && aisle(1,1) == 0)
            aisle(1,:) = lineIn(1,:);
            lineIn(1,:) = [];
        end
        time = time +1;
    end
    plane
end

function I = seatToInd(L, cn);
% Converts the vector of seat numbers into a 2-dimensional vector of indeces.
    R = ceil(L./cn);     % Counts the row position from the seat number [1, 6]
    C = mod(L-1, cn)+1;  % Counts the row in plane from the seat number [1, n]
    I = [R, C];
end

function N = indToSeat(V, cn);
% Converts the vector of indeces into a 1-dimensional vector of seat numbers.
    N = (V(:,1) - 1)*cn + V(:,2);  % Counts the seat number from given indices
    N = N(1);
end


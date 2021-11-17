%% PlaneSimulation
clc, clearvars, close all
<<<<<<< Updated upstream

seats_in_row = 6;                               % Penkkien maara rivilla
rows_in_plane = 20;                             % Rivien maara koneessa 


=======
testRes = runTestCase();
if (testRes ~= 1)
    disp("Testien lapaisy: " + testRes*100 + "%")
    return
end
     
seats_in_row = 6;                     % Penkkien maara rivilla (parillinen)
rows_in_plane = 20;                   % Rivien maara koneessa 
>>>>>>> Stashed changes

line = [1:1:seats_in_row*rows_in_plane]';       % generoitu jono

<<<<<<< HEAD
tic
n = 100000;
time = [];
for i = 1:n
    line = line(randperm(length(line)));       % Talla komennolla saa
                                            % randomoitua jarjestyksen
    time(i) = planeBoarding(line, seats_in_row, rows_in_plane);  % simulaation aloitus
end
histogram(time)
title('Random')
m = mean(time);
subtitle(['Mean: ',num2str(m,'%.2f')])
toc

=======



%% Funkkarit

function time,room_made = planeBoarding(line, seats, rows) 
    % setuppia
    time = 0;
    plane = zeros(rows, seats);
    room_made = plane;
    aisle = zeros(rows, 2);

    % Muunnetaan jono vektori sisaltamaan indeksit
    lineIn = seatToInd(line, seats);
    
    % Main Run: kaydaann lapi niin kauan kun joko jonossa tai kaytavalla on
    % ihmisia.
<<<<<<< HEAD
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
<<<<<<< HEAD
        % Jos kaytavan ensimmainen paikka on tyhja niin jonottaja ulkoa
        % voi tulla paastetaan kaytavalle. Poistetaan kokonainen sarake
        % ulkojonosta.
        if(any(any(lineIn)) && aisle(1,1) == 0)
            aisle(1,:) = lineIn(1,:);
            lineIn(1,:) = [];
        end
        time = time +1;
=======
>>>>>>> main
    end
    plane
end

<<<<<<< HEAD

% Noi on nyt rakennettu ks. jarjestyksella ja vaakasuoralla palautuksella:
% 1, 7, 13, ...
% 2, 8, ...
% 3, 9,
% ..

% Kaannetaan jos halutaan vaihtaa tarkastelu esim pystysuoraksi.


=======
>>>>>>> main

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
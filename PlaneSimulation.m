%% PlaneSimulation
clc, clearvars, close all


seats_in_row = 6;                               % Penkkien maara rivilla
rows_in_plane = 20;                             % Rivien maara koneessa 



testRes = runTestCase();
if (testRes ~= 1)
    disp("Testien lapaisy: " + testRes*100 + "%")
    return
end
     
seats_in_row = 6;                     % Penkkien maara rivilla (parillinen)
rows_in_plane = 20;                   % Rivien maara koneessa 


line = [1:1:seats_in_row*rows_in_plane]';       % generoitu jono


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

line = line(randperm(length(line)));       % Talla komennolla saa
                                           % randomoitua jarjestyksen
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

    if (mod(seats, 2) == 0);
        while (any(any(lineIn)) || any(any(aisle)));
            % Kaydaan lapi kaytava alkaen koneen lopusta
            for i = rows:-1:1
                person = aisle(i,:);
                % Tehdaan toimenpide jonottavalle henkilolle
                if(person(1) == i)             
                    % - Tarkistetaan onko henkilo oikealla rivilla
                    % - Lasketaan henkilolle istuuntumisaika, jos istuuntuminen
                    % ei ole jo valmis.
                    % - Asetetaan henkilo paikalleen
                    % - Poistetaan henkilo kaytavalta
                    if (odotus(i, 1) == 0);
                        odotus(i, 1) = 1;
                        odotus(i, 2) = determineTime(time_step, person, plane(i, :));
                    elseif (odotus(i, :) == [1, 0]);
                        plane(person(1), person(2)) = indToSeat(person, seats);
                        aisle(i,:) = [0, 0];
                        odotus(i, :) = [0, 0];
                    end
                elseif(i ~= rows);
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

            % poistetaan odotusaika jokaiselta rivilta:
            odotus(:,2) = odotus(:,2) - (odotus(:,2) > 0);
            % kasvatetaan kulunutta aikaa ja kierrosmaaraa
            time = time + time_step;
            round = round + 1;

            % Algoritmin testauksen toimivuutta varten:
            if (test == 1)
                time = round;
                odotus = [ones(rows, 1), zeros(rows, 1)];
                if (round == 3)
                    varargout{1} = aisle(:,1);
                elseif (round == 4)
                    varargout{2} = plane(:,1);

                end
            end
            aisle;
            odotus;
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



% Noi on nyt rakennettu ks. jarjestyksella ja vaakasuoralla palautuksella:
% 1, 7, 13, ...
% 2, 8, ...
% 3, 9,
% ..

% Kaannetaan jos halutaan vaihtaa tarkastelu esim pystysuoraksi.



function wait_time = determineTime(time_step, person, row);
% Laskee ajan istuuntumiselle, riippuen satunnaisuudesta, istumapaikasta ja rivin tayteydesta
    seating_time = 0;
    stowing_time = 0;
    % Satunnainen aika, joka matkatavaroiden laittamiseen kuluu
    % aika-askel - 20*aika_askel
    stowing_time = randi([0, time_step*20]);
    % istuuntumisaika lasketaan esim: seuraavasti
    % et?isyys kaytavasta * aika asekel
    % Mikali toiset ihmiset ovat edessa:
    % jokainen edessa oleva nousee ja istuuntuu takaisin:
    % + 2 * ylempi (jokaista henkiloa kohden)
    seatsOnSide = length(row)/2;
    % Taman funktion pitaisi tuottaa ym logiikalla jokaiselle rivikoolle
    % oikea etaisyys:
    % esim 3 + 3 penkkia, niin paikka 1 on 3 etaisyydella kaytavasta
    % Korjattu s.e. jono voi liikkua nopeemmin kun henkilot menevat
    % istumaan.
    time_fun = @(x) (abs(seatsOnSide + 0.5 - x) + 0.5)*time_step + 1;
    
    % Maaritetaan kummalla puolella henkil?? istuu
    if (person(2) > seatsOnSide)
        aisle = seatsOnSide + 1;
        window = seatsOnSide* 2;
        increment = 1;
    else 
        aisle = seatsOnSide;
        window = 1;
        increment = -1;
    end
    % Lasketaan aika mika  menee istumiseen
    blocking = 1;
    for i = aisle:increment:window
        if (i == person(2))
            % henkilon istuuntumisaika
            seating_time = seating_time + time_step;
            blocking = 0;
        elseif ((row(i) ~= 0) && (blocking == 1))
            % Jos joku istuu valissa istumisenprosessin kestoa
            seating_time = seating_time + time_fun(i);
        end
    end
    % Testiprinttei
    person;
    row;
    seating_time;
    % kokonaisaika tulee naiden summana:
    wait_time = stowing_time + seating_time;
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
%% PlaneSimulation
clc
testRes = runTestCase();
if (testRes ~= 1)
    disp("Testien lapaisy: " + testRes*100 + "%")
    pause
end
     
seats_in_row = 6;                               % Penkkien maara rivilla
rows_in_plane = 20;                             % Rivien maara koneessa 

line = [1:1:seats_in_row*rows_in_plane]';       % generoitu jono

line = line(randperm(length(line)))       % Talla komennolla saa
                                            % randomoitua jarjestyksen

time = planeBoarding(line, seats_in_row, rows_in_plane, 0)  % simulaation aloitus

% fixed. 

%% Funkkarit

function [time, varargout] = planeBoarding(line, seats, rows, test) 
    % setuppia
    time = 0;
    round = 0;
    time_step = 1; % jokaisen kierroksen kuluttama aikayksikk?
    plane = zeros(rows, seats);
    aisle = zeros(rows, 2);
    odotus = zeros(rows, 2);
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
        % testien vaatimat palautuksien asetukset
        if (round == 2)
            varargout{1} = aisle(:,1);
        elseif (round == 3)
            varargout{2} = plane;
        end
        % poistetaan odotusaika jokaiselta rivilta:
        odotus(:,2) = odotus(:,2) - (odotus(:,2) > 0);
        % kasvatetaan kulunutta aikaa ja kierrosmaaraa
        time = time + time_step;
        round = round + 1;
        
        % Algoritmin testauksen toimivuutta varten:
        if (test == 1)
            time = round;
            odotus = [1, 0; 1, 0; 1, 0];
        end
        aisle
        odotus
    end
    plane;
end

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
    time_fun = @(x) (abs(seatsOnSide + 0.5 - x) - 0.5)*time_step;
    for i = 1:length(row);
        if (i == person(1))
            % henkilon istuuntumisaika
            seating_time = seating_time + time_fun(i);
        elseif ((i < person(1)) && (person(1) > seatsOnSide));
            % paikat n/2 - n, tarkistus
            seating_time = seating_time + 2*time_fun(i);
        elseif ((i > person(1)) && (person(1) <= seatsOnSide));
            % paikat 1 - n/2, tarkistus
            seating_time = seating_time + 2*time_fun(i);
        end
    end
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

function pass = runTestCase();
    [time, t1, t2] = planeBoarding([3, 1, 2]', 1, 3, 1);
    test_pass = [];
    if (t1 == [2 0 3]');
        test_pass(end+1) = 1;
    else
        test_pass(end+1) = 0;
    end
    if (t2 == [1 0 3]');
        test_pass(end+1) = 1;
    else
        test_pass(end+1) = 0;
    end
    if (time == 5);
        test_pass(end+1) = 1;
    else
        test_pass(end+1) = 0;
    end
    pass = (sum(test_pass)) / length(test_pass);     
end
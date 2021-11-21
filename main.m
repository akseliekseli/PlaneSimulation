%% PlaneSimulation
clc, clearvars, close all



time = makeRandomSimulation(seats, rows,n);

[time, odotus] = planeBoarding(line',...
                               seats,...
                               rows, 0);  
figure
heatmap(odotus)
=======
clc
%

%% Funkkarit

<<<<<<< HEAD

% This function makes simulation of random order for plane of rows*seats n
% times. It makes histogram and heatmap of the results
function time = makeRandomSimulation(seats, rows, n)
    
    line = [1:1:seats*rows]';       % generoitu jono

    tic

    time = [];
    odotus=[];
    for i = 1:n

        line = line(randperm(length(line)));       % Talla komennolla saa
                                                % randomoitua jarjestyksen
        [time(i), odotus(i,:,:)] = planeBoarding(line,...
                                                seats,...
                                                rows, 0);  
                                            % simulaation aloitus
    end
    histogram(time)
    title('Random')
    m = mean(time);
    subtitle(['Mean: ',num2str(m,'%.2f')])
    toc
                                     % randomoitua jarjestyksen
    figure
    xmean = mean(odotus,1);
    xmean = squeeze(xmean);
    heatmap(xmean)
end




function [time, varargout] = planeBoarding(line, seats, rows, test) 
=======
    % setuppia
    time = 0;
    round = 0;
    time_step = 1; % jokaisen kierroksen kuluttama aikayksikk?
    plane = zeros(rows, seats);
<<<<<<< HEAD
    wait_map = plane;
    aisle = zeros(rows, 2);
    odotus = zeros(rows, 2);
=======
>>>>>>> main
    % Muunnetaan jono vektori sisaltamaan indeksit
    lineIn = seatToInd(line, seats);
    
    % Main Run: kaydaann lapi niin kauan kun joko jonossa tai kaytavalla on
    lineIn(:,3) = random';
    % Main Run: Kaydaan lapi niin kauan kun joko jonossa tai kaytavalla on
    % ihmisia.
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
                        wait_map(person(1),person(2)) = wait_map(person(1),person(2))...
                                                    + odotus(i,2);
<<<<<<< HEAD
                    elseif (odotus(i, :) == [1, 0]);
=======
>>>>>>> main
                        plane(person(1), person(2)) = indToSeat(person, seats);
                        aisle(i,:) = [0, 0];
                        odotus(i, :) = [0, 0];
                    end
<<<<<<< HEAD
                elseif((i ~= rows) && (person(1)~=0))
=======
>>>>>>> main
                    if (aisle(i + 1, 1) == 0);
                    % - Jos han ei ole oikealla rivilla -> siirretaan eteenpain
                    % - Siirretaan henkilo eteenpain
                        aisle(i+1,:) = person;
<<<<<<< HEAD
                        aisle(i,:) = [0, 0];
                        person;
                        % TODO Person on (0, 0), joten indexöinti ei toimi?
                        wait_map(person(1),person(2)) = wait_map(person(1),person(2))...
                                                               +time_step;
=======
>>>>>>> main
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
<<<<<<< HEAD
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
            
=======
>>>>>>> main
            aisle;
            odotus;
        end
    end
    varargout{1} = wait_map;
    plane;
end

function wait_time = determineTime(time_step, person, row);
% Laskee ajan istuuntumiselle, riippuen satunnaisuudesta, istumapaikasta ja rivin tayteydesta
    seating_time = 0;
<<<<<<< HEAD
    stowing_time = 0;
    % Satunnainen aika, joka matkatavaroiden laittamiseen kuluu
    % aika-askel - 20*aika_askel
    stowing_time = randi([0, 0*time_step*20]);
    % istuuntumisaika lasketaan esim: seuraavasti
    % et?isyys kaytavasta * aika asekel
=======
>>>>>>> main
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
    R = ceil(L./cn);     % Counts the row in plane from the seat number [1, n]
    C = mod(L-1, cn)+1;  % Counts the row position from the seat number [1, 6]
    I = [R, C];
end

function N = indToSeat(V, cn);
% Converts the vector of indeces into a 1-dimensional vector of seat numbers.
    N = (V(:,1) - 1)*cn + V(:,2);  % Counts the seat number from given indices
    N = N(1);
end

function pass = runTestCase();
    [time, t1, t2] = planeBoarding([5, 1, 3]', 2, 3, 1);
    test_pass = [];
    if (t1 == [2 0 3]');
        test_pass(end+1) = 1;
    else
        test_pass(end+1) = 0;
    end
    if (t2 == [1 0 5]');
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

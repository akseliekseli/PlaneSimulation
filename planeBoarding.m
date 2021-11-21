function [time varargout] = planeBoarding(line, seats, rows, varargin)
    switch nargin
        case 5
            time_step = varargin{1};
            random = varargin{2};
        case 4
            time_step = varargin{1};
            random = zeros(rows,1);
        otherwise
            time_step = 1;
            random = zeros(rows,1);
    end
    % setuppia
    time = 0;
    plane = zeros(rows, seats);
    aisle = zeros(rows, 3);
    odotus = zeros(rows, 3);
    wait_map = plane;
    % Muunnetaan jono vektori sisaltamaan indeksit
    lineIn = seatToInd(line, seats);
    lineIn(:,3) = random';
    % Main Run: Kaydaan lapi niin kauan kun joko jonossa tai kaytavalla on
    % ihmisia.
    if (mod(seats, 2) == 0)
        while (any(any(lineIn)) || any(any(aisle)))
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
                    if (odotus(i, 1) == 0)
                        odotus(i, 1) = 1;
                        odotus(i, 2) = determineTime(time_step, person, plane(i, :));
                        wait_map(person(1),person(2)) = wait_map(person(1),person(2))...
                                                    + odotus(i,2);
                    end
                    if (odotus(i, (1:2)) == [1, 0])
                        plane(person(1), person(2)) = indToSeat(person, seats);
                        aisle(i,:) = zeros(1,size(aisle,2));
                        odotus(i, :) = zeros(1,size(odotus,2));
                    end
                elseif((i ~= rows) && (person(1) ~= 0))
                    if (aisle(i + 1, 1) == 0)
                    % - Jos han ei ole oikealla rivilla -> siirretaan eteenpain
                    % - Siirretaan henkilo eteenpain
                        aisle(i+1,:) = person;
                        aisle(i,:) = zeros(1,size(aisle,2));
                    end
                    % veikkaisin, ett? tama olisi oikea kohta ks.
                    % lisaykselle
                    wait_map(person(1),person(2)) = wait_map(person(1),person(2))...
                                                               +time_step;
                end
            end
            % Jos kaytavan ensimmainen paikka on tyhja niin jonottaja ulkoa
            % voi tulla paastetaan kaytavalle. Poistetaan kokonainen sarake
            % ulkojonosta.
            if(any(any(lineIn)) && aisle(1,1) == 0)
                aisle(1,:) = lineIn(1,:);
                lineIn(1,:) = [];
            end

            % poistetaan time_step odotusajasta jokaiselta odottavalta rivilta:
            odotus(:,2) = odotus(:,2) - time_step*(odotus(:,1) == 1);
            % muutetaan kaikki negatiiviset ajat nolliksi
            odotus(:,2) = (odotus(:,2) > 0).*odotus(:,2);
            % kasvatetaan kulunutta aikaa ja kierrosmaaraa
            time = time + time_step;
            aisle;
            odotus;
            
            % Tama suoritetaan jokaisen while-kierroksen jalkeen:
            varargout{1} = wait_map;
            %
        end
    end
    plane;
    time = time/time_step;
    % Tama suoritetaan jokaisen simulaation jalkeen:
    % ulos saa tavaraaa varargout vektorin avulla:
    
    %
end
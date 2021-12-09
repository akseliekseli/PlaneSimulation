function [time varargout] = planeAnimation(line, seats, rows, varargin)
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
        figure(5)
        hold on
        axis equal
        % Data
        people = plot(0.5, -4.5, 'k.', 'MarkerSize', 20);
        delay = plot(0.5, -4.5, 'r.', 'MarkerSize', 20);
        queue = plot(0.5, -4.5, 'k.', 'MarkerSize', 20);
        queue.XData = zeros(9,1) + 0.5;
        queue.YData = -([1:9] + 3.5);
        txt = "Time = " + num2str(time);
        timer = text(-1, 2, txt, "FontSize", 14);
        % Outer walls
        plot([0 21], [-1 -1], 'k');
        plot([1 21], [-8 -8], 'k');
        % back walls
        plot([21 21], [-1, -4], 'k');
        plot([21 21], [-5 -8], 'k');
        % front walls
        plot([1 21], [-4 -4], 'k');
        plot([1 21], [-5 -5], 'k');
        plot([1 1], [-5 -8], 'k');
        plot([1 1], [-1 -4], 'k');
        plot([0 0], [-8, -5], 'k');
        plot([0 0], [-1, -4], 'k');
        % back
        plot([21 25 25 21], [-1 -3 -6 -8] ,'k');
        % wings
        plot([9 11], [-1 2], 'k')
        plot([13 14], [-1 2], 'k')
        plot([9 11], [-8 -11], 'k')
        plot([13 14], [-8 -11], 'k')
        % Front
        plot(0.5.*([-8:0.01:-1] + 7.7).*([-8:0.01:-1] + 1.3) - 1, [-8:0.01:-1], 'k');
        % Tube
        plot([0 0], [-11, -8], 'b');
        plot([1 1], [-8 -14], 'b');
        plot([0 -5], [-11, -11], 'b');
        plot([1 -5], [-14 -14], 'b');
        quiver(-1, -12.5, -4, 0, 'b>', 'LineWidth', 2)
        drawnow;
        pause(1);
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
            temp = [plane(:,1:seats/2), aisle(:, 1), plane(:,seats/2+1:end)];
            [pcols prows] = find(temp > 0);
            people.XData = pcols + 0.5;
            people.YData = -(prows + 0.5);
            [dcols drows] = find(odotus(:, 1) == 1);
            delay.XData = dcols + 0.5;
            delay.YData = -(drows + 3.5);
            if (length(lineIn(:, 1)) > 9)
                queue.XData = zeros(9,1) + 0.5;
                queue.YData = -([1:9] + 3.5);
            else
                queue.XData = zeros(size(1:length(lineIn(:, 1)))) + 0.5;
                queue.YData = -([1:length(lineIn(:, 1))] + 3.5);
            end
            timer.String = "Time = " + num2str(time);;
            drawnow
            pause(0.05)
            %
        end
        hold off
    end
    plane;
    time = time/time_step;
    % Tama suoritetaan jokaisen simulaation jalkeen:
    % ulos saa tavaraaa varargout vektorin avulla:
    
    %
end
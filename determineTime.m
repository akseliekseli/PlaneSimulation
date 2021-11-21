function wait_time = determineTime(time_step, person, row)
% Laskee ajan istuuntumiselle, riippuen satunnaisuudesta, istumapaikasta ja rivin tayteydesta
    seating_time = 0;

    stowing_time = 0;
    % Satunnainen aika, joka matkatavaroiden laittamiseen kuluu
    % aika-askel - 20*aika_askel
    stowing_time = randi([0, 0*time_step*20]);
    % istuuntumisaika lasketaan esim: seuraavasti
    % et?isyys kaytavasta * aika asekel

    stowing_time = person(3);
    % Istuuntumisaika lasketaan seuraavasti:
    % etaisyys kaytavasta * aika askel

    % Mikali toiset ihmiset ovat edessa:
    % jokainen edessa oleva nousee ja istuuntuu takaisin:
    % + 2 * ylempi (jokaista henkiloa kohden)
    seatsOnSide = length(row)/2;
    % Funktiolla tuotetaan odotusaika, kun edessa olevat ihmiset poistuvat
    % paikaltaan ja palaavat takaisin istumaan:
    % ikkuna = ei estoa, Kaytava = 3, Keskipaikka = 4, Molemmat = 5
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
    % Lasketaan aika mik?? menee istumiseen
    for i = aisle:increment:window
        if (i == person(2))
            % Lopetetaan estavien ihmisten tarkastelu
            break;
        elseif ((row(i) ~= 0))
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
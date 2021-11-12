clc;clearvars;close all;

planeBoarding([30,7,20,1,5,15,10],5,6)

% Ottaa sisään jono-vektorin, kuinka monta riviä on koneessa ja kuinka
% monta penkkiä on rivissä
function time = planeBoarding(line,rows, seat) 
    % setuppia
    time = 0;
    seats = zeros(rows, seat*2);
    aisle = zeros(rows, 2)';

    % Muutetaan vektori 2-dimensioiseksi
    row = ceil(line./seat*2);
    column = mod(line-1,seat*2) +1;
    lineIn = [row; column];
    
    % Main Run: käydään läpi niin kauan kun joko jonossa tai käytävällä on
    % ihmisiä.
    while (any(any(lineIn)) || any(any(aisle)))
        aisle
        %lineIn
        pause
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









%% PlaneAnimation
clc, clearvars, close all
%%%%%%%%%%%%%%%%% Testit %%%%%%%%%%%%%%%%%%%%%%%
tests = [3 5 1 3 2 3];
l = size(tests,1);
ev = [5];
testRes = runTestCase(tests, ev);
disp("Testeista meni lapi: "+ testRes +" / "+ l + " (" + (testRes/l)*100 +"%)")

%%%%%%%%%%%%%%%%% Asetukset %%%%%%%%%%%%%%%%%%%%%
t_step = 1;         % Simulaatiokierroksen aika-askel

seats_in_row = 6;   % Penkkien maara rivilla (parillinen)

rows_in_plane = 20; % Rivien maara koneessa

rand_state = 3;   % Luo simulaation satunnaisuuden valinnan mukaan
                        % 0 = ei satunnaisuutta, aikaa EI kulu laukkujen
                        % laittamiseen
                        % 1 = ei satunnaisuutta, vakioaikainen t ~= 0
                        % 2 = tasajakauma satunnaisuudelle
                        % 3 = betajakauma satunnaisuudelle
                        
const_time = 1*t_step;  % YM vaihtoehdon 1 vakioaika

% asetuksien sisallytys structiin:
settings = struct;
settings.t_step = t_step;
settings.seats_in_row = seats_in_row;
settings.rows_in_plane = rows_in_plane;
settings.rand_state = rand_state;
settings.const_time = const_time;

%%%%%%%%%%%%%%%%%% Jonoasetukset %%%%%%%%%%%%%%%%
% Tanne voi laittaa kaikki koodit, joilla rakennetaan simuloitavat
% tapaukset. 1 SARAKE on simuloitava jono!

% lines = generate_n_random_lines(1, settings);   
lines = generate_back_to_front(1, settings, 4);
% lines = generate_steffen_mod(1, settings);
% lines = generate_steffen_perf(1, settings);
% lines = generate_wma(1, settings);
% lines = flip(generate_back_to_front(1, settings, 4), 1);

%%%%%%%%%%%%%%%%%% Simulaation suoritus %%%%%%%%%
% asetuksien purku
seats = settings.seats_in_row;
rows = settings.rows_in_plane;
t_step = settings.t_step;
rand_state = settings.rand_state;
const_time = settings.const_time;

% Maaritetaan yksiloiden ajankaytto asetuksen mukaan
switch rand_state
    case 1
        rand_times = t_step*const_time.*ones(length(line),1);
    case 2
        rand_times = randi([0, t_step*20], length(line), 1);
    case 3
        % Beta-jakauman parametrit:
        alpha = 2;
        beta = 5;
        absmax = t_step*20;
        %
        rand_times = floor(absmax*betarnd(alpha,beta,length(line),1));
    otherwise
        rand_times = zeros(length(line),1);
end
close all % Figure(1) aukee jostain syyst? s.e. siell? on viiva 0,0 - 1,1
% en loytanyt viela syyta
tic
[times, waittimes] = planeAnimation(lines, seats, rows, t_step, rand_times); % simulaation aloitus
toc

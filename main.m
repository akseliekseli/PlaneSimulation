%% PlaneSimulation
clc, clearvars, close all


%%%%%%%%%%%%%%%%%% Testit %%%%%%%%%%%%%%%%%%%%%%%
tests = [3 5 1 3 2 3];
l = size(tests,1);
ev = [5];
testRes = runTestCase(tests, ev);
disp("Testeista meni lapi: "+ testRes +" / "+ l + " (" + (testRes/l)*100 +"%)")

%%%%%%%%%%%%%%%%% Asetukset %%%%%%%%%%%%%%%%%%%%%
t_step = 1;         % Simulaatiokierroksen aika-askel

seats_in_row = 6;   % Penkkien maara rivilla (parillinen)

rows_in_plane = 20; % Rivien maara koneessa

rand_state = 0;   % Luo simulaation satunnaisuuden valinnan mukaan
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
numberOfSims = 1000;

lines = generate_n_random_lines(numberOfSims, settings);                                   
%%%%%%%%%%%%%%%%%% Simulaation suoritus %%%%%%%%%

tic
[times, waittimes] = simulation(lines, settings);      % simulaation aloitus
toc

simulation_analytics(times, waittimes)

orderline = generate_window_aisle_line([1, 6, 2,5, 3,4], settings);
[time, odotus] = simulation(orderline,...
                               settings);  
time
figure
heatmap(odotus)



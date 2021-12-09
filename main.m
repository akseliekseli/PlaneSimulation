%% PlaneSimulation
clc, clearvars, close all

% TODO:
% wmi satunnaisina järjestyksinä
% Back-to-front 
% Front-to-back 
    % Nämä rivi kerrallaan, random järjestyksessä penkkirivi, myös kolmannes
    % kerrallaan
% https://en.wikipedia.org/wiki/Steffen_Boarding_Method

% Vertailu eri nousujärjestyksistä


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
numberOfSims = 1000;
rand_line= generate_n_random_lines(numberOfSims, settings);
orderwma_line = flip(generate_window_aisle_line(numberOfSims, settings)); % order
btf_line = generate_back_to_front(numberOfSims, settings,4);
stefmod_line = generate_steffen_mod(numberOfSims, settings);
stefperf_line = generate_steffen_perf(numberOfSims, settings);
wma_line = generate_wma(numberOfSims, settings);


%%%%%%%%%%%%%%%%%% Simulaation suoritus %%%%%%%%%

tic
[rand_times, waittimes] = simulation(rand_line, settings);      
toc
[rand_res, figu] = simulation_analytics(rand_times, waittimes, 'Random')

tic
[orderwma_times, waittimes] = simulation(orderwma_line, settings);     
toc
[orderwma_res, figu] = simulation_analytics(orderwma_times, waittimes, 'Order WMA')
figure
xmean = mean(waittimes,3);
xmean = squeeze(xmean);
heatmap(xmean)

tic
[btf_times, waittimes] = simulation(btf_line, settings);      
toc
[btf_res, figu] = simulation_analytics(btf_times, waittimes,'Back-to-Front')

tic
[stefmod_times, waittimes] = simulation(stefmod_line, settings);      
toc
[stefmod_res, figu] = simulation_analytics(stefmod_times, waittimes,'Steffen modified')

tic
[stefperf_times, waittimes] = simulation(stefperf_line, settings);      
toc
[stefperf_res, figu] = simulation_analytics(stefperf_times, waittimes,'Steffen perfect')
  
tic
[wma_times, waittimes] = simulation(wma_line, settings);     
toc
[wma_res, figu] = simulation_analytics(wma_times, waittimes,'Window-Middle-Aisle')
%%

% Yhteinen histogrammi plottaus
figure
histogram(rand_times,20,'FaceAlpha', 0.5)
hold on
histogram(orderwma_times,20,'FaceAlpha', 0.5)
histogram(btf_times,20,'FaceAlpha', 0.5)
histogram(stefmod_times,20,'FaceAlpha', 0.5)
histogram(stefperf_times,20,'FaceAlpha', 0.5)
histogram(wma_times,20,'FaceAlpha', 0.5)
legend('Random','OrderWMA','BTF','Steffen Mod', 'Steffen perfect','WMA')
hold off


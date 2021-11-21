function [times varargout] = simulation(lines, settings)
    % Funktio simulaation ajamiselle annetuilla asetuksilla


    % yksittaisten simulaatioiden ajat sisaltava vektori
    times = [];
    waittimes = [];
    nOfSims = size(lines, 2)
    
    % asetuksien purku
    seats = settings.seats_in_row;
    rows = settings.rows_in_plane;
    t_step = settings.t_step;
    rand_state = settings.rand_state;
    const_time = settings.const_time;
    %
    
    for (i = 1:1:nOfSims)
        % otetaan simuloitava jono irti matriisista
        line = lines(:, i);
        
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
        % otetaan halutut ulostulot yksittaisesta simulaatiosta
        [time odotus] = planeBoarding(line, seats, rows, t_step, rand_times);  % simulaation aloitus
        % asetetaan aika vektoriin
        times(i) = time;
        waittimes(:,:,i) = odotus;
    end
    % Taalta saa kaikeken varargout vektorin kautta pihalle simulaatioiden jalkeen
    varargout{1} = waittimes;
    %
end

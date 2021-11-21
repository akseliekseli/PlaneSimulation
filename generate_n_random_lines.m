function lines = generate_n_random_lines(n, settings)
    % This function generates n different permutations using the settings
    % from settings parameter
    lines = [];
    line = [1:1:settings.seats_in_row*settings.rows_in_plane]';       % generoitu jono

    for (i = 1:n)
        lines(:, end+1) = line(randperm(length(line)));     % Talla komennolla saa
    end                                                     % randomoitua jarjestyksen

end
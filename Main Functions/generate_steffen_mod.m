function lines = generate_steffen_mod(n, settings)
    % This function generates n different permutations using the settings
    % from settings parameter
    % Ordered by having every other row from 1 side at a time.
    lines = [];
    % generate a line 1 - last seat
    temp = [1:1:settings.seats_in_row*settings.rows_in_plane]';
    % convert it into a copy of the plane (seat numbers)
    seats = reshape(temp, settings.seats_in_row, settings.rows_in_plane)';
    % Take every other row from 1 side at a time and convert it into vector
    G1 = reshape(seats(2:2:end, settings.seats_in_row/2+1:end), [], 1);
    G2 = reshape(seats(2:2:end, 1:settings.seats_in_row/2), [], 1);
    G3 = reshape(seats(1:2:end, settings.seats_in_row/2+1:end), [], 1);
    G4 = reshape(seats(1:2:end, 1:settings.seats_in_row/2), [], 1);
    % make n permutations with rows
    for (i = 1:n)
        % Randomize the groups and put them into a single line:
        lines(:, end+1) = [G1(randperm(length(G1)));
                           G2(randperm(length(G2)));
                           G3(randperm(length(G3)));
                           G4(randperm(length(G4)))];
    end
end

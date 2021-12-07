function lines = generate_steffen_perf(n, settings)
    % This function generates n permutations using the settings
    % from settings parameter
    % Ordered by "Steffen Perfect" -boarding method
    lines = [];
    % generate a line 1 - last seat
    temp = [1:1:settings.seats_in_row*settings.rows_in_plane]';
    % convert it into a copy of the plane (seat numbers)
    seats = reshape(temp, settings.seats_in_row, settings.rows_in_plane)';
    % Convert the seats into the perfectly ordered row:
    line = [];
    for (i = 1:settings.seats_in_row/2)
        line = [line; flip(seats(2:2:end, i))];
        line = [line; flip(seats(2:2:end, end - i + 1))];
        line = [line; flip(seats(1:2:end, i))];
        line = [line; flip(seats(1:2:end, end - i + 1))];
    end 
    % make n lines:
    lines = repmat(line, 1, n);
end


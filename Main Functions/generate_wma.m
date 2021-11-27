function lines = generate_wma(n, settings)
    % This function generates n different permutations using the settings
    % from settings parameter
    % Ordered by having random window seats, middle seats and aisle seats in
    % order: w-m-a
    lines = [];
    % generate a line 1 - last seat
    temp = [1:1:settings.seats_in_row*settings.rows_in_plane]';
    % convert it into a copy of the plane (seat numbers)
    seats = reshape(temp, settings.seats_in_row, settings.rows_in_plane)';
    % Take the columns from different sides of the plane:
    groups = [];
    for (i = 1:floor(settings.seats_in_row/2))
        groups(:, end + 1) = [seats(:, i); seats(:, end - i + 1)];
    end
    % make n randomized permutations with the groups:
    for (i = 1:n)
        rand_groups = groups(randperm(size(groups, 1)), :);
        % Put the groups into a single line:
        lines(:, end+1) = [reshape(rand_groups, [], 1)];
    end
end
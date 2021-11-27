function lines = generate_back_to_front(n, settings, subgroups)
    % This function generates n different permutations using the settings
    % from settings parameter
    % Ordered by having groups of n rows at a time 
    % randomly ordered from back to front
    lines = [];
    % generate a line 1 - last seat
    temp = [1:1:settings.seats_in_row*settings.rows_in_plane]';
    % Reshape the plane into n subgropus:
    rows_in_group = floor(settings.rows_in_plane/subgroups);
    ppl_in_group = rows_in_group*settings.seats_in_row;
    groups = [];
    for (i = 1:subgroups)
        if (i == subgroups)
            last_group = temp((i-1)*ppl_in_group+1:end);
        else
            groups(:,end+1) = temp((i-1)*ppl_in_group+1:i*ppl_in_group);
        end
    end
    % make n permutations with rows
    for (i = 1:n)
        % Randomize the group s and put them into a single line:
        % randomize the order of the first n-1 groups
        rand_groups = groups(randperm(size(groups, 1)), :);
        % make them into a line and reverse the order (ftb -> btf):
        rand_groups = flip(reshape(rand_groups, [], 1));
        % create the line:
        lines(:, end+1) = [last_group(randperm(length(last_group)));
                           rand_groups];
    end
    % You can generate Random order by having subgroups == 1
    % flip(lines) or flip(lines, 1) SHOULD give you front to back with same
    % grouping logic...
end
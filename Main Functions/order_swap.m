function lines = order_swap(lines, n, m)
% Changes the position of n - m people at random from each input line
% Changes happen in an order not at the same time. currently. 
% Meaning: if 27 goes to 14, then getting "from" 26 would mean that 25
% changes position.
    for i = (1:size(lines, 2))
        % Take a line from the input (column)
        line = lines(:, i);
        % randomize the positions to be moved
        from = sort(randperm(size(lines, 1), randi([n, m], 1)))
        % randomize the end positions
        to = randperm(size(lines, 1), length(from))
        % move each person: from -> to
        for j = 1:length(from)
            % take the person to be moved
            person = line(from(j));
            % remove them from the line
            line(from(j)) = [];
            if (to(j) == 1)
                % If "to" position is at the end
                line = [person; line(to(j):end)];
            elseif (to(j) == length(line) + 1)
                % if "to" position is at the beginning
                line = [line(1:to(j)); person];
            else
                % otherwise
                line = [line(1:to(j)-1); person; line(to(j):end)];
            end
        end
        % insert the line back into the matrix
        lines(:,i) = line;
    end
end


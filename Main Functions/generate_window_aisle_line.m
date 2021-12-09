function lines = generate_window_aisle_line(n, settings)
    % Generates window-aisle line, where whole column is in order
    lines = [];
    seats = settings.seats_in_row;
    rows = settings.rows_in_plane;
    for ii=1:n
        order = randperm(6);
        line = [];
        for seatcol=order
           column = seatcol:seats:rows*seats-(seats-seatcol);
           line = [line column];
        end
        lines(:,ii) = line;
    end
    
end

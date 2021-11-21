function line = generate_window_aisle_line(order, settings)
    line = [];
    seats = settings.seats_in_row;
    rows = settings.rows_in_plane;
    for seatcol=order
       column = seatcol:seats:rows*seats-(seats-seatcol);
        line = [line column];
    end
    line = line';
end

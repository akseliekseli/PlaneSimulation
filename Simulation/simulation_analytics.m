function [] = simulation_analytics(boardingtimes, waittimes)
    % Make analysis on total boarding times and waittimes
    % Inputs:
    %       boardingtimes: 1 x n vector
    %       waittimes:      rows x seats_in_row x n  3D matrix


    figure
    histogram(boardingtimes)
    title('Random')
    m = mean(boardingtimes);
    subtitle(['Mean: ',num2str(m,'%.2f')])
    toc
                                     % randomoitua jarjestyksen
    figure
    xmean = mean(waittimes,3);
    xmean = squeeze(xmean);
    heatmap(xmean)
end

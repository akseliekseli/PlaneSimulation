function [results, fig] = simulation_analytics(boardingtimes, waittimes, name)
    % Make analysis on total boarding times and waittimes
    % Inputs:
    %       boardingtimes: 1 x n vector
    %       waittimes:      rows x seats_in_row x n  3D matrix
    %       optional figure
    
    
    results = struct()
    results.res_mean = mean(boardingtimes);
    results.str_dev = std(boardingtimes);


    if length(boardingtimes) > 10
        fig = histfit(boardingtimes)
    else
        fig = histogram(boardingtimes,'FaceAlpha', 0.9)
    end
    title(name)
    subtitle(['Mean: ',num2str(results.res_mean,'%.2f')])
    toc
                                     
    figure
    xmean = mean(waittimes,3);
    xmean = squeeze(xmean);
    heatmap(xmean)
    title(name);
end

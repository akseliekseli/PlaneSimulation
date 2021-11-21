function pass = runTestCase(tests, expectedOutcomes)
    % Ottaa sisäänn matriisin testejä
    % Jokainen rivi on yksi testi
    % tests, sisältää planeBoarding parametrit.
    pass = 0;
    for i = 1:size(tests,1)
        pituus = tests(i,1);
        n = pituus + 1;
        param1 = tests(1,2:n);
        param2 = tests(end-1);
        param3 = tests(end);
        time = planeBoarding(param1', param2, param3,1);
        
        if (expectedOutcomes(i) == time)
            pass = pass + 1;
        end
    end
end
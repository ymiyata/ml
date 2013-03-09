n = 100;
max_runs = 10;
optimal = one_max(ones(1, n));
lb = zeros(1, n);
ub = ones(1, n);

%% Randomized Hill Climbing Complete Poll Off

results = struct();

tic;
for run = 1:max_runs
    options = psoptimset ('CompletePoll', 'off');
    input = round(rand(1, n));
    [x, fval, flag, output] = patternsearch(@one_max, input, ...
        [], [],[],[], lb, ub, options);
    
    results(run).x          = x;
    results(run).fval       = fval;
    results(run).evaluation = output.funccount;
    results(run).error      = abs(optimal - fval);
end

fprintf('%%%% Randomized Hill Climbing Complete Poll Off\n');
fprintf('elapsed time: %s\n', num2str(toc));
fprintf('mean f-evals: %s\n', num2str(mean([results.evaluation])));
fprintf('mean f-vals: %s\n',  num2str(-mean([results.fval])));
min_error = min(abs([results.error]));
fprintf('min error: %d\n', min_error);
pause

%% Randomized Hill Climbing Complete Poll On

options = psoptimset ('CompletePoll', 'on');
results = struct();

tic;
for run = 1:max_runs
    input = round(rand(1, n));
    [x, fval, flag, output] = patternsearch(@one_max, input, ...
        [], [],[],[], lb, ub, options);
    
    results(run).x          = x;
    results(run).fval       = fval;
    results(run).evaluation = output.funccount;
    results(run).error      = abs(optimal - fval);
end

fprintf('%%%% Randomized Hill Climbing Complete Poll On\n');
fprintf('elapsed time: %s\n', num2str(toc));
fprintf('mean f-evals: %s\n', num2str(mean([results.evaluation])));
fprintf('mean f-vals: %s\n',  num2str(-mean([results.fval])));
min_error = min(abs([results.error]));
fprintf('min error: %d\n', min_error);
pause

%% Genetic Algorithm

pops = 10:10:100;
p = 1;
n_pop = length(pops);
results = struct();
bestval = Inf;
bestindex = 0;

tic;
for population = pops
    results(p).population = population;
    results(p).xs = {};
    results(p).fval = [];
    results(p).evaluation = [];
    results(p).error = [];
    for run = 1:max_runs
        options = gaoptimset ('PopInitRange', [-20; 20], 'PopulationSize', population, ...
            'PopulationType', 'bitstring');
        [x, fval, flag, output, pop, score] = ga(@one_max, n, options);
        
        results(p).xs{end+1}         = x;
        results(p).fval(end+1)       = fval;
        results(p).evaluation(end+1) = output.funccount;
        results(p).error(end+1)      = abs(optimal - fval);
    end
    results(p).min_error =  min([results(p).error]);
    results(p).avg_evals = mean([results(p).evaluation]);
    results(p).avg_fval  = mean([results(p).fval]);
    results(p).best_fval =  min([results(p).fval]);
    p = p + 1;
end

fprintf('%%%% Genetic Algorithm\n');
fprintf('elapsed time: %s\n', num2str(toc/length(pops)));
fprintf('mean f-evals: %s\n', num2str(mean([results.avg_evals])));
fprintf('mean f-vals:  %s\n', num2str(-mean([results.avg_fval])));
min_error = min([results.min_error]);
fprintf('min error: %d\n', min_error);
pause

fig = figure;
plot(pops, -[results.avg_fval]);
title  'Best Function Values for Four-Peaks';
ylabel 'function values';
xlabel 'population size';
waitfor(fig)

fig = figure;
plot(pops, [results.avg_evals]);
title ('Function evaluations for Four-Peaks');
ylim ([0 max([results.avg_evals])*1.2]);
xlabel ('population size');
waitfor(fig)

%% Simulated Annealing
results = struct();

tic;
for run = 1:max_runs
    options = saoptimset('MaxIter', 4000);
    input = round(rand(1, n));
    [x fval flag output] = simulannealbnd (@one_max, input, lb, ub, options);
    results(run).x = x;
    results(run).fval = fval;
    results(run).error = abs(optimal - fval);
    results(run).evaluation = output.funccount;
end

fprintf('%%%% Simulated Annealing\n');
fprintf('elapsed time: %s\n', num2str(toc));
fprintf('mean f-evals: %s\n', num2str(mean([results.evaluation])));
fprintf('mean f-vals:  %s\n', num2str(-mean([results.fval])));
min_error = min(abs([results.error]));
fprintf('min error: %d\n', min_error);
pause



function [x fval flag output net train_set test_set] = nn_usingsa(n_neuron)
    load glass_dataset

    % Number of neurons
    n = n_neuron;

    % Number of attributes and number of classifications
    [n_attr, sample_size]  = size(glassInputs);
    [n_class, ~] = size(glassTargets);
    
    % Separated into training set and test set (no validation set since
    % simulated annealing function does not have validation option)
    [trainInd, ~, testInd] = dividerand(sample_size, 0.6, 0, 0.4);
    trainInputs = glassInputs(:, trainInd);
    trainTargets = glassTargets(:, trainInd);
    train_set = {trainInputs, trainTargets};
    test_set = {glassInputs(:, testInd), glassTargets(:, testInd)};
    
    % Initialize neural network
    net = feedforwardnet(n);

    % Configure the neural network for this dataset
    net = configure(net, trainInputs, trainTargets); %view(net);

    fun = @(w) mse_test(w, net, trainInputs, trainTargets);

    % Unbounded
    lb = -Inf;
    ub = Inf;

    % Add 'Display' option to display result of iterations
    sa_opts = saoptimset('TolFun', 1e-6); %, 'PlotFcns', {@saplotbestf, @saplotf});

    % There is n_attr attributes in dataset, and there are n neurons so there 
    % are total of n_attr*n input weights (uniform weight)
    initial_il_weights = ones(1, n_attr*n);
    % There are n bias values, one for each neuron (random)
    initial_il_bias    = rand(1, n);
    % There is n_class output, so there are total of n_class*n output weights 
    % (uniform weight)
    initial_ol_weights = ones(1, n_class*n);
    % There are n_class bias values, one for each output neuron (random)
    initial_ol_bias    = rand(1, n_class);
    % starting values
    starting_values = [initial_il_weights, initial_il_bias, ...
                       initial_ol_weights, initial_ol_bias];

    [x, fval, flag, output] = simulannealbnd(fun, starting_values, lb, ub, sa_opts);
end

function mse_calc = mse_test(x, net, inputs, targets)
    % 'x' contains the weights and biases vector
    % in row vector form as passed to it by the
    % genetic algorithm. This must be transposed
    % when being set as the weights and biases
    % vector for the network.

    % To set the weights and biases vector to the
    % one given as input
    net = setwb(net, x');

    % To evaluate the ouputs based on the given
    % weights and biases vector
    y = net(inputs);

    % Calculating the mean squared error (targets could have multiple
    % classification (i.e. targets could be 2 dim) so take sum twice)
    % and divide it by number of entries
    [row col] = size(y);
    mse_calc = sum(sum((y - targets).^2))/(row * col);
end
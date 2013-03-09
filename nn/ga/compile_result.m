function compile_result(n, generate_data)
    if generate_data
        for i = 1:n
            create_results(i);
        end
    end
    fh = fopen('result.txt', 'w');
    sum_funccount = 0;
    sum_train_accuracy = 0;
    sum_test_accuracy = 0;
    for i = 1:n
        mat_filename = sprintf('ga_result%d', i);
        load(mat_filename);
        sum_funccount = sum_funccount + output.funccount;
        sum_train_accuracy = sum_train_accuracy + train_accuracy;
        sum_test_accuracy = sum_test_accuracy + test_accuracy;
    end
    fprintf(fh, 'Avg # of Function Count: %d\n', sum_funccount/n);
    fprintf(fh, 'Avg Training Accuracy:   %d\n', sum_train_accuracy/n);
    fprintf(fh, 'Avg Testing Accuracy:    %d', sum_test_accuracy/n);
    fclose(fh);
end

function create_results(test_number)
    [x fval flag output net train_set test_set] = nn_usingga(3);
    mat_filename = sprintf('ga_result%d', test_number);
    train_accuracy = accuracy(net, x, train_set{1}, train_set{2});
    test_accuracy = accuracy(net, x, test_set{1}, test_set{2});
    save(mat_filename, 'x', 'fval', 'flag', 'output', 'net', ...
        'train_set', 'train_accuracy', 'test_set', 'test_accuracy');
    fprintf('done with result %d\ntrain accuracy: %d\ntest accuracy: %d\n', ...
        test_number, round(train_accuracy*100)/100, round(test_accuracy*100)/100);
end

function percent = accuracy(net, weights, inputs, targets)
    net = setwb(net, weights');
    y = net(inputs);
    [~, n] = size(y);
    n_correct = 0;
    for i = 1:n
        [~, target] = max(targets(:, i));
        [~, hx] = max(y(:, i));
        n_correct = n_correct + all(hx == target);
    end
    percent = n_correct/n * 100;
end
function res = one_max(X)
    % X must be double of between 0 and 1
    if isnumeric(X)
        X = round(X);
    end
    res = -sum(X);
end

function res = tail(b, X)
    res = 0;
    i = length(X);
    while X(i) == b
        res = res + 1;
        i = i - 1;
    end
end

function res = head(b, X)
    res = 0;
    i = 1;
    while X(i) == b
        res = res + 1;
        i = i + 1;
    end
end

function res = R(X, T)
    res = 0;
    if tail(0, X) > T && head(1, X) > T
        res = length(X);
    end
end

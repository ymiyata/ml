function res = four_peaks(X)
    X = abs(X);
    X = round(X./max(X));
    T = round(length(X) * 0.10);
    res = -(max([tail(0, X) head(1, X)]) + R(X, T));
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

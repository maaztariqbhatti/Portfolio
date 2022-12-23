function dtw_matrix = DTW(s, t)
%% Dynamic time wrapping function
%% Returns the distance b/w two time series arrays

n = length(s);
m = length(t);
dtw_matrix = zeros(n+1, m+1);

for i=1:n+1
    for j=1:m+1
        dtw_matrix(i, j) = Inf;
    end
end
dtw_matrix(1, 1) = 0;

for i=2:n+1
    for j=2:m+1
        cost = abs(s(i-1) - t(j-1));
        %take last min from a square box
        last_min = min([dtw_matrix(i-1, j), dtw_matrix(i, j-1), dtw_matrix(i-1, j-1)]);
        dtw_matrix(i, j) = cost + last_min;
    end
end


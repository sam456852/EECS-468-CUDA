function ans = periodicalize(x, numR, numC)
ans = x;
ans(1, :) = x(numR - 1, :);
ans(numR, :) = x(2, :);
ans(:, 1) = x(:,numC - 1);
ans(:, numC) = x(:, 2);
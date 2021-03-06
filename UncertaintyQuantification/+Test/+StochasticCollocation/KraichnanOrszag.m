function KraichnanOrszag(varargin)
  setup;

  sampleCount = 1e2;

  innerTimeStep = 0.01;
  outerTimeStep = 0.1;

  time = outerTimeStep:outerTimeStep:30;
  timeSpan = [0, max(time)];

  stepCount = length(time);

  inputCount = 1;
  outputCount = 3 * stepCount;

  surrogateOptions = Options( ...
    'inputCount', inputCount, ...
    'outputCount', outputCount, ...
    'absoluteTolerance', 1e-2, ...
    'maximalLevel', 20);

  %
  % Brute-force exploration
  %
  z = transpose(linspace(-1, 1, sampleCount));

  Y = zeros(stepCount, 3, sampleCount);

  tic;
  for i = 1:sampleCount
    Y(:, :, i) = solve([1.0, 0.1 * z(i), 0], ...
      timeSpan, innerTimeStep, outerTimeStep);
  end
  fprintf('Computation time of %d samples: %.2f s\n', ...
    sampleCount, toc);

  %
  % Adaptive sparse grid collocation
  %
  target = @(u) solveVector([ones(size(u)), 0.1 * (2 * u - 1), zeros(size(u))], ...
    timeSpan, innerTimeStep, outerTimeStep, outputCount);

  surrogate = StochasticCollocation(surrogateOptions);

  tic;
  surrogateOutput = surrogate.construct(target);
  fprintf('Construction time: %.2f s\n', toc);

  tic;
  surrogateStats = surrogate.analyze(surrogateOutput);
  fprintf('Analysis time: %.2f s\n', toc);

  %
  % The expected value
  %
  figure;

  Plot.title('Expectation');
  Plot.label('Time');
  plotTransient(time, mean(Y, 3));
  plotTransient(time, reshape(surrogateStats.expectation, ...
    [stepCount, 3]), 'LineStyle', '--');

  %
  % The variance
  %
  figure;

  Plot.title('Variance');
  Plot.label('Time');
  plotTransient(time, var(Y, [], 3));
  if ~isempty(surrogateStats.variance)
    plotTransient(time, reshape(surrogateStats.variance, ...
      [stepCount, 3]), 'LineStyle', '--');
  end

  %
  % A stochastic slice
  %
  figure;
  Plot.title('Solution');
  Plot.label('Uncertain parameter');
  while true
    i = randi(stepCount);

    y1 = transpose(squeeze(Y(i, :, :)));

    y2 = surrogate.evaluate(surrogateOutput, (z + 1) / 2);
    y2 = y2(:, [i, stepCount + i, 2 * stepCount + i]);

    plotTransient(z, y1);
    plotTransient(z, y2, 'LineStyle', '--');

    fprintf('Maximal error: %.4e\n', max(abs(y1(:) - y2(:))));

    if input('Enter "y" to genereate another stochastic slice: ', 's') ~= 'y'
      break;
    end
  end

  %
  % A temporal slice
  %
  figure;
  Plot.title('Solution');
  Plot.label('Time');
  while true
    i = randi(sampleCount);

    y1 = Y(:, :, i);

    y2 = surrogate.evaluate(surrogateOutput, (z(i) + 1) / 2);
    y2 = reshape(y2, [stepCount, 3]);

    plotTransient(time, y1);
    plotTransient(time, y2, 'LineStyle', '--');

    fprintf('Maximal error: %.4e\n', max(abs(y1(:) - y2(:))));

    if input('Enter "y" to genereate another temporal slice: ', 's') ~= 'y'
      break;
    end
  end
end

function y = solve(y0, timeSpan, innerTimeStep, outerTimeStep)
  stepCount = timeSpan(end) / innerTimeStep;
  y = rk4(@rightHandSide, y0, timeSpan(1), innerTimeStep, stepCount);
  y = y(1:(outerTimeStep / innerTimeStep):stepCount, :);
end

function Y = solveVector(y0, timeSpan, innerTimeStep, outerTimeStep, outputCount)
  points = size(y0, 1);
  Y = zeros(points, outputCount);
  parfor i = 1:points
    y = solve(y0(i, :), timeSpan, innerTimeStep, outerTimeStep);
    Y(i, :) = transpose(y(:));
  end
end

function dy = rightHandSide(~, y)
  dy = [y(:, 1) .* y(:, 3), - y(:, 2) .* y(:, 3), - y(:, 1).^2 + y(:, 2).^2];
end

function plotTransient(t, y, varargin)
  count = size(y, 2);
  for i = 1:count
    line(t, y(:, i), 'Color', Color.pick(i), varargin{:});
  end
end

function y = rk4(f, y0, t, h, count)
  y = zeros(count, length(y0));
  for k = 1:count
    f1 = feval(f, t      , y0             );
    f2 = feval(f, t + h/2, y0 + (h/2) * f1);
    f3 = feval(f, t + h/2, y0 + (h/2) * f2);
    f4 = feval(f, t + h  , y0 +  h    * f3);
    y0 = y0 + (h/6) * (f1 + 2*f2 + 2*f3 + f4);
    y(k, :) = y0;
    t = t + h;
  end
end

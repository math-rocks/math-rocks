function compare(options, secondOptions)
  if nargin < 2, secondOptions = []; end

  close all;
  setup;

  options = Configure.systemSimulation(options);
  options = Configure.processVariation(options);
  options = Configure.surrogate(options);

  oneMethod = 'MonteCarlo';
  twoMethod = options.fetch('surrogate', 'Chaos');

  analysis = options.fetch('analysis', 'Transient');

  fprintf('Analysis: %s\n', analysis);

  sampleCount = 1e4;

  timeSlice = options.stepCount * options.samplingInterval / 2;
  k = floor(timeSlice / options.samplingInterval);

  one = instantiate(oneMethod, analysis, ...
    options, 'sampleCount', sampleCount);
  two = instantiate(twoMethod, analysis, ...
    options, secondOptions, 'sampleCount', sampleCount);

  [ oneTexp, oneOutput ] = one.compute(options.dynamicPower);

  time = tic;
  fprintf('%s: construction...\n', twoMethod);
  [ twoTexp, twoOutput ] = two.compute(options.dynamicPower);
  fprintf('%s: done in %.2f seconds.\n', twoMethod, toc(time));

  stats = two.computeStatistics(twoOutput);
  display(stats, sprintf('Statistics of %s', twoMethod));

  if ~isfield(twoOutput, 'Tdata') || isempty(twoOutput.Tdata)
    time = tic;
    fprintf('%s: collecting %d samples...\n', twoMethod, sampleCount);
    twoOutput.Tdata = two.sample(twoOutput, sampleCount);
    fprintf('%s: done in %.2f seconds.\n', twoMethod, toc(time));
  end

  if ~isfield(twoOutput, 'Tvar') || isempty(twoOutput.Tvar)
    twoOutput.Tvar = squeeze(var(twoOutput.Tdata, [], 1));
  end

  %
  % Comparison of expectations, variances, and PDFs
  %
  Plot.temperatureVariation({ oneTexp, twoTexp }, ...
     { oneOutput.Tvar, twoOutput.Tvar }, ...
    'time', options.timeLine, 'names', { oneMethod, twoMethod });

  Statistic.compare(Utils.toCelsius(oneOutput.Tdata(:, :, k)), ...
    Utils.toCelsius(twoOutput.Tdata(:, :, k)), ...
    'method', 'smooth', 'range', 'unbounded', ...
    'layout', 'one', 'draw', true, ...
    'names', { oneMethod, twoMethod });

  Statistic.compare( ...
    Utils.toCelsius(oneOutput.Tdata), ...
    Utils.toCelsius(twoOutput.Tdata), ...
    'method', 'histogram', 'range', 'unbounded', ...
    'layout', 'separate', 'draw', true, ...
    'names', { oneMethod, twoMethod });
end

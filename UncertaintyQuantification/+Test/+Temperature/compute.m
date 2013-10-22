function compute(varargin)
  setup;

  options = Configure.systemSimulation(varargin{:});
  options = Configure.processVariation(options);
  options = Configure.surrogate(options);

  surrogate = options.fetch('surrogate', 'Chaos');
  analysis = options.fetch('analysis', 'Transient');
  iterationCount = options.fetch('iterationCount', 1);

  fprintf('Surrogate: %s\n', surrogate);
  fprintf('Analysis: %s\n', analysis);
  fprintf('Running %d iterations...\n', iterationCount);

  surrogate = instantiate(surrogate, analysis, options);

  time = tic;
  for i = 1:iterationCount
    [ Texp, surrogateOutput ] = surrogate.compute(options.dynamicPower);
  end
  fprintf('Average computational time: %.2f s\n', toc(time) / iterationCount);

  display(surrogate.computeStatistics(surrogateOutput), 'Statistics');
  plot(surrogate, surrogateOutput);

  Plot.figure(800, 800);
  subplot(2, 1, 1);
  plot(options.power, options.dynamicPower, 'figure', false);
  subplot(2, 1, 2);
  Plot.temperatureVariation(Texp, surrogateOutput.Tvar, 'time', options.timeLine, ...
    'figure', false, 'layout', 'one');
end

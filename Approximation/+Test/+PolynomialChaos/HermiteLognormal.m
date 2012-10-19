setup;

samples = 1e4;

%% Choose a distribution.
%
distribution = ProbabilityDistribution.Lognormal( ...
  'mu', 0, 'sigma', 0.8);
variables = RandomVariables.Single(distribution);

%% Perform the transformation.
%
transformation = ProbabilityTransformation.SingleNormal(variables);

%% Construct the PC expansion.
%
quadratureOptions = Options('rules', 'GaussHermite', 'level', 10);
chaos = PolynomialChaos.Hermite('order', 6, ...
  'quadratureName', 'Tensor', ...
  'quadratureOptions', quadratureOptions);

display(chaos);

%% Sample the expansion.
%
[ sdExp, sdVar, sdData ] = chaos.sample( ...
  @transformation.evaluateNative, samples);

%% Compare.
%
mcData = distribution.sample(samples, 1);
mcExp = distribution.expectation;
mcVar = distribution.variance;

fprintf('Error of expectation: %.6f %%\n', ...
  100 * (mcExp - sdExp) / mcExp);
fprintf('Error of variance: %.6f %%\n', ...
  100 * (mcVar - sdVar) / mcVar);

compareData(mcData, sdData, ...
  'draw', true, 'method', 'histogram', 'range', 'unbounded', ...
  'labels', {{ 'Monte Carlo', 'Polynomial chaos' }});
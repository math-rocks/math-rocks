function JacobiBetaN1
  setup;

  order = 6;
  sampleCount = 1e5;
  dimensionCount = 4;

  f = @(x) exp(prod(x, 2));

  distribution = ProbabilityDistribution.Beta( ...
    'alpha', 2, 'beta', 2, 'a', -1, 'b', 1);

  samples = distribution.sample(sampleCount, dimensionCount);

  mcData = f(samples);

  pc = PolynomialChaos.Jacobi( ...
    'order', order, ...
    'inputCount', dimensionCount, ...
    'outputCount', 1, ...
    'quadratureOptions', ...
      Options('method', 'tensor', 'order', 5), ...
    'alpha', distribution.alpha - 1, ...
    'beta', distribution.beta - 1, ...
    'a', distribution.a, ...
    'b', distribution.b);
  display(pc);

  pcOutput = pc.expand(f);
  pcData = pc.evaluate(pcOutput, samples);

  assess(mcData, pcData, pcOutput);
end

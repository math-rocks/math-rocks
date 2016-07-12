function JacobiBetaN1
  setup;

  distribution = ProbabilityDistribution.Beta( ...
    'alpha', 2, 'beta', 2, 'a', -1, 'b', 1);

  assess(@(x) exp(prod(x, 2)), ...
    'basis', 'Jacobi', 'inputCount', 4, 'order', 7, ...
    'distribution', distribution, ...
    'quadratureOptions', Options('method', 'sparse'));
end

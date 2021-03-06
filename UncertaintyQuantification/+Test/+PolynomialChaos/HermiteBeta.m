function HermiteBeta
  setup;

  distribution = ProbabilityDistribution.Beta( ...
    'alpha', 1.4, 'beta', 3, 'a', 0, 'b', 2);
  variables = RandomVariables( ...
    'distributions', { distribution }, 'correlation', 1);
  transformation = ProbabilityTransformation.Gaussian( ...
    'variables', variables);

  assess(@transformation.evaluate, ...
    'basis', 'Hermite', 'exact', distribution);
end

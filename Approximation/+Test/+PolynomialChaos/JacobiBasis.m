function JacobiBasis
  setup;

  pc = PolynomialChaos.Jacobi( ...
    'inputCount', 1, ...
    'outputCount', 1, ...
    'order', 5, ...
    'alpha', 2, 'beta', 2, 'a', -1, 'b', 1, ...
    'quadratureOptions', Options( ...
      'method', 'tensor', ...
      'order', 10));
  plot(pc);
end
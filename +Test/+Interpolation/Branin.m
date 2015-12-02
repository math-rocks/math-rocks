function Branin(varargin)
  %
  % Reference:
  %
  % A. Klimke. Sparse Grid Interpolation Toolbox.
  %
  % examples/spadaptdemo.m
  %
  setup;

  pointCount = 33;

  [X, Y] = meshgrid( ...
    linspace(0, 1, pointCount), ...
    linspace(0, 1, pointCount));

  assess(@target, ...
    'support', 'Global', ...
    'basis', 'ChebyshevLagrange', ...
    'inputCount', 2, ...
    'absoluteTolerance', 1e-6, ...
    'relativeTolerance', 1e-2, ...
    'adaptivityDegree', 1, ...
    'plotGrid', { X, Y }, ...
    varargin{:});
end

function z = target(xy)
  x = 15 * xy(:, 1) - 5;
  y = 15 * xy(:, 2);
  z = (5/pi*x-5.1/(4*pi^2)*x.^2+y-6).^2 + 10*(1-1/(8*pi))*cos(x)+10;
end

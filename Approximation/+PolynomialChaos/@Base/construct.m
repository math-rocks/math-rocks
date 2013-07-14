function [ nodes, norm, projection, evaluation, rvPower, rvMap ] = construct(this, options)
  dimension = options.inputCount;
  order = options.order;

  %
  % Construct the RVs.
  %
  for i = 1:dimension
    x(i) = sympoly([ 'x', num2str(i) ]);
  end

  %
  % Compute the multi-indices.
  %
  index = Utils.constructMultiIndex( ...
    dimension, order, [], options.method) + 1;

  %
  % Construct the corresponding multivariate basis functions.
  %
  basis = this.constructBasis(x, order, index);
  terms = length(basis);

  %
  % Now, the quadrature rule.
  %
  [ nodes, weights ] = this.constructQuadrature( ...
    order, options.quadratureOptions);
  points = size(nodes, 1);

  %
  % The projection matrix.
  %
  % A (# of polynomial terms) x (# of integration nodes) matrix.
  %
  projection = zeros(terms, points);

  norm = zeros(terms, 1);

  for i = 1:terms
    f = Utils.toFunction(basis(i), x, 'columns');
    norm(i) = this.computeNormalizationConstant(i, index);
    projection(i, :) = f(nodes) .* weights / norm(i);
  end

  %
  % Construct the overall polynomial with abstract coefficients.
  %
  for i = 1:terms
    a(i) = sympoly([ 'a', num2str(i) ]);
  end

  %
  % Express the polynomial in terms of its monomials.
  %
  % A (# of monomial terms) x (# of stochastic dimensions) matrix
  % of the exponents of each of the RVs in each of the monomials.
  %
  % A (# of monomial terms) x (# of polynomial terms) matrix that
  % maps the PC expansion coefficients to the coefficients of
  % the monomials.
  %
  [ rvPower, rvMap ] = Utils.toMatrix(sum(a .* basis));

  %
  % Compute the evaluation matrix.
  %
  % A (# of quadrature nodes) x (# of monomial terms) matrix
  % that is used to compute the PC expansion at the quadrature nodes.
  %
  nodeCount = size(nodes, 1);
  monomialCount = size(rvPower, 1);

  rvProduct = zeros(nodeCount, monomialCount);
  for i = 1:monomialCount
    rvProduct(:, i) = prod(realpow( ...
      nodes, Utils.replicate(rvPower(i, :), nodeCount, 1)), 2);
  end

  evaluation = rvProduct * rvMap;
end

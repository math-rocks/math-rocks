function assessCovariance(i1, j1, i2, j2)
  basis = HierarchicalBasis.NewtonCotesHat.Local;

  validate(basis, i1, j1);
  validate(basis, i2, j2);

  compare('Covariance', ...
    deriveCovariance(basis, i1, j1, i2, j2), ...
    estimateCovariance(basis, i1, j1, i2, j2));
end
function construct(this, options)
  inputCount = options.get('inputCount', 1);

  verbose = @(varargin) [];
  if options.get('verbose', false)
    verbose = @(varargin) fprintf(varargin{:});
  end

  %
  % Deciding about the input data.
  %
  if options.has('nodes')
    nodes = options.nodes;
    nodeCount = size(nodes, 1);
  else
    nodeCount = options.get('nodeCount', 10 * inputCount);
    nodes = lhsdesign(nodeCount, inputCount);
  end

  %
  % Deciding about the output data.
  %
  if options.has('responses')
    responses = options.responses;
  else
    target = options.target;
    verbose('Gaussian process: collecting data (%d nodes)...\n', nodeCount);
    time = tic;
    responses = target(nodes);
    verbose('Gaussian process: done in %.2f seconds.\n', toc(time));
  end

  kernel = options.kernel;
  parameters = options.get('parameters', []);
  lowerBound = options.get('lowerBound', []);
  upperBound = options.get('upperBound', []);
  startCount = options.get('startCount', 1);

  verbose('Gaussian process: processing the data (%d inputs, %d outputs)...\n', ...
    inputCount, size(responses, 2));
  time = tic;

  %
  % Normalize the data.
  %
  nodeMean = mean(nodes);
  nodeDeviation = std(nodes);

  responseMean = mean(responses);
  responseDeviation = std(responses);

  nodes = (nodes - repmat(nodeMean, nodeCount, 1)) ./ ...
    repmat(nodeDeviation, nodeCount, 1);
  responses = (responses - repmat(responseMean, nodeCount, 1)) ./ ...
    repmat(responseDeviation, nodeCount, 1);

  %
  % Optimize the parameters.
  %
  if ~isempty(lowerBound) || ~isempty(upperBound)
    parameters = optimize(nodes, responses, kernel, ...
      parameters, lowerBound, upperBound, startCount);
  end

  %
  % Compute correlations between the nodes.
  %
  I = constructPairIndex(nodeCount);
  K = kernel(nodes(I(:, 1), :)', nodes(I(:, 2), :)', parameters);
  K = constructSymmetricMatrix(K, I);

  %
  % Compute the multiplier of the mean of the posterior.
  %
  inverseK = inv(K);
  inverseKy = inverseK * responses;

  verbose('Gaussian process: done in %.2f seconds.\n', toc(time));

  %
  % Save everything.
  %
  this.nodeMean = nodeMean;
  this.nodeDeviation = nodeDeviation;

  this.responseMean = responseMean;
  this.responseDeviation = responseDeviation;

  this.nodes = nodes;
  this.kernel = kernel;
  this.parameters = parameters;

  this.inverseK = inverseK;
  this.inverseKy = inverseKy;
end
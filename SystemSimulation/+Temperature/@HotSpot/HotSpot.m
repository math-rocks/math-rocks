classdef HotSpot < handle
  properties (SetAccess = 'private')
    %
    % The number of active nodes
    %
    processorCount

    %
    % The number of thermal nodes
    %
    nodeCount

    %
    % The sampling interval
    %
    samplingInterval

    %
    % The ambient temperature
    %
    ambientTemperature

    %
    % The capacitance vector
    %
    capacitance

    %
    % The conductance matrix
    %
    conductance

    %
    % The leakage model
    %
    leakage
  end

  methods
    function this = HotSpot(varargin)
      options = Options(varargin{:});

      if options.has('die')
        floorplan = options.die.filename;
      elseif options.has('floorplan');
        floorplan = options.floorplan;
      else
        assert(false);
      end

      config = options.config;
      line = options.get('line', '');

      if ~File.exist(floorplan)
        error('The floorplan file does not exist.');
      end

      if ~File.exist(config)
        error('The configuration file does not exist.');
      end

      [ this.capacitance, this.conductance, this.nodeCount, ...
        this.processorCount, this.samplingInterval, this.ambientTemperature ] = ...
        Temperature.HotSpot.constructModel(floorplan, config, line);

      this.leakage = options.get('leakage', []);
    end

    function display(this)
      fprintf('%s:\n', class(this));
      fprintf('  Processing elements: %d\n', this.processorCount);
      fprintf('  Thermal nodes:       %d\n', this.nodeCount);
      fprintf('  Sampling interval:   %.2e s\n', this.samplingInterval);
      fprintf('  Ambient temperature: %.2f C\n', ...
        Utils.toCelsius(this.ambientTemperature));

      if isempty(this.leakage), return; end

      fprintf('  Leakage model:       %s\n', class(this.leakage));
    end

    function string = toString(this)
      string = sprintf('%s(processors %d, nodes %d, sampling %.2e, ambient %.2f, leakage %s)', ...
        class(this), this.processorCount, this.nodeCount, ...
        this.samplingInterval, this.ambientTemperature, ...
        Utils.toString(this.leakage));
    end
  end

  methods (Abstract)
    [ T, output ] = compute(this, Pdyn, varargin)
  end

  methods (Static, Access = 'private')
    varargout = constructModel(varargin)
  end
end

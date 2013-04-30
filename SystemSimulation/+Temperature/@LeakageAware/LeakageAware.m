classdef LeakageAware < Temperature.HotSpot
  properties (SetAccess = 'private')
    %
    % The leakage model
    %
    leakage
  end

  methods
    function this = LeakageAware(varargin)
      options = Options(varargin{:});

      this = this@Temperature.HotSpot(options);

      this.leakage = options.get('leakage', []);
    end

    function [ T, output ] = compute(this, Pdyn, varargin)
      if isempty(this.leakage)
        T = computeWithoutLeakage(this, Pdyn, varargin{:});
      else
        [ T, output ] = computeWithLeakage(this, Pdyn, varargin{:});
      end
    end

    function T = computeWithoutLeakage(this, Pdyn, varargin)
      error('Not implemented yet.');
    end

    function [ T, output ] = computeWithLeakage(this, Pdyn, varargin)
      error('Not implemented yet.');
    end
  end
end
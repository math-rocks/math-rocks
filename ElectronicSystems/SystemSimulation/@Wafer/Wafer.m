classdef Wafer < handle
  properties (SetAccess = 'private')
    rowCount
    columnCount

    floorplan
    width
    height
    radius

    die

    dieCount
    processorCount
  end

  methods
    function this = Wafer(varargin)
      options = Options('rowCount', 20, 'columnCount', 20, varargin{:});
      this.construct(options);
    end

    function string = toString(this)
      string = sprintf('%s(%s)', class(this), ...
        String(struct( ...
          'dieCount', this.dieCount, ...
          'processorCount', this.processorCount)));
    end
  end

  methods (Access = 'private')
    construct(this, options)
  end
end

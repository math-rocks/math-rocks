vendors=Chebfun CustomizableHeatMaps DACE DataHash SANDIA_RULES SANDIA_SPARSE

all: $(vendors)

$(vendors):
	$(MAKE) -C $@ all

.PHONY: all $(vendors)

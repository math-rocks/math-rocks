all: Chebfun CustomizableHeatMaps DACE DataHash

Chebfun:
	curl http://www.chebfun.org/download/chebfun_v4.3.2987.zip -O
	unzip chebfun_v4.3.2987.zip
	mv chebfun Cheb
	mv Cheb Chebfun

CustomizableHeatMaps:
	curl http://www.mathworks.com/matlabcentral/fileexchange/downloads/514540/akamai/heatmaps.zip -O
	unzip heatmaps.zip -d CustomizableHeatMaps
	mv CustomizableHeatMaps/heatmaps/* CustomizableHeatMaps/

DACE:
	curl http://www.imm.dtu.dk/~hbni/dace/imm1460.zip -O
	unzip imm1460.zip -d DACE
	mv DACE/dace/* DACE/

DataHash:
	curl http://www.mathworks.com/matlabcentral/fileexchange/downloads/376978/akamai/DataHash_20120627.zip -O
	unzip DataHash_20120627.zip -d DataHash

.PHONY: all

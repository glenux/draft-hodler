
all: build

build: bin/hodler

bin/hodler: $(wildcard src/*.cr)
	shards build hodler

completion: bin/hodler
	$< --completion --development


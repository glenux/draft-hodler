
BINARIES=hodler
hodler_FILES=$(wildcard src/*.cr src/**/*.cr)

all: build

build: ## Build binaries

clean:  ## Clean binaries

.PHONY: clean build all

## Add targets for crystal
include tasks/crystal.mk


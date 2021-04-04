
BINARIES=hodlerctl hodlertui hodlerweb

lib_FILES=$(wildcard src/lib/*.cr src/lib/**/*.cr)
hodlerctl_FILES=$(wildcard src/hodlerctl/*.cr src/hodlerctl/**/*.cr) $(lib_FILES)
hodlertui_FILES=$(wildcard src/hodlertui/*.cr src/hodlertui/**/*.cr) $(lib_FILES)
hodlerweb_FILES=$(wildcard src/hodlerweb/*.cr src/hodlerweb/**/*.cr) $(lib_FILES)

all: build

build: ## Build binaries

clean:  ## Clean binaries

.PHONY: clean build all

## Add targets for crystal
include tasks/crystal.mk


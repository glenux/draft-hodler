
define BINARY_template
ALL_FILES += $($(1)_FILES)

build: build-$(1)
build-$(1): bin/$(1)

bin/$(1): $($(1)_FILES)
	shards build $(1)

clean: clean-$(1)
clean-$(1): 
	rm -f bin/$(1)
endef

$(foreach binary,$(BINARIES),$(eval $(call BINARY_template,$(binary))))

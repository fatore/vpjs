LOCALE ?= en_US

APP = vp

GENERATED_FILES = \
	$(APP).js \
	$(APP).min.js \
	component.json

all: $(GENERATED_FILES)

.PHONY: clean all test

test:
	@npm test

$(APP).js: $(shell node_modules/.bin/smash --list src/$(APP).js) package.json
	@rm -f $@
	node_modules/.bin/smash src/$(APP).js | node_modules/.bin/uglifyjs - -b indent-level=2 -o $@
	@chmod a-w $@

$(APP).min.js: $(APP).js
	@rm -f $@
	node_modules/.bin/uglifyjs $< -c -m -o $@

component.json: bin/component $(APP).js package.json
	@rm -f $@
	bin/component > $@
	@chmod a-w $@

clean:
	rm -f -- $(GENERATED_FILES)

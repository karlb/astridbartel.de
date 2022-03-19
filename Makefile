build: $(patsubst source/%,build/%,$(shell find source -type f))

clean:
	rm -fr build

build/%.html: source/%.html header.html
	@mkdir -p $(dir $@)
	cat header.html $< > $@

build/%: source/%
	cp $< $@

# dev helpers
watch:
	find source header.html | entr make

serve:
	python -m http.server -d build

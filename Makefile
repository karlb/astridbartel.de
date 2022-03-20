build: $(patsubst source/%,build/%,$(shell find source -type f))

clean:
	rm -fr build

build/%.html: source/%.html header.html
	@mkdir -p $(dir $@)
	cat header.html $< > $@

build/%: source/%
	cp $< $@

# Deploy to gh-pages branch according to
# https://sangsoonam.github.io/2019/02/08/using-git-worktree-to-deploy-github-pages.html
deploy:
	git worktree add public_html gh-pages
	cp -rf build/* public_html
	cd public_html && \
	  git add --all && \
	  git commit -m "Deploy to github pages" && \
	  git push origin gh-pages
	git worktree remove public_html

# dev helpers
watch:
	find source header.html | entr make

serve:
	python -m http.server -d build

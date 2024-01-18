build: $(patsubst source/%,build/%,$(shell find source -type f))

clean:
	rm -fr build

build/%.html: source/%.html header.html Makefile
	@mkdir -p $(dir $@)
	sed -E 's|(href="$(subst source,,$<))|class="current" \1|' header.html | cat - $< > $@

build/%: source/%
	cp $< $@

# Deploy to gh-pages branch according to
# https://sangsoonam.github.io/2019/02/08/using-git-worktree-to-deploy-github-pages.html
deploy:
	git worktree add public_html gh-pages
	cp -rf build/* build/.nojekyll public_html
	cd public_html && \
	  git add --all && \
	  git commit -m "Deploy to github pages" && \
	  git push origin gh-pages
	git worktree remove public_html

# dev helpers
watch:
	find source header.html Makefile | entr make

serve:
	python -m http.server -d build

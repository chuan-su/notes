PORT=3000

.PHONY: init
init:
	docker run --rm -v $(shell pwd):/data -it hrektts/mdbook mdbook init

.PHONY: build
build:
	docker run --rm -v "$(shell pwd)":/data -it hrektts/mdbook mdbook build

.PHONY: serve
serve:
	docker run --name mdbook --rm -p ${PORT}:3000 -p 3001:3001 -v $(shell pwd):/data -it hrektts/mdbook mdbook serve -p 3000 -n 0.0.0.0

.PHONY: stop
stop:
	docker stop mdbook

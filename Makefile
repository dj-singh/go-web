PROJECT = github.com/joshgav/go-web

REGISTRY = joshgav
REPO = go-web
TAG = latest

PORT = 8080
IMAGE = $(REGISTRY)/$(REPO):$(TAG)
C = $(REPO)-tester
HOST = localhost:$(PORT)

binary:
	mkdir -p out
	go build -o out/server .
	./out/server &
	curl http://$(HOST)/?name=josh && echo ""
    # TODO: get PID on creation with $! and use with `kill`
	pkill --euid $(USER) --newest --exact server

container:
	@docker build -t $(IMAGE) .
	@docker push $(IMAGE)
	docker run -d --rm \
		--name $C \
		--publish "$(PORT):8080" \
		$(IMAGE)
	curl "http://$(HOST)/?name=josh" && echo ""
	@docker container logs $C
	@docker container stop $C
	@echo "start a new container with"
	@echo "    \`docker run [-d|-it] -p $(PORT):8080 $(IMAGE)\`"

.PHONY: binary container

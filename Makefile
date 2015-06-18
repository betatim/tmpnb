# Configuration parameters
CULL_PERIOD ?= 30
CULL_TIMEOUT ?= 60
LOGGING ?= debug
POOL_SIZE ?= 3

tmpnb-image: Dockerfile
	docker build -t jupyter/tmpnb .

images: tmpnb-image demo-image minimal-image

minimal-image:
	docker pull jupyter/minimal

demo-image:
	docker pull jupyter/demo

proxy-image:
	docker pull jupyter/configurable-http-proxy

proxy: proxy-image
	docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=devtoken \
		--name=proxy \
		jupyter/configurable-http-proxy \
		--default-target http://127.0.0.1:9999

tmpnb: minimal-image tmpnb-image
	docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=devtoken \
		--name=tmpnb \
		-v /var/run/docker.sock:/docker.sock jupyter/tmpnb python orchestrate.py \
		--image=jupyter/minimal --cull_timeout=$(CULL_TIMEOUT) --cull_period=$(CULL_PERIOD) \
		--logging=$(LOGGING) --pool_size=$(POOL_SIZE)

dev: cleanup proxy tmpnb

cleanup:
	-docker ps -a | grep "proxy" | awk '{print $$1}' | xargs docker stop
	-docker ps -a | grep "proxy" | awk '{print $$1}' | xargs docker rm
	-docker ps -a | grep "tmpnb" | awk '{print $$1}' | xargs docker stop
	-docker ps -a | grep "tmpnb" | awk '{print $$1}' | xargs docker rm
	-docker ps -a | grep "jupyterminimal" | awk '{print $$1}' | xargs docker stop
	-docker ps -a | grep "jupyterminimal" | awk '{print $$1}' | xargs docker rm
#-docker images -q --filter "dangling=true" | xargs docker rmi

log-tmpnb:
	docker logs -f tmpnb

log-proxy:
	docker logs -f proxy

.PHONY: cleanup

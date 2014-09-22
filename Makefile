all: build

build:
	@docker build --tag=${USER}/apt-cacher-ng .

all: build

build:
	@docker build --tag=sameersbn/apt-cacher-ng .

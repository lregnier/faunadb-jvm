RUNTIME_IMAGE ?= openjdk:8-slim
DOCKER_RUN_FLAGS = -it --rm

ifdef FAUNA_ROOT_KEY
DOCKER_RUN_FLAGS += -e FAUNA_ROOT_KEY=$(FAUNA_ROOT_KEY)
endif

ifdef FAUNA_DOMAIN
DOCKER_RUN_FLAGS += -e FAUNA_DOMAIN=$(FAUNA_DOMAIN)
endif

ifdef FAUNA_SCHEME
DOCKER_RUN_FLAGS += -e FAUNA_SCHEME=$(FAUNA_SCHEME)
endif

ifdef FAUNA_PORT
DOCKER_RUN_FLAGS += -e FAUNA_PORT=$(FAUNA_PORT)
endif

ifdef FAUNA_TIMEOUT
DOCKER_RUN_FLAGS += -e FAUNA_TIMEOUT=$(FAUNA_TIMEOUT)
endif

test:
	sbt test

jenkins-test:
	sbt clean
	sbt test
	sbt publishLocal

docker-wait:
	dockerize -wait $(FAUNA_SCHEME)://$(FAUNA_DOMAIN):$(FAUNA_PORT)/ping -timeout $(FAUNA_TIMEOUT)

docker-test:
	docker build -f Dockerfile.test -t faunadb-jvm-test:latest --build-arg RUNTIME_IMAGE=$(RUNTIME_IMAGE) .
	docker run $(DOCKER_RUN_FLAGS) faunadb-jvm-test:latest

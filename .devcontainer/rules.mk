CONTAINER_DIR      ?= .devcontainer
WORK_DIR           ?= $(shell pwd)/..
USERNAME           ?= testuser
USER_UID           ?= 1000
USER_GID           ?= 1000

IMAGE_NAME         ?= virttas-thesis
CONTAINER_NAME     ?= $(IMAGE_NAME)-$(USERNAME)-$(shell date +"%Y-%m-%d.%H-%M")
DOCKER_FILE        ?= $(CONTAINER_DIR)/Dockerfile
DOCKER_ENTRYPOINT  ?= $(CONTAINER_DIR)/docker-entrypoint.sh
SHARED_DIRS        ?= $(WORK_DIR)

DOCKER_HTTP_PROXY  ?= 
DOCKER_HTTPS_PROXY ?=
DOCKER_NO_PROXY    ?= 

HELP_MSG           += \trun-container                 Run\
		      a container from the ${IMAGE_NAME} image \n
HELP_MSG           += \tbuild-image                   Build\
		      the docker images ${IMAGE_NAME} with the required dependencies\n
HELP_MSG           += \tclean-image                   Remove\
		      the docker image ${IMAGE_NAME}\n

DIRECTORIES        := $(CONTAINER_DIR)/directories
BUILD_IMAGE        := $(CONTAINER_DIR)/build-image 

directories: $(DIRECTORIES)

$(DIRECTORIES):
	$(foreach dir, $(SHARED_DIRS), mkdir -p $(dir);)
	@touch $@


build-image: $(BUILD_IMAGE) 

$(BUILD_IMAGE): $(DOCKER_FILE) $(DOCKER_SCRIPTS)
	@docker build -t $(IMAGE_NAME)                                 \
		--build-arg ARG_DOCKER_ENTRYPOINT=$(DOCKER_ENTRYPOINT) \
		--file $(DOCKER_FILE) .
	@touch $@


run-container: $(BUILD_IMAGE) $(DIRECTORIES)
	@docker run --interactive --tty --rm            \
                --name $(CONTAINER_NAME)                \
                --env USERNAME=$(USERNAME)              \
                --env USER_UID=$(USER_UID)              \
                --env USER_GID=$(USER_GID)              \
                --env WORK_DIR=$(WORK_DIR)              \
                --env HTTP_PROXY=$(DOCKER_HTTP_PROXY)   \
                --env HTTPS_PROXY=$(DOCKER_HTTPS_PROXY) \
                $(foreach dir, $(SHARED_DIRS), -v $(dir):$(dir)) \
                $(IMAGE_NAME)

clean-image:
	@docker rmi --force $(IMAGE_NAME)
	@rm -rf $(BUILD_IMAGE)
	@rm -rf $(DIRECTORIES)

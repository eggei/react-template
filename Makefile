config ?= docker.config.env
include $(config)
export $(shell sed 's/=.*//' $(config))

all:
	@echo ==================================================
	@echo
	@echo TASK LIST:
	@echo - "make docker-build"
	@echo - "make docker-run"
	@echo - "make docker-stop"
	@echo
	@echo ==================================================

###############
# DOCKER TASKS#
###############

# Build the container
docker-build:
	@echo Starting docker build...
	docker build -t $(CONTAINER_TAG) ./
	@echo ==================================================
	@echo
	@echo Done! - \"make docker-run\" to run this container
	@echo
	@echo ==================================================


RUNNING_CONTAINER := $(shell docker ps -f name=$(CONTAINER_NAME) | grep -w $(CONTAINER_NAME))
STOPPED_CONTAINER := $(shell docker ps -a -f name=$(CONTAINER_NAME) | grep -w $(CONTAINER_NAME))

docker-run:
# If there is no running container with same name
ifeq ($(strip $(RUNNING_CONTAINER)),)

  # and if there isn no stopped container with same name
  ifeq ($(strip $(STOPPED_CONTAINER)),)
	@echo ==================================================
	@echo
	@echo Running the container...
	@echo Container ID: `docker run -d --name $(CONTAINER_NAME) -p $(CONTAINER_PORT):80 $(CONTAINER_TAG)`
	@echo Container \"$(CONTAINER_NAME)\" is running on \"localhost:8000\"
	@echo
	@echo ==================================================
  else
  # If there is no running container but there is a stopped container with same name  
	@echo ==================================================
	@echo
	@echo Running the container...
	@echo "Container \"`docker start $(CONTAINER_NAME)`\" is running on \"localhost:8000\""
	@echo
	@echo ==================================================
  endif

else
# If there is a running container with the same name
	@echo ==================================================
	@echo
	@echo There is a container running with the same name \"$(CONTAINER_NAME)\"
	@echo Try visiting localhost:$(CONTAINER_PORT)
	@echo
	@echo ==================================================
endif

docker-stop:
	@echo ==================================================
	@echo
	@echo Stopping the container...
	@echo Container \"`docker stop $(CONTAINER_NAME)`\" is stopped
	@echo
	@echo "=================================================="

.PHONY: docker-build docker-start docker-stop
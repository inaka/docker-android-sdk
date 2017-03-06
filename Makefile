
.PHONY: all compile clean clean-all test eunit ct up down attach
.PHONY: dkr-build dkr-push


##== Settings =============================================================


DOCKER         ?= $(shell which docker)
COMPOSE        ?= $(shell which docker-compose)

DKR_REGISTRY   ?= inakaops
DKR_IMAGE      ?= android-sdk
DKR_TAG        ?= 25.2.3

DKR_BUILD_OPTS ?= -t $(DKR_REGISTRY)/$(DKR_IMAGE):$(DKR_TAG)


##== Targets ==============================================================


##== Operations ===========================================================


##-- Build ----------------------------------------------------------------


build: ## Build docker image
	$(DOCKER) build $(DKR_BUILD_OPTS) .

publish: ## Publish docker image to the provided container registry
	$(DOCKER) push $(DKR_REGISTRY)/$(DKR_IMAGE):$(DKR_TAG)


##-- Test -----------------------------------------------------------------

##-- Clean up -------------------------------------------------------------


down:
	docker compose down

build:
	docker compose build

build-all:
	docker compose build --no-cache

up:
	docker compose up


# THESE COMMANDS WILL HELP GENERATE THE CLIENTS FOR THE SERVICES IN EACH LANGUAGE

# SOME VARIABLES TO MAKE IT EASIER

OPENAPI_GENERATE := npx --yes @openapitools/openapi-generator-cli@2.13.5 generate
OPENAPI_CONTRACTS := contracts/openapi
OPENAPI_CLIENTS := packages/clients
OPENAPI_SERVICES := crawler


openapi-generate-python: $(OPENAPI_SERVICES:%=openapi-generate-python-%)
openapi-generate-go: $(OPENAPI_SERVICES:%=openapi-generate-go-%)

# THIS WILL GENERATE PYTHON CLIENTS
openapi-generate-python-%:
	$(OPENAPI_GENERATE) -i $(OPENAPI_CONTRACTS)/$*.yaml -g python -o $(OPENAPI_CLIENTS)/python/$*-client -p "packageName=$*_client,projectName=$*-client,packageVersion=0.1.0"

# AND THIS WILL GENERATE GO CLIENTS
openapi-generate-go-%:
	$(OPENAPI_GENERATE) -i $(OPENAPI_CONTRACTS)/$*.yaml -g go -o $(OPENAPI_CLIENTS)/go/$*-client -p "packageName=$*client,moduleName=whatsapp-commerce/packages/generated-clients/go/$*-client"


# GENERATE ALLL
openapi-generate: openapi-generate-python openapi-generate-go

run:
	make openapi-generate
	make up
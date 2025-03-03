DOMAIN = fgl-smartbuilding
DOMAIN_OWNER = 137650815672
REGION = us-west-2
TOKEN := $(shell aws codeartifact get-authorization-token \
	--domain ${DOMAIN} --domain-owner ${DOMAIN_OWNER} \
	--query authorizationToken --output text)
NAMESPACE = numgenius-dev
PACKAGE_NAME = numgenius
PACKAGE_VERSION := $(shell poetry version | cut -d' ' -f2)
PACKAGE_FILE = ${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz
GENERIC_REPO_NAME = generic-private-repository
PYTHON_REPO_NAME = python-private-repository
POETRY_SOURCE = aws
POETRY_SOURCE_URL_PUBLISH = https://${DOMAIN}-${DOMAIN_OWNER}.d.codeartifact.${REGION}.amazonaws.com/pypi/${PYTHON_REPO_NAME}/
POETRY_SOURCE_URL_CONSUME = https://${DOMAIN}-${DOMAIN_OWNER}.d.codeartifact.${REGION}.amazonaws.com/pypi/${PYTHON_REPO_NAME}/simple/
POETRY_HTTP_BASIC_USERNAME = ${POETRY_SOURCE}
POETRY_HTTP_BASIC_PASSWORD := ${TOKEN}

login-pip:
	@echo "Logging in to CodeArtifact with pip"
	@aws codeartifact login --tool pip \
		--domain ${DOMAIN} --domain-owner ${DOMAIN_OWNER} \
		--repository ${PYTHON_REPO_NAME}

poetry-config:
	@echo "Configuring Poetry to publish packages to the python private repository"
	@poetry config repositories.${POETRY_SOURCE} ${POETRY_SOURCE_URL_PUBLISH}
	@poetry config http-basic.${POETRY_SOURCE} ${POETRY_HTTP_BASIC_USERNAME} ${POETRY_HTTP_BASIC_PASSWORD}

poetry-source-add:
	@echo "Configuring Poetry to consume packages from the python private repository"
	@poetry source add --priority=supplemental ${POETRY_SOURCE} ${POETRY_SOURCE_URL_CONSUME}

codeartifact-publish:
	@echo "Publishing the app to CodeArtifact as a generic package"
	@aws codeartifact publish-package-version \
        --domain ${DOMAIN} --repository ${GENERIC_REPO_NAME} --region ${REGION} --format generic --namespace ${NAMESPACE} \
        --package ${PACKAGE_NAME} --package-version ${PACKAGE_VERSION} \
        --asset-content ./dist/${PACKAGE_FILE} --asset-name ${PACKAGE_FILE} \
		--asset-sha256 $(shell cd ./dist; shasum -a 256 ${PACKAGE_FILE} | awk '{print $$1;}')

codeartifact-get-package:
	@echo "Getting the app version asset from CodeArtifact"
	@read -p "Enter the package version: " PACKAGE_VERSION; \
	PACKAGE_FILE=${PACKAGE_NAME}-$$PACKAGE_VERSION.tar.gz; \
	aws codeartifact get-package-version-asset \
		--domain ${DOMAIN} --repository ${GENERIC_REPO_NAME} --region ${REGION} --format generic --namespace ${NAMESPACE} \
		--package ${PACKAGE_NAME} --package-version $$PACKAGE_VERSION \
		--asset $$PACKAGE_FILE $$PACKAGE_FILE; \
	tar -xf $$PACKAGE_FILE; \
	rm -rf $$PACKAGE_FILE

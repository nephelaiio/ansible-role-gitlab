.PHONY: ${MAKECMDGOALS}

MOLECULE_SCENARIO ?= default
MOLECULE_DOCKER_IMAGE ?= ubuntu2004
GITHUB_REPOSITORY ?= $$(git config --get remote.origin.url | cut -d':' -f 2 | cut -d. -f 1)
GITHUB_ORG = $$(echo ${GITHUB_REPOSITORY} | cut -d/ -f 1)
GITHUB_REPO = $$(echo ${GITHUB_REPOSITORY} | cut -d/ -f 2)

install:
	@poetry install --no-root

lint: install
	poetry run yamllint .
	poetry run ansible-lint -- . --exclude roles --exclude .ansible/

dependency create prepare converge idempotence side-effect verify destroy login reset:
	MOLECULE_DOCKER_IMAGE=${MOLECULE_DOCKER_IMAGE} \
	MOLECULE_DOCKER_COMMAND=${MOLECULE_DOCKER_COMMAND} \
		poetry run molecule $@ -s ${MOLECULE_SCENARIO}

test: install
	MOLECULE_KVM_IMAGE=${MOLECULE_KVM_IMAGE} \
	MOLECULE_DOCKER_COMMAND=${MOLECULE_DOCKER_COMMAND} \
	MOLECULE_DOCKER_IMAGE=${MOLECULE_DOCKER_IMAGE} \
	poetry run molecule $@ -s ${MOLECULE_SCENARIO}

ignore:
	poetry run ansible-lint --generate-ignore

clean: destroy reset
	@poetry env remove $$(which python) >/dev/null 2>&1 || exit 0

publish:
	@echo publishing repository ${GITHUB_REPOSITORY}
	@echo GITHUB_ORGANIZATION=${GITHUB_ORG}
	@echo GITHUB_REPOSITORY=${GITHUB_REPO}
	@poetry run ansible-galaxy role import \
		--api-key ${GALAXY_API_KEY} ${GITHUB_ORG} ${GITHUB_REPO}

version:
	@poetry run molecule --version

debug: version
	@poetry export --dev --without-hashes || exit 0

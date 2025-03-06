CONTAINER_RUNTIME ?= podman

ZEITGEIST_VERSION = v0.5.4
SHFMT_VERSION := v3.11.0
SHELLCHECK_VERSION := v0.10.0
MDTOC_VERSION := v1.4.0

BUILD_DIR := build
ZEITGEIST := $(BUILD_DIR)/zeitgeist
SHFMT := $(BUILD_DIR)/shfmt
SHELLCHECK := $(BUILD_DIR)/shellcheck
MDTOC := $(BUILD_DIR)/mdtoc

define curl_to
    curl -sSfL --retry 5 --retry-delay 3 "$(1)" -o $(2)
endef

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

$(ZEITGEIST): $(BUILD_DIR)
	$(call curl_to,https://storage.googleapis.com/k8s-artifacts-sig-release/kubernetes-sigs/zeitgeist/$(ZEITGEIST_VERSION)/zeitgeist-amd64-linux,$(ZEITGEIST))
	chmod +x $(ZEITGEIST)

$(SHFMT): $(BUILD_DIR)
	$(call curl_to,https://github.com/mvdan/sh/releases/download/$(SHFMT_VERSION)/shfmt_$(SHFMT_VERSION)_linux_amd64,$(SHFMT))
	chmod +x $(SHFMT)

$(SHELLCHECK): $(BUILD_DIR)
	$(call curl_to,https://github.com/koalaman/shellcheck/releases/download/$(SHELLCHECK_VERSION)/shellcheck-$(SHELLCHECK_VERSION).linux.x86_64.tar.xz,-) \
		| tar xfJ - -C $(BUILD_DIR) --strip 1 shellcheck-$(SHELLCHECK_VERSION)/shellcheck

$(MDTOC): $(BUILD_DIR)
	$(call curl_to,https://storage.googleapis.com/k8s-artifacts-sig-release/kubernetes-sigs/mdtoc/$(MDTOC_VERSION)/mdtoc-amd64-linux,$(MDTOC))
	chmod +x $(MDTOC)

.PHONY: get-script
get-script:
	sed -i '/# INCLUDE/q' get
	tail -n+2 templates/latest/cri-o/bundle/install >> get

.PHONY: prettier
prettier:
	$(CONTAINER_RUNTIME) run -it --privileged -v ${PWD}:/w -w /w --entrypoint bash node:latest -c \
		'npm install -g prettier && prettier -w .'

.PHONY: verify-dependencies
verify-dependencies: $(BUILD_DIR)/zeitgeist ## Verify external dependencies
	$(ZEITGEIST) validate --local-only --base-path . --config dependencies.yaml

.PHONY: shellfiles
shellfiles: $(SHFMT)
	$(eval SHELLFILES=$(shell $(SHFMT) -f .))

.PHONY: verify-shfmt
verify-shfmt: shellfiles
	$(SHFMT) -ln bash -w -i 4 -d $(SHELLFILES)

.PHONY: verify-shellcheck
verify-shellcheck: shellfiles $(SHELLCHECK)
	$(SHELLCHECK) -P scripts -P scripts/bundle -x $(SHELLFILES)

.PHONY: verify-get-script
verify-get-script: get-script
	scripts/tree-status

.PHONY: verify-mdtoc
verify-mdtoc: $(MDTOC)
	git grep --name-only '<!-- toc -->' | grep -v Makefile | xargs $(MDTOC) -i
	scripts/tree-status

.PHONY: verify-prettier
verify-prettier: prettier
	scripts/tree-status

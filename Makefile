CONTAINER_RUNTIME ?= podman

ZEITGEIST_VERSION = v0.8.0
SHFMT_VERSION := v3.14.1
SHELLCHECK_VERSION := v0.11.0
MDTOC_VERSION := v1.4.0
ACTIONLINT_VERSION := v1.7.12
ZIZMOR_VERSION := v1.31.1
PRETTIER_VERSION := 3.9.10
NODE_IMAGE := docker.io/library/node:26-alpine@sha256:c6ad9e9c1d80f6eb607c26b4b0a132ff7a2344fad1c78ea3baa2a7d4c8de6d94

# Pinned so that a compromised or swapped release cannot silently change the
# tooling used to verify this repository.
ZEITGEIST_SHA256 := 3899d666a6dc8ccfa99bfbb468ee282de56925c6b58a4c5937c763b14a7cae35
SHFMT_SHA256 := 76e77641faa025814b77f153b29796b8e6fa2fca03e0c76a691608b86c7ea7bf
SHELLCHECK_SHA256 := 8c3be12b05d5c177a04c29e3c78ce89ac86f1595681cab149b65b97c4e227198
MDTOC_SHA256 := 2c13e079505fdc34d814a9822813fc7e2cc5a00d1844683c77b531aa08f6986a
ACTIONLINT_SHA256 := 8aca8db96f1b94770f1b0d72b6dddcb1ebb8123cb3712530b08cc387b349a3d8
ZIZMOR_SHA256 := d185f726bdaf92df78273217dfdd24ebcd6b0ef48cf3ce776ff5762b6e138c99

BUILD_DIR := build
ZEITGEIST := $(BUILD_DIR)/zeitgeist
SHFMT := $(BUILD_DIR)/shfmt
SHELLCHECK := $(BUILD_DIR)/shellcheck
MDTOC := $(BUILD_DIR)/mdtoc
ACTIONLINT := $(BUILD_DIR)/actionlint
ZIZMOR := $(BUILD_DIR)/zizmor

define curl_to
    curl -sSfL --retry 5 --retry-delay 3 "$(1)" -o $(2)
endef

define verify_sha256
    echo "$(2)  $(1)" | sha256sum -c -
endef

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

# The remote flavour is required to resolve upstream versions, it still
# supports --local-only for the offline check.
$(ZEITGEIST): $(BUILD_DIR)
	$(call curl_to,https://github.com/kubernetes-sigs/zeitgeist/releases/download/$(ZEITGEIST_VERSION)/zeitgeist-remote-amd64-linux,$(ZEITGEIST))
	$(call verify_sha256,$(ZEITGEIST),$(ZEITGEIST_SHA256))
	chmod +x $(ZEITGEIST)

$(SHFMT): $(BUILD_DIR)
	$(call curl_to,https://github.com/mvdan/sh/releases/download/$(SHFMT_VERSION)/shfmt_$(SHFMT_VERSION)_linux_amd64,$(SHFMT))
	$(call verify_sha256,$(SHFMT),$(SHFMT_SHA256))
	chmod +x $(SHFMT)

$(SHELLCHECK): $(BUILD_DIR)
	$(call curl_to,https://github.com/koalaman/shellcheck/releases/download/$(SHELLCHECK_VERSION)/shellcheck-$(SHELLCHECK_VERSION).linux.x86_64.tar.xz,$(BUILD_DIR)/shellcheck.tar.xz)
	$(call verify_sha256,$(BUILD_DIR)/shellcheck.tar.xz,$(SHELLCHECK_SHA256))
	tar xfJ $(BUILD_DIR)/shellcheck.tar.xz -C $(BUILD_DIR) --strip 1 shellcheck-$(SHELLCHECK_VERSION)/shellcheck
	rm -f $(BUILD_DIR)/shellcheck.tar.xz

$(MDTOC): $(BUILD_DIR)
	$(call curl_to,https://storage.googleapis.com/k8s-artifacts-sig-release/kubernetes-sigs/mdtoc/$(MDTOC_VERSION)/mdtoc-amd64-linux,$(MDTOC))
	$(call verify_sha256,$(MDTOC),$(MDTOC_SHA256))
	chmod +x $(MDTOC)

$(ACTIONLINT): $(BUILD_DIR)
	$(call curl_to,https://github.com/rhysd/actionlint/releases/download/$(ACTIONLINT_VERSION)/actionlint_$(patsubst v%,%,$(ACTIONLINT_VERSION))_linux_amd64.tar.gz,$(BUILD_DIR)/actionlint.tar.gz)
	$(call verify_sha256,$(BUILD_DIR)/actionlint.tar.gz,$(ACTIONLINT_SHA256))
	tar xfz $(BUILD_DIR)/actionlint.tar.gz -C $(BUILD_DIR) actionlint
	rm -f $(BUILD_DIR)/actionlint.tar.gz

$(ZIZMOR): $(BUILD_DIR)
	$(call curl_to,https://github.com/zizmorcore/zizmor/releases/download/$(ZIZMOR_VERSION)/zizmor-x86_64-unknown-linux-gnu.tar.gz,$(BUILD_DIR)/zizmor.tar.gz)
	$(call verify_sha256,$(BUILD_DIR)/zizmor.tar.gz,$(ZIZMOR_SHA256))
	tar xfz $(BUILD_DIR)/zizmor.tar.gz -C $(BUILD_DIR) zizmor
	rm -f $(BUILD_DIR)/zizmor.tar.gz

.PHONY: get-script
get-script:
	sed -i '/# INCLUDE/q' get
	tail -n+2 templates/latest/cri-o/bundle/install >> get

.PHONY: update-digests
update-digests: ## Refresh the pinned digests of the bundled components
	scripts/update-digests

.PHONY: prettier
prettier:
	$(CONTAINER_RUNTIME) run --rm -v ${PWD}:/w:Z -w /w $(NODE_IMAGE) \
		npx --yes prettier@$(PRETTIER_VERSION) --write .

.PHONY: verify-dependencies
verify-dependencies: $(ZEITGEIST) ## Verify external dependencies
	$(ZEITGEIST) validate --local-only --base-path . --config dependencies.yaml

.PHONY: check-dependency-updates
check-dependency-updates: $(ZEITGEIST) ## Report dependencies that are outdated upstream
	$(ZEITGEIST) validate --base-path . --config dependencies.yaml

.PHONY: shellfiles
shellfiles: $(SHFMT)
	$(eval SHELLFILES=$(shell $(SHFMT) -f .))

.PHONY: shfmt
shfmt: shellfiles
	$(SHFMT) -ln bash -w -i 4 $(SHELLFILES)

.PHONY: verify-shfmt
verify-shfmt: shellfiles
	$(SHFMT) -ln bash -i 4 -d $(SHELLFILES)

.PHONY: verify-shellcheck
verify-shellcheck: shellfiles $(SHELLCHECK)
	$(SHELLCHECK) -P scripts -P scripts/bundle -x $(SHELLFILES)

.PHONY: verify-actionlint
verify-actionlint: $(ACTIONLINT)
	$(ACTIONLINT) -color

# Low confidence findings are mostly persist-credentials hints on checkouts that
# never push, they would drown out the actionable ones.
.PHONY: verify-zizmor
verify-zizmor: $(ZIZMOR)
	$(ZIZMOR) --persona=regular --min-confidence=medium .github/workflows

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

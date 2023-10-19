ZEITGEIST_VERSION = v0.4.1
SHFMT_VERSION := v3.7.0
SHELLCHECK_VERSION := v0.9.0

BUILD_DIR := build
ZEITGEIST := $(BUILD_DIR)/zeitgeist
SHFMT := $(BUILD_DIR)/shfmt
SHELLCHECK := $(BUILD_DIR)/shellcheck

define curl_to
    curl -sSfL --retry 5 --retry-delay 3 "$(1)" -o $(2)
endef

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

$(ZEITGEIST): $(BUILD_DIR)
	$(call curl_to,https://github.com/kubernetes-sigs/zeitgeist/releases/download/$(ZEITGEIST_VERSION)/zeitgeist_$(ZEITGEIST_VERSION:v%=%)_linux_amd64,$(ZEITGEIST))
	chmod +x $(ZEITGEIST)

$(SHFMT): $(BUILD_DIR)
	$(call curl_to,https://github.com/mvdan/sh/releases/download/$(SHFMT_VERSION)/shfmt_$(SHFMT_VERSION)_linux_amd64,$(SHFMT))
	chmod +x $(SHFMT)

$(SHELLCHECK): $(BUILD_DIR)
	$(call curl_to,https://github.com/koalaman/shellcheck/releases/download/$(SHELLCHECK_VERSION)/shellcheck-$(SHELLCHECK_VERSION).linux.x86_64.tar.xz,-) \
		| tar xfJ - -C $(BUILD_DIR) --strip 1 shellcheck-$(SHELLCHECK_VERSION)/shellcheck

.PHONY: get-script
get-script:
	sed -i '/# INCLUDE/q' get
	tail -n+2 templates/latest/cri-o/bundle/install >> get

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
verify-get-script:
	scripts/tree-status

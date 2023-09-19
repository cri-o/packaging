ZEITGEIST_VERSION = v0.4.1
BUILD_DIR := build

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/zeitgeist: $(BUILD_DIR)
	curl -sSfL -o $(BUILD_DIR)/zeitgeist \
		https://github.com/kubernetes-sigs/zeitgeist/releases/download/$(ZEITGEIST_VERSION)/zeitgeist_$(ZEITGEIST_VERSION:v%=%)_linux_amd64
	chmod +x $(BUILD_DIR)/zeitgeist

.PHONY: verify-dependencies
verify-dependencies: $(BUILD_DIR)/zeitgeist ## Verify external dependencies
	$(BUILD_DIR)/zeitgeist validate --local-only --base-path . --config dependencies.yaml

UPX_VERSION = 3.96
IMAGE_BUILDER ?= docker
IMAGE_BUILD_CMD ?= buildx

all:
	$(IMAGE_BUILDER) $(IMAGE_BUILD_CMD) build --build-arg UPX_VERSION=$(UPX_VERSION) -t build.local/cloudtogo4edge/upx-src:$(UPX_VERSION) --target=src .
	$(IMAGE_BUILDER) $(IMAGE_BUILD_CMD) build --build-arg UPX_VERSION=$(UPX_VERSION) --push --platform=linux/amd64,linux/arm64,linux/arm/v7 -t cloudtogo4edge/upx:$(UPX_VERSION) .
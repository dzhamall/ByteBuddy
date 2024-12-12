CLTEXECUTOR_NAME = CLTExecutor
MODULE_NAME = ByteBuddy
MODULE_NAME_STATIC = ByteBuddy-static

ARHIVE_DIRECTORY_PATH = $(MODULE_NAME)-iphonesimulator.xcarchive
IPHONEOS_SIMULATOR_DIRECTORY = $(CURDIR)/$(ARHIVE_DIRECTORY_PATH)
OUTPUT_DIR = $(CURDIR)/$(MODULE_NAME).xcframework

.PHONY: release
release:
	rm -rf Release
	mkdir -p Release/ByteBuddy

	make clean

	swift build -c release --product $(MODULE_NAME_STATIC)
	cp -f -R `swift build -c release --product $(MODULE_NAME_STATIC) --show-bin-path`/* Release/ByteBuddy/
	cd Release && zip -r ByteBuddy-arm64.zip ByteBuddy

.PHONY: createXCFramework
createXCFramework:
	set -e

	## Cleanup
	rm -rf $(IPHONEOS_SIMULATOR_DIRECTORY)
	rm -rf $(OUTPUT_DIR)

	# Archive
	xcodebuild archive -scheme $(MODULE_NAME) \
	-destination "generic/platform=iOS Simulator" \
	-archivePath $(IPHONEOS_SIMULATOR_DIRECTORY) \
	-sdk iphonesimulator \
	SKIP_INSTALL=NO \
	BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

	## XCFramework
	xcodebuild -create-xcframework \
	-framework "$(IPHONEOS_SIMULATOR_DIRECTORY)/Products/usr/local/lib/$(MODULE_NAME).framework" \
	-output $(OUTPUT_DIR)

	cp -f -R $(OUTPUT_DIR) Release/
	cd Release && zip -r ByteBuddy-XCFramework.zip $(MODULE_NAME).xcframework

	## Cleanup
	rm -rf $(IPHONEOS_SIMULATOR_DIRECTORY)

.PHONY: buildCLTExecutor
buildCLTExecutor:
	@printf "Building CLTExecutor..."
	swift build -c release -Xswiftc -whole-module-optimization --product $(CLTEXECUTOR_NAME)
	cp "`swift build -c release --product $(CLTEXECUTOR_NAME) --show-bin-path`/$(CLTEXECUTOR_NAME)" ./bin
	@echo "Done"

.PHONY: cleanBuildCLTExecutor
cleanBuildCLTExecutor: cleanArtifacts buildCLTExecutor

.PHONY: clean
clean:
	swift package clean
	rm -rdf .swiftpm/xcode
	rm -rdf .build/
	rm -rf Package.resolved
	rm -rf .DS_Store

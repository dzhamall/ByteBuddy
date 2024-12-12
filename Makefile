CLTEXECUTOR_NAME = CLTExecutor
MODULE_NAME = ByteBuddy

ARHIVE_DIRECTORY_PATH = $(MODULE_NAME)-iphonesimulator.xcarchive
IPHONEOS_SIMULATOR_DIRECTORY = $(CURDIR)/$(ARHIVE_DIRECTORY_PATH)
OUTPUT_DIR = $(CURDIR)/$(MODULE_NAME).xcframework

.PHONY: release
release:
	swift build -c release

.PHONY: createXCFramework
createXCFramework:
	set -x
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

	## Cleanup
	rm -rf $(IPHONEOS_SIMULATOR_DIRECTORY)


.PHONY: buildCLTExecutor
buildCLTExecutor:
	@printf "Building CLTExecutor..."
	@swift build -c release -Xswiftc -whole-module-optimization --product $(CLTEXECUTOR_NAME)
	@cp "`swift build -c release --product $(CLTEXECUTOR_NAME) --show-bin-path`/$(CLTEXECUTOR_NAME)" ./bin
	@echo "Done"

.PHONY: cleanBuildCLTExecutor
cleanBuildCLTExecutor: cleanArtifacts buildCLTExecutor

.PHONY: clean
clean:
	swift package reset
	rm -rdf .swiftpm/xcode
	rm -rdf .build/
	rm Package.resolved
	rm .DS_Store

.PHONY: cleanArtifacts
cleanArtifacts:
	swift package clean

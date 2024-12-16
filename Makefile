CLTEXECUTOR_NAME = CLTExecutor
MODULE_NAME = ByteBuddy

IPHONEOS_SIMULATOR_DIRECTORY = $(CURDIR)/$(MODULE_NAME)-iphonesimulator.xcarchive
OUTPUT_DIR = $(CURDIR)/$(MODULE_NAME).xcframework
FRAMEWORKS_INSTALL_PATH = Library/Frameworks
DD_DIR_PATH = DerivedData

.PHONY: release
release:
	rm -rf Release
	mkdir -p Release/ByteBuddy

	make clean

	swift build -c release --product $(MODULE_NAME)
	cp -f -R `swift build -c release --product $(MODULE_NAME) --show-bin-path`/* Release/ByteBuddy/
	cd Release && zip -r ByteBuddy-arm64.zip ByteBuddy

.PHONY: createXCFramework
createXCFramework:
	set -e

	## Cleanup
	rm -rf $(IPHONEOS_SIMULATOR_DIRECTORY)
	rm -rf $(OUTPUT_DIR)
	rm -rf $(DD_DIR_PATH)

	mkdir -p $(DD_DIR_PATH)
	mkdir -p Release/$(MODULE_NAME)-XCFramework

	# Prepare spm modules
	find . -type f -name "*.swift" -exec sed -i '' '/import Shared/d' {} +
	find . -type f -name "*.swift" -exec sed -i '' 's/Shared\.//' {} +
	sed -i '' 's/, dependencies: \["Shared"\]//g' Package.swift

	## https://forums.swift.org/t/how-to-build-swift-package-as-xcframework/41414/3
	sed -i '' 's/\.static/\.dynamic/g' Package.swift

	cp -f -R Sources/Shared/* Sources/ByteBuddy/Public/

	# Archive
	xcodebuild archive \
	-scheme $(MODULE_NAME) \
	-configuration Release \
	-destination "generic/platform=iOS Simulator" \
	-archivePath $(IPHONEOS_SIMULATOR_DIRECTORY) \
	-sdk iphonesimulator \
	-derivedDataPath $(DD_DIR_PATH) \
	SKIP_INSTALL=NO \
	BUILD_LIBRARY_FOR_DISTRIBUTION=YES  \
	INSTALL_PATH=$(FRAMEWORKS_INSTALL_PATH) \
    MODULES_FOLDER_PATH=${MODULE_NAME}.framework/Modules \
    PRODUCT_TYPE=com.apple.product-type.framework \
    PUBLIC_HEADERS_FOLDER_PATH=${MODULE_NAME}.framework/Headers \
    SWIFT_INSTALL_OBJC_HEADER=YES \

	find . -type f -name "*.swiftinterface" -exec sed -i '' 's/XCTest\.XCUIApplication/XCUIApplication/g' {} +

	## XCFramework
	xcodebuild -create-xcframework \
	-framework "$(IPHONEOS_SIMULATOR_DIRECTORY)/Products/$(FRAMEWORKS_INSTALL_PATH)/$(MODULE_NAME).framework" \
	-output $(OUTPUT_DIR)

	cp -f -R $(OUTPUT_DIR) Release/$(MODULE_NAME)-XCFramework/
	cp -f -R bin Release/$(MODULE_NAME)-XCFramework/
	cd Release && zip -r ByteBuddy-XCFramework.zip $(MODULE_NAME)-XCFramework

	# Cleanup
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

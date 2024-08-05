CLTEXECUTOR_NAME = CLTExecutor

.PHONY: release
release:
	swift build -c release

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

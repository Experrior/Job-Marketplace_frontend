codegen:
	@echo "Generating build_runner files..."
	fvm dart run build_runner build --delete-conflicting-outputs

watch_generator:
	@echo "Generating build_runner files & watching..."
	fvm dart run build_runner watch -d
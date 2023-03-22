#!/bin/bash

# Fetch tokens from somewhere via wget of git clone
# ---

# Install (or update) figma2flutter dart package
# Disabled, this project already has it locally in ../bin
# pub global activate figma2flutter

# Run `figma2flutter` to generate Flutter content from given tokens
# figma2flutter -o ./lib/ui/utils

dart ../bin/figma2flutter.dart -i ./bin/example-themes.json -o ./lib/generated

dart format -l 120 --fix ./lib/generated
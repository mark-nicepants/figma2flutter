#!/bin/bash

# Install (or update) figma2flutter dart package
# Disabled, this project already has it locally in ../bin
# pub global activate figma2flutter

# Run `figma2flutter` to generate Flutter content from given tokens
# figma2flutter -o ./lib/ui/utils
dart ../bin/figma2flutter.dart -i ./bin/example-tokens.json -o ./lib/generated

dart format -l 120 ./lib/generated

#!/bin/bash

# Install (or update) figma2flutter dart package
# pub global activate figma2flutter
#
# No need to install figma2flutter, this example project has it locally in ../bin

# Run `figma2flutter` to generate Flutter content from given token json files
# The script assumes this is being run from the root of the `example`

dart ../bin/figma2flutter.dart -i ./bin/example-themes.json -o ./lib/generated

dart format -l 120 --fix ./lib/generated
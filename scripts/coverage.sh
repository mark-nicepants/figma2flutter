#!/bin/bash

dart pub global activate coverage
dart pub global run coverage:test_with_coverage

# Create html pages
genhtml -o coverage coverage/lcov.info

# Open in the default browser (mac):
open coverage/index.html
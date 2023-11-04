# figma2flutter example application.

Sample flutter app that demonstrates creating theme from design tokens and using that theme in a simple application.

## Getting Started

1. This application uses the generated themes located in [lib/generated](lib/generated).
1. The theme was generated using the [script](bin/update-tokens.sh) and [example-themes.json](bin/example-themes.json) definitions in the [bin](bin) directory. Comments in the script describe how to execute it. The script and json files are outside of teh lib directory because the app will only include the generated dart files and not the design token json files.


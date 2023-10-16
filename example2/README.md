An example without an app that demonstrates mult-file Json design tokens.
Complete Design Token defitions are often delivered as multiple definition files that are stitched together to provide complete definitions.
The merged information from multiple files exactly matches the structure of a set of design tokens defined in a single file.

## Running example2

Run the following from the example2 directory or run the script in bin.  It will generate token defition classes

`dart ..\bin\figma2flutter.dart -i .\bin\tokens\ -o .\lib\generated\`

## Assumptions
1. `bin\tokens` contains some number of design token json files and contorl files.
1. `$metadata.json` file that describes the locations of all the files to include.
1. `$themes.json` that describes the themes and which json files are included in each theme.

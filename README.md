
# figma2flutter (pre-release)

[![codecov](https://codecov.io/gh/mark-nicepants/figma2flutter/branch/main/graph/badge.svg?token=CEO88366WO)](https://codecov.io/gh/mark-nicepants/figma2flutter)
[![pub package](https://img.shields.io/pub/v/figma2flutter.svg)](https://pub.dev/packages/figma2flutter)

This package converts [Tokens Studio for Figma](https://docs.tokens.studio/) json exports into Flutter code.

**[Notice] You may use this package but breaking changes may occur when relying on releases lower than v1.0.0**

## How to use

### 1. Install

```
dart pub global activate figma2flutter
```

### 2. Export 

Export your tokens from Figma and save the json file in your project folder.

You can do this manually or use the [Tokens Studio for Figma](https://docs.tokens.studio/) plugin to export your tokens directly into your repository.

### 3. Generate
Run the command in the root of your project
```
figma2flutter --input <path_to_json_file> --output <path_to_output_folder>
```

Default config values are:
  
```
--input: ./design/tokens.json
--output: ./lib/assets/tokens/
```

## Token support

- [ ] sizing
- [x] spacing (output = EdgeInsets)
  - [x] 1, 2, 3 or 4 values
  - [x] accept int/double values, px of rem suffix
- [ ] color
  - [x] Solid (output = Color)
    - [x] hex
    - [x] rgb 
    - [x] rgba
    - [x] hsla
  - [ ] Gradients
- [ ] borderRadius
- [ ] borderWidth
- [ ] boxShadow
- [ ] opacity
- [ ] fontFamilies
- [ ] fontWeights
- [ ] fontSizes
- [ ] lineHeight
- [ ] letterSpacing
- [ ] paragraphSpacing
- [ ] textCase
- [ ] textDecoration
- [x] typography (output = TextStyle)
- [ ] asset
- [ ] composition (pro)
- [ ] dimension
- [ ] border

## Ideas for contributing

- [ ] Add an example that illustrates how to use the package
- [ ] Generate a view similar to the Figma plugin (sort of a tokens Gallery)
- [ ] Generate MaterialColors when we have multiple color values and int base keys (100, 200, 300, 400)
- [ ] Generate extensions for Gap to easily allow spacing tokens to be used as Gap (spacing.small=4 => Gap.small => const Gap(4))
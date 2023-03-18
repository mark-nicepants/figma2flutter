![Package art](https://github.com/mark-nicepants/figma2flutter/raw/main/doc/header.png)

[![codecov](https://codecov.io/gh/mark-nicepants/figma2flutter/branch/main/graph/badge.svg?token=CEO88366WO)](https://codecov.io/gh/mark-nicepants/figma2flutter)
[![pub package](https://img.shields.io/pub/v/figma2flutter.svg)](https://pub.dev/packages/figma2flutter)

This package converts [Tokens Studio for Figma](https://docs.tokens.studio/) json exports into Flutter code.

**[Notice] You may use this package but breaking changes may occur when relying on releases lower than v1.0.0**

## How to use

### 1. Install

```bash
dart pub global activate figma2flutter
```

### 2. Export 

Export your tokens from Figma and save the json file in your project folder.

You can do this manually or use the [Tokens Studio for Figma](https://docs.tokens.studio/) plugin to export your tokens directly into your repository.

### 3. Generate
Run the command in the root of your project
```bash
figma2flutter --input <path_to_json_file> --output <path_to_output_folder>
```

Default config values are:
  
```bash
--input: ./design/tokens.json
--output: ./lib/assets/tokens/
```

## Token support (checked = supported)

[Overview of all tokens available here](https://docs.tokens.studio/available-tokens/available-tokens)

- ✅ [sizing](https://docs.tokens.studio/available-tokens/sizing-tokens)
- ✅ [spacing](https://docs.tokens.studio/available-tokens/spacing-tokens) (output = EdgeInsets)
  - ✅ 1, 2, 3 or 4 values
  - ✅ accept int/double values, px of rem suffix
- ✅ [color](https://docs.tokens.studio/available-tokens/color-tokens)
  - ✅ Solid (output = Color)
    - ✅ hex
    - ✅ rgb 
    - ✅ rgba
    - ✅ hsla
  - 🚫 Gradients
- ✅ [borderRadius](https://docs.tokens.studio/available-tokens/border-radius-tokens) (output = BorderRadius)
  - ✅ 1 value all corners
  - ✅ 2 values = topLeft + bottomRight | topRight + bottomLeft
  - ✅ 3 values = This will apply topLeft | topRight + bottomLeft | bottomRight
  - ✅ 4 values = This will apply topLeft | topRight | bottomRight | bottomLeft
- ✅  [boxShadow](https://docs.tokens.studio/available-tokens/shadow-tokens)
  - ✅ dropShadow
  - ~~innerShadow~~ (not supported but PRs's are welcome)
  - ✅ single shadow
  - ✅ list of shadows
- ✅ [typography](https://docs.tokens.studio/available-tokens/typography-tokens) (output = TextStyle)
  - ✅ fontFamily
  - ✅ fontWeights
  - ✅ fontSize
  - ✅ lineHeight
  - ✅ letterSpacing
  - ~~paragraphSpacing~~ (ignored, not a TextStyle property)
  - ~~textCase~~ (ignored, not a TextStyle property)
  - ~~textDecoration~~ (ignored, not a TextStyle property)
- ~~[asset](https://docs.tokens.studio/available-tokens/asset-tokens)~~ no support
- ✅ [composition](https://docs.tokens.studio/available-tokens/composition-tokens) (see below)
- ✅ [dimension](https://docs.tokens.studio/available-tokens/dimension-tokens) (output = has no output, but is correctly used in references)
  - ✅ [opacity](https://docs.tokens.studio/available-tokens/opacity-tokens)
- ✅ [border](https://docs.tokens.studio/available-tokens/border-tokens)
  - ✅ [borderWidth](https://docs.tokens.studio/available-tokens/border-width-tokens)
  - ✅ color
  - ✅ style 
    - ✅ solid
    - ~~dashed~~ (not supported but PRs's are welcome)

### Math support

Tokens Studio supports math operations on tokens. This package supports the following math operations:

  - [math operations](https://docs.tokens.studio/tokens/using-math)
    - 🚫 add
    - 🚫 subtract
    - 🚫 multiply
    - 🚫 divide

### Modify support

Tokens Studio supports modifying tokens. This package supports the following modify operations:

- [color](https://docs.tokens.studio/tokens/color-modifiers)
  - 🚫 lighten
  - 🚫 darken
  - 🚫 mix
  - ✅ alpha

## Composition support

We are currently working on supporting the composition tokens. This will allow you to create custom widgets that can be used in your app. When generating code from tokens, all composition tokens will be exposed as a dart class. Using the Composition widget that will be added to you app you can then use these tokens in your app.

For example with a `card` composition token you can create the following widget:

```dart
Composition(
  token: Tokens.composition.card,
  axis: Axis.vertical,
  children: [
    Text('Title'),
    ...
  ],
)
```

And a generated composition token will look like this:

```dart
CompositionToken(
  size: Size,
  fill: Color,
  border: Border,
  borderRadius: BorderRadius,
  itemSpacing: double,
  opacity: double,
  boxShadow: List<BoxShadow>,
  textStyle: TextStyle,
  padding: EdgeInsets,
)
```

Composition support: 

- ✅ sizing
  - ✅ width
  - ✅ height
- ✅ spacing
  - ✅ verticalPadding
  - ✅ horizontalPadding
  - ✅ paddingTop
  - ✅ paddingRight
  - ✅ paddingBottom
  - ✅ paddingLeft
- ✅ fill
- ✅ itemSpacing
- ~~backgroundBlur~~ (not supported but PRs's are welcome)
- ✅ border (All)
  - ✅ borderTop
  - ✅ borderRight
  - ✅ borderBottom
  - ✅ borderLeft
  - ✅ borderColor
  - ✅ borderWidth (All)
    - ✅ borderWidthTop
    - ✅ borderWidthRight
    - ✅ borderWidthBottom
    - ✅ borderWidthLeft
- ✅ borderRadius
  - ✅ borderRadiusTopLeft
  - ✅ borderRadiusTopRight
  - ✅ borderRadiusBottomRight
  - ✅ borderRadiusBottomLeft
- ✅ boxShadow
- ✅ opacity
- ✅ typography
  - ✅ fontFamilies
  - ✅ fontWeights
  - ✅ fontSizes
  - ✅ lineHeights
  - ✅ letterSpacing

## Realised feature ideas

- ✅ Generate MaterialColors when we have multiple color values and int base keys (100, 200, 300, 400)
- ✅ Add an example that illustrates how to use the package (see `/example` folder and `/example/bin/update-tokens.sh`)

## Ideas for contributing

- Generate a Theme.TextTheme with all tokens that match the [material3 spec](https://m3.material.io/styles/typography/type-scale-tokens#d74b73c2-ac5d-43c5-93b3-088a2f67723d). This would allow us to use the tokens as a theme for the whole app.
- Add example json to the repo that makes it easy to start with the package and Figmas Tokens Studio plugin
- Generate a view similar to the Figma plugin (sort of a tokens Gallery/Storybook)
- Generate extensions for Gap to easily allow spacing tokens to be used as Gap (spacing.small=4 => Gap.small => const Gap(4))
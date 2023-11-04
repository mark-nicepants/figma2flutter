![Package art](https://github.com/mark-nicepants/figma2flutter/raw/main/doc/header.png)

[![codecov](https://codecov.io/gh/mark-nicepants/figma2flutter/branch/main/graph/badge.svg?token=CEO88366WO)](https://codecov.io/gh/mark-nicepants/figma2flutter)
[![pub package](https://img.shields.io/pub/v/figma2flutter.svg)](https://pub.dev/packages/figma2flutter)

This package converts [Tokens Studio for Figma](https://docs.tokens.studio/) json exports into Flutter code.

**[Notice] You may use this package but breaking changes may occur when relying on releases lower than v1.0.0**

- [How to use](#how-to-use)
  - [1. Install](#1-install)
  - [2. Export](#2-export)
  - [3. Generate](#3-generate)
  - [4. Add to your project](#4-add-to-your-project)
- [Token support](#token-support)
  - [Math expressions](#math-expressions)
  - [Modify support](#modify-support)
- [Themes](#themes)
- [Composition support](#composition-support)
  - [CompositionToken.toInputDecoration](#compositiontokentoinputdecoration)
  - [Token support for composition tokens](#token-support-for-composition-tokens)
- [Examples](#examples)
- [Realised feature ideas](#realised-feature-ideas)
- [Ideas for contributing](#ideas-for-contributing)


# How to use

## 1. Install

```bash
dart pub global activate figma2flutter
```

## 2. Export

Export your tokens from Figma and save the json file in your project folder.

You can do this manually or use the [Tokens Studio for Figma](https://docs.tokens.studio/) plugin to export your tokens directly into your repository.

## 3. Generate
figma2flutter supports design token definitions made up of a single json file or defined as a folder of JSON files.

### When using a single JSON design token file that contains $metadata, $theme and defintions
Run the command in the root of your project
```bash
figma2flutter --input <path_to_json_file> --output <path_to_output_folder>
```

Default config values are:

```bash
--input: ./design/tokens.json
--output: ./lib/assets/tokens/
```

### When using a folder of JSON design token files
Multi-file support assumes that the input folder containing the JSON token files, a `$metadata` file, a `$themes` file.

Run the command in the root of your project
```bash
figma2flutter --input <path_to_json_folder> --output <path_to_output_folder>
```

Default config values are:

```bash
--input: ./design/tokens
--output: ./lib/assets/tokens/
```

## 4. Add to your project

Wrap your app in a Tokens widget and pass in a generated ITokens theme. See example for more details.

```dart
  @override
  Widget build(BuildContext context) {
    return Tokens(
      tokens: LightTokens(),
      child: MaterialApp(
        ...
```

Now you can use your tokens in your app! 🎉

```dart
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.tokens.sizing.large,
      height: context.tokens.sizing.large,
      decoration: BoxDecoration(
        color: context.tokens.color.primary,
        borderRadius: context.tokens.borderRadius.medium,
        boxShadow: context.tokens.boxShadow.medium,
      ),
    );
  }
```

# Token support

[Overview of all tokens available here](https://docs.tokens.studio/available-tokens/available-tokens)

- ✅ [sizing](https://docs.tokens.studio/available-tokens/sizing-tokens)
- ✅ [spacing](https://docs.tokens.studio/available-tokens/spacing-tokens) (output = EdgeInsets)
  - ✅ 1, 2, 3 or 4 values
  - ✅ accept int/double values, px of rem suffix
- ✅ [color](https://docs.tokens.studio/available-tokens/color-tokens)
  - ✅ [Solid](https://docs.tokens.studio/available-tokens/color-tokens#solid-colors) (output = Color)
    - ✅ hex
    - ✅ rgb
    - ✅ rgba
    - ✅ hsla
  - ✅ [Gradients](https://docs.tokens.studio/available-tokens/color-tokens#gradients)
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

## Math expressions

Tokens Studio supports math operations on tokens. This package supports the following math operations:

A math expression can be used to combine multiple tokens. For example: `{primary} + {tokens.secondary}` will result in a color that is the sum of the primary and secondary color. Each math operation needs to have atleast 1 token on the left side. The right side can be a token or a number. Eg `{primary} + 10` or `{primary} + {secondary}`.

To be able to parse properly the math expression, the tokens need to be wrapped in `{}`. And the operation must be properly spaced to the left and to the right (e.g. ` + ` instead of `+ `).

  - [math operations](https://docs.tokens.studio/tokens/using-math)
    - ✅ add
    - ✅ subtract
    - ✅ multiply
    - ✅ divide

## Modify support

Color modifiers are a way to modify a color token. In Figma you can use the color modifier to lighten or darken a color and select different color spaces to do so. While there is support, results may vary as we are not using the same color space as Figma (Only srgb is supported).

Tokens Studio supports modifying tokens. This package supports the following modify operations:

- [color](https://docs.tokens.studio/tokens/color-modifiers) *(only space=srgb is supported)
  - ✅ lighten
  - ✅ darken
  - ✅ mix
  - ✅ alpha

# Themes

This package supports generating multiple themes. By exposing a `ITokens` interface with the Tokens `InheritedWidget` you can easily switch between themes. See example for more details.

# Composition support

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
  size: Size, // For giving a static size
  fill: Color, // For adding a background color
  gradient: LinearGradient, // For adding a background gradient. If both fill and gradient are set, gradient will be used
  border: Border, // For adding a border
  borderRadius: BorderRadius, // For adding a border radius
  itemSpacing: double, // For adding spacing between children
  opacity: double, // For adding opacity to the widget
  boxShadow: List<BoxShadow>, // For adding shadows
  textStyle: TextStyle, // For adding a default text style that all children will inherit
  padding: EdgeInsets, // For adding padding to the widget
)
```

## CompositionToken.toInputDecoration

You can use composition tokens as `InputDecoration` in `TextField` and `TextFormField`. This will allow you to easily create custom input fields. Use the token.toInputDecoration(BorderColors) method to convert a composition token to an `InputDecoration`.

## Token support for composition tokens

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
- ✅ fill (1 of 2 options must be set, but not both. If both are set, gradient will be used)
  - ✅ solid
  - ✅ gradient
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

# Examples

- ✅ **Example 1** A Flutter application whose styles and themes were generated from the design token JSON file in the example bin directory.  It includes the generated dart files.
- ✅ **Example 2** A design token and generated code example that demonstrates generating themes from a _set_ of design token files including seperate `$metadata` and `$themes` files. No Flutter app is included. It includes the generated dart files.


# Realised feature ideas

- ✅ **Generate MaterialColors** when we have multiple color values and int base keys (100, 200, 300, 400)
- ✅ **Add an example** that illustrates how to use the package (see `/example` folder and `/example/bin/update-tokens.sh`)
- ✅ Figure out a way to convert tokens to **InputDecorations** or even an InputDecorationTheme.
- ✅ Add example json to the repo that makes it easy to start with the package and Figmas Tokens Studio plugin
-
# Ideas for contributing

- Generate a Theme.TextTheme with all tokens that match the [material3 spec](https://m3.material.io/styles/typography/type-scale-tokens#d74b73c2-ac5d-43c5-93b3-088a2f67723d). This would allow us to use the tokens as a theme for the whole app.
- Generate a view similar to the Figma plugin (sort of a tokens Gallery/Storybook)
- Generate extensions for Gap to easily allow spacing tokens to be used as Gap (Tokens.spacing.small=4 => Gap.small => const Gap(4))
## 0.0.8-alpha

- Remove dependency on TinyColor2 and Flutter framework.
- Fix bug in resolving reverences when a reference is a reference to a reference.

## 0.0.7-alpha

- Add support for color modifiers. (in srgb space)
  - lighten
  - darken
  - mix
  - alpha
- Add support for math operations. This includes:
  - add
  - subtract
  - multiply
  - divide

## 0.0.6-alpha

- Add support for linear gradients.

## 0.0.5-alpha

- Added support for shadows (separate and within Composition tokens).
- Added support for typography in Composition tokens.
- Fixed bug in Color transformer when encountering a hex color with alpha.
- Added support for Color Modifier alpha.

## 0.0.4-alpha

- Working on Composition tokens and added a Composition widget to use them in your app.
- Added a json + dart example to the example folder that shows how to use the Composition widget.

## 0.0.3-alpha

- Add support for MaterialColors when multiple colors are defined with int keys (100, 200, 300, 400).

## 0.0.2-alpha

- Added support for border radius.
- Added more documentation.
- Added tests for extension methods.
- Added output when running the command.

## 0.0.1-alpha

- Basic json parsing for tokens.
- Add ability to detect sets and token overrides.
- Add ability to detect references to other tokens.
- Add group type that will be used in the group when the children don't have a type defined.
- Added Color transformer to generate Flutter colors.
- Added Spacing transformer to generate Flutter EdgeInsets.
- Added Typography transformer to generate Flutter TextStyle.

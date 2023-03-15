
# figma2flutter

Convert [Tokens Studio for Figma]() json exports to Flutter code.

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

# Ideas

- [ ] Generate a view similar to the Figma plugin (sort of a tokens Gallery)
- [ ] Generate MaterialColors when we have multiple color values and int base keys (100, 200, 300, 400)
- [ ] Generate extensions for Gap to easily allow spacing tokens to be used as Gap (spacing.small=4 => Gap.small => const Gap(4))
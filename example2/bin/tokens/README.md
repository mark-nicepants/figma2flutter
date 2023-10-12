These figma files were generated using https://tokenzengarden.design/explore/e70c7218-8978-4254-967f-4e119219ce5c

# Manual changes

The following manual changes were applied to the files to make them work with the current parsers.

## Remove special charfacters in labels
These files from actually had "special" characters that are scrubbed which breaks the variable resolution. I've removed all the special characters.  See "arrow" in the labels in the json sample below

```json
      "slate": {
        "0-deg-↑": {
          "value": "linear-gradient(0deg, #475569 0%, #94a3b8 100%)",
          "type": "color"
        },
        "45-deg-↗": {
          "value": "linear-gradient(45deg, #475569 0%, #94a3b8 100%)",
          "type": "color"
        },
        "90-deg-→": {
          "value": "linear-gradient(90deg, #475569 0%, #94a3b8 100%)",
          "type": "color"
        },
        "180-deg-↓": {
          "value": "linear-gradient(180deg, #475569 0%, #94a3b8 100%)",
          "type": "color"
        },
        "225-deg-↙": {
          "value": "linear-gradient(225deg, #475569 0%, #94a3b8 100%)",
          "type": "color"
        },
        "270-deg-←": {
          "value": "linear-gradient(270deg, #475569 0%, #94a3b8 100%)",
          "type": "color"
        }
      },
```

## Remove leading underscores in labels.
These files had leading underscores for names.  The program fails to handle those. Ex: `_base` and `_scale`

```json
   "fontSize": {
      "_base": {
        "type": "fontSizes",
        "value": "16"
      },
      "_scale": {
        "type": "fontSizes",
        "value": "1.2"
      },
      "10xl": {
        "type": "fontSizes",
        "value": "roundTo({semantic.fontSize.9xl} * {semantic.fontSize._scale}, 0)"
      },
      "2xl": {
        "type": "fontSizes",
        "value": "roundTo({semantic.fontSize._base} * {semantic.fontSize._scale}^3, 0)"
      },
    }

```
# Remove all non !/-* math operators

Remove the `roundTo` and `^` operators and the associated parenthesis.

```json
    "fontSize": {
      "10xl": {
        "type": "fontSizes",
        "value": "roundTo({semantic.fontSize.9xl} * {semantic.fontSize.scale}, 0)"
      },
      "2xl": {
        "type": "fontSizes",
        "value": "roundTo({semantic.fontSize.base} * {semantic.fontSize.scale}^3, 0)"
      },
```


## Remove spaces from theme names.
Remove spaces from `$themes.json`  `names`.  This is becaue the theme name becomes a class name.  The alternative is to remove spaces and camel case.

```json
  {
    "id": "3302a6ab13541c7c09e7a82868ef83ef0e4e27d3",
    "name": "default - dark",
  }
```
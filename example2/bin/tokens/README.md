These figma files were generated using https://tokenzengarden.design/explore/e70c7218-8978-4254-967f-4e119219ce5c

# Manual changes

The following manual changes were applied to the files to make them work with the current math operation limitations.
Math operations are limited to `+-*/` at this time.

# Remove all non !/-* math operators
Remove all function calls inside the values in the json.  Function calls are not supported at this time.

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


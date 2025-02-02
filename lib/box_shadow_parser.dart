import 'package:color_generator/color_validator.dart';

extension BoxShadowParser on Map<dynamic, dynamic> {
  void validateBoxShadow(String optionName) {
    // A common message explaining the required rules for shadow-related keys.
    const String _shadowRules =
        " For any key named shadow, its value must follow these rules: "
        "'offsetX' must be a double, "
        "'offsetY' must be a double, "
        "'blur' must be a double, "
        "'spread' must be a double, and 'color' must be String";

    // The expected final correct form of the BoxShadow.
    const String _finalCorrectForm = " Expected final form:\n"
        "shadow\": {\n"
        "  \"offsetX\": double,\n"
        "  \"offsetY\": double,\n"
        "  \"blur\": double,\n"
        "  \"spread\": double,\n"
        "  \"color\": String,\n"
        ")";

    // Validate 'offsetX'
    if (!containsKey('offsetX')) {
      throw FormatException(
          "Missing key: 'offsetX'. $_shadowRules $_finalCorrectForm");
    }
    if (this['offsetX'] is! num) {
      throw FormatException(
          "Key 'offsetX' must be a number, got ${this['offsetX']}. $_shadowRules $_finalCorrectForm");
    }

    // Validate 'offsetY'
    if (!containsKey('offsetY')) {
      throw FormatException(
          "Missing key: 'offsetY'. $_shadowRules $_finalCorrectForm");
    }
    if (this['offsetY'] is! num) {
      throw FormatException(
          "Key 'offsetY' must be a number, got ${this['offsetY']}. $_shadowRules $_finalCorrectForm");
    }

    // Validate 'blur'
    if (!containsKey('blur')) {
      throw FormatException(
          "Missing key: 'blur'. $_shadowRules $_finalCorrectForm");
    }
    if (this['blur'] is! num) {
      throw FormatException(
          "Key 'blur' must be a number, got ${this['blur']}. $_shadowRules $_finalCorrectForm");
    }

    // Validate 'spread'
    if (!containsKey('spread')) {
      throw FormatException(
          "Missing key: 'spread'. $_shadowRules $_finalCorrectForm");
    }
    if (this['spread'] is! num) {
      throw FormatException(
          "Key 'spread' must be a number, got ${this['spread']}. $_shadowRules $_finalCorrectForm");
    }

    // Validate 'color'
    if (!containsKey('color')) {
      throw FormatException(
          "Missing key: 'color'. $_shadowRules $_finalCorrectForm");
    }
    final color = this['color'];
    print(color);
    if (color is! String) {
      throw FormatException(
        "Color for the shadow must be a string",
      );
    }
    final validColor = (color).getColor;
    if (validColor == null) {
      throw FormatException(
        '''
Invalid color format for key "${color}": "$validColor"
Valid formats:
- 6 characters: RRGGBB (assumes full opacity)
- 7 characters: #RRGGBB (assumes full opacity)
- 10 characters: 0xAARRGGBB (full format with alpha)
- Must contain valid hexadecimal characters (0-9, A-F)
''',
        optionName,
      );
    }
    this['color'] = validColor.toString();
  }

  String get shadowString {
    return '''BoxShadow(
\t\t\toffset: Offset(${this['offsetX']}, ${this['offsetY']}),
\t\t\tblurRadius: ${this['blur']},
\t\t\tspreadRadius: ${this['spread']},
\t\t\tcolor: Color(${this['color']}),
\t\t)''';
  }
}

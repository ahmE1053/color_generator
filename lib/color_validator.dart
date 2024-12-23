/// Custom exception for color-related errors
class ColorFormatException implements Exception {
  final String message;
  ColorFormatException(this.message);

  @override
  String toString() => 'ColorFormatException: $message';
}

/// Represents a color with red, green, blue, and alpha components
class ColorValue {
  final int value;

  /// Creates a color from a 32-bit integer value
  /// The format is 0xAARRGGBB where:
  /// - AA: alpha channel (opacity)
  /// - RR: red channel
  /// - GG: green channel
  /// - BB: blue channel
  ColorValue(this.value);

  /// Gets the alpha channel value (0-255)
  int get alpha => (value >> 24) & 0xFF;

  /// Gets the red channel value (0-255)
  int get red => (value >> 16) & 0xFF;

  /// Gets the green channel value (0-255)
  int get green => (value >> 8) & 0xFF;

  /// Gets the blue channel value (0-255)
  int get blue => value & 0xFF;

  @override
  String toString() =>
      '0x${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

extension ColorExtractor on String {
  /// Converts a color string to a ColorValue object
  /// Supports the following formats:
  /// - 6 characters: RRGGBB (assumes full opacity)
  /// - 7 characters: #RRGGBB (assumes full opacity)
  /// - 10 characters: 0xAARRGGBB (full format with alpha)
  /// - RGBA format: rgba(###, ###, ###, #)
  ColorValue? get getColor {
    if (startsWith('rgba')) {
      try {
        // Extract the values between parentheses
        final rgbaMatch = RegExp(r'rgba\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+)\)')
            .firstMatch(this);
        if (rgbaMatch != null) {
          final r = int.parse(rgbaMatch.group(1)!);
          final g = int.parse(rgbaMatch.group(2)!);
          final b = int.parse(rgbaMatch.group(3)!);
          final a = (double.parse(rgbaMatch.group(4)!) * 255).toInt();

          // Ensure values are within valid range
          if (r >= 0 && r <= 255 && g >= 0 && g <= 255 && b >= 0 && b <= 255 && a >= 0 && a <= 255) {
            return ColorValue((a << 24) | (r << 16) | (g << 8) | b);
          }
        }
      } on FormatException {
        return null;
      }
    }

    // Handle 6-character format (RRGGBB)
    if (length == 6) {
      try {
        // Add full opacity (FF) prefix to the color
        return ColorValue(int.parse('0xff$this'));
      } on FormatException {
        return null;
      }
    }

    // Handle 7-character format (#RRGGBB)
    if (startsWith('#') && length == 7) {
      try {
        final colorCode = substring(1);
        return ColorValue(int.parse('0xff$colorCode'));
      } on FormatException {
        return null;
      }
    }

    // Handle 10-character format (0xAARRGGBB)
    if (length == 10 && startsWith('0x')) {
      try {
        return ColorValue(int.parse(this));
      } on FormatException {
        return null;
      }
    }

    return null;
  }
}
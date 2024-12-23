import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:color_generator/color_validator.dart';
import 'package:path/path.dart';

/// Reads and validates a color configuration from a JSON file.
///
/// [args] - Command line arguments containing the file path
/// [optionName] - The name of the option that specifies the file path
///
/// Returns a Map containing the validated color configurations.
/// Throws various exceptions for different error cases with detailed messages.
Map<String, Object> getColorsMap(ArgResults args, String optionName) {
  // Construct the full file path using the current directory
  final filePath = join(Directory.current.path, args.option(optionName));
  final file = File(filePath);

  // Validate file existence and read permissions
  if (!file.existsSync()) {
    throw FileSystemException(
      'The specified file does not exist',
      filePath,
    );
  }

  try {
    final String fileContent = file.readAsStringSync();

    // Handle empty file case
    if (fileContent.trim().isEmpty) {
      throw FormatException(
        'The file is empty',
        optionName,
      );
    }

    // Parse JSON and validate format
    dynamic map;
    try {
      map = jsonDecode(fileContent);
    } on FormatException catch (e) {
      throw FormatException(
        'Invalid JSON format in file $optionName: ${e.message}',
        optionName,
      );
    }

    validateMapFormat(map, optionName);
    return Map<String, Object>.from(map);
  } on FileSystemException catch (e) {
    throw FileSystemException(
      'Error reading file $optionName: ${e.message}',
      filePath,
    );
  }
}

/// Validates the structure and content of the color configuration map.
///
/// [map] - The map to validate
/// [optionName] - The name of the option/file being validated (for error messages)
///
/// Throws FormatException with detailed messages for various validation failures.
void validateMapFormat(dynamic map, String optionName) {
  if (map is! Map) {
    throw FormatException(
      '''
The file $optionName must contain a JSON object/map.
Expected format: {"colorName": "#RRGGBB" or "RRGGBB"}
''',
      optionName,
    );
  }

  for (var entry in map.entries) {
    // Validate key format
    if (entry.key is! String) {
      throw FormatException(
        '''
Invalid key type at "${entry.key}". Keys must be strings.
Found type: ${entry.key.runtimeType}
''',
        optionName,
      );
    }
    if (entry.key == 'light' || entry.key == 'dark') {
      throw FormatException(
        '''
Keys can't be "light" or "dark"
''',
        optionName,
      );
    }
    final value = entry.value;
    if (value is String) {
      final validColor = value.getColor;
      if (validColor == null) {
        throw FormatException(
          '''
Invalid color format for key "${entry.key}": "$value"
Valid formats:
- 6 characters: RRGGBB (assumes full opacity)
- 7 characters: #RRGGBB (assumes full opacity)
- 10 characters: 0xAARRGGBB (full format with alpha)
- Must contain valid hexadecimal characters (0-9, A-F)
''',
          optionName,
        );
      }
      map[entry.key] = validColor.toString();
    } else if (value is Map) {
      // Recursively validate nested maps
      try {
        validateMapFormat(value, optionName);
      } catch (e) {
        // Enhance nested error messages with parent key context
        if (e is FormatException) {
          throw FormatException(
            'In nested map "${entry.key}": ${e.message}',
            optionName,
          );
        }
        rethrow;
      }
    } else {
      throw FormatException(
        '''
Invalid value type for key "${entry.key}".
Expected: String (color) or Map (nested colors)
Found: ${value.runtimeType}
''',
        optionName,
      );
    }
  }
}

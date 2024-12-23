/// Custom exception for map structure validation errors
class MapStructureException implements Exception {
  final String message;
  final dynamic key;

  MapStructureException(this.message, [this.key]);

  @override
  String toString() => key != null
      ? 'MapStructureException at key "$key": $message'
      : 'MapStructureException: $message';
}

/// Validates that two maps have identical key structures, throwing detailed errors for any mismatches.
///
/// This function checks:
/// 1. Map sizes match
/// 2. All keys are present in both maps
/// 3. Nested maps have consistent structure
///
/// Throws [MapStructureException] with detailed messages about any structural mismatches.
void compareMapsKeys(Map first, Map second) {
  // Compare map lengths
  if (first.length != second.length) {
    final extraKeys = first.length > second.length
        ? first.keys.where((k) => !second.containsKey(k))
        : second.keys.where((k) => !first.containsKey(k));

    throw MapStructureException(
        '''Maps have different numbers of keys (${first.length} vs ${second.length}).
${first.length > second.length ? 'First' : 'Second'} map contains extra keys: ${extraKeys.join(', ')}''');
  }

  // Convert to sets for key comparison
  Set firstKeys = first.keys.toSet();
  Set secondKeys = second.keys.toSet();

  // Check for missing keys in either map
  if (!firstKeys.containsAll(secondKeys)) {
    final missingInFirst = secondKeys.difference(firstKeys);
    final missingInSecond = firstKeys.difference(secondKeys);

    throw MapStructureException('''Maps have different keys:
${missingInFirst.isEmpty ? '' : '- Keys missing in first map: ${missingInFirst.join(', ')}'}
${missingInSecond.isEmpty ? '' : '- Keys missing in second map: ${missingInSecond.join(', ')}'}''');
  }

  // Recursively validate nested maps
  for (var key in firstKeys) {
    var firstValue = first[key];
    var secondValue = second[key];

    // Check if values are consistently typed
    if (firstValue is Map && secondValue is Map) {
      try {
        compareMapsKeys(firstValue, secondValue);
      } catch (e) {
        // Enhance nested errors with parent key context
        if (e is MapStructureException) {
          throw MapStructureException(
              'In nested map "$key": ${e.message}', key);
        }
        rethrow;
      }
    } else if (firstValue is Map || secondValue is Map) {
      throw MapStructureException('''Inconsistent value types for key "$key":
- First map value type: ${firstValue.runtimeType}
- Second map value type: ${secondValue.runtimeType}
Please ensure both values are either maps or non-maps''', key);
    }
  }
}

import 'package:args/args.dart';

import 'color_file_parser.dart';
import 'maps_validator.dart';

class ColorsModel {
  final Map light;
  final Map dark;
  final Map static;
  final String outputPath;
  final Iterable<String> rootColorOnlyKeys;
  final Iterable<String> rootMapOnlyKeys;

  const ColorsModel._({
    required this.light,
    required this.dark,
    required this.static,
    required this.outputPath,
    required this.rootColorOnlyKeys,
    required this.rootMapOnlyKeys,
  });

  factory ColorsModel(ArgResults args) {
    final lightFile = getColorsMap(args, 'light');
    final darkFile = getColorsMap(args, 'dark');
    final staticFile = getColorsMap(args, 'static');

    compareMapsKeys(lightFile, darkFile);
    return ColorsModel._(
      light: lightFile,
      dark: darkFile,
      static: staticFile,
      outputPath: args.option('output')!,
      rootColorOnlyKeys: lightFile.rootColorOnlyKeys,
      rootMapOnlyKeys: lightFile.rootMapOnlyKeys,
    );
  }

  ColorsModel getForNestedMaps(Map light, Map dark) {
    return ColorsModel._(
      light: light,
      dark: dark,
      rootColorOnlyKeys: light.rootColorOnlyKeys,
      rootMapOnlyKeys: dark.rootMapOnlyKeys,
      static: static,
      outputPath: outputPath,
    );
  }
}

extension ColorsOnlyExtension on Map {
  Iterable<String> get rootColorOnlyKeys =>
      entries.where((element) => element.value is String).map((e) => e.key);

  Iterable<String> get rootMapOnlyKeys =>
      entries.where((element) => element.value is Map).map((e) => e.key);
}

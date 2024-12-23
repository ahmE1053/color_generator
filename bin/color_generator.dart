import 'dart:io';

import 'package:color_generator/colors_model.dart';
import 'package:color_generator/nested_color_classes_geneartor.dart';
import 'package:color_generator/parser.dart';
import 'package:recase/recase.dart';

void main(List<String> args) {
  final argResults = setupParser(args);
  if (argResults.flag('help')) {
    printHelp();
    return;
  }
  writeFile(ColorsModel(argResults));
}

//@formatter:off
void writeFile(ColorsModel colorsModel) {

  final buffer = StringBuffer();
  buffer.writeln("// DO NOT EDIT. This is code generated via package color_generator");
  buffer.writeln();
  buffer.writeln(
    '''import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors._({
    ${colorsModel.light.keys.map((e) => "required this.$e,",).join("\n\t\t")}
  });
  
  //colors affected by theme change
  ${colorsModel.rootColorOnlyKeys.map((e) => "final Color $e;",).join("\n\t")}
  ${colorsModel.rootMapOnlyKeys.map((e) => "final ${ReCase(e).pascalCase} $e;",).join("\n\t")}
  
  @override
  ThemeExtension<AppColors> copyWith({
    ${colorsModel.rootColorOnlyKeys.map((e) => "Color? $e,",).join("\n\t\t")}
    ${colorsModel.rootMapOnlyKeys.map((e) => "${ReCase(e).pascalCase}? $e,",).join("\n\t\t")}
  }) {
    return AppColors._(
      ${colorsModel.light.keys.map((e) => "$e: $e ?? this.$e,",).join("\n\t\t\t")}
    );
  }
  
   @override
  AppColors lerp(
    covariant AppColors? other,
    double t,
  ) {
    if (other == null) return this;
    return AppColors._(
      ${colorsModel.rootColorOnlyKeys.map((e) => "$e: Color.lerp($e, other.$e, t) ?? $e,",).join("\n\t\t\t")}
      ${colorsModel.rootMapOnlyKeys.map((e) => "$e: $e.lerp($e, other.$e, t),",).join("\n\t\t\t")}
    );
  }
  
  static const light = AppColors._(
    ${colorsModel.rootColorOnlyKeys.map((e) => "$e: Color(${colorsModel.light[e]}),",).join("\n\t\t")}
    ${colorsModel.rootMapOnlyKeys.map((e) => "$e: ${ReCase(e).pascalCase}.light,",).join("\n\t\t")}
  );
  
  static const dark = AppColors._(
    ${colorsModel.rootColorOnlyKeys.map((e) => "$e: Color(${colorsModel.dark[e]}),",).join("\n\t\t")}
    ${colorsModel.rootMapOnlyKeys.map((e) => "$e: ${ReCase(e).pascalCase}.dark,",).join("\n\t\t")}
  );
  
  // static colors
  ${colorsModel.static.entries.map((e) => 'static const ${e.key} = Color(${e.value});').join("\n\t")}
}
'''
  );
  if (colorsModel.rootMapOnlyKeys.isNotEmpty) {
    for (var e in colorsModel.rootMapOnlyKeys) {
      buffer.writeln(
        nestedColorClassesGenerator(
          e,
          e,
          colorsModel.getForNestedMaps(
            colorsModel.light[e],
            colorsModel.dark[e],
          ),
        ),
      );
    }
  }
  final file=File(colorsModel.outputPath);
  if(!file.existsSync()){
    file.createSync(recursive: true);
  }
  file.writeAsStringSync(buffer.toString());
}
//@formatter:on
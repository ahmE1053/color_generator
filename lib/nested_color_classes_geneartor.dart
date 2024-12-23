import 'package:color_generator/colors_model.dart';
import 'package:recase/recase.dart';

String nestedColorClassesGenerator(
  String key,
  String concatedKey,
  ColorsModel nestedColorModel,
) {
  final buffer = StringBuffer();

  buffer.writeln();
  final pascalKey = '_${ReCase(concatedKey).pascalCase}';

//@formatter:off
    buffer.write('''
class $pascalKey {
  const $pascalKey._({
    ${nestedColorModel.light.keys.map((e) => "required this.$e,",).join("\n\t\t")}
  });
  
  //colors affected by theme change
  ${nestedColorModel.rootColorOnlyKeys.map((e) => "final Color $e;",).join("\n\t")}
  ${nestedColorModel.rootMapOnlyKeys.map((e) => "final _${ReCase('${concatedKey}_$e').pascalCase} $e;",).join("\n\t")}
  
  $pascalKey copyWith({
    ${nestedColorModel.rootColorOnlyKeys.map((e) => "Color? $e,",).join("\n\t\t")}
    ${nestedColorModel.rootMapOnlyKeys.map((e) => "_${ReCase('${concatedKey}_$e').pascalCase}? $e,",).join("\n\t\t")}
  }) {
    return $pascalKey._(
      ${nestedColorModel.light.keys.map((e) => "$e: $e ?? this.$e,",).join("\n\t\t\t")}
    );
  }
  
  $pascalKey lerp(
    $pascalKey x,
    $pascalKey y,
    double t,
  ) {
    return $pascalKey._(
      ${nestedColorModel.rootColorOnlyKeys.map((e) => "$e: Color.lerp(x.$e, y.$e, t) ?? $e,",).join("\n\t\t\t")}
      ${nestedColorModel.rootMapOnlyKeys.map((e) => "$e: $e.lerp(x.$e, y.$e, t),",).join("\n\t\t\t")}
    );
  }
  
  static const light = $pascalKey._(
    ${nestedColorModel.rootColorOnlyKeys.map((e) => "$e: Color(${nestedColorModel.light[e]}),",).join("\n\t\t")}
    ${nestedColorModel.rootMapOnlyKeys.map((e) => "$e: _${ReCase('${concatedKey}_$e').pascalCase}.light,",).join("\n\t\t")}
  );
  
  static const dark = $pascalKey._(
    ${nestedColorModel.rootColorOnlyKeys.map((e) => "$e: Color(${nestedColorModel.dark[e]}),",).join("\n\t\t")}
    ${nestedColorModel.rootMapOnlyKeys.map((e) => "$e: _${ReCase('${concatedKey}_$e').pascalCase}.dark,",).join("\n\t\t")}
  );
}
''');
//@formatter:on
  if (nestedColorModel.rootMapOnlyKeys.isNotEmpty) {
    for (var e in nestedColorModel.rootMapOnlyKeys) {
      buffer.writeln(
        nestedColorClassesGenerator(
          e,
          '${concatedKey}_$e',
          nestedColorModel.getForNestedMaps(
            nestedColorModel.light[e],
            nestedColorModel.dark[e],
          ),
        ),
      );
    }
  }
  return buffer.toString();
}

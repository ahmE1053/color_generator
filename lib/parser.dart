import 'package:args/args.dart';

final argParser = ArgParser();

ArgResults setupParser(List<String> args) {
  argParser.addOption(
    'light',
    abbr: 'L',
    defaultsTo: 'assets/colors/light.json',
  );

  argParser.addOption(
    'dark',
    abbr: 'D',
    defaultsTo: 'assets/colors/dark.json',
  );

  argParser.addOption(
    'static',
    abbr: 'S',
    defaultsTo: 'assets/colors/static.json',
  );

  argParser.addOption(
    'output',
    abbr: 'O',
    defaultsTo: 'lib/core/consts/app_colors.g.dart',
  );

  argParser.addFlag('help', abbr: 'H');

  return argParser.parse(args);
}

void printHelp() {
  print('''
This package helps you generate light and dark mode colors for your Flutter application using theme extensions. It simplifies the process of managing and animating between colors, handling the boilerplate code of manually defining numerous color properties.

Simply provide your light, dark, and static colors in JSON files, and this generator will create a Dart file containing a theme extension that you can use throughout your app.

Key Features:

Theme Extension Integration: Uses Flutter's theme extensions for seamless integration with your app's theme.
Color Animation Support: Enables smooth transitions between light and dark mode colors.
Reduced Boilerplate: Eliminates the need to write repetitive code for each color.
Static Color Support: Allows you to define colors that remain constant regardless of the current theme mode.
Easy JSON Input: Uses simple JSON files to define your colors.

Usage:

dart run color_generator [options]

Options:

${argParser.usage}

Example:

dart run color_generator -L assets/colors/my_light_colors.json -D assets/colors/my_dark_colors.json -S assets/colors/my_static_colors.json -O lib/my_app_colors.dart
''');
}
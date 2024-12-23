# Color Generator for Flutter

Simplify the way you handle light and dark mode colors in your Flutter application with **Color Generator**. This package leverages Flutter's theme extensions to automate color management, making it easier to work with nested and complex color structures while reducing boilerplate code.

## Key Features

- **Streamlined Theme Management**: Automatically generate a `ThemeExtension` class to manage your app’s color themes for both light and dark modes.
- **Reduced Boilerplate**: Eliminate repetitive manual definitions of color properties.
- **Static Color Support**: Define colors that remain constant, irrespective of the theme mode.
- **Multiple Nesting Levels**: Organize colors hierarchically to better structure your code.
- **Smooth Color Transitions**: Built-in support for animating between light and dark mode colors.
- **JSON-Driven Configurations**: Define all your color schemes in simple JSON files for easy maintenance.

## How It Works

This package uses JSON files to generate a Dart class with all the required color properties. The generated `ThemeExtension` class integrates seamlessly into your app’s `ThemeData`, ensuring smooth handling of light and dark mode transitions and better organization of nested colors.

### Advantages

1. **Automated Code Generation**: Simplifies the process of defining and maintaining colors, reducing errors and saving time.
2. **Improved Code Organization**: Supports hierarchical nesting of colors, making your code more readable and maintainable.
3. **Consistent Theme Usage**: Guarantees consistency across your app by centralizing color definitions.
4. **Future-Proof Design**: Easily update or extend themes without refactoring existing code.

## Usage

### Command

Run the generator tool using the following command:

```bash
dart run color_generator [options]
```

### Example Command

```bash
dart run color_generator \
  -L assets/colors/my_light_colors.json \
  -D assets/colors/my_dark_colors.json \
  -S assets/colors/my_static_colors.json \
  -O lib/my_app_colors.dart
```

This generates a Dart file (`my_app_colors.dart`) with a `ThemeExtension` class containing the structure of your defined colors.

## Integrating with Your App

### Adding Colors to ThemeData

Include the generated `ThemeExtension` in your app’s theme:

```dart
ThemeData(
  extensions: [AppColors.light],
);

ThemeData(
  extensions: [AppColors.dark],
);
```

### Accessing Colors in Widgets

Use an extension method for easy access to colors:

```dart
extension ColorsExtension on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
```

Then, access the colors in your widgets:

```dart
Text(
  'Example',
  style: TextStyle(color: context.colors.text.primary),
);
```


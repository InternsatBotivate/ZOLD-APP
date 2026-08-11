class StringUtils {
  static String capitalize(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String capitalizeFirst(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }

  static String capitalizeAll(String? text) {
    if (text == null || text.isEmpty) return '';
    return text.split(' ').map((word) => capitalizeFirst(word)).join(' ');
  }
}

extension StringFormatExtension on String {
  String get toCapitalized => StringUtils.capitalize(this);
  String get toCapitalizedFirst => StringUtils.capitalizeFirst(this);
  String get toCapitalizedAll => StringUtils.capitalizeAll(this);
}

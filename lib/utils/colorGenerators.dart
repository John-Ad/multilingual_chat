import 'dart:ui';

Color getLanguageBannerColorDark(int languageId) {
  switch (languageId % 10) {
    case 0:
      return const Color(0xFFB71C1C);
    case 1:
      return const Color(0xFF880E4F);
    case 2:
      return const Color(0xFF4A148C);
    case 3:
      return const Color(0xFF311B92);
    case 4:
      return const Color(0xFF1A237E);
    case 5:
      return const Color(0xFF0D47A1);
    case 6:
      return const Color(0xFF01579B);
    case 7:
      return const Color(0xFF006064);
    case 8:
      return const Color(0xFF004D40);
    case 9:
      return const Color(0xFF1B5E20);
    default:
      return const Color.fromARGB(255, 255, 153, 0);
  }
}

Color getLanguageBorderColorDark(int languageId) {
  switch (languageId % 10) {
    case 0:
      return const Color(0xFFEF9A9A);
    case 1:
      return const Color(0xFFCE93D8);
    case 2:
      return const Color(0xFFB39DDB);
    case 3:
      return const Color(0xFF9FA8DA);
    case 4:
      return const Color(0xFF90CAF9);
    case 5:
      return const Color(0xFF81D4FA);
    case 6:
      return const Color(0xFF80DEEA);
    case 7:
      return const Color(0xFF80CBC4);
    case 8:
      return const Color(0xFFA5D6A7);
    case 9:
      return const Color(0xFFC5E1A5);
    default:
      return const Color.fromARGB(255, 255, 153, 0);
  }
}

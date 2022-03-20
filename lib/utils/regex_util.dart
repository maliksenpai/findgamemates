class RegexUtil {
  static RegExp passwordRegex =
      RegExp(r'(?=(.*[0-9]))((?=.*[A-Za-z0-9])(?=.*[A-Z])(?=.*[a-z]))^.{8,}$');
}

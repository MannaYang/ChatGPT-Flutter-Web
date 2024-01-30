///
/// RegExp
///
class RegExpProvider {
  static bool isEmail(String inputStr) {
    if (inputStr.isEmpty) return false;
    if (!RegExp(
            '^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-z0-9A-Z]{2,}\$')
        .hasMatch(inputStr)) {
      return false;
    }
    return true;
  }

  static bool isLetterNumber(String inputStr) {
    if (inputStr.isEmpty) return false;
    if (!RegExp('(?=.*[a-z])(?=.*[0-9])[a-zA-Z0-9]{8,20}')
        .hasMatch(inputStr)) {
      return false;
    }
    return true;
  }
}

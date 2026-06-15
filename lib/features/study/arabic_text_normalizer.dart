class ArabicTextNormalizer {
  static String normalize(String text) {
    return text
        // Fatha
        .replaceAll('\u064E', '')
        // Damma
        .replaceAll('\u064F', '')
        // Kasra
        .replaceAll('\u0650', '')
        // Sukun
        .replaceAll('\u0652', '')
        // Shadda
        .replaceAll('\u0651', '')
        // Tanwin Fath
        .replaceAll('\u064B', '')
        // Tanwin Damm
        .replaceAll('\u064C', '')
        // Tanwin Kasr
        .replaceAll('\u064D', '')
        .trim()
        .toLowerCase();
  }
}

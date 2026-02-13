class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String textDirection;

  LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.textDirection,
  });

  bool get isRTL => textDirection == 'rtl';
}

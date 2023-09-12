enum MathSessionType {
  easy("Easy"),
  normal("Normal"),
  hard("Hard"),
  hexDecode("Hex decode");

  static const MathSessionType defaultType = easy;

  const MathSessionType(this.name);
  final String name;
}

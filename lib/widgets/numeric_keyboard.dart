import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:math_training/widgets/custom_theme.dart';

class NumericKeyboard extends StatefulWidget {
  final bool numericInputEnabled;
  final void Function(String) onChange;
  final void Function(String) onApply;

  const NumericKeyboard({
    Key? key,
    required this.onChange,
    required this.onApply,
    this.numericInputEnabled = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NumericKeyboardState();
  }
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  static const int maxNumberLength = 7;

  get numericInputEnabled => widget.numericInputEnabled;
  String _value = "";

  void _add(String s) {
    if (s == "0" && _value == "0") return;
    if (_value.length >= maxNumberLength) return;
    if (_value == "0") _value = "";
    _value += s;
    widget.onChange(_value);
  }

  void _backspace() {
    if (_value.length <= 1) {
      _value = "";
    } else {
      _value = _value.substring(0, _value.length - 1);
    }
    widget.onChange(_value);
  }

  void _apply() {
    widget.onApply(_value);
    _value = "";
    widget.onChange(_value);
  }

  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment(0.0, 1.0),
          colors: [theme.primaryColor, theme.secondaryColor],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                _KeyboardButton(
                  text: "1",
                  onPress: () => _add("1"),
                  enabled: numericInputEnabled,
                ),
                _KeyboardButton(
                  text: "2",
                  onPress: () => _add("2"),
                  enabled: numericInputEnabled,
                ),
                _KeyboardButton(
                  text: "3",
                  onPress: () => _add("3"),
                  enabled: numericInputEnabled,
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _KeyboardButton(
                  text: "4",
                  onPress: () => _add("4"),
                  enabled: numericInputEnabled,
                ),
                _KeyboardButton(
                  text: "5",
                  onPress: () => _add("5"),
                  enabled: numericInputEnabled,
                ),
                _KeyboardButton(
                  text: "6",
                  onPress: () => _add("6"),
                  enabled: numericInputEnabled,
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _KeyboardButton(
                  text: "7",
                  onPress: () => _add("7"),
                  enabled: numericInputEnabled,
                ),
                _KeyboardButton(
                  text: "8",
                  onPress: () => _add("8"),
                  enabled: numericInputEnabled,
                ),
                _KeyboardButton(
                  text: "9",
                  onPress: () => _add("9"),
                  enabled: numericInputEnabled,
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _KeyboardButton(
                  text: "<|",
                  onPress: _backspace,
                  enabled: numericInputEnabled,
                ),
                _KeyboardButton(
                  text: "0",
                  onPress: () => _add("0"),
                  enabled: numericInputEnabled,
                ),
                _KeyboardButton(
                  text: "Ok",
                  onPress: _apply,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyboardButton extends StatelessWidget {
  final String text;
  final Function() onPress;
  final bool enabled;

  const _KeyboardButton({
    Key? key,
    required this.text,
    required this.onPress,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: GestureDetector(
      onTapDown: enabled ? (_) => onPress() : null,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.white60)),
        child: Center(
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              text,
              style: TextStyle(color: enabled ? Colors.white60 : Colors.white24, fontSize: 69),
            ),
          ),
        ),
      ),
    ));
  }
}

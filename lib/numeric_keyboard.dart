import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'data.dart';

class NumericKeyboard extends StatefulWidget {
  final Function(String) onChange;
  final Function(String) onApply;

  const NumericKeyboard({Key key, this.onChange, this.onApply})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NumericKeyboardState();
  }
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  static const int maxNumberLength = 7;
  String _value = "";

  void _add(String s) {
    if (s == "0" && _value == "0") return;
    if (_value.length >= maxNumberLength) return;
    if (_value == "0") _value = "";
    _value += s;
    widget.onChange?.call(_value);
  }

  void _backspace() {
    if (_value.length <= 1) {
      _value = "";
    } else {
      _value = _value.substring(0, _value.length - 1);
    }
    widget.onChange?.call(_value);
  }

  void _apply() {
    if (_value.length == 0) return;
    widget.onApply?.call(_value);
    _value = "";
    widget.onChange?.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment(0.0, 1.0),
          colors: [primaryColor, secondaryColor],
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
                ),
                _KeyboardButton(
                  text: "2",
                  onPress: () => _add("2"),
                ),
                _KeyboardButton(
                  text: "3",
                  onPress: () => _add("3"),
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
                ),
                _KeyboardButton(
                  text: "5",
                  onPress: () => _add("5"),
                ),
                _KeyboardButton(
                  text: "6",
                  onPress: () => _add("6"),
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
                ),
                _KeyboardButton(
                  text: "8",
                  onPress: () => _add("8"),
                ),
                _KeyboardButton(
                  text: "9",
                  onPress: () => _add("9"),
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
                ),
                _KeyboardButton(
                  text: "0",
                  onPress: () => _add("0"),
                ),
                _KeyboardButton(
                  text: "k",
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

  const _KeyboardButton({
    Key key,
    @required this.text,
    @required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => onPress(),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.white60)),
        child: Center(
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              text,
              style: TextStyle(color: Colors.white60, fontSize: 69),
            ),
          ),
        ),
      ),
    ));
  }
}

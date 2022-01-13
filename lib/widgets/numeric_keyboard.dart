import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_training/widgets/custom_theme.dart';

class InputTextProcessor {
  final int maxLength;
  final RegExp _validator = new RegExp(r"[0-9]");
  final void Function(String) onChange;

  String value = "";

  InputTextProcessor({
    required this.maxLength,
    required this.onChange,
  });

  bool validateInput(String s) {
    return _validator.hasMatch(s);
  }

  void addIfValid(String s){
    if (!validateInput(s)) return;
    add(s);
  }

  void add(String s) {
    if (s == "0" && value == "0") return;
    if (value.length >= maxLength) return;
    if (value == "0") value = "";
    value += s;
    onChange(value);
  }

  void backspace() {
    if (value.length <= 1) {
      value = "";
    } else {
      value = value.substring(0, value.length - 1);
    }
    onChange(value);
  }

  void clear(){
    value = "";
    onChange(value);
  }
}

class GameKeyboardInputWrapper extends StatefulWidget {
  final Widget child;
  final bool numericInputEnabled;
  final void Function(String) onChange;
  final void Function(String) onApply;

  const GameKeyboardInputWrapper({
    Key? key,
    this.numericInputEnabled = true,
    required this.onChange,
    required this.onApply,
    required this.child,
  }) : super(key: key);

  @override
  _GameKeyboardInputWrapperState createState() => _GameKeyboardInputWrapperState();
}

class _GameKeyboardInputWrapperState extends State<GameKeyboardInputWrapper> {
  static const int maxNumberLength = 7;
  bool focused = false;
  late FocusNode focusNode;
  late InputTextProcessor inputText;

  @override
  void initState() {
    super.initState();
    inputText = new InputTextProcessor(
      maxLength: maxNumberLength,
      onChange: widget.onChange,
    );
    focusNode = new FocusNode();
    focusNode.addListener(() {
      setState(() {
        focused = focusNode.hasFocus;
      });
    });
  }

  void _apply(){
    widget.onApply(inputText.value);
    inputText.clear();
  }

  void _processKeyboardEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _apply();
        return;
      } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
        inputText.backspace();
        return;
      }
    }

    var character = event.character;

    if (character == null) return;
    inputText.addIfValid(character);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusNode.requestFocus(), // workaround to avoid losing focus
      child: KeyboardListener(
        focusNode: focusNode,
        autofocus: true,
        onKeyEvent: _processKeyboardEvent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Container(
                color: Colors.transparent,
                child: widget.child,
              ),
            ),
            Flexible(
              flex: 3,
              child: NumericKeyboard(
                numericInputEnabled: widget.numericInputEnabled,
                enabled: focused,
                onBackspace: inputText.backspace,
                onEnter: _apply,
                onInput: inputText.add,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NumericKeyboard extends StatelessWidget {

  final bool numericInputEnabled;
  final bool enabled;
  final void Function() onBackspace;
  final void Function(String) onInput;
  final void Function() onEnter;

  const NumericKeyboard({
    Key? key,
    this.numericInputEnabled = true,
    this.enabled = true,
    required this.onBackspace,
    required this.onInput,
    required this.onEnter,
  }) : super(key: key);

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
                  onPress: () => onInput("1"),
                  enabled: numericInputEnabled && enabled,
                ),
                _KeyboardButton(
                  text: "2",
                  onPress: () => onInput("2"),
                  enabled: numericInputEnabled && enabled,
                ),
                _KeyboardButton(
                  text: "3",
                  onPress: () => onInput("3"),
                  enabled: numericInputEnabled && enabled,
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _KeyboardButton(
                  text: "4",
                  onPress: () => onInput("4"),
                  enabled: numericInputEnabled && enabled,
                ),
                _KeyboardButton(
                  text: "5",
                  onPress: () => onInput("5"),
                  enabled: numericInputEnabled && enabled,
                ),
                _KeyboardButton(
                  text: "6",
                  onPress: () => onInput("6"),
                  enabled: numericInputEnabled && enabled,
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _KeyboardButton(
                  text: "7",
                  onPress: () => onInput("7"),
                  enabled: numericInputEnabled && enabled,
                ),
                _KeyboardButton(
                  text: "8",
                  onPress: () => onInput("8"),
                  enabled: numericInputEnabled && enabled,
                ),
                _KeyboardButton(
                  text: "9",
                  onPress: () => onInput("9"),
                  enabled: numericInputEnabled && enabled,
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _KeyboardButton(
                  text: "<|",
                  onPress: onBackspace,
                  enabled: numericInputEnabled && enabled,
                ),
                _KeyboardButton(
                  text: "0",
                  onPress: () => onInput("0"),
                  enabled: numericInputEnabled && enabled,
                ),
                _KeyboardButton(
                  text: "Ok",
                  onPress: onEnter,
                  enabled: enabled,
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

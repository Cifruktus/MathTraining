import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'training.dart';
import 'data.dart';

class SettingsPage extends StatefulWidget {
  final SharedPreferences preferences;

  SettingsPage({Key key, this.preferences}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences get prefs => widget.preferences;

  void _showTrainingTypeDialog() {
    ListDialog.fromStringList(
      "Type",
      MathConstants.sessionDifficultyNames,
      selected: prefs.sessionDifficulty,
    ).show(context).then((data) {
      if (data != null)
        setState(() {
          prefs.sessionDifficulty = data;
        });
    });
  }

  void _showDurationSelectDialog() {
    List<ListDialogElement<int>> elements = MathConstants.durationOptions
        .map((option) =>
            new ListDialogElement(value: option, child: Text("$option min")))
        .toList();

    ListDialog(
      elements: elements,
      title: "Duration",
      selected: prefs.sessionDuration,
    ).show(context).then((data) {
      if (data != null)
        setState(() {
          prefs.sessionDuration = data;
        });
    });
  }

  void _showClearScoresDialog() {
    var dialog = AlertDialog(
      content: Text("All scores will be deleted"),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context, false),
        ),
        FlatButton(
          child: Text("Ok"),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );

    showDialog<bool>(context: context, builder: (_) => dialog)
        .then((value) async {
      if (value == true) {
        var resultsFile = File(await statsFilePath);
        if (await resultsFile.exists()) resultsFile.delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          VariableCard.withText(
            name: "Difficulty",
            value: prefs.sessionDifficulty,
            onTap: _showTrainingTypeDialog,
          ),
          VariableCard.withText(
            name: "Duration",
            value: "${prefs.sessionDuration} min",
            onTap: _showDurationSelectDialog,
          ),
          VariableCard(
            name: "Clear scores",
            child: Container(),
            onTap: _showClearScoresDialog,
          ),
        ],
      ),
    );
  }
}

class SettingsElement extends StatelessWidget {
  final String name;
  final String value;

  const SettingsElement({Key key, @required this.name, @required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[Text(name), Text(value)],
    );
  }
}

class VariableCard extends StatelessWidget {
  static final TextStyle style = TextStyle(fontSize: 22.0);
  static final TextStyle styleRight = TextStyle(
      fontSize: 22.0, color: primaryColor, fontWeight: FontWeight.bold);

  final String name;
  final Widget child;
  final Function onTap;

  const VariableCard(
      {Key key, @required this.name, @required this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: new Row(children: <Widget>[
          Expanded(
            child: Text(name, style: style),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: child,
          )
        ]),
      ),
    ));
  }

  factory VariableCard.withText(
      {Key key,
      @required String name,
      @required String value,
      Function onTap}) {
    return VariableCard(
      key: key,
      name: name,
      onTap: onTap,
      child: Text(value, style: styleRight),
    );
  }
}

class ListDialogElement<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const ListDialogElement({Key key, @required this.value, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class ListDialog<T> {
  final List<ListDialogElement<T>> elements;
  final String title;
  final T selected;

  const ListDialog(
      {Key key, @required this.title, @required this.elements, this.selected});

  static ListDialog<String> fromStringList(String title, List<String> list,
      {String selected}) {
    return ListDialog(
        title: title,
        selected: selected,
        elements: list
            .map((option) => new ListDialogElement(
                  value: option,
                  child: Text(option),
                ))
            .toList());
  }

  Widget _build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children:
          elements.map((element) => _buildOption(element, context)).toList(),
    );
  }

  Widget _buildOption(ListDialogElement<T> element, BuildContext context) {
    return Container(
      color: element.value == selected
          ? Theme.of(context).colorScheme.primary.withAlpha(30)
          : Colors.transparent,
      child: SimpleDialogOption(
        onPressed: () => _onChoiceMade(element.value, context),
        child: element.child,
      ),
    );
  }

  void _onChoiceMade(T choice, BuildContext context) {
    Navigator.pop(context, choice);
  }

  Future<T> show(BuildContext context) {
    return showDialog<T>(context: context, builder: _build);
  }
}

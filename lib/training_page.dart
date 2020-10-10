import 'dart:async';

import 'package:flutter/material.dart';

import 'data.dart';
import 'training.dart';
import 'numeric_keyboard.dart';

class TrainingPage extends StatefulWidget {
  final int duration;
  final QuestionGenerator questions;

  TrainingPage({
    Key key,
    @required this.duration,
    @required this.questions,
  }) : super(key: key);

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  int secondsToGo;
  Timer timer;
  String inputValue = "";
  MathTest questions;

  int get trainingDuration => widget.duration;

  int get minutesToGo => (secondsToGo / 60).ceil();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), _timerCallback);
    secondsToGo = widget.duration;
    questions = new MathTest(widget.questions);
  }

  _updateValue(String s) {
    setState(() {
      inputValue = s;
    });
  }

  _applyQuestion(String s) {
    setState(() {
      var correct = questions.answer(int.tryParse(s) ?? 0);
      print(correct);
    });
  }

  _timerCallback(Timer timer) {
    setState(() {
      secondsToGo--;
    });
    if (secondsToGo == 0) _finishTest(context);
  }

  _finishTest(BuildContext ctx) {
    MathTestResult result = MathTestResult(
        duration: trainingDuration,
        time: DateTime.now(),
        correct: questions.statsCorrect,
        incorrect: questions.statsIncorrect,
        type: questions.generatorName);

    Navigator.of(ctx).pop(result);
  }

  @override
  dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Training (${secondsToGo}s)"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(flex: 2, child: _buildFormulaUI()),
            //_getInput(),
            Flexible(
              flex: 3,
              child: NumericKeyboard(
                onChange: _updateValue,
                onApply: _applyQuestion,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFormulaUI() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Flexible(
            child: Center(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  questions.currentQuestion.formula,
                  style: TextStyle(fontSize: 69, color: textOnWhiteColor),
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: textOnWhiteColor,
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: inputValue.length > 0
                  ? FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        inputValue,
                        style: TextStyle(fontSize: 69, color: textOnWhiteColor),
                      ),
                    )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}

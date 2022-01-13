import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_training/math_game/bloc/game_bloc.dart';
import 'package:math_training/math_game/bloc/game_events.dart';
import 'package:math_training/math_game/bloc/game_state.dart';
import 'package:math_training/settings/cubit/app_settings_cubit.dart';
import 'package:math_training/widgets/custom_theme.dart';
import 'package:math_training/widgets/numeric_keyboard.dart';


class MathGameView extends StatelessWidget {
  static Route route(AppSettingsCubit settings) {
    return MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: settings,
                ),
                BlocProvider(
                  create: (context) => MathGameBloc.fromSettings(context.read<AppSettingsCubit>().state),
                ),
              ],
              child: const MathGameView(),
            ));
  }

  static void finishGame(BuildContext context){
    var game = context.read<MathGameBloc>();
    Navigator.of(context).pop(game.getResult());
  }

  const MathGameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        finishGame(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: GameAppTitle(),
        ),
        body: PageContent(),
      ),
    );
  }
}

class MainGameWindow extends StatelessWidget {
  const MainGameWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.select((MathGameBloc bloc) => bloc.state.stateType);

    if (state == GameStateType.ready) return const BeforeGameView();
    if (state == GameStateType.finished) return AfterGameView();
    if (state == GameStateType.going) return QuestionTextField();

    return Container();
  }
}

class BeforeGameView extends StatelessWidget {
  const BeforeGameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var game = context.watch<MathGameBloc>();
    var theme = CustomTheme.of(context);

    return Column(
      children: [
        Expanded(
          child: Container(),
        ),
        Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Session type: ${game.sessionType}", style: theme.cardText,),
                  Text("Duration: ${game.duration.inMinutes} min", style: theme.cardText),
                ],
              ),
            ),
          ),
        ),

        Expanded(
          child: Center(
            child: Text(
              "Press OK to \nstart",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.black45
              )
            ),
          ),
        ),
      ],
    );
  }
}

class AfterGameView extends StatelessWidget {
  const AfterGameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var questions = context.select((MathGameBloc bloc) => bloc.state.answered);
    var theme = CustomTheme.of(context);

    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, i) {
        var question = questions[i];
        var correct = question.isCorrect;

        return Card(
            shape: correct
                ? null
                : new RoundedRectangleBorder(
                    side: new BorderSide(color: theme.mistakeHighlightColor, width: 2.0),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: "${question.formula} = ${question.refAnswer} "),
                        if (!correct)
                          TextSpan(
                            text: "${question.answer}",
                            style: TextStyle(decoration: TextDecoration.lineThrough),
                          )
                      ]),
                      style: theme.cardText,
                    ),
                  ),
                  Icon(correct ? Icons.check : Icons.clear),
                ],
              ),
            ));
      },
    );
  }
}

class GameAppTitle extends StatelessWidget {
  const GameAppTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var secondsToGo = context.select((MathGameBloc bloc) => bloc.state.duration);
    var state = context.select((MathGameBloc bloc) => bloc.state.stateType);

    switch (state) {
      case GameStateType.ready:
        return const Text("Math test");
      case GameStateType.finished:
        return ResultsGameTitle();
      default:
        return Text("Training (${secondsToGo}s)");
    }
  }
}

class ResultsGameTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool noMistakes = context.select((MathGameBloc bloc) => bloc.state.noMistakes);

    return noMistakes
        ? Row(
            children: [
              Text("Results "),
              Icon(Icons.auto_awesome_rounded),
            ],
          )
        : Text("Results");
  }
}

class QuestionTextField extends StatelessWidget {
  const QuestionTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var inputValue = context.select((MathGameBloc bloc) => bloc.state.inputValue);
    var formula = context.select((MathGameBloc bloc) => bloc.state.currentQuestion.formula);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Flexible(
            child: Center(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  formula,
                  style: TextStyle(fontSize: 69),
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: Container(
              height: 5,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.black,
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: inputValue.isNotEmpty
                  ? FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        inputValue,
                        style: TextStyle(fontSize: 69),
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

class PageContent extends StatelessWidget {
  const PageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.select((MathGameBloc bloc) => bloc.state.stateType);

    return GameKeyboardInputWrapper(
      onApply: (s) => applyPressed(context,s),
      onChange: (s) => onChange(context,s),
      numericInputEnabled: state == GameStateType.going,
      child: MainGameWindow(),
    );
  }

  void onChange(BuildContext context, String text){
    context.read<MathGameBloc>().add(MathGameNewInputData(text));
  }

  void applyPressed(BuildContext context, String text) {
    var gameBloc = context.read<MathGameBloc>();

    switch (gameBloc.state.stateType) {
      case GameStateType.ready:
        gameBloc.add(MathGameStart());
        return;
      case GameStateType.going:
        gameBloc.add(MathGameOnOkInput(text));
        return;
      case GameStateType.finished:
        MathGameView.finishGame(context);
        return;
      default:
        return;
    }
  }
}


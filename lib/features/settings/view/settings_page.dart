import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_training/core/settings/models/math_session_type.dart';
import 'package:math_training/core/settings/models/session_durations.dart';
import 'package:math_training/features/settings/view/widgets.dart';
import 'package:math_training/core/scores/bloc/scored_bloc.dart';
import 'package:math_training/core/settings/cubit/app_settings_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri githubPage = Uri.parse('https://github.com/Cifruktus/MathTraining');

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => SettingsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MathDurationEditor(),
          MathSessionEditor(),
          ClearScoresButton(),
          GithubPageButton(),
        ],
      ),
    );
  }
}

class ClearScoresButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NameValueCard(
      onTap: () => showDialog(context: context, builder: (c) => ClearScoresButton()),
      name: Text("Clear scores"),
      value: Container(),
    );
  }
}

class ClearScoresDialog extends StatelessWidget {
  const ClearScoresDialog({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("All scores will be deleted"),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
            context.read<ScoresCubit>().clearScores();
          },
        ),
      ],
    );
  }
}

class GithubPageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NameValueCard(
      onTap: () => launchUrl(githubPage),
      name: Text("View project on Github",
        style: TextStyle(
          color: Colors.blueAccent[700]
        ),
      ),
      value: Container(),
    );
  }
}

class MathDurationEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var duration = context.select((AppSettingsCubit c) => c.state.mathSessionDuration);

    return NameValueCard(
      onTap: () => showDialog(context: context, builder: (c) => MathSessionDurationDialog()),
      name: Text("Game duration:"),
      value: Text("${duration.inMinutes} min"),
    );
  }
}

class MathSessionDurationDialog extends StatelessWidget {
  const MathSessionDurationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ListDialogElement<Duration>> elements = durationOptions
        .map((option) => ListDialogElement(
      value: option,
      child: Text("${option.inMinutes} min"),
    ))
        .toList();

    var settings = context.read<AppSettingsCubit>();

    return ListDialog<Duration>(
      elements: elements,
      title: "Duration",
      selected: settings.state.mathSessionDuration,
      onChoiceMade: (data) => settings.mathSessionDuration = data,
    );
  }
}

class MathSessionEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sessionType = context.select((AppSettingsCubit c) => c.state.mathSessionType);

    return NameValueCard(
      onTap: () => showDialog(context: context, builder: (c) => MathSessionTypeDialog()),
      name: Text("Session type:"),
      value: Text(sessionType.name),
    );
  }
}

class MathSessionTypeDialog extends StatelessWidget {
  const MathSessionTypeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ListDialogElement<MathSessionType>> elements = MathSessionType.values
        .map((option) => ListDialogElement(value: option, child: Text("${option.name}")))
        .toList();

    var settings = context.read<AppSettingsCubit>();

    return ListDialog<MathSessionType>(
      elements: elements,
      title: "Session type",
      selected: settings.state.mathSessionType,
      onChoiceMade: (data) => settings.mathSessionType = data,
    );
  }
}


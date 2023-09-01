import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_training/core/settings/models/math_session_type.dart';
import 'package:math_training/features/settings/view/widgets.dart';
import 'package:math_training/core/scores/bloc/scored_bloc.dart';
import 'package:math_training/core/settings/cubit/app_settings_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri githubPage = Uri.parse('https://github.com/Cifruktus/MathTraining');

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static Route route(AppSettingsCubit settings, ScoresCubit scores) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: scores,
        child: BlocProvider.value(
          value: settings,
          child: SettingsPage(),
        ),
      ),
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
      onTap: () => _showClearScoresDialog(context),
      name: Text("Clear scores"),
      value: Container(),
    );
  }

  void _showClearScoresDialog(BuildContext context) async {
    bool? answer = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
              content: Text("All scores will be deleted"),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: Text("Ok"),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));

    if (answer == true) {
      context.read<ScoresCubit>().clearScores();
    }
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
      onTap: () => _showDurationSelectDialog(context),
      name: Text("Game duration:"),
      value: Text("${duration.inMinutes} min"),
    );
  }

  void _showDurationSelectDialog(BuildContext context) {
    List<ListDialogElement<Duration>> elements = durationOptions
        .map((option) => ListDialogElement(
              value: option,
              child: Text("${option.inMinutes} min"),
            ))
        .toList();

    var settings = context.read<AppSettingsCubit>();

    ListDialog(
      elements: elements,
      title: "Duration",
      selected: settings.state.mathSessionDuration,
    ).show(context).then((data) {
      if (data != null) settings.mathSessionDuration = data;
    });
  }
}

class MathSessionEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sessionType = context.select((AppSettingsCubit c) => c.state.mathSessionType);

    return NameValueCard(
      onTap: () => _showDurationSelectDialog(context),
      name: Text("Session type:"),
      value: Text(sessionType),
    );
  }

  void _showDurationSelectDialog(BuildContext context) {
    List<ListDialogElement<String>> elements = sessionDifficultyNames
        .map((option) => ListDialogElement(value: option, child: Text("${option}")))
        .toList();

    var settings = context.read<AppSettingsCubit>();

    ListDialog(
      elements: elements,
      title: "Session type",
      selected: settings.state.mathSessionType,
    ).show(context).then((data) {
      if (data != null) settings.mathSessionType = data;
    });
  }
}

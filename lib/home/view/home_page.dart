import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_training/math_game/models/result.dart';
import 'package:math_training/math_game/view/math_game_page.dart';
import 'package:math_training/scores/cubit/scored_bloc.dart';
import 'package:math_training/settings/cubit/app_settings_cubit.dart';
import 'package:math_training/settings/view/settings_page.dart';
import 'package:math_training/widgets/custom_theme.dart';


class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => page());
  }

  static Widget page() {
    return BlocProvider(
        create: (context) => AppSettingsCubit(),
        child: BlocProvider(
          create: (context) => ScoresCubit(),
          child: MainPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (__, _) {
              return <Widget>[HomePageAppBar()];
            },
            body: ScoresList()));
  }
}

class HomePageAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      titleSpacing: 0,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text("Training",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            )),
        background: SliverAppBarBG(),
      ),
      actions: <Widget>[
        new IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
                  SettingsPage.route(context.read<AppSettingsCubit>(),context.read<ScoresCubit>()),
                ))
      ],
    );
  }
}

class SliverAppBarBG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment(0.0, 1.0),
          colors: [theme.secondaryColor, theme.primaryColor],
          tileMode: TileMode.repeated,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: IconButton(
            icon: Icon(Icons.play_arrow),
            color: Colors.white,
            iconSize: 80,
            onPressed: () async {
              var result = await Navigator.of(context).push(
                MathGameView.route(context.read<AppSettingsCubit>()),
              );
              if (result is MathTestResult) {
                context.read<ScoresCubit>().addScore(result);
              }
            },
          ),
        ),
      ),
    );
  }
}

class ScoresList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var scores = context.select((ScoresCubit scores) => scores.state.mathTestScores);
    var theme = CustomTheme.of(context);

    if (scores.isEmpty) {
      return Center(child: Text("No scores", style: theme.cardTextHighlighted,));
    }

    return SingleChildScrollView(
      child: Column(
        children: scores.reversed.map((result) {
          return MathTestResultCard(result);
        }).toList(),
      ),
    );
  }
}

class MathTestResultCard extends StatelessWidget {
  final MathTestResult result;

  const MathTestResultCard(this.result, {Key? key}) : super(key: key);

  // It's better to use intl
  String _getTimeString(DateTime time) {
    var year = time.year.toString();
    var month = time.month.toString().padLeft(2, "0");
    var day = time.day.toString().padLeft(2, "0");
    var hours = time.hour.toString().padLeft(2, "0");
    var minutes = time.minute.toString().padLeft(2, "0");
    return "$day.$month.$year  $hours:$minutes";
  }

  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(child: Text(_getTimeString(result.time), style: theme.cardTextHighlighted,)),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("Correct: ${result.correct}\n"
                  "Incorrect: ${result.incorrect}\n"
                  "Speed: ${result.speed}\n"
                  "Duration: ${result.duration}\n"
                  "Session type: ${result.type}",
              style: theme.cardText,),
            ),
          ],
        ),
      ),
    );
  }
}

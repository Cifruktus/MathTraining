import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_training/core/settings/cubit/app_settings_cubit.dart';
import 'package:math_training/features/home/view/widgets.dart';
import 'package:math_training/features/math_game/view/math_game_page.dart';
import 'package:math_training/features/settings/view/settings_page.dart';
import 'package:math_training/core/scores/bloc/scored_bloc.dart';
import 'package:math_training/widgets/theme.dart';


class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        TransitionAppBar(),
        ScoresList(),
      ],
    ));
  }
}

class TransitionAppBar extends StatelessWidget {
  TransitionAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    EdgeInsets padding = data.padding;

    var sessionType = context.select((AppSettingsCubit s) => s.state.mathSessionType);
    var problemsSolved = context.select((ScoresCubit s) => s.state.getProblemsSolvedBySessionType(sessionType));
    var averageSpeed = context.select((ScoresCubit s) => s.state.getAverageSpeedBySessionType(sessionType));
    var averageAccuracy = context.select((ScoresCubit s) => s.state.getAverageAccuracyBySessionType(sessionType));

    return SliverPersistentHeader(
      pinned: true,
      delegate: _TransitionAppBarDelegate(
        safeTopPadding: padding.top,
        problemsSolved: problemsSolved,
        averageAccuracy: averageAccuracy,
        averageSpeed: averageSpeed,
        sessionType: sessionType.name,
      ),
    );
  }
}

class _TransitionAppBarDelegate extends SliverPersistentHeaderDelegate {
  static const kAppBarHeight = 56.0;
  static const kButtonRadius = 30.0;
  static const kButtonCutoutRadius = 40.0;
  static const kBottomPadding = 8.0;

  final double extent = 300;
  final double safeTopPadding;

  final double averageSpeed;
  final double averageAccuracy;
  final int problemsSolved;
  final String sessionType;

  _TransitionAppBarDelegate({
    required this.sessionType,
    required this.averageSpeed,
    required this.averageAccuracy,
    required this.problemsSolved,
    required this.safeTopPadding,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    double extendedValue = 1 - shrinkOffset / (maxExtent - minExtent);
    extendedValue = min(max(0, extendedValue), 1);

    double reflectionOpacity = min(max(0, (extendedValue - 0.7) * 3), 1);
    double smallStatsOpacity = min(max(0, (extendedValue - 0.1) * 1.5), 1);
    double centerStatsOpacity = min(max(0, (extendedValue - 0.4) * 2), 1);

    var theme = Theme.of(context).extension<AppTheme>()!.data;

    var bottomColor = Color.lerp(theme.primaryColor, theme.secondaryColor, extendedValue)!;
    var buttonColor = Color.lerp(theme.primaryColor, bottomColor, 0.8)!;

    var accuracyPercent = (averageAccuracy * 100).toStringAsFixed(1);
    var speedRounded = averageSpeed.toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.only(bottom: kBottomPadding),
      child: Stack(
        children: <Widget>[
          Positioned.fill( // background decoration and shape
            child: Container(
              margin: EdgeInsets.only(bottom: kButtonRadius),
              decoration: ShapeDecoration(
                  shadows: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6.0,
                      spreadRadius: 2.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment(0.0, 1.0),
                    colors: [theme.primaryColor, bottomColor],
                  ),
                  shape: AppBarShapeBorder(cutoutRadius: kButtonCutoutRadius)),
            ),
          ),
          Positioned.fill( // reflection
            child: Opacity(
              opacity: reflectionOpacity,
              child: Padding(
                padding: EdgeInsets.only(top: (1 - extendedValue) * 100),
                child: Container(
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment(0.0, 1.0),
                      colors: [Colors.white12, Color(0x00FFFFFF)],
                    ),
                    shape: ReflectionShape(
                        leftPadding: safeTopPadding + kAppBarHeight * 2,
                        rightPadding: safeTopPadding + kAppBarHeight,
                        radius: 1.3), //CustomShapeBorder()
                  ),
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: AppBar(
                toolbarHeight: kAppBarHeight,
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.settings),
                    onPressed: () => Navigator.push(context, SettingsPage.route()),
                  ),
                ],
                title: Row(children: [
                  Text("Training"),
                  Opacity(opacity: smallStatsOpacity, child: Text(" - ${sessionType}")),
                ]),
              )),
          Align(
              alignment: Alignment.center,
              child: AppBarStatText(
                opacity: centerStatsOpacity,
                mainData: true,
                name: "Problems solved",
                value: "$problemsSolved",
              )),
          Align(
            alignment: Alignment.bottomLeft,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Padding(
                padding: const EdgeInsets.only(bottom: kButtonCutoutRadius, right: kButtonCutoutRadius),
                child: AppBarStatText(
                  opacity: smallStatsOpacity,
                  name: "Speed",
                  value: "${speedRounded} p/min",
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: kButtonCutoutRadius, left: kButtonCutoutRadius),
                  child: AppBarStatText(
                    opacity: smallStatsOpacity,
                    name: "Accuracy",
                    value: "${accuracyPercent}%",
                  ),
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: StartButton(
              size: kButtonRadius * 2,
              color: buttonColor,
              onPressed: () => Navigator.push(context, MathGamePage.route()),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => safeTopPadding + kButtonRadius + kAppBarHeight + kBottomPadding;

  @override
  bool shouldRebuild(covariant _TransitionAppBarDelegate oldDelegate) {
    return sessionType != oldDelegate.sessionType ||
        problemsSolved != oldDelegate.problemsSolved ||
        averageAccuracy != oldDelegate.averageAccuracy ||
        averageSpeed != oldDelegate.averageSpeed ||
        safeTopPadding != oldDelegate.safeTopPadding ||
        extent != oldDelegate.extent;
  }
}

class ScoresList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sessionType = context.select((AppSettingsCubit s) => s.state.mathSessionType);
    var scores = context.select((ScoresCubit scores) => scores.state.getResultsBySessionType(sessionType)).toList();

    var theme = Theme.of(context).extension<AppTheme>()!.data;

    if (scores.isEmpty) {
      return SliverFillRemaining(
        child: Center(
            child: Text(
          "No scores",
          style: theme.cardTextHighlighted,
        )),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return MathTestResultCard(scores[scores.length - 1 - index]);
      },
      childCount: scores.length
      ),
    );
  }
}

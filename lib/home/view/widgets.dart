import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:math_training/math_game/models/result.dart';
import 'package:math_training/widgets/custom_theme.dart';

class MathTestResultCard extends StatelessWidget {
  static const divider = Divider(color: Colors.white54);

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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              spreadRadius: 2.0,
              offset: Offset(2.0, 2.0),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor,
              Color.lerp(theme.primaryColor, theme.secondaryColor, 0.33)!,
              theme.secondaryColor,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Center(
                    child: Text(
                  _getTimeString(result.time),
                  style: theme.cardTitleText,
                )),
              ),
              DefaultTextStyle.merge(
                style: theme.cardText.copyWith(color: Colors.white),
                child: Column(
                  children: [
                    _ResultsCardNameValue(
                      name: Text("Solved"),
                      value: Text("${result.correct} / ${result.questions}"),
                    ),
                    divider,
                    _ResultsCardNameValue(
                      name: Text("Duration"),
                      value: Text("${result.duration} sec"),
                    ),
                    divider,
                    _ResultsCardNameValue(
                      name: Text("Speed"),
                      value: Text("${result.speed} p/min"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultsCardNameValue extends StatelessWidget {
  final Widget name;
  final Widget value;

  const _ResultsCardNameValue({Key? key, required this.name, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: name,
        ),
        value,
      ],
    );
  }
}

class StartButton extends StatelessWidget {
  final Color? color;
  final double size;
  final void Function() onPressed;

  const StartButton({
    Key? key,
    this.color,
    this.size = 60,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Theme.of(context).primaryColor,
      elevation: 6,
      shape: CircleBorder(),
      child: Container(
          width: size,
          height: size,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: size * 0.60,
            ),
          )),
      // onPressed: (){},
    );
  }
}

class AppBarStatText extends StatelessWidget {
  final double opacity;
  final String name;
  final String value;
  final bool mainData;

  const AppBarStatText({
    Key? key,
    required this.opacity,
    required this.name,
    required this.value,
    this.mainData = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.of(context);

    return Opacity(
      opacity: opacity,
      child: DefaultTextStyle.merge(
        style: TextStyle(color: Colors.white70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(name),
            Text(value, style: mainData ? theme.homePageMainStatText : theme.homePageStatText),
          ],
        ),
      ),
    );
  }
}

class AppBarShapeBorder extends ContinuousRectangleBorder {
  final double cutoutBorderRadius;
  final double cutoutRadius;
  final double bottomPadding;

  AppBarShapeBorder({
    required this.cutoutRadius,
    this.cutoutBorderRadius = 30.0,
    this.bottomPadding = 0,
  });

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final double middle = rect.width / 2;
    final double height = rect.height - bottomPadding;

    double cosD = cutoutBorderRadius / (cutoutBorderRadius + cutoutRadius);
    double sinD = sqrt(1 - cosD * cosD);
    double h = cutoutRadius * cosD;
    double d = cutoutRadius * sinD;
    double d2 = (cutoutRadius + cutoutBorderRadius) * sinD;

    Path path = Path();
    path.lineTo(0, height);

    path.lineTo(middle - d2, height);

    path.arcToPoint(
      Offset(middle - d, height - h),
      radius: Radius.circular(cutoutBorderRadius),
      clockwise: false,
    );

    path.arcToPoint(
      Offset(middle + d, height - h),
      radius: Radius.circular(cutoutRadius),
    );

    path.arcToPoint(
      Offset(middle + d2, height),
      radius: Radius.circular(cutoutBorderRadius),
      clockwise: false,
    );

    path.lineTo(rect.width, height);
    path.lineTo(rect.width, 0.0);

    path.close();

    return path.shift(Offset(rect.left, rect.top));
  }
}

class ReflectionShape extends ContinuousRectangleBorder {
  final double leftPadding;
  final double rightPadding;
  final double radius;

  ReflectionShape({
    required this.leftPadding,
    required this.rightPadding,
    required this.radius,
  });

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double leftPadding = min(this.leftPadding, rect.height);
    double rightPadding = min(this.rightPadding, rect.height);

    Path path = Path();

    path.lineTo(0, leftPadding);

    double radius = Offset(rect.width, rightPadding - leftPadding).distance * this.radius;

    path.arcToPoint(
      Offset(rect.width, rightPadding),
      radius: Radius.circular(radius),
    );

    path.lineTo(rect.width, rect.height);
    path.lineTo(0.0, rect.height);

    path.close();

    return path.shift(Offset(rect.left, rect.top));
  }
}

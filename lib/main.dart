import 'package:flutter/material.dart';

import 'data.dart';
import 'home_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "JetBrainsMono",
        primarySwatch: primaryColorSwatch,
      ),
      home: HomePage(),
    );
  }
}

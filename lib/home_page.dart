import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';
import 'settings.dart';
import 'training.dart';
import 'training_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _startTest(BuildContext ctx) async {
    var prefs = await SharedPreferences.getInstance();

    Navigator.of(ctx)
        .push(MaterialPageRoute(
            builder: (context) => TrainingPage(
                  duration: prefs.sessionDuration * 60,
                  questions:
                      MathConstants.sessionTypes[prefs.sessionDifficulty](),
                )))
        .then(_afterTest);
  }

  _openSettings() async {
    var prefs = await SharedPreferences.getInstance();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SettingsPage(preferences: prefs)));
  }

  _afterTest(dynamic result) {
    if (result is MathTestResult) {
      saveResult(result);
    }
  }

  Future<void> saveResult(MathTestResult result) async {
    var resultsFile = File(await statsFilePath);
    List<dynamic> results = <dynamic>[];
    if (await resultsFile.exists()) {
      results = jsonDecode(await resultsFile.readAsString());
    }
    print(jsonEncode(results));
    results.add(result.toMap());
    await resultsFile.writeAsString(jsonEncode(results));
    setState(() {});
  }

  Future<List<MathTestResult>> getResults() async {
    var resultsFile = File(await statsFilePath);
    if (!await resultsFile.exists()) return <MathTestResult>[];
    List<dynamic> results = jsonDecode(await resultsFile.readAsString());
    return results
        .map<MathTestResult>((result) => MathTestResult.fromMap(result))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            titleSpacing: 0,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text("Training",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
              background: _sliverAppBarBg(),
            ),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.settings), onPressed: _openSettings)
            ],
          ),
        ];
      },
      body: FutureBuilder<List<MathTestResult>>(
          future: getResults(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                //  color: Colors.lightGreenAccent,
                child: snapshot.data.length > 0
                    ? ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: snapshot.data.length,
                        itemBuilder: (ctx, index) => MathTestResultCard(
                            snapshot.data[snapshot.data.length - index - 1]))
                    : Center(child: Text("No scores")),
              );
            }
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text("Error loading scores"));
            }
            return Center(child: CircularProgressIndicator());
          }),
    ));
  }

  Widget _sliverAppBarBg() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment(0.0, 1.0),
          colors: [secondaryColor, primaryColor],
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
            onPressed: () => _startTest(context),
          ),
        ),
      ),
    );
  }
}

class MathTestResultCard extends StatelessWidget {
  final MathTestResult result;
  static DateFormat dateFormat = DateFormat.yMMMMEEEEd().add_Hm();

  const MathTestResultCard(this.result, {Key key}) : super(key: key);

  // It's better to use intl
  String _getTimeString(DateTime time){
    var year = time.year.toString();
    var month = time.month.toString().padLeft(2, "0");
    var day = time.day.toString().padLeft(2, "0");
    var hours = time.hour.toString().padLeft(2, "0");
    var minutes = time.minute.toString().padLeft(2, "0");
    return "$day.$month.$year  $hours:$minutes";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(child: Text(_getTimeString(result.time))),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("Correct: ${result.correct}\n"
                  "Incorect: ${result.incorrect}\n"
                  "Speed: ${result.speed}\n"
                  "Duration: ${result.duration}\n"
                  "Difficulty: ${result.type}"),
            ),
          ],
        ),
      ),
    );
  }
}

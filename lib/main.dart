import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:math_training/home/view/home_page.dart';
import 'package:math_training/theme.dart';
import 'package:math_training/widgets/custom_theme.dart';

import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTheme(
      data: customThemeData,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: materialThemeData,
        home: MainPage.page(),
      ),
    );
  }
}


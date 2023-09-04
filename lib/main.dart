import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:math_training/core/scores/bloc/scored_bloc.dart';
import 'package:math_training/core/settings/cubit/app_settings_cubit.dart';
import 'package:math_training/features/home/view/home_page.dart';
import 'package:math_training/widgets/theme.dart';

import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AppSettingsCubit()),
          BlocProvider(create: (context) => ScoresCubit()),
        ],
        child: MaterialApp(
          title: 'Math Training',
          theme: materialThemeData,
          home: MainPage(),
        ));
  }
}


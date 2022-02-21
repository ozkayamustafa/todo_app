import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/hive_storage.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/pages/home_page.dart';
import 'package:todo_app/viewmodel/color_viewmodel.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<LocalStoragaData>(HiveLocalStoraga());
}

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var task = await Hive.openBox<Task>("Tasks");
  for (var element in task.values) {
    if (element.createAt.day != DateTime.now().day) {
      task.delete(element.id);
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupHive();
  setup();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('tr', 'TR')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en', 'US'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.deviceLocale,
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black))),
      home: ChangeNotifierProvider(
          create: (context) => ColorViewModel(), child: HomePage()),
    );
  }
}

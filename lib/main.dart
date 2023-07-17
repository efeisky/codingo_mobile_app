import 'package:codingo/firebase_options.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/manager/navigator_manager.dart';
import 'package:codingo/product/model/user_model.dart';
import 'package:codingo/product/constant/project_items.dart';
import 'package:codingo/product/routes/navigator_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  Hive.initFlutter('database');
  Hive.registerAdapter<UserModel>(UserModelAdapter());
  
  initializeDateFormatting('tr_TR', null);
  
  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserNotifier())
    ],
    child: const MyApp(),
    ),
  );


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ProjectItems.projectName,
      debugShowCheckedModeBanner: ProjectItems.debugBannerMode,
      theme: ThemeData.light(),
      routes: NavigatorRoutes().items,
      navigatorKey: NavigatorManager.instance.navigatorGlobalKey,
    );
  }
}

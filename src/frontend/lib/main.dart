import 'package:FatCat/constants/app_theme.dart';
import 'package:FatCat/constants/seed_data.dart';
import 'package:FatCat/models/card_provider.dart';
import 'package:FatCat/models/deck_provider.dart';
import 'package:FatCat/router/app_router.dart';
import 'package:FatCat/viewmodels/screen_control_viewmodel.dart';
import 'package:FatCat/viewmodels/theme_viewmodel.dart';
import 'package:FatCat/views/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:FatCat/services/DatabaseHelper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  vah_test();
  await seedDatabaseForDecksControl();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScreenControlViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(create: (_) => DeckProvider()),
        ChangeNotifierProvider(create: (_) => CardProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
      builder: (context, themeVM, _) => MaterialApp.router(
      title: 'FatCat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: Provider.of<ThemeViewModel>(context).themeMode,
      routerConfig: appRouter,
      ),
    );
  }
}

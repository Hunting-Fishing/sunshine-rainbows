import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/core/router.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/core/theme/theme_provider.dart';

import 'package:myapp/trading_card_game/data/card_repository.dart';
import 'package:myapp/trading_card_game/data/local_asset_card_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        Provider<CardRepository>(
          create: (_) => LocalAssetCardRepository(
            assetPath: 'assets/trading_card_game/cards.json',
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'My Awesome Game',
            theme: lightTheme(),
            darkTheme: darkTheme(),
            themeMode: themeProvider.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}

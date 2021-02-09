import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:pb_ph1/routers/root_router.dart';
import 'core/utils/color_swatch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: ThemeData(
            primarySwatch: createMaterialColor(Color(0xFF8D0CE8)),
            textTheme: GoogleFonts.playTextTheme(Theme.of(context).textTheme),
            visualDensity: VisualDensity.adaptivePlatformDensity),
      home: Nuvigator(
          router: RootRouter(),
          initialRoute: RootRoutes.manageFundsRoute,
          screenType: cupertinoScreenType,
          shouldPopRoot: true
      ),
    );
  }
}
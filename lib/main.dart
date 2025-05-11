import 'package:flutter/material.dart';
import 'package:food_restaurant_app/composition_root.dart';
import 'package:food_restaurant_app/ui/auth/auth_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  CompositionRoot.configure();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foodie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Color.fromARGB(255, 251, 176, 59),
        ),
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CompositionRoot.composeAuthUI(),
    );
  }
}

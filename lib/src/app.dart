import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ventas_app/src/providers/user_provider.dart';
import 'package:ventas_app/src/screens/contact.screen.dart';
import 'package:ventas_app/src/screens/detail.screen.dart';
import 'package:ventas_app/src/screens/home.screen.dart';
import 'package:ventas_app/src/screens/map.screen.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        // hide the debug banner
        debugShowCheckedModeBanner: false,
        title: "Ventas App",
        initialRoute: '/',
        routes: {
          '/home': (context) => const HomeScreen(),
          '/detail': (context) => DetailScreen(
              id: ModalRoute.of(context)!.settings.arguments as int),
          '/contact': (context) => const ContactScreen(),
          '/map': (context) => const MapScreen(),
        },
        home: const Scaffold(
          backgroundColor: Color.fromARGB(255, 135, 170, 252),
          body: HomeScreen(),
        ),
      ),
    );
  }
}

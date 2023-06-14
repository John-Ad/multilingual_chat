import 'package:flutter/material.dart';
import 'package:multilingual_chat/views/home.dart';

void main() {
  runApp(const MyApp());
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multilingual Chat',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color.fromARGB(255, 35, 39, 42),
          secondary: Color.fromARGB(255, 44, 47, 51),
          tertiary: Color.fromARGB(255, 52, 152, 219),
          surface: Color.fromARGB(255, 62, 66, 70),
          background: Color.fromARGB(255, 44, 47, 51),
          error: Colors.red,
          onError: Colors.red,
          onPrimary: Color.fromARGB(255, 255, 255, 255),
          onSecondary: Color.fromARGB(255, 255, 255, 255),
          onSurface: Color.fromARGB(255, 52, 152, 219),
          onBackground: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: const Home(title: 'Multilingual Chat'),
      navigatorObservers: [routeObserver],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:german_tutor/views/home.dart';

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
      title: 'German Tutor',
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
      home: const Home(title: 'German Tutor'),
      navigatorObservers: [routeObserver],
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: Text(
//             widget.title,
//             style: theme.textTheme.headlineLarge,
//           ),
//         ),
//         backgroundColor: theme.primaryColor,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const <Widget>[
//             Text(
//               'Nothing yet',
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         tooltip: 'New Conversation',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

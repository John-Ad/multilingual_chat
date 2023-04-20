import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.title,
            style: theme.textTheme.headlineLarge!.copyWith(
              color: theme.colorScheme.tertiary,
            ),
          ),
        ),
        backgroundColor: theme.primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the German Tutor',
              style: theme.textTheme.headlineLarge,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Start',
                style: theme.textTheme.labelLarge!.copyWith(
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

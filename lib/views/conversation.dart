import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  final String title;
  final int id;

  const ConversationPage({
    super.key,
    required this.title,
    required this.id,
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
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
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
      body: Center(
        child: Text("Hello World"),
      ),
    );
  }
}

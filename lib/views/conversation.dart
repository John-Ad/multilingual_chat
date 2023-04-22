import 'package:flutter/material.dart';
import 'package:german_tutor/models/conversation.dart';
import 'package:german_tutor/services/CoversationsService.dart';

import '../models/message.dart';

class ConversationPage extends StatefulWidget {
  final String title;
  final int id;
  final String topic;

  const ConversationPage({
    super.key,
    required this.title,
    required this.id,
    required this.topic,
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  bool loadingMessages = false;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _getMessages();
  }

  Future<void> _getMessages() async {}

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
            child: Text(
              'Conversations',
              style: theme.textTheme.headlineSmall!.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: false,
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}

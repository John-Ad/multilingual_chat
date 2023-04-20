import 'package:flutter/material.dart';

import '../models/conversation.dart';
import '../services/CoversationsService.dart';

class NewConversation extends StatefulWidget {
  const NewConversation({super.key, required this.title});

  final String title;

  @override
  State<NewConversation> createState() => _NewConversationState();
}

class _NewConversationState extends State<NewConversation> {
  final ConversationsService _conversationsService = ConversationsService();

  String _topic = '';

  void _addConversation() async {
    if (await _conversationsService.add(_topic)) {
      debugPrint('Conversation added');
    } else {
      debugPrint('Conversation not added');
    }
  }

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
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Text(
                'New Conversation',
                style: theme.textTheme.headlineSmall!.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

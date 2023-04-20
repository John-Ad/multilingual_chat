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
  final TextEditingController _topicController = TextEditingController();

  void _addConversation() async {
    if (await _conversationsService.add(_topicController.text)) {
      debugPrint('Conversation added');
    } else {
      debugPrint('Conversation not added');
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var topics = [
      "greetings",
      "world politics",
      "cold war",
    ];

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
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      "Choose a topic",
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Container(
                      width: (MediaQuery.of(context).size.width * 0.8) * 0.8,
                      height: (MediaQuery.of(context).size.height * 0.6) * 0.5,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListView(
                        children: [
                          for (var topic in topics)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: ListTile(
                                title: Text(
                                  topic,
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                                onTap: () {
                                  _topicController.text = topic;
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: TextField(
                        controller: _topicController,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Topic',
                          hintStyle: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:german_tutor/models/conversation.dart';

class HomeConversation extends StatelessWidget {
  final Conversation conversation;
  final Future<void> Function(int) deleteConversation;

  const HomeConversation({
    super.key,
    required this.conversation,
    required this.deleteConversation,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      color: theme.colorScheme.secondary,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            conversation.name,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => deleteConversation(conversation.id),
            icon: Icon(
              Icons.delete,
              color: theme.colorScheme.onPrimary,
            ),
            label: const Text(""),
          ),
        ],
      ),
    );
  }
}

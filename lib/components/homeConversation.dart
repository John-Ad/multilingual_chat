import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../views/conversation.dart';

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

    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConversationPage(
                              title: "Multilingual Chat",
                              id: conversation.id,
                              topic: conversation.name,
                            )),
                  )
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      conversation.name,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: IconButton(
                onPressed: () => deleteConversation(conversation.id),
                icon: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

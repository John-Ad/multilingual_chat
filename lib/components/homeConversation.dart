import 'package:flutter/material.dart';
import 'package:multilingual_chat/components/ScrollingText.dart';
import 'package:multilingual_chat/utils/colorGenerators.dart';
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Banner(
          message: conversation.languageName ?? '',
          location: BannerLocation.topStart,
          color: getLanguageBannerColorDark(conversation.languageId),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50,
            color: theme.colorScheme.surface,
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
                            cameFromHomeView: true,
                            title: "Multilingual Chat",
                            id: conversation.id,
                            language: conversation.languageName ?? '',
                            languageId: conversation.languageId,
                            topic: conversation.name,
                          ),
                        ),
                      )
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: ScrollingText(text: conversation.name),
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
        ),
      ),
    );
  }
}

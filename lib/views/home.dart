import 'package:flutter/material.dart';
import 'package:german_tutor/components/homeConversation.dart';
import 'package:german_tutor/models/conversation.dart';
import 'package:german_tutor/services/CoversationsService.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ConversationsService _conversationsService = ConversationsService();
  List<Conversation> _conversations = [];

  _HomeState() {
    _getAllConversations();
  }

  void _getAllConversations() async {
    var conversations = await _conversationsService.getAll();
    setState(() {
      _conversations = conversations;
    });
  }

  Future<void> _deleteConversation(int id) async {
    await _conversationsService.deleteById(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    List<Conversation> testConversations = [
      Conversation(
        id: 1,
        name:
            "World politics, ksdnfjjkdsfn jnksdf jnsdf jsnkdfsd fjkn jsndfsdk",
        createdAt: 971200000,
        updatedAt: 971200000,
      ),
      Conversation(
        id: 2,
        name: "Cold war",
        createdAt: 971200000,
        updatedAt: 971200000,
      ),
      Conversation(
        id: 3,
        name: "Oreos",
        createdAt: 971200000,
        updatedAt: 971200000,
      ),
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Text(
              'Conversations',
              style: theme.textTheme.headlineSmall!.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (var conversation in testConversations)
                  HomeConversation(
                    conversation: conversation,
                    deleteConversation: _deleteConversation,
                  )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {debugPrint("tapped")},
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add),
      ),
    );
  }
}

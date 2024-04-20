import 'package:flutter/material.dart';
import 'package:multilingual_chat/components/homeConversation.dart';
import 'package:multilingual_chat/models/conversation.dart';
import 'package:multilingual_chat/services/CoversationsService.dart';
import 'package:multilingual_chat/views/settings.dart';

import '../main.dart';
import 'newConversation.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with RouteAware {
  final ConversationsService _conversationsService = ConversationsService();
  List<Conversation> _conversations = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void initState() {
    super.initState();
    _getAllConversations();
  }

  @override
  void didPopNext() {
    debugPrint("didPopNext called");
    _getAllConversations();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _getAllConversations() async {
    var conversations = await _conversationsService.getAll();
    debugPrint(conversations.length.toString());
    setState(() {
      _conversations = conversations;
    });
  }

  Future<void> _deleteConversation(int id) async {
    await _conversationsService.deleteById(id);
    _getAllConversations();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.title,
            style: theme.textTheme.headlineMedium!.copyWith(
              color: theme.colorScheme.tertiary,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(title: widget.title)),
            )
          },
          icon: Icon(
            Icons.home,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsPage(title: widget.title)),
              )
            },
            icon: Icon(
              Icons.settings,
              color: theme.colorScheme.onPrimary,
            ),
          )
        ],
        backgroundColor: theme.primaryColor,
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
              children: [
                for (var conversation in _conversations)
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
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewConversation(title: widget.title)),
          )
        },
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add),
      ),
    );
  }
}

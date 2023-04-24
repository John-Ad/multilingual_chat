import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:german_tutor/components/gptMessage.dart';
import 'package:german_tutor/components/toasts.dart';
import 'package:german_tutor/models/conversation.dart';
import 'package:german_tutor/services/CoversationsService.dart';
import 'package:german_tutor/services/GPTService.dart';
import 'package:german_tutor/services/MessagesService.dart';
import 'package:german_tutor/views/settings.dart';

import '../components/userMessage.dart';
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
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _newMessageController = TextEditingController();
  final MessagesService _messagesService = MessagesService();
  late FToast fToast;
  bool loadingMessages = false;
  List<Message> _messages = [];
  int _messageCount = 0;

  bool _generatingResponse = false;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _getMessages();
  }

  @override
  void didUpdateWidget(ConversationPage old) {
    super.didUpdateWidget(old);

    if (_messageCount != _messages.length) {
      _scrollToBottomOfMessages();
      setState(() {
        _messageCount = _messages.length;
      });
    }
  }

  void _scrollToBottomOfMessages() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  Future<void> _getMessages() async {
    setState(() {
      loadingMessages = true;
    });

    var result = await _messagesService.getMessagesForConversation(widget.id);

    setState(() {
      loadingMessages = false;
      _messages = result;
    });
  }

  Future<void> _addMessage() async {
    var message = _newMessageController.text;

    _newMessageController.clear();

    var result = await _addUserMessage(message);
    if (!result) {
      _newMessageController.text = message;
      return;
    }

    result = await _addGPTMessage(message);
    if (!result) {
      _newMessageController.text = message;
      return;
    }

    _getMessages();
  }

  Future<bool> _addUserMessage(String message) async {
    if (_newMessageController.text.isEmpty) {
      fToast.showToast(child: const ErrorToast(message: "Enter a message."));
      return false;
    }

    var id = await _messagesService.add(widget.id, message, true);
    if (id <= 0) {
      fToast.showToast(
          child: const ErrorToast(message: "Error saving message."));
      return false;
    }

    await _getMessages();

    return true;
  }

  Future<bool> _addGPTMessage(String message) async {
    setState(() {
      _generatingResponse = true;
    });

    var response = await GPTService.getGermanResponse(message);
    var correction = await GPTService.getGermanCorrection(message);

    if (response.isEmpty || correction.isEmpty) {
      fToast.showToast(
          child: const ErrorToast(message: "Error generating a response"));
      return false;
    }

    var id = await _messagesService.add(widget.id, response, false);

    if (id <= 0) {
      fToast.showToast(
          child: const ErrorToast(message: "Error generating a response"));
      return false;
    }

    var updated = await _messagesService.update(id, correction, null);

    if (!updated) {
      fToast.showToast(
          child: const ErrorToast(message: "Error generating a response"));
      return false;
    }

    setState(() {
      _generatingResponse = false;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    List<Message> gptMessages = [
      Message(
        id: 1,
        content: 'Hallo, wie geht es dir?',
        correction: 'Hallo, wie geht es Ihnen?',
        translation: 'Hello, how are you?',
        conversationId: 1,
        isUserMessage: false,
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      ),
      Message(
        id: 2,
        content: 'Mir geht es gut, danke.',
        correction: 'Mir geht es gut, danke.',
        translation: 'I\'m fine, thank you.',
        conversationId: 1,
        isUserMessage: true,
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      ),
      Message(
        id: 3,
        content: 'Wie geht es dir?',
        correction: 'Wie geht es Ihnen?',
        conversationId: 1,
        isUserMessage: false,
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      ),
    ];

    List<Message> userMessages = [
      Message(
        id: 4,
        content: 'Mir geht es gut, danke.',
        translation: 'I\'m fine, thank you.',
        conversationId: 1,
        isUserMessage: true,
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      ),
      Message(
        id: 5,
        content: 'Wie geht es dir?',
        correction: 'Wie geht es Ihnen?',
        conversationId: 1,
        isUserMessage: false,
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
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
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(
            Icons.arrow_back,
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
      ),
      body: Stack(
        children: [
          Column(
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 90),
                  child: ListView(
                    controller: _scrollController,
                    shrinkWrap: false,
                    children: [
                      for (var message in gptMessages)
                        GPTMessage(
                          message: message,
                        ),
                      for (var message in userMessages)
                        UserMessage(
                          message: message,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // send message
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          selectionColor: theme.colorScheme.surface,
                        ),
                      ),
                      child: TextField(
                        controller: _newMessageController,
                        cursorColor: theme.colorScheme.onPrimary,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                        maxLines: 4,
                        decoration: InputDecoration(
                          isDense: true,
                          fillColor: theme.colorScheme.primary,
                          filled: true,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Enter a message',
                          hintStyle: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.colorScheme.onPrimary.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async => {_addMessage()},
                    icon: const Icon(
                      Icons.send,
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

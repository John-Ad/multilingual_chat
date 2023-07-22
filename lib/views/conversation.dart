import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multilingual_chat/components/gptMessage.dart';
import 'package:multilingual_chat/components/isTypingAnimation.dart';
import 'package:multilingual_chat/components/toasts.dart';
import 'package:multilingual_chat/services/GPTService.dart';
import 'package:multilingual_chat/services/MessagesService.dart';
import 'package:multilingual_chat/utils/colorGenerators.dart';
import 'package:multilingual_chat/views/settings.dart';

import '../components/userMessage.dart';
import '../models/message.dart';

class ConversationPage extends StatefulWidget {
  final String title;
  final int id;
  final String topic;
  final int languageId;
  final String language;

  const ConversationPage({
    super.key,
    required this.title,
    required this.id,
    required this.topic,
    required this.languageId,
    required this.language,
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
  bool _generatingResponse = false;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _getMessagesWithScroll();
  }

  void _scrollToBottomOfMessages() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent * 10,
        duration: const Duration(milliseconds: 3000),
        curve: Curves.easeOut,
      );
    });
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

  Future<void> _getMessagesWithScroll() async {
    await _getMessages();
    _scrollToBottomOfMessages();
  }

  Future<void> _getMessagesNoScroll() async {
    await _getMessages();
  }

  Future<void> _addMessage() async {
    var message = _newMessageController.text;

    _newMessageController.clearComposing();
    _newMessageController.text = "";

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

    _getMessagesWithScroll();
  }

  Future<bool> _addUserMessage(String message) async {
    if (message.isEmpty) {
      fToast.showToast(child: const ErrorToast(message: "Enter a message."));
      return false;
    }

    var id = await _messagesService.add(widget.id, message, true);
    if (id <= 0) {
      fToast.showToast(
          child: const ErrorToast(message: "Error saving message."));
      return false;
    }

    await _getMessagesWithScroll();

    return true;
  }

  Future<bool> _addGPTMessage(String message) async {
    setState(() {
      _generatingResponse = true;
    });

    // get last 20 messages before very the last message
    var lastNMessages =
        _messages.reversed.skip(1).take(20).toList().reversed.toList();

    var response = await GPTService.getResponseInChosenLanguage(
      widget.language,
      widget.topic,
      lastNMessages,
      message,
    );
    var correction = await GPTService.getLanguageCorrection(
      widget.language,
      [],
      message,
    );

    setState(() {
      _generatingResponse = false;
    });

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

    return true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                getLanguageBannerColorDark(widget.languageId),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  getLanguageBorderColorDark(widget.languageId),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
                            child: Text(
                              textAlign: TextAlign.start,
                              widget.language,
                              style: theme.textTheme.headlineLarge!.copyWith(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        widget.topic,
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 90),
                  child: ListView(
                    controller: _scrollController,
                    shrinkWrap: false,
                    children: [
                      for (var message in _messages)
                        if (message.isUserMessage)
                          UserMessage(
                            message: message,
                            refreshMessages: _getMessagesNoScroll,
                          )
                        else
                          GPTMessage(
                            message: message,
                            refreshMessages: _getMessagesNoScroll,
                          ),
                      if (_generatingResponse) const IsTypingAnimation(),
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

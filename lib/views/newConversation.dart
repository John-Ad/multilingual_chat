import 'package:flutter/material.dart';
import 'package:multilingual_chat/components/chooseLanguageDialogue.dart';
import 'package:multilingual_chat/components/toasts.dart';
import 'package:multilingual_chat/models/language.dart';
import 'package:multilingual_chat/services/TopicGeneratorService.dart';
import 'package:multilingual_chat/views/conversation.dart';
import 'package:multilingual_chat/views/settings.dart';

import '../services/CoversationsService.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../services/LanguagesService.dart';

class NewConversation extends StatefulWidget {
  const NewConversation({super.key, required this.title});

  final String title;

  @override
  State<NewConversation> createState() => _NewConversationState();
}

class _NewConversationState extends State<NewConversation> {
  final ConversationsService _conversationsService = ConversationsService();
  late FToast fToast;
  late List<String> _topics;
  late List<Language> _languages;

  final TextEditingController _topicController = TextEditingController();
  Language _selectedLanguage = Language(id: 0, name: "");

  _NewConversationState() {
    _topics = _getRandomTopics();
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  List<String> _getRandomTopics() {
    var topics = TopicGeneratorService.getRandomTopics(3);
    return topics;
  }

  void navigateToConversation(int id, String topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ConversationPage(
                title: widget.title,
                id: id,
                language: _selectedLanguage.name,
                topic: topic,
              )),
    );
  }

  void _addConversation() async {
    if (_selectedLanguage.name.isEmpty) {
      fToast.showToast(
        child: const ErrorToast(message: "Please select a language"),
      );
      return;
    }

    if (_topicController.text.isEmpty) {
      fToast.showToast(
        child: const ErrorToast(message: "Please enter or choose a topic"),
      );
      return;
    }

    int id = await _conversationsService.add(
      _selectedLanguage.id,
      _topicController.text,
    );

    if (id > 0) {
      debugPrint('Conversation added');
      fToast.showToast(
          child: const SuccessToast(message: "Conversation added"));

      navigateToConversation(id, _topicController.text);
    } else {
      debugPrint('Conversation not added');
      fToast.showToast(
          child: const ErrorToast(message: "Conversation not added"));
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
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
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
                padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          "Language: ",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      if (_selectedLanguage.id == 0)
                        ElevatedButton(
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (context) => ChooseLanguageDialogue(
                                onLanguageSelected: (language) => setState(
                                    () => _selectedLanguage = language),
                              ),
                            )
                          },
                          style: ElevatedButton.styleFrom(
                            // light grey bg color
                            backgroundColor:
                                theme.colorScheme.tertiary.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          ),
                          child: Text(
                            "Choose a language",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      if (_selectedLanguage.id != 0)
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedLanguage.name,
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(() {
                                  _selectedLanguage = Language(id: 0, name: "");
                                }),
                                icon: const Icon(
                                  Icons.close,
                                  color: Color.fromARGB(255, 255, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                          width:
                              (MediaQuery.of(context).size.width * 0.8) * 0.8,
                          height:
                              (MediaQuery.of(context).size.height * 0.6) * 0.6,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Center(
                                  child: Text(
                                    "Suggestions:",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Container(
                                  height: 1,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: theme.colorScheme.onPrimary,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              for (var topic in _topics)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: ListTile(
                                    title: Center(
                                      child: Text(
                                        topic,
                                        style:
                                            theme.textTheme.bodySmall!.copyWith(
                                          color: theme.colorScheme.onPrimary,
                                        ),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: SizedBox(
                          width:
                              (MediaQuery.of(context).size.width * 0.8) * 0.8,
                          height: 50,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: TextSelectionThemeData(
                                selectionColor: theme.colorScheme.surface,
                              ),
                            ),
                            child: TextField(
                              controller: _topicController,
                              cursorColor: theme.colorScheme.onPrimary,
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                              maxLines: 1,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(0, 1, 20, 1),
                                isDense: true,
                                fillColor: theme.colorScheme.primary,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Enter a topic',
                                hintStyle: theme.textTheme.bodyLarge!.copyWith(
                                  color: theme.colorScheme.onPrimary
                                      .withOpacity(0.3),
                                ),
                                prefixIcon: Icon(
                                  Icons.edit,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: SizedBox(
                          width:
                              (MediaQuery.of(context).size.width * 0.8) * 0.8,
                          height: 50,
                          child: ElevatedButton(
                            // onPressed: _addConversation,
                            onPressed: () {
                              _addConversation();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                            ),
                            child: Text(
                              'Continue',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/language.dart';
import '../services/LanguagesService.dart';

class ChooseLanguageDialogue extends StatefulWidget {
  final Function(Language language) onLanguageSelected;

  const ChooseLanguageDialogue({super.key, required this.onLanguageSelected});

  @override
  State<ChooseLanguageDialogue> createState() => _ChooseLanguageDialogueState();
}

class _ChooseLanguageDialogueState extends State<ChooseLanguageDialogue> {
  final LanguagesService _languagesService = LanguagesService();
  late List<Language> _languages;

  _ChooseLanguageDialogueState();

  Future<void> _getLanguages() async {
    _languages = await _languagesService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Choose Language"),
      contentPadding: const EdgeInsets.all(20),
      children: [
        FutureBuilder(
          future: _getLanguages(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  for (var language in _languages)
                    ListTile(
                      title: Text(language.name),
                      onTap: () {
                        widget.onLanguageSelected(language);
                        Navigator.pop(context);
                      },
                    ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../models/language.dart';
import '../services/LanguagesService.dart';
import '../utils/colorGenerators.dart';

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
    var theme = Theme.of(context);

    return SimpleDialog(
      title: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
        child: Text(
          "Choose Language",
          style: theme.textTheme.headlineSmall!.copyWith(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        FutureBuilder(
          future: _getLanguages(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  for (var language in _languages)
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: BoxDecoration(
                        color: getLanguageBannerColorDark(language.id),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: getLanguageBorderColorDark(language.id),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          language.name,
                          style: theme.textTheme.headlineSmall!.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          widget.onLanguageSelected(language);
                          Navigator.pop(context);
                        },
                      ),
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

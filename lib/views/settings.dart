import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:german_tutor/services/SettingsService.dart';

import '../components/toasts.dart';
import '../models/settings.dart';

class SettingsPage extends StatefulWidget {
  final String title;

  const SettingsPage({
    super.key,
    required this.title,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsService settingsService = SettingsService();
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _maxTokensController = TextEditingController();
  final TextEditingController _contextMessagesCountController =
      TextEditingController();
  late FToast fToast;

  bool loading = false;
  Settings? settings;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _getSettings();
  }

  Future<void> _getSettings() async {
    debugPrint("Getting settings");
    setState(() {
      loading = true;
    });

    debugPrint("Getting settings 2");
    var result = await settingsService.getSettings();

    if (result != null) {
      _apiKeyController.text = result.apiKey;
      _maxTokensController.text = result.maxTokens.toString();
      _contextMessagesCountController.text =
          result.contextMessagesCount.toString();
    }

    setState(() {
      loading = false;
      settings = result;
    });
  }

  Future<void> _updateSettings() async {
    if (settings == null) return;
    if (_apiKeyController.text.isEmpty) {
      fToast.showToast(
          child: const ErrorToast(message: "API Key cannot be empty"));
      return;
    }

    int? maxTokens = int.tryParse(_maxTokensController.text);
    int? contextMessageCount =
        int.tryParse(_contextMessagesCountController.text);

    if (maxTokens == null) {
      fToast.showToast(
          child: const ErrorToast(message: "Invalid max tokens value"));
      return;
    }
    if (contextMessageCount == null) {
      fToast.showToast(
          child: const ErrorToast(message: "Invalid context messages value"));
      return;
    }

    setState(() {
      loading = true;
    });

    if (await settingsService.updateSettings(Settings(
      id: settings!.id,
      apiKey: _apiKeyController.text,
      maxTokens: maxTokens!,
      contextMessagesCount: contextMessageCount!,
    ))) {
      fToast.showToast(child: const SuccessToast(message: "Settings saved"));
    } else {
      fToast.showToast(
          child: const ErrorToast(message: "Failed to save settings"));
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
            child: Text(
              'Settings',
              style: theme.textTheme.headlineSmall!.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: false,
              children: [
                if (settings == null) const Text("No settings found."),
                if (settings != null)
                  // API Key
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 16, 0),
                            child: Text(
                              "API Key:",
                              style: TextStyle(
                                fontSize: 20,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: TextSelectionThemeData(
                                selectionColor: theme.colorScheme.surface,
                              ),
                            ),
                            child: TextField(
                              controller: _apiKeyController,
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
                                hintText: 'Enter your open ai api key',
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
                        )
                      ],
                    ),
                  ),
                // Max tokens
                if (settings != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 16, 0),
                            child: Text(
                              "Max tokens:",
                              style: TextStyle(
                                fontSize: 20,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: TextSelectionThemeData(
                                selectionColor: theme.colorScheme.surface,
                              ),
                            ),
                            child: TextField(
                              controller: _maxTokensController,
                              keyboardType: TextInputType.number,
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
                                hintText:
                                    'Enter max tokens gpt should generate',
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
                        )
                      ],
                    ),
                  ),
                // Num of context messages to include
                if (settings != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 16, 0),
                            child: Text(
                              "Context count:",
                              style: TextStyle(
                                fontSize: 20,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: TextSelectionThemeData(
                                selectionColor: theme.colorScheme.surface,
                              ),
                            ),
                            child: TextField(
                              controller: _contextMessagesCountController,
                              keyboardType: TextInputType.number,
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
                                hintText:
                                    'Enter number of prev messages to include in new prompts',
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
                        )
                      ],
                    ),
                  ),
                // save button
                if (settings != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.tertiary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () => {_updateSettings()},
                      child: Text(
                        "Save",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

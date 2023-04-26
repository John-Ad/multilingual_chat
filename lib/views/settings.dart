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
    }

    setState(() {
      loading = true;
    });

    if (await settingsService.updateSettings(
        Settings(id: settings!.id, apiKey: _apiKeyController.text))) {
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 16, 0),
                          child: Text(
                            "API Key:",
                            style: TextStyle(
                              fontSize: 20,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        Expanded(
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

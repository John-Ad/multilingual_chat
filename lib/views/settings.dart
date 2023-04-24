import 'package:flutter/material.dart';
import 'package:german_tutor/services/SettingsService.dart';

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

  bool loading = false;
  Settings? settings;

  @override
  void initState() {
    super.initState();
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

    setState(() {
      loading = true;
    });

    await settingsService.updateSettings(settings!);

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
                if (settings == null) Text("No settings found."),
                if (settings != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 16, 0),
                        child: Text("API Key:"),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _apiKeyController,
                          decoration: InputDecoration(
                            hintText: 'Enter API Key',
                          ),
                          onChanged: (value) {
                            settings!.apiKey = value;
                          },
                        ),
                      )
                    ],
                  ),
                if (settings != null)
                  ElevatedButton(
                    onPressed: () => {_updateSettings()},
                    child: Text("Save"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

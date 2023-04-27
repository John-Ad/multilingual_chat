import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:german_tutor/components/toasts.dart';
import 'package:german_tutor/models/message.dart';

import '../services/GPTService.dart';
import '../services/MessagesService.dart';

class GPTMessage extends StatefulWidget {
  final Message message;
  final Function refreshMessages;

  const GPTMessage({
    super.key,
    required this.message,
    required this.refreshMessages,
  });

  @override
  State<GPTMessage> createState() => _GPTMessageState();
}

class _GPTMessageState extends State<GPTMessage> {
  final MessagesService _messagesService = MessagesService();
  late FToast fToast;
  late Message _message;
  bool _loadingTranslation = false;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);

    _message = widget.message;
  }

  Future<void> _translate() async {
    setState(() {
      _loadingTranslation = true;
    });

    var translation =
        await GPTService.getEnglishTranslation([], widget.message.content);

    setState(() {
      _loadingTranslation = false;
    });

    if (translation.isEmpty) {
      fToast.showToast(
          child: const ErrorToast(message: "Failed to translate."));
      return;
    }

    var updated =
        await _messagesService.update(widget.message.id, null, translation);

    if (!updated) {
      fToast.showToast(
          child: const ErrorToast(message: "Failed to save translation."));
    }

    Message newMessage = _message.copyWith(translation: translation);

    setState(() {
      _message = newMessage;
    });
  }

  Future<void> _delete() async {
    setState(() {
      _deleting = true;
    });

    var deleted = await _messagesService.deleteById(_message.id);

    setState(() {
      _deleting = false;
    });

    if (!deleted) {
      fToast.showToast(
          child: const ErrorToast(message: "Failed to delete message."));
      return;
    }

    widget.refreshMessages();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(50, 0, 20, 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // correction
                  if (_message.correction != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                      child: Text(
                        "Correction:",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.onPrimary.withAlpha(128),
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                  if (_message.correction != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                      child: Text(
                        _message.correction!,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onPrimary.withAlpha(128),
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),

                  // response
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                    child: Text(
                      "Response:",
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontFamily: "OpenSans",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 10),
                    child: Text(
                      _message.content,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontFamily: "OpenSans",
                      ),
                    ),
                  ),

                  // loading translation
                  if (_loadingTranslation)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),

                  // translation
                  if (_message.translation != null)
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _message.translation!,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            backgroundColor: theme.colorScheme.primary,
                            fontFamily: "OpenSans",
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      "GPT",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontFamily: "OpenSans",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => {
                      if (_message.translation == null)
                        {_translate()}
                      else
                        {
                          fToast.showToast(
                            child: const SuccessToast(
                                message: "Already translated."),
                          )
                        }
                    },
                    icon: const Icon(Icons.translate),
                  ),
                  IconButton(
                    onPressed: () => {_delete()},
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:german_tutor/components/toasts.dart';
import 'package:german_tutor/models/message.dart';
import 'package:german_tutor/services/GPTService.dart';
import 'package:german_tutor/services/MessagesService.dart';

class UserMessage extends StatefulWidget {
  final Message message;
  final Function refreshMessages;

  const UserMessage({
    super.key,
    required this.message,
    required this.refreshMessages,
  });

  @override
  State<UserMessage> createState() => _UserMessageState();
}

class _UserMessageState extends State<UserMessage> {
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
    await Future.delayed(const Duration(milliseconds: 500));

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
      margin: const EdgeInsets.fromLTRB(20, 0, 50, 20),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                    child: Text(
                      widget.message.content,
                      maxLines: 20,
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
                      "You",
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
                  if (!_deleting)
                    IconButton(
                      onPressed: () => {_delete()},
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  if (_deleting)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
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

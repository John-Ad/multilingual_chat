import 'package:flutter/material.dart';
import 'package:german_tutor/models/message.dart';

class UserMessage extends StatefulWidget {
  final Message message;

  const UserMessage({
    super.key,
    required this.message,
  });

  @override
  State<UserMessage> createState() => _UserMessageState();
}

class _UserMessageState extends State<UserMessage> {
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
                        color: theme.colorScheme.onPrimary.withAlpha(178),
                        fontFamily: "OpenSans",
                      ),
                    ),
                  ),

                  // translation
                  if (widget.message.translation != null)
                    Text(
                      widget.message.translation!,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        backgroundColor: theme.colorScheme.primary,
                        fontFamily: "OpenSans",
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
                    onPressed: () => {},
                    icon: const Icon(Icons.translate),
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

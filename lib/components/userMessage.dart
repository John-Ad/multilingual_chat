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
      margin: const EdgeInsets.fromLTRB(0, 0, 50, 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // content
          Text(
            widget.message.content,
          ),

          // translation
          if (widget.message.translation != null)
            Text(
              widget.message.translation!,
              style: theme.textTheme.bodyMedium!.copyWith(
                backgroundColor: theme.colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}

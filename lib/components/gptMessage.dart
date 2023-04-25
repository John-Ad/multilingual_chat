import 'package:flutter/material.dart';
import 'package:german_tutor/models/message.dart';

class GPTMessage extends StatefulWidget {
  final Message message;

  const GPTMessage({
    super.key,
    required this.message,
  });

  @override
  State<GPTMessage> createState() => _GPTMessageState();
}

class _GPTMessageState extends State<GPTMessage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(50, 0, 0, 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // correction
          if (widget.message.correction != null)
            Text(
              """
              Correction:

              ${widget.message.correction!}
              """,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onPrimary.withAlpha(178),
                fontFamily: "OpenSans",
              ),
            ),

          // response
          Text(
            """
            Response:

            ${widget.message.content}
            """,
            style: theme.textTheme.bodyMedium!.copyWith(
              fontFamily: "OpenSans",
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
    );
  }
}

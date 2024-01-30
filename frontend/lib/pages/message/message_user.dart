import 'package:flutter/material.dart';
import 'package:frontend/service/ext/ext.dart';
import 'package:frontend/widget/custom_markdown.dart';

///
/// AI-User : Chat user message widget
///
class MessageUserView extends StatelessWidget {
  const MessageUserView(this.displayMsg, this.displayTime, {super.key});

  final String displayMsg;

  final String displayTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 40.0),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SelectableText(checkTimeStr(displayTime), style: style14),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    // color: Theme.of(context).colorScheme.secondaryContainer,
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CustomMarkdown(displayMsg),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        const Padding(
            padding: EdgeInsets.only(top: 32),
            child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/ic_user.webp'),
                radius: 16.0))
      ],
    );
  }
}

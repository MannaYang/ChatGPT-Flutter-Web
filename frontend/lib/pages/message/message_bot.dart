import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/gen/strings.g.dart';
import 'package:frontend/pages/chat/provider/chat_provider.dart';
import 'package:frontend/service/ext/ext.dart';
import 'package:frontend/widget/custom_markdown.dart';
import 'package:frontend/widget/message_loading.dart';
import 'package:frontend/widget/show_snackbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

///
/// AI-Bot : Chat bot message widget
///
class MessageBotView extends StatelessWidget {
  const MessageBotView(
      this.displayMsg, this.displayTime, this.isStream, this.controller,
      {super.key});

  /// Show content str
  final String displayMsg;

  /// Show content time
  final String displayTime;

  /// If true,show [StreamBuilder], false show content str,
  final bool isStream;

  /// ScrollController
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        displayMsg.isEmpty
            ? const SizedBox()
            : Row(
                children: [
                  const SizedBox(width: 48),
                  SelectableText(checkTimeStr(displayTime),
                      style: TextStyle(fontSize: 14, color: primary(context))),
                  const SizedBox(width: 4),
                  TextButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: displayMsg));
                        showSnackBar(t.app.copy_success);
                      },
                      icon: const Icon(Icons.copy_rounded, size: 20),
                      label: Text(t.app.copy, style: style14))
                ],
              ),
        const SizedBox(height: 4),
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/ic_bot.png'),
                      radius: 16.0,
                      backgroundColor: Colors.transparent)),
              const SizedBox(width: 16.0),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: isStream
                          ? MessageBotStream(controller)
                          : CustomMarkdown(displayMsg)))
            ])
      ])),
      const SizedBox(width: 40.0)
    ]);
  }
}

///
/// StreamBuilder
///
class MessageBotStream extends ConsumerWidget {
  const MessageBotStream(this.controller, {super.key});

  /// ScrollController
  final ScrollController controller;

  ///
  /// 逐字打印滚动[ScrollController,scroll content to end]
  ///
  void scrollEnd(ScrollController controller, int milliseconds) {
    if (controller.positions.isEmpty) return;
    controller.animateTo(controller.position.maxScrollExtent,
        duration: Duration(milliseconds: milliseconds),
        curve: Curves.easeOutQuart);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamControl = ref.watch(streamControlProvider);
    return StreamBuilder(
      stream: streamControl.stream,
      key: Key('${Random().nextDouble()}'),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return SelectableText("${t.app.error}: ${snapshot.error}");
        }
        if (snapshot.hasData) {
          String content = snapshot.data ?? "";
          scrollEnd(controller, 200);
          if (content.isNotEmpty) return SelectableText(content);
          // if (content.isNotEmpty) {
          //   return MarkdownBody(data: content, selectable: true);
          // }
        }
        return const MessageLoading();
      },
    );
  }
}

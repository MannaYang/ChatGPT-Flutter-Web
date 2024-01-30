import 'package:flutter/material.dart';
import 'package:frontend/pages/chat/view/input/chat_input.dart';
import 'package:frontend/pages/chat/view/message/chat_message_list.dart';
import 'package:frontend/service/ext/ext.dart';
import 'package:frontend/service/utils/api_provider.dart';

///
/// Chat message list
///
class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          height: 56,
          margin: const EdgeInsets.only(top: 16),
          child: const Row(children: [
            SelectableText('Generative AI', style: style18),
            SizedBox(width: 8),
            ElevatedButton(
                onPressed: null,
                style: ButtonStyle(
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                    minimumSize: MaterialStatePropertyAll(Size(40, 30))),
                child: SelectableText(ApiProvider.aiModel, style: style12)),
          ])),
      Expanded(
        child: Stack(children: [
          /// Border
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),

            /// Message list and input
            child: Stack(
              children: [
                Container(
                    alignment: Alignment.topCenter,
                    constraints: const BoxConstraints(minWidth: 360),
                    margin: const EdgeInsets.only(bottom: 68),
                    child: const ChatMessageList()),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      constraints:
                          const BoxConstraints(maxHeight: 168, minHeight: 56),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ChatInput()),
                ),
              ],
            ),
          ),

          /// Default label
          Center(
              child: Text(
            'AI.MANNA',
            style: TextStyle(
                fontSize: 48,
                color: Theme.of(context).colorScheme.surfaceVariant),
          )),
        ]),
      ),
    ]);
  }
}

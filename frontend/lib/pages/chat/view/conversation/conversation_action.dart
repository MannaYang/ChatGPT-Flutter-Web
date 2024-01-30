import 'package:flutter/material.dart';
import 'package:frontend/gen/strings.g.dart';
import 'package:frontend/pages/chat/provider/chat_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

///
/// Create chat conversation
/// - [FloatingActionButton]
///
class ConversationAction extends ConsumerWidget {
  const ConversationAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
        onPressed: () => insertConversation(ref),
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(26))),
        label: Row(children: [
          const Icon(Icons.create_rounded),
          const SizedBox(width: 16),
          Text(t.chat.create_chat)
        ]));
  }

  ///
  /// Add conversation
  /// - [title]
  /// - [sub_title]
  /// - [role_play] - When you choose endDrawer prompt template role play, this
  ///               it will be actual role.
  ///               The path[lib/pages/chat/view/prompt/chat_prompt_template.dart]
  ///
  insertConversation(WidgetRef ref) async {
    var params = {
      "title": "AI Conversation",
      "sub_title": "AI Conversation Content",
      "role_play": ""
    };
    var conversationId = await ref
        .read(chatConversationsProvider.notifier)
        .insertConversation(params);
    ref
        .read(conversationSelectedProvider.notifier)
        .updateStatus((conversationId, true, ""));
  }
}

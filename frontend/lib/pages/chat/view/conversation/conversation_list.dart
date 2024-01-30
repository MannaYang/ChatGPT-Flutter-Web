import 'package:flutter/material.dart';
import 'package:frontend/pages/chat/provider/chat_provider.dart';
import 'package:frontend/service/ext/ext.dart';
import 'package:frontend/widget/show_snackbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import 'conversation_list_action.dart';

///
/// Conversation List
/// - [ListView.separated]
///
/// This is Record()
/// ```
/// final conversations = ref.watch(chatConversationsProvider);
/// final selected = ref.watch(conversationSelectedProvider);
/// ```
///
class ConversationList extends ConsumerStatefulWidget {
  const ConversationList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ConversationListState();
  }
}

class ConversationListState extends ConsumerState<ConversationList> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.short1, () {
      ref.read(chatConversationsProvider.notifier).selectConversationList();
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Chat conversation list
    final conversations = ref.watch(chatConversationsProvider);
    ref.listen(chatConversationsProvider, (previous, next) {
      if (next.$1 != 0) showSnackBar(next.$2);
    });

    /// Current selected conversation
    final selected = ref.watch(conversationSelectedProvider);

    return ListView.separated(
        itemCount: conversations.$3?.length ?? 0,
        itemBuilder: (context, index) {
          final conversation = conversations.$3![index];
          final titleStr = conversation.title ?? '';
          final subTitleStr = conversation.subTitle ?? '';
          final isSelected = selected.$1 == conversation.id;
          final rolePlay = conversation.rolePlay ?? "";
          return ListTile(
              // leading: Icon(rolePlay.isEmpty?Icons.chat_rounded:Icons.density_medium_outlined),
              // leading: Icon(rolePlay.isEmpty?Icons.chat_rounded:Icons.generating_tokens),
              leading: Icon(rolePlay.isEmpty
                  ? Icons.chat_rounded
                  : Icons.question_answer_rounded),
              contentPadding: const EdgeInsets.only(left: 16),
              mouseCursor: SystemMouseCursors.click,
              selected: isSelected,
              onTap: () => onTap(
                  (conversation.id ?? 0, true, conversation.rolePlay ?? "")),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              hoverColor: Theme.of(context).colorScheme.surfaceVariant,
              title: Text(titleStr,
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: style15),
              subtitle: Text(subTitleStr,
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: style12),
              trailing: ConversationListAction(conversation, isSelected));
        },
        separatorBuilder: (_, __) => const SizedBox(height: 8));
  }

  ///
  /// - [onTap]one of conversation selected
  ///
  onTap((int, bool, String) chatSelected) {
    Logger().d("Role = ${chatSelected.$3}");
    ref.read(conversationSelectedProvider.notifier).updateStatus(chatSelected);
  }
}

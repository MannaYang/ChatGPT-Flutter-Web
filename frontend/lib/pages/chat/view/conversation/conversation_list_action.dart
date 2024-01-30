import 'package:flutter/material.dart';
import 'package:frontend/gen/strings.g.dart';
import 'package:frontend/pages/chat/model/chat_conversation_info.dart';
import 'package:frontend/pages/chat/provider/chat_provider.dart';
import 'package:frontend/service/ext/ext.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

///
/// Create conversation [trailing] operation
/// - [edit] edit current conversation title and subTitle
/// - [delete] delete current conversation
///
class ConversationListAction extends ConsumerWidget {
  const ConversationListAction(this.conversation, this.isCurrentSelected,
      {super.key});

  final ChatConversationInfo conversation;
  final bool isCurrentSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MenuAnchor(
        style: MenuStyle(
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)))),
        builder: (_, MenuController controller, __) {
          return IconButton(
              onPressed: () {
                controller.isOpen ? controller.close() : controller.open();
              },
              tooltip: t.app.more,
              icon: const Icon(Icons.more_vert_outlined, size: 20));
        },
        menuChildren: [
          MenuItemButton(
              child: SizedBox(
                  width: 128,
                  height: 48,
                  child: Row(children: [
                    const SizedBox(width: 8),
                    const Icon(Icons.edit, size: 20),
                    const SizedBox(width: 8),
                    Text(t.app.edit, style: style15)
                  ])),
              onPressed: () => showEditDialog(context, ref)),
          MenuItemButton(
              child: SizedBox(
                  width: 112,
                  height: 48,
                  child: Row(children: [
                    const SizedBox(width: 8),
                    const Icon(Icons.delete, size: 20),
                    const SizedBox(width: 8),
                    Text(t.app.delete, style: style15)
                  ])),
              onPressed: () => deleteConversation(
                  isCurrentSelected, ref, conversation.rolePlay ?? ""))
        ]);
  }

  ///
  /// Create edit conversation
  /// - [AlertDialog]
  ///
  showEditDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: conversation.title ?? '');
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(t.chat.edit_prompt),
              content: createTextField(controller),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(t.app.cancel)),
                ElevatedButton(
                    onPressed: () {
                      updateConversation(controller.text, ref);
                      Navigator.of(context).pop();
                    },
                    child: Text(t.app.confirm))
              ]);
        });
  }

  ///
  /// Create edit conversation dialog
  /// - [TextField]
  ///
  Widget createTextField(TextEditingController controller) {
    return SizedBox(
      height: 128,
      width: 512,
      child: TextField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        expands: true,
        showCursor: true,
        autofocus: true,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: t.chat.edit_prompt_hint,
          counter: const SizedBox(width: 0, height: 0),
          isCollapsed: true,
          hoverColor: const Color(0xFFCAC4D0),
          contentPadding: const EdgeInsets.only(top: 18),
        ),
      ),
    );
  }

  ///
  /// Update conversation title and subTitle
  ///
  updateConversation(String text, WidgetRef ref) {
    ref.read(chatConversationsProvider.notifier).updateConversation(
        {"id": conversation.id, "title": text, "sub_title": ""});
  }

  ///
  /// delete current conversation
  ///
  deleteConversation(bool currentSelect, WidgetRef ref, String rolePlay) {
    var params = {"id": conversation.id, "role_play": rolePlay};
    ref.read(chatConversationsProvider.notifier).deleteConversation(params);

    /// If current conversation selected, reset conversation list selected status
    if (currentSelect) {
      ref
          .read(conversationSelectedProvider.notifier)
          .updateStatus((0, false, ""));
      ref.read(settingMultiModalProvider.notifier).updateStatus(0);
    }
  }
}
